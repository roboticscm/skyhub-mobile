import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/common/convertor.dart';
part 'user_business_model.g.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class UserBusiness {


  final int userId;
  final String business;
  final bool isLevel1;
  final bool isLevel2;
  final bool isLevel3;

  UserBusiness({
     this.userId,
     this.business,
     this.isLevel1,
     this.isLevel2,
     this.isLevel3

  });

  factory UserBusiness.fromJson(Map<String, dynamic> json) => _$UserBusinessFromJson(json);
  Map<String, dynamic> toJson() => _$UserBusinessToJson(this);
}


