// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_devices_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterDevices _$RegisterDevicesFromJson(Map<String, dynamic> json) {
  return RegisterDevices(
      userId: json['userId'] as int,
      uuid: json['uuid'] as String,
      device: json['device'] as String,
      os: json['os'] as String,
      accepted: json['accepted'] as bool);
}

Map<String, dynamic> _$RegisterDevicesToJson(RegisterDevices instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'uuid': instance.uuid,
      'device': instance.device,
      'os': instance.os,
      'accepted': instance.accepted
    };
