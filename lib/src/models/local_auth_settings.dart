import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
import 'package:crypto/crypto.dart';

part 'local_auth_settings.g.dart';

@JsonSerializable(explicitToJson: true)
class LocalAuthSettings {
  bool active;
  @JsonKey(name: 'timeout_Days')
  int timeoutDays;
  @JsonKey(name: 'debug_Mode')
  bool debugMode;
  int stampPoints;
  double gridX;
  double gridY;
  double tolerance;

  LocalAuthSettings({
    required this.active,
    required this.timeoutDays,
    required this.debugMode,
    required this.stampPoints,
    required this.gridX,
    required this.gridY,
    required this.tolerance
  });

  factory LocalAuthSettings.fromJson(Map<String, dynamic> json) => _$LocalAuthSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$LocalAuthSettingsToJson(this);
}