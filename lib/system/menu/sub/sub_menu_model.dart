
import 'package:json_annotation/json_annotation.dart';
part 'sub_menu_model.g.dart';

@JsonSerializable()
class SubMenu {
  final int id;
  final String resourceKey;
  int totalNotify;
  DateTime lastNotify;
  SubMenu({this.id, this.resourceKey});
  factory SubMenu.fromJson(Map<String, dynamic> json) => _$SubMenuFromJson(json);
  Map<String, dynamic> toJson() => _$SubMenuToJson(this);
}