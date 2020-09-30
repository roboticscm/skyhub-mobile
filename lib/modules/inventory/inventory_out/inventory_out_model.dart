import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/common/convertor.dart';
part 'inventory_out_model.g.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class InventoryOutView {
  final int id;
  String code;
  final int status;
  final DateTime requestDate;
  final DateTime inventoryDate;
  final DateTime createdDate;
  final int inventoryType;
  String content;
  final String partnerType;
  final int partnerId;
  String partnerName;
  final String requesterName;
  final String stockerName;
  final int requesterId;

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
  final String warehouseName;
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
  final String contactName;
  final String contactPhone;

  InventoryOutView({this.id, this.stockerName, this.code, this.content, this.partnerType, this.companyId, this.branchId,
    this.deleted, this.deletedId, this.createdId, this.warehouseId, this.warehouseName, this.updatedId, this.updatedDate, this.deletedDate,
    this.customerId, this.employeeId, this.supplierId, this.sumQty,
    this.partnerId, this.requesterId, this.partnerName, this.status, this.requestDate, this.inventoryDate, this.createdDate,
    this.inventoryType, this.requesterName, this.approvalDate1, this.approvalName1,
    this.approvalDate2, this.approvalName2, this.approvalDate3, this.approvalName3,
    this.notes, this.contactName, this.contactPhone
  });

  factory InventoryOutView.fromJson(Map<String, dynamic> json) => _$InventoryOutViewFromJson(json);



  Map<String, dynamic> toJson() => _$InventoryOutViewToJson(this);
}


@JsonSerializable()
@CustomDateTimeConverter()
class InventoryOutItemView {
  final int itemId;
  final String itemCode;
  final String itemName;
  final String notes;
  final int status;
  final String lot;
  final String model;
  final DateTime expireDate;
  final DateTime limitDate;
  final String serial;
  final String barcode;
  final int qty;

  InventoryOutItemView({
    this.itemId, this.itemCode, this.itemName, this.notes, this.status, this.lot,
    this.model, this.expireDate, this.limitDate, this.serial, this.qty,
    this.barcode
  });

  factory InventoryOutItemView.fromJson(Map<String, dynamic> json) => _$InventoryOutItemViewFromJson(json);
  Map<String, dynamic> toJson() => _$InventoryOutItemViewToJson(this);
}