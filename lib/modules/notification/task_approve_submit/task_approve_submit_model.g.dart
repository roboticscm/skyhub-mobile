// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_approve_submit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskApproveSubmit _$TaskApproveSubmitFromJson(Map<String, dynamic> json) {
  return TaskApproveSubmit(
      userId: json['userId'] as int,
      task: json['task'] as int,
      groupId: json['groupId'] as int,
      sourceId:  json['sourceId'] as int
     );
}

Map<String, dynamic> _$TaskApproveSubmitToJson(TaskApproveSubmit instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'task': instance.task,
      'groupId': instance.groupId,
      'sourceId': instance.sourceId

    };

