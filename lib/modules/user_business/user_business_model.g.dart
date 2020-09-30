// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_business_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBusiness _$UserBusinessFromJson(Map<String, dynamic> json) {
  return UserBusiness(
    userId: json['userId'] as int,
    business: json['business'] as String,
    isLevel1: json['levelApprove1']  == 1? true :false,
    isLevel2:  json['levelApprove2'] == 1? true :false,
    isLevel3:  json['levelApprove3'] == 1? true :false,
  );
}

Map<String, dynamic> _$UserBusinessToJson(UserBusiness instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'business': instance.business,
    };

