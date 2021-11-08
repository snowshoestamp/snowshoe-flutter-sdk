import 'package:json_annotation/json_annotation.dart';

part 'snow_shoe_stamp.g.dart';

@JsonSerializable(explicitToJson: true)
class SnowShoeStamp {
  String serial;
  String customName;

  SnowShoeStamp({
    required this.serial,
    required this.customName
  });

  factory SnowShoeStamp.fromJson(Map<String, dynamic> json) => _$SnowShoeStampFromJson(json);
  Map<String, dynamic> toJson() => _$SnowShoeStampToJson(this);
}