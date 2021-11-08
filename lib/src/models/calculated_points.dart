import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'calculated_points.g.dart';

@JsonSerializable(explicitToJson: true)
class CalculatedPoints {
  double x1;
  double y1;
  double x2;
  double y2;
  double x3;
  double y3;

  CalculatedPoints({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required this.x3,
    required this.y3,
  });

  factory CalculatedPoints.fromJson(Map<String, dynamic> json) => _$CalculatedPointsFromJson(json);
  Map<String, dynamic> toJson() => _$CalculatedPointsToJson(this);
}