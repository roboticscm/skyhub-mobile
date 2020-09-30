import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/common/convertor.dart';
part 'message_model.g.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class Message {

  final String status;
  final String message;
  final String updateObject;

  Message({
    this.status,
    this.message,
    this.updateObject


  });

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}


