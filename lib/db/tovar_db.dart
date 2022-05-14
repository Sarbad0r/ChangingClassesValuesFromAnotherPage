import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/tovar_model.dart';
import '../widget/add_widget.dart';

class DbTovar {
  static final Future<Database> database =
      getDatabasesPath().then((value) async {
    return openDatabase(join(value, 'tovar.db'),
        onCreate: (db, version) async {
          await db.execute('''
       CREATE TABLE tovar (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, code TEXT)
      ''');
          await db.execute(
              "CREATE TABLE card(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, tovar_id, name TEXT, age TEXT)");
        },
        version: 2,
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            db.execute('''
          CREATE TABLE tovar (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, code TEXT)
          ''');
            db.execute(
                "CREATE TABLE card(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, tovar_id INTEGER, name TEXT, age TEXT)");
          }
        });
  });

  static Future<void> inserToDb(Tovar tovar) async {
    final db = await database;

    tovar.id = await db.insert("tovar", tovar.toJson(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<void> insertToCard(
      int tovarId, List<AddWidget> addWidget) async {
    final db = await database;

    for (int i = 0; i < addWidget.length; i++) {
      if (addWidget[i].id != null) {
        await db.rawUpdate(
            'UPDATE card SET name = "${addWidget[i].nameCotroller.text}", age = "${addWidget[i].ageController.text}" WHERE id == ${addWidget[i].id}');
        continue;
      }
      addWidget[i].id = await db.rawInsert(
          'INSERT INTO card (tovar_id , name, age) VALUES'
          ' ($tovarId, "${addWidget[i].nameCotroller.text}", "${addWidget[i].ageController.text}")');
    }
  }

  static Future<void> deleteTovar(int id) async {
    final db = await database;

    await db.delete("tovar", where: "id = ?", whereArgs: [id]);
  }

  static Future<void> updateTovar(Tovar tovar) async {
    final db = await database;

    await db.update('tovar', tovar.toJson(),
        where: 'id = ?', whereArgs: [tovar.id]);
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

  static Future<List<AddWidget>> getCard() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('card');

    return List.generate(maps.length, (index) {
      return AddWidget(
        id: maps[index]['id'],
        tovar_id: maps[index]['tovar_id'],
        age: maps[index]['age'],
        name: maps[index]['name'],
      );
    });
  }
}
