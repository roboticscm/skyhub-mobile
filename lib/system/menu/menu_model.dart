import 'package:json_annotation/json_annotation.dart';
part 'menu_model.g.dart';

@JsonSerializable()
class Menu {
  final int id;
  final String resourceKey;
  int totalNotify;
  DateTime lastNotify;
  static const   int MESSAGE = 10101;
  static const   int WORKS_MANAGERMENT   = 20101;
  Menu({this.id, this.resourceKey});

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);
  Map<String, dynamic> toJson() => _$MenuToJson(this);
}