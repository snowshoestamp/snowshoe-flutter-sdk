import 'package:json_annotation/json_annotation.dart';

part 'snow_shoe_stamp.g.dart';

@JsonSerializable(explicitToJson: true)
class SnowShoeStamp {
  String serial;

  SnowShoeStamp({
    required this.serial
  });

  factory SnowShoeStamp.fromJson(Map<String, dynamic> json) => _$SnowShoeStampFromJson(json);
  Map<String, dynamic> toJson() => _$SnowShoeStampToJson(this);
}