
import 'dart:io';

import 'package:flutter_notes_app/model/notes_item.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

///Created on Android Studio Canary Version
///User: Gagandeep
///Date: 05-05-2019
///Time: 11:07
///Project Name: flutter_notes_app

class DatabaseHelper{
  static final DatabaseHelper _instance = DatabaseHelper.internal();
factory DatabaseHelper() => _instance;
  final table = "notesTable";
final columnId = "id";
final columnItemName = "item_name";
final columnCreatedOn = "created_on";
  static Database _db;


  DatabaseHelper.internal();

  Future<Database> get db async {
    if(_db != null) return _db;
    _db = await initDb();
    return _db;
  }


  initDb() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join (documentDirectory.path, "notes.db");
    var ourDb = await openDatabase(path, onCreate: _onCreate, version: 1);
    return ourDb;
  }

  void _onCreate(Database db, int version) async{
    await db.execute("CREATE TABLE $table ($columnId INTEGER PRIMARY KEY, $columnItemName TEXT, $columnCreatedOn DATETIME)");
  }


  Future<int> saveItem(NotesItem item) async{
    var dbClient = await db;
    int result = await dbClient.insert(table, item.toMap());
    return result;
  }

  Future<List> getAllItems() async {
    var dbClient = await db;
     List _itemList = await dbClient.rawQuery("SELECT * FROM $table");
    return _itemList;
  }

  Future<int> getCount() async {

    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT COUNT(*) FROM *notesTable");
    return Sqflite.firstIntValue(result);
  }

  Future<NotesItem> getNote(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $table WHERE $columnId = $id");
    if(result.length==0) return null;
    return NotesItem.fromMap(result.first);
  }

  Future<int> deleteNote(int id) async {
    var dbClient = await db;
    int result = await dbClient.delete(table, where: "$columnId = ?", whereArgs: [id]);
    return result;
  }

  Future<int> updateNote(NotesItem item) async {
    var dbClient = await db;
    int result = await dbClient.update(table, item.toMap(), where: "$columnId = ?", whereArgs: [item.id]);
    return result;
  }

}

