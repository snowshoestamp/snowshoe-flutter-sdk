import 'package:snowshoe_sdk_flutter/src/db/stamp.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class StampDao {
  static const String _table = "stamps";
  final Database _db;

  StampDao(this._db);

  Future<List<Stamp>> getAllStamps() async {
    final stamps = await _db.query(_table);
    return stamps.map((data) => Stamp.fromJson(data)).toList();
  }

  Future<List<Stamp>> getStamp(double x1, double y1,
      double x2, double y2, double x3, double y3, double tolerance) async {
    final stamps = await _db.rawQuery(
        "SELECT * FROM stamps WHERE active = 1 "
        "AND x1 BETWEEN ${x1-tolerance} AND ${x1+tolerance} "
        "AND y1 BETWEEN ${y1-tolerance} AND ${y1+tolerance} "
        "AND x2 BETWEEN ${x2-tolerance} AND ${x2+tolerance} "
        "AND y2 BETWEEN ${y2-tolerance} AND ${y2+tolerance} "
        "AND x3 BETWEEN ${x3-tolerance} AND ${x3+tolerance} "
        "AND y3 BETWEEN ${y3-tolerance} AND ${y3+tolerance} "
    );
    return stamps.map((data) => Stamp.fromJson(data)).toList();
  }

  Future<void> insertStamp(Stamp stamp) async {
    await _db.insert(_table, stamp.toJson(), conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> insertNewAndUpdateStamps(List<Stamp> stamps) async {
    var batch = _db.batch();
    for (var element in stamps) {
      batch.insert(_table, element.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  Future<void> deleteAllStamps() async {
    await _db.delete(_table);
  }
}