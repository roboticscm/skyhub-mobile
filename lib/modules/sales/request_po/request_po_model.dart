import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/common/convertor.dart';
part 'request_po_model.g.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class RequestPoView {

   static const int STATUS_NEW = 1;
   static const int STATUS_REJECT = 2;
   static const int STATUS_WAITING = 3;
   static const int STATUS_SUBMIT = 4;
   static const int STATUS_PUR = 5;
   static const int STATUS_APPROVED = 6;
   static const int STATUS_WAITING_PO = 7;
   static const int STATUS_DONE = 8;
   static const int STATUS_NO_ENOUGH = 9;
   static const int STATUS_ENOUGH = 10;
   static const int STATUS_PROCESSING = 11;
   static const int STATUS_CANCELED = -1;
   static const int STAGE = 10;

   int id;
   String code;
   int requestType;
   String content;
   int requesterId;
   DateTime requestDate;
   int approverId1;
   DateTime approvalDate1;
   int approverId2;
   DateTime approvalDate2;
   int approverId3;
   DateTime approvalDate3;
   int supplierId;
   String brand;
   int stage;
   int quotationId;
   int contractId;
   int reqInventoryOutId;
   String fromBusinessCode;
   int fromBusinessId;
   String reportCode;
   String notes;
   int status;
   int companyId;
   int branchId;
   int deleted;
   int deletedId;
   DateTime deletedDate;
   int createdId;
   DateTime createdDate;
   int updatedId;
   DateTime updatedDate;
   int version;
   int creatorId;
   DateTime creationDate;
   double sumQty;
   int submit;
   int submitId0;
   int submitId1;
   int submitId2;
   int submitId3;
   String submitName0;
   String submitName1;
   String submitName2;
   String submitName3;
   int isOwnerApproveLevel1;
   int isOwnerApproveLevel2;
   int isOwnerApproveLevel3;
   String approverName1;
   String approverName2;
   String approverName3;
   String requesterName;
   String creatorName;

   RequestPoView({
     this.id,
     this.code,
     this.requestType,
     this.content,
     this.requesterId,
     this.requestDate,
     this.approverId1,
     this.approvalDate1,
     this.approverId2,
     this.approvalDate2,
     this.approverId3,
     this.approvalDate3,
     this.supplierId,
     this.brand,
     this.stage,
     this.quotationId,
     this.contractId,
     this.reqInventoryOutId,
     this.fromBusinessCode,
     this.fromBusinessId,
     this.reportCode,
     this.notes,
     this.status,
     this.companyId,
     this.branchId,
     this.deleted,
     this.deletedId,
     this.deletedDate,
     this.createdId,
     this.createdDate,
     this.updatedId,
     this.updatedDate,
     this.version,
     this.creatorId,
     this.creationDate,
     this.sumQty,
     this.submit,
     this.submitId0,
     this.submitId1,
     this.submitId2,
     this.submitId3,
     this.submitName0,
     this.submitName1,
     this.submitName2,
     this.submitName3,
     this.isOwnerApproveLevel1,
     this.isOwnerApproveLevel2,
     this.isOwnerApproveLevel3,
     this.approverName1,
     this.approverName2,
     this.approverName3,
     this.requesterName,
     this.creatorName

   });

  factory RequestPoView.fromJson(Map<String, dynamic> json) => _$RequestPoViewFromJson(json);



  Map<String, dynamic> toJson() => _$RequestPoViewToJson(this);
}

@JsonSerializable()
@CustomDateTimeConverter()
class RequestPoItemView {
  int	id;
  int	req_po_id;
  int	item_id;
  String	item_code;
  String	item_name;
  String	item_code_origin;
  String	item_name_origin;
  String	brand;
  int	unit_id;
  String	unit_name ;
  double 	qty;
  int	customer_id;
  String	customer_name;
  int	quotation_id;
  String	quotation_code;
  int	contract_id;
  String	contract_code;
  int	req_inventory_out_id;
  String	req_inventory_out_code;
  int	sort;
  String	notes;
  int	status;
  int	deleted;
  int	deleted_id;
  DateTime	deleted_date;
  int	created_id;
  DateTime	created_date;
  int	updated_id;
  DateTime	updated_date;
  int	version;
  String	item_code_order;
  int	quotation_item_id;
  String unitName;
  
  RequestPoItemView({
    this.id,
    this.req_po_id,
    this.item_id,
    this.item_code,
    this.item_name,
    this.item_code_origin,
    this.item_name_origin,
    this.brand,
    this.unit_id,
    this.unit_name,
    this.qty,
    this.customer_id,
    this.customer_name,
    this.quotation_id,
    this.quotation_code,
    this.contract_id,
    this.contract_code,
    this.req_inventory_out_id,
    this.req_inventory_out_code,
    this.sort,
    this.notes,
    this.status,
    this.deleted,
    this.deleted_id,
    this.deleted_date,
    this.created_id,
    this.created_date,
    this.updated_id,
    this.updated_date,
    this.version,
    this.item_code_order,
    this.quotation_item_id,
    this.unitName,
});

  factory RequestPoItemView.fromJson(Map<String, dynamic> json) => _$RequestPoItemViewFromJson(json);

  Map<String, dynamic> toJson() => _$RequestPoItemViewToJson(this);
}



@JsonSerializable()
@CustomDateTimeConverter()
class RequestPoItemFromQuotation {
  int id;
  int item_id;
  String item_code;
  String item_name;
  String item_code_origin;
  String item_name_origin;
  String item_code_order;
  String brand;
  int unit_id;
  String unit_name;
  double qty;

  RequestPoItemFromQuotation({
    this.id,
    this.item_id,
    this.item_code,
    this.item_name,
    this.item_code_origin,
    this.item_name_origin,
    this.item_code_order,
    this.brand,
    this.unit_id,
    this.unit_name,
    this.qty,
  });

  factory RequestPoItemFromQuotation.fromJson(Map<String, dynamic> json) => _$RequestPoItemFromQuotationfromJson(json);

  Map<String, dynamic> toJson() => _$RequestPoItemFromQuotationToJson(this);
}





