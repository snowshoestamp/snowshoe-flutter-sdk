import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class Stamp {
  String serial;
  String customName;
  bool active;
  double x1;
  double y1;
  double x2;
  double y2;
  double x3;
  double y3;

  Stamp({
    required this.serial,
    required this.customName,
    required this.active,
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required this.x3,
    required this.y3,
  });

  factory Stamp.fromJson(Map<String, dynamic> json) {
    var active = json['active'] is bool ? json['active'] : json['active'] == 1;
    return Stamp(
      serial: json['serial'] as String,
      customName: json['customName'] as String,
      active: active,
      x1: (json['x1'] as num).toDouble(),
      y1: (json['y1'] as num).toDouble(),
      x2: (json['x2'] as num).toDouble(),
      y2: (json['y2'] as num).toDouble(),
      x3: (json['x3'] as num).toDouble(),
      y3: (json['y3'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic> {
      'serial': serial,
      'customName': customName,
      'active': active ? 1 : 0,
      'x1': x1,
      'y1': y1,
      'x2': x2,
      'y2': y2,
      'x3': x3,
      'y3': y3
  };
}