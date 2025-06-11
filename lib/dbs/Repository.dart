import 'package:mobile_phone_book/dbs/db_connection.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  late DatabaseConnection _databaseConnection;

  Repository() {
    _databaseConnection = DatabaseConnection();
  }

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _databaseConnection.setDatabase();
    return _database;
  }

  insertData(table, data) async {
    var connection = await database;
    return connection?.insert(table, data);
  }

  readData(table) async {
    var connection = await database;
    return connection?.query(table);
  }

  deleteData(table, id) async {
    var connection = await database;
    return connection?.rawDelete("DELETE FROM $table WHERE id = $id");
  }
}
