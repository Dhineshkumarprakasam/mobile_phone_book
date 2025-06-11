class User {
  int? id;
  String? name;
  String? contact;
  String? description;

  User(this.id, this.name, this.contact, this.description);
  userMap() {
    var map = Map<String, dynamic>();
    map['id'] = id ?? null;
    map['name'] = name!;
    map['contact'] = contact!;
    map['description'] = description!;
    return map;
  }
}
