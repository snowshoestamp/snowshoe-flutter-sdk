import 'package:snowshoe_sdk_flutter/src/db/local_auth_data.dart';
import 'package:snowshoe_sdk_flutter/src/db/settings.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class LocalAuthDao {
  static const String _table = "local_auth_data";
  final Database _db;

  LocalAuthDao(this._db);

  Future<List<LocalAuthData>> getAllLocalAuth() async {
    final settings = await _db.query(_table);
    return settings.map((data) => LocalAuthData.fromJson(data)).toList();
  }

  Future<void> insertLocalAuthData(LocalAuthData data) async {
    await _db.insert(_table, data.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> clearData() async {
    await _db.delete(_table);
  }
}