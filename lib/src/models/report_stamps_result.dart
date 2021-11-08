import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'report_stamps_result.g.dart';

@JsonSerializable(explicitToJson: true)
class ReportStampsResult {
  int code;
  String message;

  ReportStampsResult({
    required this.code,
    required this.message
  });

  factory ReportStampsResult.fromJson(Map<String, dynamic> json) => _$ReportStampsResultFromJson(json);
  Map<String, dynamic> toJson() => _$ReportStampsResultToJson(this);
}