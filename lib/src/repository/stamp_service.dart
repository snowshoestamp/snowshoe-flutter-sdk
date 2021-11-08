import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:snowshoe_sdk_flutter/src/api/snow_shoe_api.dart';
import 'package:snowshoe_sdk_flutter/src/api/stamp_request.dart';
import 'package:snowshoe_sdk_flutter/src/api/stamp_result.dart';
import 'package:snowshoe_sdk_flutter/src/db/local_auth_data.dart';
import 'package:snowshoe_sdk_flutter/src/listeners/report_stamp_listener.dart';
import 'package:snowshoe_sdk_flutter/src/models/get_stamps_request.dart';
import 'package:snowshoe_sdk_flutter/src/models/get_stamps_result.dart';
import 'package:snowshoe_sdk_flutter/src/models/report_stamps_request.dart';
import 'package:snowshoe_sdk_flutter/src/models/report_stamps_result.dart';
import 'package:snowshoe_sdk_flutter/src/models/snow_shoe_error.dart';
import 'package:snowshoe_sdk_flutter/src/listeners/on_stamp_listener.dart';
import 'package:snowshoe_sdk_flutter/src/models/snow_shoe_result.dart';
import 'package:snowshoe_sdk_flutter/src/utils/ss_utils.dart';
import 'dart:convert';

class StampService {
  final String _apiKey;
  late final SnowShoeApiClient _api;
  late final Dio _dio;
  late final Logger _logger;

  StampService(this._apiKey) {
    _dio = Dio();
    _api = SnowShoeApiClient(_dio, baseUrl: SSUtils.getBaseUrl());
    _logger = Logger();
  }

  Future<GetStampsResult?> getStamps(String timestamp, String continuationToken) async {
    return await _api.getStamps(_apiKey, GetStampsRequest(timestamp: timestamp, continuationToken: continuationToken, sdkVersion: SSUtils.getSdkVersion()))
    .then((it){
      _logger.i(it);
      return it;
    }).catchError((Object obj) {
      throw obj;
    });
  }

  Future<void> reportStamps(List<LocalAuthData> data) async {
    var request = _buildReportStampsRequest(data);
    await _api.reportStamps(_apiKey, request);
  }

  Future<void> reportStamp(LocalAuthData data) async {
    await reportStamps([data]);
  }

  List<ReportStampsRequest> _buildReportStampsRequest(List<LocalAuthData> data) {
    List<ReportStampsRequest> requests = <ReportStampsRequest>[];
    for (var element in data) {
      requests.add(ReportStampsRequest.secondary(element, SSUtils.getSdkVersion()));
    }
    return requests;
  }
}