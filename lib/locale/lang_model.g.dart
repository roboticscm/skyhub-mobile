part of 'lang_model.dart';
Lang _$LangFromJson(Map<String, dynamic> json) {
  return Lang(
    key: json['key'] as String,
    vi: json['vi'] as String,
    en: json['en'] as String,
  );
}

Map<String, dynamic> _$LangToJson(Lang instance) =>
    <String, dynamic>{
      'key': instance.key,
      'vi': instance.vi,
      'en': instance.en,
    };