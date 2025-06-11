import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dbs/Repository.dart';
import 'model/User.dart';
import 'mytheme.dart';
import 'screen/addUser.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<User> users;
  final Repository repository = Repository();

  readAllUsers() async {
    var usersData = await repository.readData("user");

    setState(() {
      users = usersData.map<User>((userData) {
        return User(
          userData['id'],
          userData['name'],
          userData['contact'],
          userData['description'],
        );
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    users = [];
    readAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.white,
              backgroundColor: Color.fromRGBO(0, 180, 0, 0.5),
              centerTitle: true,
              title: Text(
                "Contacts",
                style: GoogleFonts.abel(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            floatingActionButton: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Color.fromRGBO(0, 180, 0, 0.5),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => AddUser()))
                    .then((value) {
                      if (value != null) {
                        readAllUsers();
                      }
                    });
              },
              child: Icon(Icons.add, color: Colors.white),
            ),

            body: RefreshIndicator(
              onRefresh: () async {
                readAllUsers();
              },
              child: users.isEmpty
                  ? Center(
                      child: Text(
                        "No Contacts Found",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(20),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 180, 0, 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Dismissible(
                            confirmDismiss: (DismissDirection direction) async {
                              return await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Confirm Delete"),
                                  content: Text(
                                    "Do you want to delete '${users[index].name}'?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      }, // Cancel
                                      child: Text("No"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      }, // Confirm
                                      child: Text("Yes"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            direction: DismissDirection.endToStart,
                            background: Container(
                              decoration: BoxDecoration(
                                color: Colors.redAccent.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),

                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              repository.deleteData("user", users[index].id);
                              setState(() {
                                users.removeAt(index);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: primary_color,
                                    content: Text(
                                      "Contact Deleted Successfully",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                );
                              });
                            },

                            child: Container(
                              child: ListTile(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: Text("Contact"),
                                        content: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Icon(Icons.person, size: 20),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    users[index].name!,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Icon(Icons.phone, size: 20),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    users[index].contact!,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.description,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    users[index].description !=
                                                            ""
                                                        ? users[index]
                                                              .description!
                                                        : "No Description",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text("Close"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },

                                leading: Icon(Icons.person, size: 40),
                                title: Text(
                                  users[index].name!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  users[index].contact!,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }
}
