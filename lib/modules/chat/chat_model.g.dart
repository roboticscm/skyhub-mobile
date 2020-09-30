// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatHistory _$ChatHistoryFromJson(Map<String, dynamic> json) {
  return ChatHistory(
      userId: json['userId'] as int,
      task: json['task'] as int,
      name: json['name'] as String,
      account: json['account'] as String,
      jobTitle: json['jobTitle'] as String,
      lastMessage: json['lastMessage'] as String,
      unreadMessage: json['unreadMessage'] as int,
      lastAccess: json['lastAccess'] == null ? null
          : const CustomDateTimeConverter().fromJson(json['lastAccess'] as String),
      sendDate: json['sendDate'] == null ? null
        : const CustomDateTimeConverter().fromJson(json['sendDate'] as String),
      sourceId: json['sourceId'] == null ? 0:json['sourceId']);
}

Map<String, dynamic> _$ChatHistoryToJson(ChatHistory instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'task': instance.task,
      'name' : instance.name,
      'account' : instance.account,
      'jobTitle' : instance.jobTitle,
      'lastMessage' : instance.lastMessage,
      'unreadMessage' : instance.unreadMessage,
      'lastAccess' : instance.lastAccess == null ? null : const CustomDateTimeConverter().toJson(instance.lastAccess),
      'sendDate' : instance.sendDate == null ? null : const CustomDateTimeConverter().toJson(instance.sendDate),
       'sourceId' : instance.sourceId == null ? 0 : instance.sourceId,
    };

ChatHistoryDetails _$ChatHistoryDetailsFromJson(Map<String, dynamic> json) {
  return ChatHistoryDetails(
      id: json['id'] as int,
      senderId: json['senderId'] as int,
      task: json['task'] as int,
      receiverId: json['receiverId'] as int,
      message: json['message'] as String,
      name: json['name'] as String,
      status: json['status'] as int,
      sendDate: json['sendDate'] == null ? null : const CustomDateTimeConverter().fromJson(json['sendDate'] as String),
      sourceId: json['sourceId'] == null ? 0 : json['sourceId'] as int);
}

Map<String, dynamic> _$ChatHistoryDetailsToJson(ChatHistoryDetails instance) =>
    <String, dynamic>{
      'id':instance.id,
      'senderId': instance.senderId,
      'task': instance.task,
      'receiverId' : instance.receiverId,
      'message' : instance.message,
      'name' : instance.name,
      'status' : instance.status,
      'sendDate' : instance.sendDate == null ? null : const CustomDateTimeConverter().toJson(instance.sendDate),
      'sourceId'  :instance.sourceId == null ? 0: instance.sourceId,
    };


UserMetaData _$UserMetaDataFromJson(Map<String, dynamic> json) {
  return UserMetaData(
      userId: json['userId'] as int,
      name: json['name'] as String,
      account: json['account'] as String,
      employeeId: json['employeeId'] as int,
      companyId: json['companyId'] as int,
      branchId: json['branchId'] as int,
      departmentId: json['departmentId'] as int,
      onlineUsers: json['onlineUsers'] as Map<dynamic, dynamic>,
      receiverId: json['receiverId'] as int,
      deviceInfo: json['deviceInfo'] as String,
      sessionId: json['sessionId'] as String,
      candidate: json['candidate'] == null ? null: Candidate.fromJson(json['candidate']),
      device: json['device'] as String,
      screenWidth: json['screenWidth'] as double,
      screenHeight: json['screenHeight'] as double,
      videoMediaCall: json['videoMediaCall'] as bool,
      candidateDescription: json['candidateDescription'] == null ? null: CandidateDescription.fromJson(json['candidateDescription']),
      groupId: json['groupId'] as int);
}

Map<String, dynamic> _$UserMetaDataToJson(UserMetaData instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'account': instance.account,
      'employeeId' : instance.employeeId,
      'companyId' : instance.companyId,
      'branchId' : instance.branchId,
      'departmentId' : instance.departmentId,
      'groupId' : instance.groupId,
      'onlineUsers' : instance.onlineUsers,
      'receiverId' : instance.receiverId,
      'deviceInfo': instance.deviceInfo,
      'candidate': instance.candidate,
      'device': instance.device,
      'screenHeight': instance.screenHeight,
      'screenWidth': instance.screenWidth,
      'videoMediaCall': instance.videoMediaCall,
      'sessionId': instance.sessionId,
      'candidateDescription': instance.candidateDescription
    };


CandidateDescription _$CandidateDescriptionFromJson(Map<String, dynamic> json) {
  return CandidateDescription(
      type: json['type'] as String,
      sdp: json['sdp'] as String,
      );
}

Map<String, dynamic> _$CandidateDescriptionToJson(CandidateDescription instance) =>
    <String, dynamic>{
      'type': instance.type,
      'sdp': instance.sdp,
    };

Candidate _$CandidateFromJson(Map<String, dynamic> json) {
  return Candidate(
    candidate: json['candidate'] as String,
    sdpMid: json['sdpMid'] as String,
    sdpMLineIndex: json['sdpMLineIndex'] as int,
  );
}

Map<String, dynamic> _$CandidateToJson(Candidate instance) =>
    <String, dynamic>{
      'candidate': instance.candidate,
      'sdpMid': instance.sdpMid,
      'sdpMLineIndex': instance.sdpMLineIndex,
    };

ChatData _$ChatDataFromJson(Map<String, dynamic> json) {
  return ChatData(
      id: json['id'] as int,
      datetime: json['datetime'] as String,
      fromId: json['fromId'] as int,
      toId: json['toId'] as int,
      time: json['time'] as String,
      senderName: json['senderName'] as String,
      avatar: json['avatar'] as String,
      dateTimeHead: json['dateTimeHead'] as int,
      mychattimeline: json['mychattimeline'] as String,
      msgContent: json['msgContent'] as String,
      newDate: json['newDate'] as int,
      numMsg: json['numMsg'] as int,
      bridged: json['bridged'] as int,
      subItemHead: json['subItemHead'] as String,
      lapseTime: json['lapseTime'] as String,
      response: json['response'] as String);
}

Map<String, dynamic> _$ChatDataToJson(ChatData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'datetime': instance.datetime,
      'fromId': instance.fromId,
      'toId': instance.toId,
      'time' : instance.time,
      'senderName' : instance.senderName,
      'avatar' : instance.avatar,
      'dateTimeHead' : instance.dateTimeHead,
      'mychattimeline' : instance.mychattimeline,
      'msgContent' : instance.msgContent,
      'newDate' : instance.newDate,
      'numMsg': instance.numMsg,
      'bridged': instance.bridged,
      'subItemHead': instance.subItemHead,
      'lapseTime': instance.lapseTime,
      'response': instance.response
};


SkyNotification _$SkyNotificationFromJson(Map<String, dynamic> json) {
  return SkyNotification(
//      employee: json['employee'] as int,
//      traveling: json['traveling'] as int,
//      quotation: json['quotation'] as int,
//      holiday: json['holiday'] as int,
//      reqInventoryOut: json['reqInventoryOut'] as int,
//      reqInventoryIn: json['reqInventoryIn'] as int,
//      reqPo: json['reqPo'] as int,
//      message: json['message'] as int,
//      task: json['task'] as int,
//      event: json['event'] as int,
    sendDate: json['sendDate'] == null ? null : const CustomDateTimeConverter().fromJson(json['sendDate'] as String),
    displayId: json['displayId'] as int,
    count: json['count'] as int,
  );
}

Map<String, dynamic> _$SkyNotificationToJson(SkyNotification instance) =>
    <String, dynamic>{
//      'employee': instance.employee,
//      'traveling': instance.traveling,
//      'quotation': instance.quotation,
//      'holiday': instance.holiday,
//      'event': instance.event,
//      'reqInventoryOut': instance.reqInventoryOut,
//      'reqInventoryIn': instance.reqInventoryIn,
//      'reqPo': instance.reqPo,
//      'message': instance.message,
//      'task': instance.task,
      'count': instance.count,
      'displayId': instance.displayId,
      'sendDate' : instance.sendDate == null ? null : const CustomDateTimeConverter().toJson(instance.sendDate)
    };