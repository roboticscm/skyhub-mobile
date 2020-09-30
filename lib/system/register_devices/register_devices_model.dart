import 'package:json_annotation/json_annotation.dart';
part 'register_devices_model.g.dart';

@JsonSerializable()
class RegisterDevices {
  final int userId;
  final DateTime createdDate;
  final String uuid;
  final String device;
  final String os;
  final bool accepted;
  RegisterDevices({
    this.userId,
    this.createdDate,
    this.uuid,
    this.device,
    this.os,
    this.accepted
  });

  factory RegisterDevices.fromJson(Map<String, dynamic> json) => _$RegisterDevicesFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterDevicesToJson(this);
}
