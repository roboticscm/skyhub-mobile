import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/common/convertor.dart';
part 'task_approve_submit_model.g.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class TaskApproveSubmit {
  static const int TASK_FINISH = 0;
  static const int TASK_SUBMIT =1;
  static const int TASK_CANCEL_SUBMIT = 2;
  static const int TASK_APPROVE = 3;
  static const int TASK_CANCEL_APPROVE = 4;
  static const int TASK_REJECT = 5;
  static const int TASK_CANCEL =6;
  static const int TASK_DELETE =7;
  final int userId;
  final int task;
  final int sourceId;
  final int groupId;


  TaskApproveSubmit({
     this.userId,
     this.task,
     this.sourceId,
     this.groupId

  });

  factory TaskApproveSubmit.fromJson(Map<String, dynamic> json) => _$TaskApproveSubmitFromJson(json);
  Map<String, dynamic> toJson() => _$TaskApproveSubmitToJson(this);
}


