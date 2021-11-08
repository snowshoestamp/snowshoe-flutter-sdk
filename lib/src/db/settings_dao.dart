import 'package:snowshoe_sdk_flutter/src/db/settings.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class SettingsDao {
  static const String _table = "settings";
  final Database _db;

  SettingsDao(this._db);

  Future<List<Settings>> getSettings() async {
    final settings = await _db.query(_table);
    return settings.map((data) => Settings.fromJson(data)).toList();
  }

  Future<void> insertSettings(Settings settings) async {
    await _db.insert(_table, settings.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> clearSettings() async {
    await _db.delete(_table);
  }
}