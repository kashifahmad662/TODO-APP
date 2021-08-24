import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/utils/sql_Data.dart';

class database_handler {

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'TODO_Data.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE TODO_LIST(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL,content TEXT NOT NULL, colorData TEXT NOT NULL, day INTEGER, month INTEGER, year INTEGER, hour INTEGER, minute INTEGER, reminder INTEGER, colorIndex INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertList(List<ToDoListData> todo_data) async {
    int result = 0;
    final Database db = await initializeDB();
    for(var items in todo_data){
      result = await db.insert('TODO_LIST', items.toMap());
    }
    return result;
  }
  int? count;

  Future<List<ToDoListData>> retrieveTODO_Data() async {
    final Database db = await initializeDB();
    count = Sqflite
        .firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM TODO_LIST'));

    final List<Map<String, Object?>> queryResult = await db.query('TODO_LIST');
    return queryResult.map((e) => ToDoListData.fromMap(e)).toList();
  }

  
  Future<void> updateTODOList(List<ToDoListData> todo_data) async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Update the given Dog.
    for(var items in todo_data){
    await db.update(
      'TODO_LIST',
      items.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [items.id],
    );}
  }

  

  Future<void> deleteList(int id) async {
    final db = await initializeDB();
    await db.delete(
      'TODO_LIST',
      where: "id = ?",
      whereArgs: [id],
    );
  }

}