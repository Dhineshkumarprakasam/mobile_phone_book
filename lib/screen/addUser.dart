import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../dbs/Repository.dart';
import '../model/User.dart';

const primary_color = Color.fromRGBO(0, 180, 0, 0.5);

SaveUser(User user) async {
  Repository repository = Repository();
  return await repository.insertData("user", user.userMap());
}

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String? firstName;
  String? description;
  String? phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: primary_color,
        centerTitle: true,
        title: Text(
          "Add New Contact",
          style: GoogleFonts.abel(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Container(
        margin: EdgeInsets.only(top: 30),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                filled: false,
                labelText: "First Name",
                floatingLabelStyle: const TextStyle(fontSize: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                filled: false,
                labelText: "Phone Number",
                floatingLabelStyle: const TextStyle(fontSize: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                filled: false,
                labelText: "Description",
                floatingLabelStyle: const TextStyle(fontSize: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (firstNameController.text.isNotEmpty &&
                          phoneController.text.length == 10) {
                        if (descriptionController.text.isNotEmpty) {
                          description = descriptionController.text;
                        } else
                          description = "";

                        firstName = firstNameController.text;
                        phone = phoneController.text;

                        User user = User(null, firstName, phone, description);
                        SaveUser(user);

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Success"),
                              content: Text("Contact Added Successfully"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop(user);
                                  },
                                  child: Text("Ok"),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: primary_color,
                            content: Text(
                              "Name and phone number should be filled properly",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }
                    });
                  },

                  child: Text(
                    "Save Details",
                    style: GoogleFonts.abel(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: primary_color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                ElevatedButton(
                  onPressed: () {
                    firstNameController.clear();
                    phoneController.clear();
                    descriptionController.clear();
                  },
                  child: Text(
                    "Clear All",
                    style: GoogleFonts.abel(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
