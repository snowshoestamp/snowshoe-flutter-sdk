import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:snowshoe_sdk_flutter/src/db/local_auth_dao.dart';
import 'package:snowshoe_sdk_flutter/src/db/settings_dao.dart';
import 'package:snowshoe_sdk_flutter/src/db/stamp_dao.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class _DBConfiguration {
  final String path;
  final String password;

  _DBConfiguration({required this.path, required this.password});

  String get name => path.split("/").last;
}

class SnowShoeDBAdapter {
  late Database? _database;
  late final SettingsDao settingsDao;
  late final StampDao stampDao;
  late final LocalAuthDao localAuthDao;

  SnowShoeDBAdapter();

  //Future<Database> get db async => _database ?? await _initDatabase();

  Future<Database> initDatabase(String key) async {
    _database = await openDatabase(
      "encrypted.db",
      password: key,
      onCreate: SnowShoeDBAdapter._onCreate,
      version: 1,
    );

    settingsDao = SettingsDao(_database!);
    stampDao = StampDao(_database!);
    localAuthDao = LocalAuthDao(_database!);

    return _database!;
  }

  static void _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE local_auth_data (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    serial TEXT,
    eventTimeStamp TEXT,
    didSucceed TEXT, x1 REAL, y1 REAL, x2 REAL, y2 REAL, x3 REAL, y3 REAL,
    mx1 REAL, my1 REAL, mx2 REAL, my2 REAL, mx3 REAL, my3 REAL, mx4 REAL, my4 REAL,
    mx5 REAL, my5 REAL) 
    ''');

    await db.execute('''
    CREATE TABLE settings (
    id INTEGER PRIMARY KEY, 
    lastSyncTimeStamp TEXT,
    timeoutDays INTEGER,
    debugMode INTEGER,
    active INTEGER,
    appKey TEXT,
    stampPoints INTEGER,
    gridX REAL,
    gridY REAL,
    tolerance REAL) 
    ''');

    await db.execute('''
    CREATE TABLE stamps (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    serial TEXT,
    customName TEXT,
    active INTEGER, x1 REAL, y1 REAL, x2 REAL, y2 REAL, x3 REAL, y3 REAL) 
    ''');
  }
}