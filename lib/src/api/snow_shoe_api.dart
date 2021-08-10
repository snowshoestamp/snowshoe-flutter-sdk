import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:snowshoe_sdk_flutter/src/api/stamp_request.dart';
import 'package:snowshoe_sdk_flutter/src/api/stamp_result.dart';
import 'apis.dart';

part 'snow_shoe_api.g.dart';

@RestApi(baseUrl: "https://api.snowshoestamp.com/v3")
abstract class SnowShoeApiClient {
  factory SnowShoeApiClient(Dio dio, {String baseUrl}) = _SnowShoeApiClient;

  @POST(Apis.stamp)
  Future<StampResult> stamp(@Header("SnowShoe-Api-Key") String apiKey, @Body() StampRequest data);
}