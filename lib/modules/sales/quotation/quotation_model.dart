import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/common/convertor.dart';
part 'quotation_model.g.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class QuotationView {

  static const int STATUS_NEW = 1;
  static const int STATUS_REJECT = 2;
  static const int STATUS_WAITING = 3;
  static const int STATUS_SUBMIT = 4;
  static const int STATUS_MANAGER = 5;
  static const int STATUS_APPROVED = 6;
  static const int STATUS_FOLLOW_UP = 7;
  static const int STATUS_SOLD = 8;
  static const int STATUS_CANCEL = 9;
  static const int STATUS_TIMEOUT = 10;
  static const int STATUS_FAILED = -1;

  static const int TYPE_SALE = 1;
  static const int TYPE_SERVICE = 2;

  static const  String REPORT_SUNTECH = "suntech";
  static const  String REPORT_DYNAMED = "dynamed";

  static const intSTAGE = 6;

  final int id;
  String code;
  final DateTime quotationDate;
  String content;
  String customerName;
  final int customerId;
  final String empName;
  int status;
  int submit;
  final double grandTotal;
  final String creatorName;
  final DateTime createdDate;
  final DateTime approvalDate1;
  final String approvalName1;
  final DateTime approvalDate2;
  final String approvalName2;
  final DateTime approvalDate3;
  final String approvalName3;
  final int createdId;
  final int requesterId;
  final int creatorId;
  final int picId;
  final int isOwnerApproveLevel1;
  final int isOwnerApproveLevel2;
  final int isOwnerApproveLevel3;

  QuotationView({this.id, this.code, this.grandTotal, this.quotationDate, this.createdDate, this.content, this.customerName,
    this.customerId, this.empName, this.status,this.submit, this.creatorName, this.approvalDate1, this.approvalName1,
    this.approvalDate2, this.approvalName2, this.approvalDate3, this.approvalName3,
    this.createdId, this.requesterId, this.creatorId, this.picId,this.isOwnerApproveLevel1,this.isOwnerApproveLevel2,this.isOwnerApproveLevel3
  });

  factory QuotationView.fromJson(Map<String, dynamic> json) => _$QuotationViewFromJson(json);

  Map<String, dynamic> toJson() => _$QuotationViewToJson(this);
}


@JsonSerializable()
class QuotationItemView {
  final int quotationId;
  final int id;
  final int itemId;
  final String itemCode;
  final String itemName;
  final String itemCodeOrigin;
  final String itemNameOrigin;
  final String itemCodeOrder;
  final String brand;
  final int unitId;
  final String unitName;
  final int qty;
  final int price;
  final int qtyOut;
  final int stock;
  QuotationItemView({this.quotationId, this.id, this.itemId, this.itemCode,
    this.itemName, this.qty, this.price, this.qtyOut, this.stock ,this.itemCodeOrigin,this.itemNameOrigin,this.itemCodeOrder,this.brand,this.unitName,this.unitId
  });

  factory QuotationItemView.fromJson(Map<String, dynamic> json) => _$QuotationItemViewFromJson(json);
  Map<String, dynamic> toJson() => _$QuotationItemViewToJson(this);
}


