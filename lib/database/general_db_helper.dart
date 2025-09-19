import 'package:sqflite/sqflite.dart';
import 'package:transit_seoul/database/database_helper.dart';
import 'package:transit_seoul/models/common/general_db_data_model.dart';

class GeneralDbHelper extends DatabaseHelper {
  GeneralDbHelper._privateConstructor();

  static final GeneralDbHelper _instance =
      GeneralDbHelper._privateConstructor();
  static GeneralDbHelper get instance => _instance;

  Future<GeneralDbDataModel?> retrieveData() async {
    try {
      return await safeDbCall(() async {
        final Database db = await openDB();

        final List<Map<String, Object?>> result = await db.query(
          userTable,
          where: 'indexId = ?',
          whereArgs: [0],
          limit: 1,
        );

        if (result.isNotEmpty) {
          return GeneralDbDataModel.fromJson(result.first);
        } else {
          return null;
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveData(GeneralDbDataModel data) async {
    try {
      await safeDbCall(() async {
        final Database db = await openDB();

        await db.insert(
          userTable,
          data.toJsonSql(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteData() async {
    try {
      return await safeDbCall(() async {
        final Database db = await openDB();

        return await db.delete(
          userTable,
          where: 'indexId = ?',
          whereArgs: [0],
        );
      });
    } catch (e) {
      rethrow;
    }
  }
}
