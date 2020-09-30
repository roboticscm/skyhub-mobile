import 'package:json_annotation/json_annotation.dart';
part 'lang_model.g.dart';

@JsonSerializable()
class Lang {
  final String key;
  final String en;
  final String vi;

  Lang({this.key, this.en, this.vi});

  factory Lang.fromJson(Map<String, dynamic> json) =>
      _$LangFromJson(json);

  Map<String, dynamic> toJson() => _$LangToJson(this);
}

