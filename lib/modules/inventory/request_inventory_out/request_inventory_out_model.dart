import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/common/convertor.dart';
part 'request_inventory_out_model.g.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class RequestInventoryOutView {
   static const int TYPE_SALES = 1;
   static const int TYPE_FREE_SAMPLE = 2;
   static const int TYPE_CONSIGNMENT = 3;
   static const int TYPE_LOAN = 4;
   static const int TYPE_LEASE = 5;
   static const int TYPE_LOAN_INTERNAL = 6;
   static const int TYPE_RETURN = 7;
   static const int TYPE_CHANGE = 8;
   static const int TYPE_DAMAGED = 9;
   static const int TYPE_LOSS = 10;
   static const int TYPE_WARRANTY = 11;
   static const int TYPE_LIQUIDATION = 12;
   static const int TYPE_INVENTORY = 18;
   static const int TYPE_OTHER = 19;

   static const int STATUS_NEW = 1;
   static const int STATUS_REJECT = 2;
   static const int STATUS_WAITING = 3;
   static const int STATUS_SUBMIT = 4;
   static const int STATUS_STOCKER = 5;
   static const int STATUS_APPROVED = 6;
   static const int STATUS_UNDONE = 7;
   static const int STATUS_DONE = 8;
   static const int STATUS_CANCELED = -1;

  final int id;
  String code;
  int status;
  int submit;
  final DateTime requestDate;
  final DateTime createdDate;
  final int requestType;
  String content;
  final String partnerType;
  final int partnerId;
  String partnerName;
  final String requesterName;
  final int requesterId;

  final String contactName;
  final String contactPhone;
  final int customerId;
  final int employeeId;
  final int supplierId;
  final double sumQty;

  final int companyId;
  final int branchId;
  final int deleted;
  final int deletedId;
  final int createdId;
  final int warehouseId;
  final int updatedId;
  final DateTime deletedDate;
  final DateTime updatedDate;


  final DateTime approvalDate1;
  final String approvalName1;
  final DateTime approvalDate2;
  final String approvalName2;
  final DateTime approvalDate3;
  final String approvalName3;
  final String notes;
  final int isOwnerApproveLevel1;
  final int isOwnerApproveLevel2;
  final int isOwnerApproveLevel3;
  final int quotationId;
  String fromBusinessCode;
  int    fromBusinessId;


   RequestInventoryOutView({this.id, this.code, this.content, this.partnerType, this.companyId, this.branchId,
    this.deleted, this.deletedId, this.createdId, this.warehouseId, this.updatedId, this.updatedDate, this.deletedDate,
    this.customerId, this.employeeId, this.supplierId, this.sumQty, this.contactName, this.contactPhone,
    this.partnerId, this.requesterId, this.partnerName, this.status, this.requestDate, this.createdDate,
    this.requestType, this.requesterName, this.approvalDate1, this.approvalName1,
    this.approvalDate2, this.approvalName2, this.approvalDate3, this.approvalName3,
    this.notes,this.submit,this.isOwnerApproveLevel1,this.isOwnerApproveLevel2,this.isOwnerApproveLevel3,this.quotationId,this.fromBusinessId,
     this.fromBusinessCode
  });

  factory RequestInventoryOutView.fromJson(Map<String, dynamic> json) => _$RequestInventoryOutViewFromJson(json);



  Map<String, dynamic> toJson() => _$RequestInventoryOutViewToJson(this);
}


@JsonSerializable()
@CustomDateTimeConverter()
class RequestInventoryOutItemView {
  final int id;
  int reqInventoryOutId;
  int itemId;
  String itemCode;
  String itemName;
  int qty;
  int stock;
  int otherWaitingOutQty;
  String notes;

  int warehouseId;
  int status;
  int createdId;
  int updatedId;
  DateTime updatedDate;
  int employeeId;
  int sort;
  DateTime limitDate;
  String brand;
  int unitId;
  String unitName;
  String itemCodeOrigin;
  String itemNameOrigin;
  
  RequestInventoryOutItemView({this.id, this.reqInventoryOutId, this.notes, this.itemId, this.itemCode, this.itemName,
    this.warehouseId, this.status, this.createdId, this.updatedId, this.updatedDate, this.employeeId, this.sort,
    this.qty, this.stock, this.otherWaitingOutQty, this.limitDate,this.brand,this.unitName,this.unitId,this.itemNameOrigin,this.itemCodeOrigin});

  factory RequestInventoryOutItemView.fromJson(Map<String, dynamic> json) => _$RequestInventoryOutItemViewFromJson(json);

  Map<String, dynamic> toJson() => _$RequestInventoryOutItemViewToJson(this);
}


@JsonSerializable()
class RequestInventoryOutItemWaiting {
  final int itemId;
  final int qty;
  final String account;

  RequestInventoryOutItemWaiting({this.itemId, this.qty, this.account});

  factory RequestInventoryOutItemWaiting.fromJson(Map<String, dynamic> json) => _$RequestInventoryOutItemWaitingFromJson(json);
}