import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'measured_points.g.dart';

@JsonSerializable(explicitToJson: true)
class MeasuredPoints {
  double x1;
  double y1;
  double x2;
  double y2;
  double x3;
  double y3;
  double x4;
  double y4;
  double x5;
  double y5;

  MeasuredPoints({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required this.x3,
    required this.y3,
    required this.x4,
    required this.y4,
    required this.x5,
    required this.y5,
  });

  factory MeasuredPoints.fromJson(Map<String, dynamic> json) => _$MeasuredPointsFromJson(json);
  Map<String, dynamic> toJson() => _$MeasuredPointsToJson(this);
}