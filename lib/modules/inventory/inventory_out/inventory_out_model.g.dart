part of 'inventory_out_model.dart';

InventoryOutView _$InventoryOutViewFromJson(Map<String, dynamic> json) {
  return InventoryOutView(
    id: json['id'] as int,
    code: json['code'] as String,
    requesterId: json['requesterId'] as int,
    requesterName: json['requesterName'] as String,
    status: json['status'] as int,
    inventoryType: json['inventoryType'] as int,
    customerId: json['customerId'] as int,
    supplierId: json['supplierId'] as int,
    employeeId: json['employeeId'] as int,
    content: json['content'] as String,
    partnerType: json['partnerType'] as String,
    partnerId: json['partnerId'] as int,
    partnerName: json['partnerName'] as String,
    stockerName: json['stockerName'] as String,
    contactName: json['contactName'] as String,
    contactPhone: json['contactPhone'] as String,
    notes: json['notes'] as String,
    sumQty: json['sumQty'] == null ? null : double.parse(json['sumQty'].toString()),

    companyId: json['companyId'] as int,
    branchId: json['branchId'] as int,
    deleted: json['deleted'] as int,
    deletedId: json['deletedId'] as int,
    createdId: json['createdId'] as int,
    warehouseId: json['warehouseId'] as int,
    warehouseName: json['warehouseName'] as String,
    updatedId: json['updatedId'] as int,
    inventoryDate: json['inventoryDate'] == null ? null
        : const CustomDateTimeConverter().fromJson(json['inventoryDate'] as String),
    deletedDate: json['deletedDate'] == null ? null
        : const CustomDateTimeConverter().fromJson(json['deletedDate'] as String),
    updatedDate: json['updatedDate'] == null ? null
        : const CustomDateTimeConverter().fromJson(json['updatedDate'] as String),

    requestDate: json['requestDate'] == null ? null
        : const CustomDateTimeConverter().fromJson(json['requestDate'] as String),
    createdDate: json['createdDate'] == null ? null
        : const CustomDateTimeConverter().fromJson(json['createdDate'] as String),

    approvalName1: json['approvalName1'] as String,
    approvalName2: json['approvalName2'] as String,
    approvalName3: json['approvalName3'] as String,
    approvalDate1: json['approvalDate1'] == null ? null
        : const CustomDateTimeConverter().fromJson(json['approvalDate1'] as String),
    approvalDate2: json['approvalDate2'] == null ? null
        : const CustomDateTimeConverter().fromJson(json['approvalDate2'] as String),
    approvalDate3: json['approvalDate3'] == null ? null
        : const CustomDateTimeConverter().fromJson(json['approvalDate3'] as String),
  );
}

Map<String, dynamic> _$InventoryOutViewToJson(InventoryOutView instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requesterId': instance.requesterId,
      'requesterName': instance.requesterName,
      'code' : instance.code,
      'status' : instance.status,
      'content': instance.content,
      'partnerType': instance.partnerType,
      'partnerName': instance.partnerName,
      'partnerId': instance.partnerId,
      'employeeId': instance.employeeId,
      'supplierId': instance.supplierId,
      'customerId': instance.customerId,
      'inventoryDate': instance.inventoryDate,
      'sumQty': instance.sumQty,
      'notes': instance.notes,
      'stockerName' : instance.stockerName,
      'contactPhone': instance.contactPhone,
      'contactName' : instance.contactName,
      'approvalName1' : instance.approvalName1,
      'approvalName2' : instance.approvalName2,
      'approvalName3' : instance.approvalName3,

      'companyId': instance.companyId,
      'branchId': instance.branchId,
      'deleted': instance.deleted,
      'deletedId': instance.deletedId,
      'createdId' : instance.createdId,
      'warehouseId' : instance.warehouseId,
      'warehouseName' : instance.warehouseName,
      'updatedId' : instance.updatedId,

      'deletedDate' : instance.deletedDate == null ? null : const CustomDateTimeConverter().toJson(instance.deletedDate),
      'updatedDate' : instance.updatedDate == null ? null : const CustomDateTimeConverter().toJson(instance.updatedDate),

      'createdDate' : instance.createdDate == null ? null : const CustomDateTimeConverter().toJson(instance.createdDate),
      'requestDate' : instance.requestDate == null ? null : const CustomDateTimeConverter().toJson(instance.requestDate),
      'approvalDate1' : instance.approvalDate1 == null ? null : const CustomDateTimeConverter().toJson(instance.approvalDate1),
      'approvalDate2' : instance.approvalDate2 == null ? null : const CustomDateTimeConverter().toJson(instance.approvalDate2),
      'approvalDate3' : instance.approvalDate3 == null ? null : const CustomDateTimeConverter().toJson(instance.approvalDate3),
    };


InventoryOutItemView _$InventoryOutItemViewFromJson(Map<String, dynamic> json) {
  return InventoryOutItemView(
    itemId: json['itemId'] as int,
    itemCode: json['itemCode'] as String,
    itemName: json['itemName'] as String,
    status: json['status'] as int,
    notes: json['notes'] as String,
    lot: json['lot'] as String,
    model: json['model'] as String,
    serial: json['serial'] as String,
    barcode: json['barcode'] as String,
    qty: json['qty'] as int,
    limitDate: json['limitDate'] == null ? null : const CustomDateTimeConverter().fromJson(json['limitDate'] as String),
    expireDate: json['expireDate'] == null ? null : const CustomDateTimeConverter().fromJson(json['expireDate'] as String),
  );
}

Map<String, dynamic> _$InventoryOutItemViewToJson(InventoryOutItemView instance) =>
    <String, dynamic>{
      'itemId' : instance.itemId,
      'itemCode' : instance.itemCode,
      'itemName': instance.itemName,
      'status': instance.status,
      'notes': instance.notes,
      'lot': instance.lot,
      'model': instance.model,
      'serial': instance.serial,
      'barcode': instance.barcode,
      'qty': instance.qty,
      'expireDate' : instance.expireDate == null ? null : const CustomDateTimeConverter().toJson(instance.expireDate),
      'limitDate' : instance.limitDate == null ? null : const CustomDateTimeConverter().toJson(instance.limitDate),
    };