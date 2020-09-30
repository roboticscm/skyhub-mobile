part of 'holiday_model.dart';

HolidayView _$HolidayViewFromJson(Map<String, dynamic> json) {
  return HolidayView(
      employeeId: json['employeeId'] as int,
      id: json['id'] as int,
      empName: json['empName'] as String,
      departmentId: json['departmentId'] as int,
      companyId: json['companyId'] as int,
      branchId: json['branchId'] as int,
      deptName: json['deptName'] as String,
      code: json['code'] as String,
      holidayType: json['holidayType'] as String,
      status: json['status'] as int,
      submit: json['submit'] as int,
      content: json['content'] as String,
      notes: json['notes'] as String,
      account: json['account'] as String,
      used: json['used'] == null ? null : double.parse(json['used'].toString()),
      numOfDay: json['numOfDay'] == null ? null : double.parse(json['numOfDay'].toString()),
      holidayDay: json['holidayDay'] == null ? null : double.parse(json['holidayDay'].toString()),
      lastYearBalance: json['lastYearBalance'] == null ? null : double.parse(json['lastYearBalance'].toString()),
      submitId0: json['submitId0'] as int,
      submitName0: json['submitName0'] as String,
      submitId1: json['submitId1'] as int,
      submitName1: json['submitName1'] as String,
      submitId2: json['submitId2'] as int,
      submitName2: json['submitName2'] as String,
      submitId3: json['submitId3'] as int,
      submitName3: json['submitName3'] as String,
      approverId1: json['approverId1'] as int,
      approvalName1: json['approvalName1'] as String,
      approvalName2: json['approvalName2'] as String,
      approvalName3: json['approvalName3'] as String,
      creatorId: json['creatorId'] as int,
      createdId: json['createdId'] as int,
      isOwnerApproveLevel1:json['isOwnerApproveLevel1'] as int,
      isOwnerApproveLevel2:json['isOwnerApproveLevel2'] as int,
      isOwnerApproveLevel3:json['isOwnerApproveLevel3'] as int,
      lastYearExp: json['lastYearExp'] == null ? null
      : const CustomDateTimeConverter().fromJson(json['lastYearExp'] as String),
      approvalDate1: json['approvalDate1'] == null ? null
          : const CustomDateTimeConverter().fromJson(json['approvalDate1'] as String),
      approverId2: json['approverId2'] as int,
      approvalDate2: json['approvalDate2'] == null ? null
          : const CustomDateTimeConverter().fromJson(json['approvalDate2'] as String),
      approverId3: json['approverId3'] as int,
      approvalDate3: json['approvalDate3'] == null ? null
          : const CustomDateTimeConverter().fromJson(json['approvalDate3'] as String),
      requesterId: json['requesterId'] as int,
      requestDate: json['requestDate'] == null ? null
          : const CustomDateTimeConverter().fromJson(json['requestDate'] as String),
      createdDate: json['createdDate'] == null ? null
          : const CustomDateTimeConverter().fromJson(json['createdDate'] as String),
      startDate: json['startDate'] == null ? null
          : const CustomDateTimeConverter().fromJson(json['startDate'] as String),
      endDate: json['endDate'] == null ? null
          : const CustomDateTimeConverter().fromJson(json['endDate'] as String));
}

Map<String, dynamic> _$HolidayViewToJson(HolidayView instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'id': instance.id,
      'empName': instance.empName,
      'departmentId' : instance.departmentId,
      'companyId' : instance.companyId,
      'branchId' : instance.branchId,
      'deptName' : instance.deptName,
      'code' : instance.code,
      'account' : instance.account,
      'holidayType' : instance.holidayType,
      'status' : instance.status,
      'submit' :instance.submit,
      'content': instance.content,
      'notes': instance.notes,
      'numOfDay' : instance.numOfDay,
      'createdId': instance.createdId,
      'creatorId' : instance.creatorId,
      'requesterId' : instance.requesterId,
      'approverId1' : instance.approverId1,
      'approverId2' : instance.approverId2,
      'approverId3' : instance.approverId3,

      'approvalName1' : instance.approvalName1,
      'approvalName2' : instance.approvalName2,
      'approvalName3' : instance.approvalName3,

      'submitId0': instance.submitId0,
      'submitName0': instance.submitName0,
      'submitId1' : instance.submitId1,
      'submitName1' : instance.submitName1,
      'submitId2' : instance.submitId2,
      'submitName2' : instance.submitName2,
      'submitId3' : instance.submitId3,
      'submitName3' : instance.submitName3,

      'holidayDay' : instance.holidayDay,
      'lastYearBalance' : instance.lastYearBalance,
      'used' : instance.used,
      'isOwnerApproveLevel1':instance.isOwnerApproveLevel1 ,
      'isOwnerApproveLevel1':instance.isOwnerApproveLevel2 ,
      'isOwnerApproveLevel1':instance.isOwnerApproveLevel3 ,
      'lastYearExp' : instance.lastYearExp == null ? null : const CustomDateTimeConverter().toJson(instance.lastYearExp),
      'createdDate' : instance.createdDate == null ? null : const CustomDateTimeConverter().toJson(instance.createdDate),
      'requestDate' : instance.requestDate == null ? null : const CustomDateTimeConverter().toJson(instance.requestDate),
      'approvalDate1' : instance.approvalDate1 == null ? null : const CustomDateTimeConverter().toJson(instance.approvalDate1),
      'approvalDate2' : instance.approvalDate2 == null ? null : const CustomDateTimeConverter().toJson(instance.approvalDate2),
      'approvalDate3' : instance.approvalDate3 == null ? null : const CustomDateTimeConverter().toJson(instance.approvalDate3),
      'startDate' : instance.startDate == null ? null : const CustomDateTimeConverter().toJson(instance.startDate),
      'endDate' : instance.endDate == null ? null : const CustomDateTimeConverter().toJson(instance.endDate),
    };

HolidayParam _$HolidayParamFromJson(Map<String, dynamic> json) {
      return HolidayParam(
          empId: json['empId'] as int,
          deptId: json['deptId'] as int,
          deptName: json['deptName'] as String,
          holidayDay: json['holidayDay'] == null ? null : double.parse(json['holidayDay'].toString()),
          used: json['used'] == null ? null : double.parse(json['used'].toString()),
          lastYearBalance: json['lastYearBalance'] == null ? null : double.parse(json['lastYearBalance'].toString()),
          lastYearExp: json['lastYearExp'] == null ? null
              : const CustomDateTimeConverter().fromJson(json['lastYearExp'] as String));
}

Map<String, dynamic> _$HolidayParamToJson(HolidayParam instance) =>
    <String, dynamic>{
          'empId': instance.empId,
          'deptId': instance.deptId,
          'deptName' : instance.deptName,
          'holidayDay' : instance.holidayDay,
          'used' : instance.used,
          'lastYearBalance' : instance.lastYearBalance,
          'lastYearExp' : instance.lastYearExp == null ? null : const CustomDateTimeConverter().toJson(instance.lastYearExp),
    };
