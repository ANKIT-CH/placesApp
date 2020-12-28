import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DatabaseHelper {
  static Future<sql.Database> fetchDatabase() async {
    final databasePath = await sql.getDatabasesPath();

    return sql.openDatabase(path.join(databasePath, 'places.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE places(id TEXT PRIMARY KEY,title TEXT,image TEXT,latitude REAL,longitude REAL,address TEXT)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final sqlDatabase = await DatabaseHelper.fetchDatabase();

    sqlDatabase.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> fetchData(String table) async {
    final sqlDatabase = await DatabaseHelper.fetchDatabase();

    return sqlDatabase.query(table);
  }
}
