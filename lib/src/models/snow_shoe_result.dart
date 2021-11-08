import 'package:json_annotation/json_annotation.dart';

import 'snow_shoe_error.dart';
import 'snow_shoe_stamp.dart';

part 'snow_shoe_result.g.dart';

@JsonSerializable(explicitToJson: true)
class SnowShoeResult {
  SnowShoeError? error;
  SnowShoeStamp? stamp;
  DateTime? created;
  String receipt;

  SnowShoeResult({
    required this.error,
    required this.stamp,
    required this.created,
    required this.receipt
  });

  SnowShoeResult.secondary(this.receipt, this.created);

  factory SnowShoeResult.fromJson(Map<String, dynamic> json) => _$SnowShoeResultFromJson(json);
  Map<String, dynamic> toJson() => _$SnowShoeResultToJson(this);
}