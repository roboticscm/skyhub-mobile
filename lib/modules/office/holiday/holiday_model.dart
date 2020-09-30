import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/common/convertor.dart';
part 'holiday_model.g.dart';

@JsonSerializable()
@CustomDateTimeConverter()
@CustomTimeConverter()
class HolidayView {
  static const int STATUS_NEW = 1;
  static const int STATUS_REJECT = 2;
  static const int STATUS_WAITING = 3;
  static const int STATUS_SUBMIT = 4;
  static const int STATUS_HR = 5;
  static const int STATUS_APPROVED = 6;
  static const int STATUS_CANCELED = -1;
  static const String TYPE_PERSONAL_LEAVE = "PR";

  final int id;
  final int employeeId;
  String empName;
  String account;
  final int departmentId;
  final int companyId;
  final int branchId;
  String deptName;
  final String code;
  final String holidayType;
  int status;
  int submit;
  final String content;
  final String notes;
  DateTime startDate;
  DateTime endDate;
  double numOfDay;
  final DateTime createdDate;
  final int requesterId;
  final DateTime requestDate;
  final int approverId1;
  final DateTime approvalDate1;
  final String approvalName1;
  final int approverId2;
  final DateTime approvalDate2;
  final String approvalName2;
  final int approverId3;
  final DateTime approvalDate3;
  final String approvalName3;
  final int submitId0;
  final String submitName0;
  final int submitId1;
  final String submitName1;
  final int submitId2;
  final String submitName2;
  final int submitId3;
  final String submitName3;
  final int createdId;
  final int creatorId;
  final int isOwnerApproveLevel1;
  final int isOwnerApproveLevel2;
  final int isOwnerApproveLevel3;

  double holidayDay;
  double lastYearBalance;
  final DateTime lastYearExp;
  double used;

  HolidayView({this.approvalName1, this.approvalName2, this.approvalName3, this.account,
      this.companyId, this.branchId,this.createdId, this.creatorId, this.id, this.code, this.holidayType,
      this.status, this.content, this.notes, this.startDate,
      this.endDate, this.numOfDay, this.createdDate, this.requesterId, this.requestDate, this.approverId1,
      this.approvalDate1, this.approverId2, this.approvalDate2, this.approverId3, this.approvalDate3,
      this.submitId0, this.submitName0, this.submitId1, this.submitName1, this.submitId2, this.submitName2,
      this.submitId3, this.submitName3, this.employeeId, this.empName, this.departmentId, this.deptName,
      this.holidayDay, this.lastYearBalance, this.lastYearExp, this.used,this.submit,this.isOwnerApproveLevel1,this.isOwnerApproveLevel2,this.isOwnerApproveLevel3
  });

  factory HolidayView.fromJson(Map<String, dynamic> json) => _$HolidayViewFromJson(json);
  Map<String, dynamic> toJson() => _$HolidayViewToJson(this);
}


@JsonSerializable()
@CustomDateTimeConverter()
class HolidayParam {
  final int empId;
  final int deptId;
  final String deptName;
  final double holidayDay;
  final double lastYearBalance;
  final DateTime lastYearExp;
  final double used;

  HolidayParam({
    this.empId,
    this.deptId,
    this.deptName,
    this.holidayDay,
    this.lastYearBalance,
    this.lastYearExp,
    this.used,
});

  factory HolidayParam.fromJson(Map<String, dynamic> json) => _$HolidayParamFromJson(json);
  Map<String, dynamic> toJson() => _$HolidayParamToJson(this);
}