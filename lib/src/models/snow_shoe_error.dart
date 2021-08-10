import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'snow_shoe_error.g.dart';

@JsonSerializable(explicitToJson: true)
class SnowShoeError {
  int code;
  String message;

  SnowShoeError({
    required this.code,
    required this.message
  });

  factory SnowShoeError.fromJson(Map<String, dynamic> json) => _$SnowShoeErrorFromJson(json);
  Map<String, dynamic> toJson() => _$SnowShoeErrorToJson(this);
}