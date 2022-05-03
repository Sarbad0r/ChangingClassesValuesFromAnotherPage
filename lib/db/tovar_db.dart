import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/tovar_model.dart';

class DbTovar {
  static final Future<Database> database =
      getDatabasesPath().then((value) async {
    return openDatabase(join(value, 'tovar.db'),
        onCreate: (db, version) async {
          await db.execute('''
       CREATE TABLE tovar (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, code TEXT)
      ''');
        },
        version: 2,
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 1) {
            db.execute('''
          CREATE TABLE tovar (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, code TEXT)
          ''');
          }
        });
  });

  static Future<void> inserToDb(Tovar tovar) async {
    final db = await database;

    tovar.id = await db.insert("tovar", tovar.toJson(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<void> deleteIzbrannie(int id) async {
    final db = await database;

    await db.delete("tovar", where: "id = ?", whereArgs: [id]);
  }

  static Future<List<Tovar>> getTovar() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('tovar');

    return List.generate(maps.length, (index) {
      return Tovar(
          id: maps[index]['id'],
          name: maps[index]['name'],
          code: maps[index]['code']);
    });
  }
}
