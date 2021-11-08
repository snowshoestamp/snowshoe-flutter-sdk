import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:snowshoe_sdk_flutter/src/models/get_stamps_request.dart';
import 'package:snowshoe_sdk_flutter/src/models/get_stamps_result.dart';
import 'package:snowshoe_sdk_flutter/src/models/report_stamps_request.dart';
import 'package:snowshoe_sdk_flutter/src/models/report_stamps_result.dart';
import 'package:snowshoe_sdk_flutter/src/models/snow_shoe_result.dart';
import 'apis.dart';

part 'snow_shoe_api.g.dart';

@RestApi()
abstract class SnowShoeApiClient {
  factory SnowShoeApiClient(Dio dio, {String baseUrl}) = _SnowShoeApiClient;

  @POST(Apis.reportStamps)
  Future<void> reportStamps(@Header("SnowShoe-Api-Key") String apiKey, @Body() List<ReportStampsRequest> data);

  @POST(Apis.getStamps)
  Future<GetStampsResult> getStamps(@Header("SnowShoe-Api-Key") String apiKey, @Body() GetStampsRequest request);
}