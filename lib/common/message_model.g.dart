
part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    status: json['status'] as String,
    message: json['message'] as String,
    updateObject: json['updateObject'] as String,

  );
}

Map<String, dynamic> _$MessageToJson(Message instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'updateObject':instance.updateObject,
    };

