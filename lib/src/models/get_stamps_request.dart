import 'package:json_annotation/json_annotation.dart';

part 'get_stamps_request.g.dart';

@JsonSerializable(explicitToJson: true)
class GetStampsRequest {
  String timestamp;
  String continuationToken;
  String sdkVersion;

  GetStampsRequest({
    required this.timestamp,
    required this.continuationToken,
    required this.sdkVersion,
  });

  factory GetStampsRequest.fromJson(Map<String, dynamic> json) => _$GetStampsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$GetStampsRequestToJson(this);
}