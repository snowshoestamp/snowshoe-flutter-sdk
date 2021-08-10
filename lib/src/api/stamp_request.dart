import 'dart:ffi';
import 'package:json_annotation/json_annotation.dart';

part 'stamp_request.g.dart';

@JsonSerializable(explicitToJson: true)
class StampRequest {
  List<List<double>> data;

  StampRequest({
    required this.data
  });

  factory StampRequest.fromJson(Map<String, dynamic> json) => _$StampRequestFromJson(json);
  Map<String, dynamic> toJson() => _$StampRequestToJson(this);
}