import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable(explicitToJson: true)
class Settings {
  int id;
  String lastSyncTimeStamp;
  int timeoutDays;
  int debugMode;
  int active;
  String appKey;
  int stampPoints;
  double gridX;
  double gridY;
  double tolerance;

  Settings({
    required this.id,
    required this.lastSyncTimeStamp,
    required this.timeoutDays,
    required this.debugMode,
    required this.active,
    required this.appKey,
    required this.stampPoints,
    required this.gridX,
    required this.gridY,
    required this.tolerance
  });

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  bool isActive() => active == 1;
  bool isDebugMode() => debugMode == 1;
}