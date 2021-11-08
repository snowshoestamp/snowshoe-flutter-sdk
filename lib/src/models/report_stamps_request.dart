import 'package:json_annotation/json_annotation.dart';
import 'package:snowshoe_sdk_flutter/src/db/local_auth_data.dart';
import 'package:snowshoe_sdk_flutter/src/models/calculated_points.dart';
import 'package:snowshoe_sdk_flutter/src/models/measured_points.dart';
import 'package:snowshoe_sdk_flutter/src/utils/ss_utils.dart';

part 'report_stamps_request.g.dart';

@JsonSerializable(explicitToJson: true)
class ReportStampsRequest {
  late String eventTimeStamp;
  late MeasuredPoints measuredPoints;
  late CalculatedPoints calculatedPoints;
  late String calculatedSerial;
  late String calculatedStatus;
  late String deviceType;
  late String deviceModel;
  late String deviceOsName;
  late String deviceOsVersion;
  late String sdkVersion;

  ReportStampsRequest({
    required this.eventTimeStamp,
    required this.measuredPoints,
    required this.calculatedPoints,
    required this.calculatedSerial,
    required this.calculatedStatus,
    required this.deviceType,
    required this.deviceModel,
    required this.deviceOsName,
    required this.deviceOsVersion,
    required this.sdkVersion,
  });

  ReportStampsRequest.secondary(LocalAuthData data, String sdkVersion1) {
    eventTimeStamp = data.eventTimeStamp;
    sdkVersion = sdkVersion1;
    measuredPoints = MeasuredPoints(
        x1: data.mx1, y1: data.my1,
        x2: data.mx2, y2: data.my2,
        x3: data.mx3, y3: data.my3,
        x4: data.mx4, y4: data.my4,
        x5: data.mx5, y5: data.my5);
    calculatedPoints = CalculatedPoints(
        x1: data.x1, y1: data.y1,
        x2: data.x2, y2: data.y2,
        x3: data.x3, y3: data.y3);
    calculatedSerial = data.serial;
    calculatedStatus = data.didSucceed;
    deviceType = "";
    deviceModel = "";
    deviceOsVersion = "";
    deviceOsName = "";
  }

  factory ReportStampsRequest.fromJson(Map<String, dynamic> json) => _$ReportStampsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ReportStampsRequestToJson(this);
}