import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:snowshoe_sdk_flutter/src/db/local_auth_data.dart';
import 'package:snowshoe_sdk_flutter/src/db/settings.dart';
import 'package:snowshoe_sdk_flutter/src/db/snow_shoe_db_adapter.dart';
import 'package:snowshoe_sdk_flutter/src/db/stamp_data_source.dart';
import 'package:snowshoe_sdk_flutter/src/models/report_stamps_request.dart';
import 'package:snowshoe_sdk_flutter/src/models/snow_shoe_error.dart';
import 'package:snowshoe_sdk_flutter/src/models/snow_shoe_result.dart';
import 'package:snowshoe_sdk_flutter/src/models/snow_shoe_stamp.dart';
import 'package:snowshoe_sdk_flutter/src/repository/stamp_service.dart';
import 'package:snowshoe_sdk_flutter/src/snow_shoe_multi_touch_gesture.dart';
import 'package:snowshoe_sdk_flutter/src/utils/ss_utils.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'authentication.dart';
import 'db/stamp.dart';
import 'listeners/on_stamp_listener.dart';

class SnowShoeView extends StatelessWidget {
  static const String tag = "SnowShoeView";
  static const String routeName = "/snow_shoe_view";
  static int touchPoints = 5;

  final storage = const FlutterSecureStorage();
  final String sdkVersion = "3.1.2";
  final int maxTouchPoints = 5;
  final int maxSerialPoints = 3;
  final double tolerance = 2.0;
  late Settings settings;
  late final StampDataSource _stampDao;
  late final OnStampListener onStampListener;
  late final String? apiKey;
  late final StampService _stampService;
  late final SnowShoeDBAdapter dbAdapter;


  bool _stampBeingChecked = false;

  SnowShoeView({Key? key}) : super(key: key) {
    _stampService = StampService(apiKey!);
  }

  SnowShoeView.secondary(this.onStampListener, this.apiKey, {Key? key}) : super(key: key) {
    _stampService = StampService(apiKey!);
  }

  Future<void> syncStampInfo() async {
    var options = const IOSOptions(accessibility: IOSAccessibility.first_unlock);
    if(await storage.read(key: "key") == null) {
      await storage.write(key: "key", value: _randomValue(), iOptions: options);
    }
    var pass = await storage.read(key: "key");
    dbAdapter = SnowShoeDBAdapter();
    await dbAdapter.initDatabase(pass!);
    _stampDao = StampDataSource(dbAdapter);
    // var settingsList = await dbAdapter.settingsDao.getSettings();
    // if(settingsList.isNotEmpty) {
    //   settings = settingsList.first;
    //   touchPoints = settings.stampPoints;
    // }
    await _getStampTable(false);
  }

  String _randomValue() {
    final rand = Random();
    final codeUnits = List.generate(20, (index) {
      return rand.nextInt(26) + 65;
    });

    return String.fromCharCodes(codeUnits);
  }

  void setOnStampListener(OnStampListener listener) {
    onStampListener = listener;
  }

  void setApiKey(String key) {
    apiKey = key;
  }

  Future<bool> onTouchEvent(List<List<double>> data) async {
    print("Tapped with '${data.length}' finger(s)");
    print("1 - ${data[0][0]}, ${data[0][1]}");
    print("2 - ${data[1][0]}, ${data[1][1]}");
    print("3 - ${data[2][0]}, ${data[2][1]}");
    print("4 - ${data[3][0]}, ${data[3][1]}");
    print("5 - ${data[4][0]}, ${data[4][1]}");

    if(!_stampBeingChecked) {
      _stampBeingChecked = true;
      var result = await _getStampResult(data);
      onStampListener.onGetSerialResult(result);
    }

    return true;
  }

  Future<SnowShoeResult> _getStampResult(List<List<double>> stampPoints) async {
    //Check if app has local-auth enabled. If not, clear the DB
    //List<Settings> settingsList = await dbAdapter.settingsDao.getSettings();

    var result = SnowShoeResult.secondary(
        const Uuid().v1(), DateTime.now().toUtc()
    );

    List<Settings> settingsList = await dbAdapter.settingsDao.getSettings();
    Settings? settings = settingsList.isNotEmpty ? settingsList.first : null;

    if (settings == null || !settings.isActive()) {
      try {
        _stampDao.deleteAllStamps();
        dbAdapter.settingsDao.clearSettings();
        SSUtils.logger.e(tag, "NO ACCESS: THIS APP DOES NOT HAVE LOCAL-AUTH ACCESS, CONTACT AN ADMIN");
      } catch (ex) {
        result.error = SnowShoeError(code: 2, message: "Error with DB");
        _stampBeingChecked = false;
        return result;
      }
    }

    int pointCount = settings?.stampPoints ?? 5;
    double gridX = settings?.gridX ?? 36.0;
    double gridY = settings?.gridY ?? 36.0;
    int timeoutDays = settings?.timeoutDays ?? -1;
    String lastSyncTimeStamp = settings?.lastSyncTimeStamp ?? "2020-01-01T00:00:00.000Z";

    List<List<double>> convertedPoints;
    try {
      convertedPoints = Authentication.getStampIdPoints(stampPoints, pointCount, gridX, gridY);
    } catch(exc) {
      result.error = SnowShoeError(code: 3, message: "localizedDescription");
      _stampBeingChecked = false;
      return result;
    }

    initializeDateFormatting();
    DateTime now = DateTime.now().toUtc();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    String dateString = dateFormat.format(now);

    //Check if app hasn't ran a sync for the amount of days in timeout_days.
    try {
      DateTime lastSyncDate = dateFormat.parse(lastSyncTimeStamp);
      int dateDiff = now.difference(lastSyncDate).inMilliseconds; //Time since last sync and now in milliseconds.
      if (timeoutDays <= (dateDiff / 1000 / 60 / 60 / 24)) {
        _stampDao.deleteAllStamps();
        dbAdapter.settingsDao.clearSettings();
        SSUtils.logger.e(tag, "NOT SYNCED: THIS APP HAS NOT SYNCED IN MORE THAN THE ALLOWED AMOUNT OF DAYS, STAMP DATA COULD BE OUT DATED");
      }
    } catch (e) {
      SSUtils.logger.e(tag, e.toString());
    }

    //if not a 5pt stamp fill in the blank points with 0,0 and reorder.
    if (convertedPoints.length < maxSerialPoints) {
      while (convertedPoints.length < maxSerialPoints) {
        convertedPoints.add([0,0]);
      }
      convertedPoints = Authentication.sortPoints(convertedPoints, gridX, gridY);
    }

    Stamp? stamp = await _stampDao.getStamp(
        convertedPoints[0].first, convertedPoints[0].last,
        convertedPoints[1].first, convertedPoints[1].last,
        convertedPoints[2].first, convertedPoints[2].last,
        tolerance);

    //if not a 5pt stamp fill in the blank points with 0,0
    if (stampPoints.length < maxTouchPoints) {
      while (stampPoints.length < maxTouchPoints) {
        stampPoints.add([0,0]);
      }
    }

    if(stamp == null) {
      result.error = SnowShoeError(code: 1, message: "No Stamp found");
      //Add the local-auth call to the local-auth table
      try {
        var data = LocalAuthData(serial: "", eventTimeStamp: dateString, didSucceed: "No Stamp Found",
            x1: convertedPoints[0][0], y1: convertedPoints[0][1], x2: convertedPoints[1][0], y2: convertedPoints[1][1], x3: convertedPoints[2][0], y3: convertedPoints[2][1],
            mx1: stampPoints[0][0], my1: stampPoints[0][1], mx2: stampPoints[1][0], my2: stampPoints[1][1], mx3: stampPoints[2][0], my3: stampPoints[2][1],
            mx4: stampPoints[3][0], my4: stampPoints[3][1], mx5: stampPoints[4][0], my5: stampPoints[4][1]);
        await dbAdapter.localAuthDao.insertLocalAuthData(data);
      } catch (ex) {
        SSUtils.logger.e("Error inserting local-auth info to database");
        result.error?.code = 3;
        result.error?.message = "No Stamp Found / Error Adding local-auth to DB";
        _stampBeingChecked = false;
        return result;
      }
    }
    else {
      result.stamp = SnowShoeStamp(serial: stamp.serial, customName: stamp.customName);
      _stampBeingChecked = false;
      try {
        var data = LocalAuthData(serial: stamp.serial, eventTimeStamp: dateString, didSucceed: "Success",
            x1: convertedPoints[0][0], y1: convertedPoints[0][1], x2: convertedPoints[1][0], y2: convertedPoints[1][1], x3: convertedPoints[2][0], y3: convertedPoints[2][1],
            mx1: stampPoints[0][0], my1: stampPoints[0][1], mx2: stampPoints[1][0], my2: stampPoints[1][1], mx3: stampPoints[2][0], my3: stampPoints[2][1],
            mx4: stampPoints[3][0], my4: stampPoints[3][1], mx5: stampPoints[4][0], my5: stampPoints[4][1]);
        await dbAdapter.localAuthDao.insertLocalAuthData(data);
      } catch (ex) {
        SSUtils.logger.e("Error inserting local-auth info to database");
      }
    }

    _pushLocalAuthData();

    _stampBeingChecked = false;
    return result;
  }

  Future<void> _pushLocalAuthData() async {
    if(apiKey != null){
      var localAuthData = await dbAdapter.localAuthDao.getAllLocalAuth();
      if(localAuthData.isNotEmpty) {
        await _stampService.reportStamps(localAuthData)
        .then((_) {
            dbAdapter.localAuthDao.clearData();
            SSUtils.logger.i(tag, "Successfully pushed local-auth data");
            onStampListener.onSyncCompleted(true);
        })
        .catchError((onError) {
            SSUtils.logger.i(tag, "Error pushing local-auth data");
        });
      }
    }
    else {
      SSUtils.logger.e("Api Key is required");
    }
  }

  _refreshStampInfo() {
    _getStampTable(true);
  }

  _getStampTable(bool refresh, { String continuationToken = "" }) async {
    if(apiKey != null) {
      List<Settings> settingsList = await dbAdapter.settingsDao.getSettings();
      Settings? settings;
      var dateString = "";

      if(continuationToken == "" && settingsList.isNotEmpty) {
        if(!refresh  && settingsList.isNotEmpty && settingsList.first.appKey == apiKey) {
          settings = settingsList.first;
          dateString = settings.lastSyncTimeStamp;
        }
        else {
          _stampDao.deleteAllStamps()
              .catchError((onError) => onStampListener.onSyncCompleted(false));
        }
      }

      try {
        var response = await _stampService.getStamps(dateString, continuationToken);
        continuationToken = response!.continuationToken ?? "";
        var successMessage = "";
        var validTimeout = response.localAuthSettings.timeoutDays;
        var didPopulate = false;

        //Set what the stamp point count will be.
        touchPoints = response.localAuthSettings.stampPoints;

        if(validTimeout > -1) {
          //Check if current stamp DB has different point count as stamp DB being retrieved.
          //If they are different clear stamp DB before updating with new stamps.
          if(settingsList.isNotEmpty && settingsList.first.stampPoints != touchPoints) {
            _stampDao.deleteAllStamps()
                .catchError((onError) => onStampListener.onSyncCompleted(false));
          }
          didPopulate = await _updateStampTable(response.stamps);
          if (didPopulate) {
            successMessage = "Successfully synced with cloud stamp database";
          }
          else {
            successMessage = "Error syncing cloud stamp database";
          }
        }
        else {
          successMessage = "Error with validation check";
        }

        if(continuationToken == "" || validTimeout == -1) {
          settings = Settings(
              id: 1,
              lastSyncTimeStamp: response.timeStamp ?? "",
              timeoutDays: validTimeout,
              debugMode: response.localAuthSettings.debugMode ? 1 : 0,
              active: response.localAuthSettings.active? 1 : 0,
              appKey: apiKey!,
              stampPoints: response.localAuthSettings.stampPoints,
              gridX: response.localAuthSettings.gridX,
              gridY: response.localAuthSettings.gridY,
              tolerance: response.localAuthSettings.tolerance);

          await dbAdapter.settingsDao.insertSettings(settings)
              .then((_) => didPopulate = true)
              .catchError((onError) {
                successMessage = "Error updating local-auth settings";
                onStampListener.onSyncCompleted(false);
              });
          await _pushLocalAuthData();
        }

        SSUtils.logger.i(tag, successMessage);

        if(continuationToken != "" && didPopulate) {
          _getStampTable(false, continuationToken: continuationToken);
          return;
        }
        if(continuationToken == "" || !didPopulate || validTimeout == -1) {
          if(validTimeout == -1) {
            didPopulate = false;
          }
          onStampListener.onSyncCompleted(didPopulate);
        }
      } catch (ex) {
        SSUtils.logger.e("Error syncing with cloud stamp database");
        onStampListener.onSyncCompleted(false);
        return;
      }
    }
    else {
      SSUtils.logger.e("Api Key is required");
      onStampListener.onSyncCompleted(false);
    }
  }

  Future<bool> _updateStampTable(List<Stamp> stamps) async {
    var didUpdate = true;
    if(stamps.isNotEmpty){
      await _stampDao.insertStamp(stamps)
        .then((value) => SSUtils.logger.i("Stamps added/updated: ${stamps.length}"))
        .catchError((value) => didUpdate = false);
    }
    return didUpdate;
  }

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          SnowShoeMultiTouchGesture: GestureRecognizerFactoryWithHandlers<SnowShoeMultiTouchGesture>(
                () => SnowShoeMultiTouchGesture(),
                (SnowShoeMultiTouchGesture instance) {
                  instance.minNumberOfTouches = 5;
                  instance.onMultiTap = (data) => onTouchEvent(data);
                })
        }
      );
  }
}