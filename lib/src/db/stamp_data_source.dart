import 'package:snowshoe_sdk_flutter/src/db/snow_shoe_db_adapter.dart';
import 'package:snowshoe_sdk_flutter/src/db/stamp_dao.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../authentication.dart';
import 'stamp.dart';

class StampDataSource {

  SnowShoeDBAdapter dbAdapter;

  StampDataSource(this.dbAdapter);

  Future<Stamp?> getStamp(double x1, double y1,
      double x2, double y2, double x3, double y3, double tolerance) async {

    double tolReduce = 0.2;
    int tolReduceCount = 7;
    List<Stamp> stamps = await dbAdapter.stampDao.getStamp(x1, y1, x2, y2, x3, y3, tolerance);
    Stamp? stamp;

    //If more than one stamp is returned query the DB multiple times to try and narrow it down.
    double curTol = tolerance - tolReduce;
    if(stamps.length > 1) {
      for(int i = 0; i < tolReduceCount && stamps.length != 1; i++) {
        stamps = await dbAdapter.stampDao.getStamp(x1, y1, x2, y2, x3, y3, curTol);
        curTol = curTol - tolReduce;
      }
    }

    if(stamps.isNotEmpty) {
      stamp = stamps.first;
    }
    return stamp;
  }

  Future<void> insertStamp(List<Stamp> stamps) async {
    for (var stamp in stamps) {
      stamp = _sortRequestedStamp(stamp);
    }
    return await dbAdapter.stampDao.insertNewAndUpdateStamps(stamps);
  }

  Future<List<Stamp>> getAllStamps() async {
    return await dbAdapter.stampDao.getAllStamps();
  }

  Future<void> deleteAllStamps() async {
    await dbAdapter.stampDao.deleteAllStamps();
  }

  Stamp _sortRequestedStamp(Stamp stamp) {
    List<List<double>> points = <List<double>>[];
    points.add([stamp.x1, stamp.y1]);
    points.add([stamp.x2, stamp.y2]);
    points.add([stamp.x3, stamp.y3]);
    var sortedPoints = Authentication.sortPoints(points, 36.0, 36.0);
    stamp.x1 = sortedPoints[0].first;
    stamp.y1 = sortedPoints[0].last;
    stamp.x2 = sortedPoints[1].first;
    stamp.y2 = sortedPoints[1].last;
    stamp.x3 = sortedPoints[2].first;
    stamp.y3 = sortedPoints[2].last;
    return stamp;
  }
}