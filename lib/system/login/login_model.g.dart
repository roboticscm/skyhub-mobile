// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRequest _$AuthRequestFromJson(Map<String, dynamic> json) {
  return AuthRequest(
      resetToken: json['resetToken'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      urlPrefix: json['urlPrefix'] as String,
      companyId: json['companyId'] as num,
      branchId: json['branchId'] as num);
}

Map<String, dynamic> _$AuthRequestToJson(AuthRequest instance) =>
    <String, dynamic>{
      'resetToken': instance.resetToken,
      'username': instance.username,
      'urlPrefix': instance.urlPrefix,
      'password': instance.password,
      'companyId': instance.companyId,
      'branchId': instance.branchId
    };

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) {
  return AuthResponse(
      userId: json['userId'] as int,
      employeeId: json['employeeId'] as int,
      loginResult: json['loginResult'] as String,
      username: json['username'] as String,
      fullName: json['fullName'] as String,
      token: json['token'] as String);
}

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'employeeId': instance.employeeId,
      'loginResult': instance.loginResult,
      'username': instance.username,
      'fullName': instance.fullName,
      'token': instance.token
    };
