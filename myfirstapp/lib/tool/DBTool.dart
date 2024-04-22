import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBTool {
  String dbName = "db.db";

  late Database db;

  initDB(String dbName, Map<String, String> tableMap) async {
    this.dbName = dbName;
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, dbName);
    print("--------------------------------");
    print("DataBase Path:$path");
    print("--------------------------------");

    if (await databaseExists(path)) {
      print("--------------------------------");
      print("DataBase Exists!");
      print("--------------------------------");
      return;
    }

    Database db = await openDatabase(path, version: 1);
    tableMap.forEach((key, value) async {
      await db.execute(value);
    });
    print("--------------------------------");
    print("DataBase Init Success!");
    print("--------------------------------");
  }

  openDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, dbName);
    db = await openDatabase(path, version: 1);
  }

  Future<List<Map>> select(String sql) async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, dbName);
    Database db = await openDatabase(path, version: 1);
    var result = await db.rawQuery(sql);
    return result;
  }

  Future<bool> insert(String sql) async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, dbName);
    Database db = await openDatabase(path, version: 1);
    var result = await db.rawInsert(sql);
    return result > 0;
  }

  Future<bool> update(String sql) async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, dbName);
    Database db = await openDatabase(path, version: 1);
    var result = await db.rawUpdate(sql);
    return result > 0;
  }

  Future<bool> delete(String sql) async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, dbName);
    Database db = await openDatabase(path, version: 1);
    var result = await db.rawDelete(sql);
    return result > 0;
  }
}
