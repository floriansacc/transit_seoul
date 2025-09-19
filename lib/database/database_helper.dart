import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  String get _dbName => 'transit_seoul_database.db';
  String get userTable => 'USER_TABLE';

  Future<Database> openDB() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();

    final String dbPath = join(
      documentsDirectory.path,
      _dbName,
    );

    Future<Database> database = openDatabase(
      dbPath,
      onConfigure: (Database db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $userTable (
            indexId INTEGER PRIMARY KEY,
            isLogin INTEGER,
            userName TEXT,
            email TEXT,
            userID TEXT,
            picture TEXT
          )
        ''');
      },
      onUpgrade: _onUpgrade,
      version: 1,
    );
    return database;
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<T> safeDbCall<T>(Future<T> Function() dbCall) async {
    try {
      return await dbCall();
    } on DatabaseException catch (e) {
      if (e.isDuplicateColumnError()) {
        await deleteDatabase();
      }

      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDatabase() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();

    final String dbPath = join(
      documentsDirectory.path,
      _dbName,
    );

    await databaseFactory.deleteDatabase(dbPath);
  }
}
