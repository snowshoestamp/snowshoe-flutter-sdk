import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
import 'package:snowshoe_sdk_flutter/src/models/snow_shoe_error.dart';
import 'package:snowshoe_sdk_flutter/src/models/snow_shoe_stamp.dart';

part 'stamp_result.g.dart';

@JsonSerializable(explicitToJson: true)
class StampResult {
  SnowShoeError? error;
  SnowShoeStamp? stamp;
  bool? secure;
  DateTime? created;
  String receipt;

  StampResult({
    required this.error,
    required this.stamp,
    required this.secure,
    required this.created,
    required this.receipt
  });

  factory StampResult.fromJson(Map<String, dynamic> json) => _$StampResultFromJson(json);
  Map<String, dynamic> toJson() => _$StampResultToJson(this);
}
