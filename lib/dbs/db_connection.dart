import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  Future<void> _createDatabase(Database database, int version) async {
    await database.execute(
      'CREATE TABLE user(id INTEGER PRIMARY KEY, name TEXT, contact TEXT, description TEXT)',
    );
  }

  Future<Database> setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'user.db');
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );

    return database;
  }
}
