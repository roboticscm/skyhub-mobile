import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/common/convertor.dart';
part 'chat_model.g.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class ChatHistory {
  static const int TASK_FINISH = 0;
  static const int TASK_SUBMIT =1;
  static const int TASK_CANCEL_SUBMIT = 2;
  static const int TASK_APPROVE = 3;
  static const int TASK_CANCEL_APPROVE = 4;
  static const int TASK_REJECT = 5;
  static const int TASK_DENY =6;

  static const int GROUP_CHAT = 1;
  static const int GROUP_QUOTATION = 2;
  static const int GROUP_CONTRACT = 3;
  static const int GROUP_ACCEPTANCE =4;
  static const int GROUP_REQORDER =5;
  static const int GROUP_REQINVENTORYOUT =6;
  static const int GROUP_REQINVENTORYIN = 7;
  static const int GROUP_ADVANCE = 8;
  static const int GROUP_REQPAYMENT =9;
  static const int GROUP_HOLIDAY = 10;
  static const int GROUP_TRAVELING  = 11;
  static const int GROUP_PAYMENT    =12;
  static const int GROUP_REQPO      =13;
  static const int GROUP_INVENTORYOUT = 14;
  static const int GROUP_INVENTORYIN  =15;
  static const int GROUP_EMPLOYEE     =16;
  static const int GROUP_INSPECTION   = 17;
  static const int GROUP_REPAIRREPORT  = 18;
  static const int GROUP_PO = 19;
  
  final int userId;
  final String name;
  final String account;
  final String jobTitle;
  final String lastMessage;
  final DateTime sendDate;
  final DateTime lastAccess;
  final int task;
  final int sourceId;

  bool isOnline;
  String devices;
  int unreadMessage;

  ChatHistory({
    this.userId,
    this.name,
    this.account,
    this.jobTitle,
    this.lastMessage,
    this.sendDate,
    this.unreadMessage,
    this.lastAccess,
    this.task,
    this.sourceId,
  });

  factory ChatHistory.fromJson(Map<String, dynamic> json) => _$ChatHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$ChatHistoryToJson(this);
}

@JsonSerializable()
@CustomDateTimeConverter()
class ChatHistoryDetails {

  static const int TASK_FINISH = 0;
  static const int TASK_SUBMIT =1;
  static const int TASK_CANCEL_SUBMIT = 2;
  static const int TASK_APPROVE = 3;
  static const int TASK_CANCEL_APPROVE = 4;
  static const int TASK_REJECT = 5;
  static const int TASK_DENY =6;

  static const int TASK_ME_SUBMIT =101;
  static const int TASK_CAN_CANCEL_SUBMIT =102;
   int id;
   int senderId;
   int task;
   int receiverId;
   String message;
   DateTime sendDate;
   int status;
   String name;
   int sourceId;

  ChatHistoryDetails({
    this.id,
    this.senderId,
    this.task,
    this.receiverId,
    this.message,
    this.sendDate,
    this.status,
    this.name,
    this.sourceId,
  });

  factory ChatHistoryDetails.fromJson(Map<String, dynamic> json) => _$ChatHistoryDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$ChatHistoryDetailsToJson(this);
}

@JsonSerializable()
class UserMetaData {
  final int userId;
  final int employeeId;
  final int companyId;
  final int branchId;
  final int departmentId;
  final int groupId;
  final int receiverId;
  final Map<dynamic, dynamic> onlineUsers;
  final String account;
  final String name;
  final String deviceInfo;
  final Candidate candidate;
  final String device; //Web, Mobile
  final double screenWidth;
  final double screenHeight;
  final bool videoMediaCall;
  final String sessionId;

  final CandidateDescription candidateDescription;
  UserMetaData({
    this.userId,
    this.employeeId,
    this.companyId,
    this.branchId,
    this.departmentId,
    this.groupId,
    this.receiverId,
    this.onlineUsers,
    this.name,
    this.account,
    this.deviceInfo,
    this.candidate,
    this.candidateDescription,
    this.device,
    this.screenHeight,
    this.screenWidth,
    this.videoMediaCall,
    this.sessionId,

  });

  factory UserMetaData.fromJson(Map<String, dynamic> json) => _$UserMetaDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserMetaDataToJson(this);
}

@JsonSerializable()
class CandidateDescription {
  final String sdp;
  final String type;

  CandidateDescription({
    this.sdp,
    this.type,
  });

  factory CandidateDescription.fromJson(Map<String, dynamic> json) => _$CandidateDescriptionFromJson(json);
  Map<String, dynamic> toJson() => _$CandidateDescriptionToJson(this);
}

@JsonSerializable()
class Candidate {
  final String candidate;
  final String sdpMid;
  final int sdpMLineIndex;

  Candidate({
    this.candidate,
    this.sdpMid,
    this.sdpMLineIndex,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) => _$CandidateFromJson(json);
  Map<String, dynamic> toJson() => _$CandidateToJson(this);
}

class ChatData {
  final int id;
  final String datetime;
  final int fromId;
  final int toId;
  final String time;
  final String senderName;
  final String avatar;
  final int dateTimeHead;
  final String mychattimeline;
  final String msgContent;
  final int newDate;
  final int numMsg;
  final int bridged;
  final String subItemHead;
  final String lapseTime;
  final String response;

  ChatData({
    this.id,
    this.datetime,
    this.fromId,
    this.toId,
    this.time,
    this.senderName,
    this.avatar,
    this.dateTimeHead,
    this.mychattimeline,
    this.msgContent,
    this.newDate,
    this.numMsg,
    this.bridged,
    this.subItemHead,
    this.lapseTime,
    this.response,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) => _$ChatDataFromJson(json);
  Map<String, dynamic> toJson() => _$ChatDataToJson(this);
}


class SkyNotification {
   static const int GROUP_MESSAGE = 1;
   static const int GROUP_QOTATION = 2;
   static const int GROUP_CONTRACT = 3;
   static const int GROUP_ACCEPTANCE =4;
   static const int GROUP_REQORDER =5;
   static const int GROUP_REQINVENTORYOUT =6;
   static const int GROUP_REQINVENTORYIN = 7;
   static const int GROUP_ADVANCE = 8;
   static const int GROUP_REQPAYMENT =9;
   static const int GROUP_HOLIDAY = 10;
   static const int GROUP_TRAVELING = 11;
   static const int GROUP_PAYMENT =12;
   static const int GROUP_REQPO = 13;
   static const int GROUP_INVENTORYOUT = 14;
   static const int GROUP_INVENTORYIN =15;
   static const int GROUP_EMPLOYEE =16;
   static const int GROUP_INSPECTION = 17;
   static const int GROUP_REPAIRREPORT = 18;
   static const int GROUP_TASK = 19;
   static const int GROUP_EVENT = 20;
   static const int GROUP_CALENDAR = 21;
   static const int GROUP_NOTIFICATION = 22;
   static const int GROUP_REGISTER_DEVICES = 23;

//   final int employee;
//   final int traveling;
//   final int quotation;
//   final int holiday;
//   final int reqInventoryOut;
//   final int reqInventoryIn;
//   final int reqPo;
//   final int message;
//   final int task;
//   final int event;
//   final int reqPayment;
//   final int advance;
//   final int payment;
//   final int contract;
//   final int acceptance;
//   final int inspection;
//   final int repairReport;
//   final int inventoryIn;
//   final int inventoryOut;

    final int displayId;
    final int count;
    final DateTime sendDate;
   SkyNotification({
//     this.employee,
//     this.traveling,
//     this.quotation,
//     this.holiday,
//     this.reqInventoryOut,
//     this.reqInventoryIn,
//     this.reqPo,
//     this.message,
//     this.task,
//     this.event,
//     this.reqPayment,
//     this.advance,
//     this.payment,
//     this.contract,
//     this.acceptance,
//     this.inspection,
//     this.repairReport,
//     this.inventoryIn,
//     this.inventoryOut,
      this.sendDate,
      this.count,
      this.displayId
   });

   factory SkyNotification.fromJson(Map<String, dynamic> json) => _$SkyNotificationFromJson(json);
   
   Map<String, dynamic> toJson() => _$SkyNotificationToJson(this);
}