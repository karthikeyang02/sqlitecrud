import 'dart:io';

import 'package:flutter_sqflite/Reg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';

class DatabaseHelper{

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String regTable = 'reg_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPhone = 'phone';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if(_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'reg.db';

    var regDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return regDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $regTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$colTitle TEXT, '
        '$colDescription TEXT, '
        '$colPhone TEXT, $colPriority INTEGER, $colDate TEXT)');
  }


  Future<List<Map<String, dynamic>>> getRegMapList() async {
    Database db = await this.database;
    var result = await db.query(regTable, orderBy: '$colPriority ASC');
    return result;
  }

  Future<int> insertReg(Reg reg) async {
    Database db = await this.database;
    var result = await db.insert(regTable, reg.toMap());
    return result;
  }

  Future<int> updateReg(Reg reg) async {
    var db = await this.database;
    var result = await db.update(regTable, reg.toMap(), where: '$colId = ?',
        whereArgs: [reg.id]);
    return result;
  }

  Future<int> deleteReg(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $regTable WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $regTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }


  Future<List<Reg>> getRegList() async {
    var regMapList = await getRegMapList();
    int count = regMapList.length;

    List<Reg> regList = List<Reg>();

    for(int i = 0; i < count; i++) {
      regList.add(Reg.fromMapObject(regMapList[i]));
    }
    return regList;
  }
}