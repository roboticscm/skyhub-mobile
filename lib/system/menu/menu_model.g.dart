part of 'menu_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************
Menu _$MenuFromJson(Map<String, dynamic> json) {
  return Menu(
      resourceKey: json['resourceKey'] as String,
      id: json['id'] as int,
      );
}

Map<String, dynamic> _$MenuToJson(Menu instance) =>
    <String, dynamic>{
      'id': instance.id,
      'resourceKey': instance.resourceKey
    };