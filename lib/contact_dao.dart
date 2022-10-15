import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'dart:async';
import 'contact.dart';

class ContactDao {
  static const String databaseName = 'phonebook.db';
  late Future<Database> database;

  Future connect() async {
    var databasePath = await getDatabasesPath();
    String path = p.join(databasePath, databaseName);
    database =
        openDatabase(path, version: 1, onCreate: (Database db, int version) {
          return db.execute("CREATE TABLE IF NOT EXISTS "
              "${Contact.tableName} ( "
              "${Contact.colunmNameName} PRIMARY KEY, "
              "${Contact.colunmNamePhone} TEXT) ");
        });
  }

  Future<List<Contact>> list() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(Contact.tableName);
    return List.generate(maps.length, (i) {
      return Contact(
          name: maps[i][Contact.colunmNameName],
          phone: maps[i][Contact.colunmNamePhone]
      );
    });
  }

  Future<void> insert(Contact contact) async {
    final Database db = await database;

    await db.insert(
        Contact.tableName,
        contact.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<void> update(Contact contact) async {
    final db = await database;
    await db.update(
        Contact.tableName,
        contact.toMap(),
        where: "${Contact.colunmNameName} = ?",
        whereArgs: [contact.name]
    );
  }

  Future<void> delete(String name) async {
    final db = await database;
    await db.delete(
        Contact.tableName,
        where: "${Contact.colunmNameName} = ?",
        whereArgs: [name]
    );
  }

}
