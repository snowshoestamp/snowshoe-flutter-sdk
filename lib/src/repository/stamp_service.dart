import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:snowshoe_sdk_flutter/src/api/snow_shoe_api.dart';
import 'package:snowshoe_sdk_flutter/src/api/stamp_request.dart';
import 'package:snowshoe_sdk_flutter/src/api/stamp_result.dart';
import 'package:snowshoe_sdk_flutter/src/models/snow_shoe_error.dart';
import 'package:snowshoe_sdk_flutter/src/on_stamp_listener.dart';

class StampService {
  final String _apiKey;
  final OnStampListener listener;
  late final SnowShoeApiClient api;
  late final Dio dio;
  late final Logger logger;

  StampService(this._apiKey, this.listener) {
    dio = Dio();
    api = SnowShoeApiClient(dio);
    logger = Logger();
  }

  Future<void> getStampByTouchPoints(List<List<double>> data) async {
    var request = StampRequest(data: data);
    await api.stamp(_apiKey, StampRequest.fromJson(request.toJson()))
    .then((it){
      logger.i(it);
      listener.onStampResult(it);
    }).catchError((Object obj) {
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          switch(res?.statusCode){
            case 400:
              var stampResult = StampResult.fromJson(res?.data);
              listener.onStampResult(stampResult);
              break;
            default:
              listener.onStampResult(null);
              throw obj;
          }
          break;
        default:
          listener.onStampResult(null);
          throw obj;
      }
      //
    });
  }
}