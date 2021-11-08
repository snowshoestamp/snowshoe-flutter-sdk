import 'package:json_annotation/json_annotation.dart';
import 'package:snowshoe_sdk_flutter/src/db/stamp.dart';
import 'package:snowshoe_sdk_flutter/src/models/local_auth_settings.dart';

part 'get_stamps_result.g.dart';

@JsonSerializable(explicitToJson: true)
class GetStampsResult {
  String? timeStamp;
  String? continuationToken = "";
  List<Stamp> stamps;
  @JsonKey(name: 'localAuth_Settings')
  LocalAuthSettings localAuthSettings;

  GetStampsResult({
    required this.timeStamp,
    required this.continuationToken,
    required this.stamps,
    required this.localAuthSettings,
  });

  factory GetStampsResult.fromJson(Map<String, dynamic> json) => _$GetStampsResultFromJson(json);
  Map<String, dynamic> toJson() => _$GetStampsResultToJson(this);
}