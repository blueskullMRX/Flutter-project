import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;
  
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  initialDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'first.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) {
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE event (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        day TEXT,
        month TEXT,
        year TEXT,
        type TEXT
      );
    ''');
  }

  Future<List<Map>> readData(String sql, [List<dynamic>? parameters]) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql, parameters);
    return response;
  }

  Future<int> insertData(String sql, [List<dynamic>? parameters]) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql, parameters);
    return response;
  }

  Future<int> updateData(String sql, [List<dynamic>? parameters]) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql, parameters);
    return response;
  }

  Future<int> deleteData(String sql, [List<dynamic>? parameters]) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql, parameters);
    return response;
  }
}
