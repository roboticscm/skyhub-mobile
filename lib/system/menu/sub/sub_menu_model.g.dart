part of 'sub_menu_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************
SubMenu _$SubMenuFromJson(Map<String, dynamic> json) {
  return SubMenu(
    resourceKey: json['resourceKey'] as String,
    id: json['id'] as int,
  );
}

Map<String, dynamic> _$SubMenuToJson(SubMenu instance) =>
    <String, dynamic>{
      'id': instance.id,
      'resourceKey': instance.resourceKey
    };