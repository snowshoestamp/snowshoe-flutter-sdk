import 'package:json_annotation/json_annotation.dart';

part 'local_auth_data.g.dart';

@JsonSerializable(explicitToJson: true)
class LocalAuthData {
  int? id;
  String serial;
  String eventTimeStamp;
  String didSucceed;
  double x1;
  double y1;
  double x2;
  double y2;
  double x3;
  double y3;
  double mx1;
  double my1;
  double mx2;
  double my2;
  double mx3;
  double my3;
  double mx4;
  double my4;
  double mx5;
  double my5;

  LocalAuthData({
    required this.serial,
    required this.eventTimeStamp,
    required this.didSucceed,
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required this.x3,
    required this.y3,
    required this.mx1,
    required this.my1,
    required this.mx2,
    required this.my2,
    required this.mx3,
    required this.my3,
    required this.mx4,
    required this.my4,
    required this.mx5,
    required this.my5
  });

  factory LocalAuthData.fromJson(Map<String, dynamic> json) => _$LocalAuthDataFromJson(json);
  Map<String, dynamic> toJson() => _$LocalAuthDataToJson(this);
}