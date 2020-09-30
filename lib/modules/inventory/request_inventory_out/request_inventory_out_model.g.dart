part of 'request_inventory_out_model.dart';

RequestInventoryOutView _$RequestInventoryOutViewFromJson(
    Map<String, dynamic> json) {
  return RequestInventoryOutView(
    id: json['id'] as int,
    code: json['code'] as String,
    requesterId: json['requesterId'] == null
        ? json['requester_id']
        : json['requesterId'] as int,
    requesterName: json['requesterName'] == null
        ? json['requester_name']
        : json['requesterName'] as String,
    status: json['status'] as int,
    submit: json['submit'] as int,
    quotationId: json['quotationId'] == null
      ? json['quotation_id']
      : json['quotationId'] as int,
    fromBusinessCode: json['from_business_code'] == null
        ?json['fromBusinessCode']
        :json['from_business_code']  as String,
    fromBusinessId: json['from_business_id'] == null
        ?json['fromBusinessId']
        :json['from_business_id']  as int,
    requestType: json['requestType'] == null
        ? json['request_type']
        : json['requestType'] as int,
    customerId: json['customerId'] == null
        ? json['customer_id']
        : json['customerId'] as int,
    supplierId: json['supplierId'] == null
        ? json['supplier_id']
        : json['supplierId'] as int,
    employeeId: json['employeeId'] == null
        ? json['employee_id']
        : json['employeeId'] as int,
    content: json['content'] as String,
    partnerType: json['partnerType'] == null
        ? json['partner_type']
        : json['partnerType'] as String,
    partnerId: json['partnerId'] == null
        ? json['partner_id']
        : json['partnerId'] as int,
    partnerName: json['partnerName'] == null
        ? json['partner_name']
        : json['partnerName'] as String,
    contactName: json['contactName'] == null
        ? json['contact_name']
        : json['contactName'] as String,
    contactPhone: json['contactPhone'] == null
        ? json['contact_phone']
        : json['contactPhone'] as String,
    notes: json['notes'] as String,
    sumQty:
        json['sumQty'] == null ? null : double.parse(json['sumQty'].toString()),
    companyId: json['companyId'] == null
        ? json['company_id']
        : json['companyId'] as int,
    branchId:
        json['branchId'] == null ? json['branch_id'] : json['branchId'] as int,
    deleted: json['deleted'] as int,
    deletedId: json['deletedId'] as int,
    createdId: json['createdId'] == null
        ? json['created_id']
        : json['createdId'] as int,
    warehouseId: json['warehouseId'] == null
        ? json['warehouse_id']
        : json['warehouseId'] as int,
    updatedId: json['updatedId'] == null
        ? json['updated_id']
        : json['updatedId'] as int,
    isOwnerApproveLevel1: json['isOwnerApproveLevel1'] as int,
    isOwnerApproveLevel2: json['isOwnerApproveLevel2'] as int,
    isOwnerApproveLevel3: json['isOwnerApproveLevel3'] as int,
    deletedDate: json['deletedDate'] == null
        ? null
        : const CustomDateTimeConverter()
            .fromJson(json['deletedDate'] as String),
    updatedDate: json['updatedDate'] == null
        ? null
        : const CustomDateTimeConverter()
            .fromJson(json['updatedDate'] as String),
    requestDate: json['requestDate'] == null
        ? (json['request_date'] == null
            ? null
            : CustomDateTimeConverter()
                .fromJson(json['request_date'] as String))
        : const CustomDateTimeConverter()
            .fromJson(json['requestDate'] as String),
    createdDate: json['createdDate'] == null
        ? null
        : const CustomDateTimeConverter()
            .fromJson(json['createdDate'] as String),
    approvalName1: json['approvalName1'] as String,
    approvalName2: json['approvalName2'] as String,
    approvalName3: json['approvalName3'] as String,
    approvalDate1: json['approvalDate1'] == null
        ? null
        : const CustomDateTimeConverter()
            .fromJson(json['approvalDate1'] as String),
    approvalDate2: json['approvalDate2'] == null
        ? null
        : const CustomDateTimeConverter()
            .fromJson(json['approvalDate2'] as String),
    approvalDate3: json['approvalDate3'] == null
        ? null
        : const CustomDateTimeConverter()
            .fromJson(json['approvalDate3'] as String),
  );
}

Map<String, dynamic> _$RequestInventoryOutViewToJson(
        RequestInventoryOutView instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requesterId': instance.requesterId,
      'requesterName': instance.requesterName,
      'code': instance.code,
      'status': instance.status,
      'submit': instance.submit,
      'content': instance.content,
      'partnerType': instance.partnerType,
      'partnerName': instance.partnerName,
      'partnerId': instance.partnerId,
      'employeeId': instance.employeeId,
      'supplierId': instance.supplierId,
      'customerId': instance.customerId,
      'requestType': instance.requestType,
      'contactName': instance.contactName,
      'contactPhone': instance.contactPhone,
      'sumQty': instance.sumQty,
      'notes': instance.notes,
      'approvalName1': instance.approvalName1,
      'approvalName2': instance.approvalName2,
      'approvalName3': instance.approvalName3,
      'quotationId': instance.quotationId,
      'fromBusinessId': instance.fromBusinessId,
      'fromBusinessCode':instance.fromBusinessCode,
      'companyId': instance.companyId,
      'branchId': instance.branchId,
      'deleted': instance.deleted,
      'deletedId': instance.deletedId,
      'createdId': instance.createdId,
      'warehouseId': instance.warehouseId,
      'updatedId': instance.updatedId,
      'isOwnerApproveLevel1': instance.isOwnerApproveLevel1,
      'isOwnerApproveLevel2': instance.isOwnerApproveLevel2,
      'isOwnerApproveLevel3': instance.isOwnerApproveLevel3,
      'deletedDate': instance.deletedDate == null
          ? null
          : const CustomDateTimeConverter().toJson(instance.deletedDate),
      'updatedDate': instance.updatedDate == null
          ? null
          : const CustomDateTimeConverter().toJson(instance.updatedDate),
      'createdDate': instance.createdDate == null
          ? null
          : const CustomDateTimeConverter().toJson(instance.createdDate),
      'requestDate': instance.requestDate == null
          ? null
          : const CustomDateTimeConverter().toJson(instance.requestDate),
      'approvalDate1': instance.approvalDate1 == null
          ? null
          : const CustomDateTimeConverter().toJson(instance.approvalDate1),
      'approvalDate2': instance.approvalDate2 == null
          ? null
          : const CustomDateTimeConverter().toJson(instance.approvalDate2),
      'approvalDate3': instance.approvalDate3 == null
          ? null
          : const CustomDateTimeConverter().toJson(instance.approvalDate3),
    };

RequestInventoryOutItemView _$RequestInventoryOutItemViewFromJson(
    Map<String, dynamic> json) {
  return RequestInventoryOutItemView(
      id: json['id'] as int,
      reqInventoryOutId: json['reqInventoryOutId'] as int,
      itemId: json['itemId'] as int,
      itemCode: json['itemCode'] as String,
      itemName: json['itemName'] as String,
      notes: json['notes'] as String,
      qty: json['qty'] as int,
      stock: json['stock'] as int,
      otherWaitingOutQty: json['otherWaitingOutQty'] as int,
      warehouseId: json['warehouseId'] as int,
      status: json['status'] as int,
      createdId: json['createdId'] as int,
      updatedId: json['updatedId'] as int,
      employeeId: json['employeeId'] as int,
      sort: json['sort'] as int,
      updatedDate: json['updatedDate'] == null
          ? null
          : const CustomDateTimeConverter()
              .fromJson(json['updatedDate'] as String),
      limitDate: json['limitDate'] == null
          ? null
          : const CustomDateTimeConverter()
              .fromJson(json['limitDate'] as String),
      brand: json['brand'] as String,
      unitId: json['unitId'] as int,
      unitName: json['unitName'] as String,
      itemCodeOrigin: json['itemCodeOrigin'] as String,
      itemNameOrigin: json['itemCodeOrigin'] as String);
}

Map<String, dynamic> _$RequestInventoryOutItemViewToJson(
        RequestInventoryOutItemView instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reqInventoryOutId': instance.reqInventoryOutId,
      'itemId': instance.itemId,
      'itemCode': instance.itemCode,
      'itemName': instance.itemName,
      'notes': instance.notes,
      'qty': instance.qty,
      'stock': instance.stock,
      'otherWaitingOutQty': instance.otherWaitingOutQty,
      'sort': instance.sort,
      'warehouseId': instance.warehouseId,
      'status': instance.status,
      'createdId': instance.createdId,
      'updatedId': instance.updatedId,
      'employeeId': instance.employeeId,
      'updatedDate': instance.updatedDate == null
          ? null
          : const CustomDateTimeConverter().toJson(instance.updatedDate),
      'limitDate': instance.limitDate == null
          ? null
          : const CustomDateTimeConverter().toJson(instance.limitDate),
      'brand': instance.brand,
      'unitId': instance.unitId,
      'unitName': instance.unitName,
      'itemCodeOrigin': instance.itemCodeOrigin,
      'itemNameOrigin': instance.itemNameOrigin
    };

RequestInventoryOutItemWaiting _$RequestInventoryOutItemWaitingFromJson(
    Map<String, dynamic> json) {
  return RequestInventoryOutItemWaiting(
    itemId: json['itemId'] as int,
    account: json['account'] as String,
    qty: json['qty'] as int,
  );
}
