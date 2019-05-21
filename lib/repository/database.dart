import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:w_reader/model/savedlink.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static final String dbName = "links.db";
  static final int dbVersion = 1;
  static final DatabaseProvider instance = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initializeDatabase();
    return _database;
  }

  initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return await openDatabase(path,
        version: dbVersion,
        onOpen: (db) {},
        onCreate: (Database db, int version) => _createModels(db));
  }

  _createModels(Database db) async {
    await db.execute("""
    CREATE TABLE saved_links (
      id INTEGER PRIMARY KEY, 
      linkId INTEGER,
      title TEXT, 
      description TEXT, 
      imageUrl TEXT,
    )""");
  }

  Future<int> add(SavedLink link) async =>
      await (await database).insert("saved_links", link.toMap());

  list() async {
    var cursor = await (await database).query("saved_links");
    return _cursorToList(cursor);
  }

  Future<int> delete(int id) async => await (await database)
      .delete("saved_links", where: "id = ?", whereArgs: [id]);

  List<SavedLink> _cursorToList(List<Map<String, dynamic>> cursor) {
    return cursor.isNotEmpty
        ? cursor.map((row) => SavedLink.fromMap(row)).toList()
        : List<SavedLink>();
  }
}