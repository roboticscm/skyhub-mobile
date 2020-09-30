part of 'request_po_model.dart';

RequestPoView _$RequestPoViewFromJson(Map<String, dynamic> json) {
  return RequestPoView(
      id:json['id']   as	 int,
      code:json['code']   as	 String,
      requestType:json['request_type']  as	 int,
      content:json['content']  as	 String,
      requesterId:json['requester_id']   as	 int,
      requestDate:json['request_date']  	 == null ? null : const CustomDateTimeConverter().fromJson(json['request_date'] as String),
      approverId1:json['approver_id_1']  as	 int,
      approvalDate1:json['approval_date_1']   == null ? null : const CustomDateTimeConverter().fromJson(json['approval_date_1'] as String),
      approverId2:json['approver_id_2']   as	 int,
      approvalDate2:json['approval_date_2']  == null ? null :const CustomDateTimeConverter().fromJson(json['approval_date_2'] as String),
      approverId3:json['approver_id_3']   as	 int,
      approvalDate3:json['approval_date_3']  == null ? null :
      const CustomDateTimeConverter().fromJson(json['created_date'] as String),
      supplierId:json['supplier_id']  as	 int,
      brand:json['brand']  as	 String,
      stage:json['stage']   as	 int,
      quotationId:json['quotation_id']   as	 int,
      contractId:json['contract_id']  as	 int,
      reqInventoryOutId:json['req_inventory_out_id']   as	 int,
      fromBusinessCode:json['from_business_code']   as	 String,
      fromBusinessId:json['from_business_id']  as	 int,
      reportCode:json['report_code']   as	 String,
      notes:json['notes']  as	 String,
      status:json['status']   as	 int,
      companyId:json['company_id']   as	 int,
      branchId:json['branch_id']  as	 int,
      deleted:json['deleted']  as	 int,
      deletedId:json['deleted_id']   as	 int,
      deletedDate:json['deleted_date']   ,
      createdId:json['created_id']   as	 int,
      createdDate:json['created_date'] == null ? null :
      const CustomDateTimeConverter().fromJson(json['created_date'] as String),
      updatedId:json['updated_id']   as	 int,
      updatedDate:json['updated_date'] == null ? null :
      const CustomDateTimeConverter().fromJson(json['updated_date'] as String) ,
      creatorId:json['creator_id']  as	 int,
      creationDate:json['creation_date']  == null ? null :
      const CustomDateTimeConverter().fromJson(json['creation_date'] as String) ,
      version: json['version'] as int,
      sumQty:json['sum_qty'] == null ? null :json['sum_qty'].toDouble(),
      submit:json['submit']   as	 int,
      submitId0:json['submit_id_0']   as	 int,
      submitId1:json['submit_id_1']  as	 int,
      submitId2:json['submit_id_2']   as	 int,
      submitId3:json['submit_id_3']  as	 int,
      submitName0:json['submit_name_0']   as	 String,
      submitName1:json['submit_name_1']   as	 String,
      submitName2:json['submit_name_2']  as	 String,
      submitName3:json['submit_name_3']   as	 String,
      approverName1: json['approver_name_1']   as	 String,
      approverName2: json['approver_name_2']   as	 String,
      approverName3: json['approver_name_3']   as	 String,
      requesterName: json['requester_name']   as	 String,
      creatorName: json['creator_name']   as	 String,

  );
}

Map<String, dynamic> _$RequestPoViewToJson(RequestPoView instance) =>
    <String, dynamic>{
    'id':instance.id,
    'code':instance.code,
    'requestType':instance.requestType,
    'content':instance.content,
    'requester_id':instance.requesterId,
    'request_date': instance.requestDate == null ? null : const CustomDateTimeConverter().toJson(instance.requestDate),
    'approver_id_1':instance.approverId1,
    'approval_date_1':instance.approvalDate1 == null ? null : const CustomDateTimeConverter().toJson(instance.approvalDate1),
    'approver_id_2':instance.approverId2,
    'approval_date_2':instance.approvalDate2 == null ? null : const CustomDateTimeConverter().toJson(instance.approvalDate2),
    'approver_id_3':instance.approverId3,
    'approval_date_3':instance.approvalDate3 == null ? null : const CustomDateTimeConverter().toJson(instance.approvalDate3),
    'supplier_id':instance.supplierId,
    'brand':instance.brand,
    'stage':instance.stage,
    'quotation_id':instance.quotationId,
    'contract_id':instance.contractId,
    'req_inventory_out_id':instance.reqInventoryOutId,
    'from_business_code':instance.fromBusinessCode,
    'from_business_id':instance.fromBusinessId,
    'report_code':instance.reportCode,
    'notes':instance.notes,
    'status':instance.status,
    'company_id':instance.companyId,
    'branch_id':instance.branchId,
    'deleted':instance.deleted,
    'deleted_id':instance.deletedId,
    'deleted_date':instance.deletedDate == null ? null : const CustomDateTimeConverter().toJson(instance.deletedDate),
    'created_id':instance.createdId,
    'created_date':instance.createdDate == null ? null : const CustomDateTimeConverter().toJson(instance.createdDate),
    'updated_id':instance.createdId,
    'updated_date':instance.updatedDate == null ? null : const CustomDateTimeConverter().toJson(instance.updatedDate),
    'version':instance.version,
    'creator_id':instance.creatorId,
    'creation_date':instance.creationDate == null ? null : const CustomDateTimeConverter().toJson(instance.creationDate),
    'sum_qty':instance.sumQty,
    'submit':instance.submit,
    'submit_id_0':instance.submitId0,
    'submit_id_1':instance.submitId1,
    'submit_id_2':instance.submitId2,
    'submit_id_3':instance.submitId3,
    'submit_name_0':instance.submitName0,
    'submit_name_1':instance.submitName1,
    'submit_name_2':instance.submitName2,
    'submit_name_3':instance.submitName3,
    //'isOwnerApproveLevel1':instance.isOwnerApproveLevel1,
    //'isOwnerApproveLevel2':instance.isOwnerApproveLevel2,
    //'isOwnerApproveLevel3':instance.isOwnerApproveLevel3,
    //'approverName1': instance.approverName1,
    //'approverName2': instance.approverName2,
    //'approverName3': instance.approverName3,
    //'requesterName': instance.requesterName,
    //'creatorName': instance.creatorName,
    };

RequestPoItemView _$RequestPoItemViewFromJson(Map<String, dynamic> json) {
  return RequestPoItemView(
    id: json['id'] as int,
    req_po_id: json['req_po_id'] as int,
    item_id: json['item_id'] as int,
    item_code: json['item_code'] as String,
    item_name: json['item_name'] as String,
    item_code_origin: json['item_code_origin'] as String,
    item_name_origin: json['item_name_origin'] as String,
    brand: json['brand'] as String,
    unit_id: json['unit_id'] as int,
    unit_name: json['unit_name'] as String,
    qty: json['qty'] == null ? null :json['qty'].toDouble(),
    customer_id: json['customer_id'] as int,
    customer_name: json['customer_name'] as String,
    quotation_id: json['quotation_id'] as int,
    quotation_code: json['quotation_code'] as String,
    contract_id: json['contract_id'] as int,
    contract_code: json['contract_code'] as String,
    req_inventory_out_id: json['req_inventory_out_id'] as int,
    req_inventory_out_code: json['req_inventory_out_code'] as String,
    sort: json['sort'] as int,
    notes: json['notes'] as String,
    status: json['status'] as int,
    deleted: json['deleted'] as int,
    deleted_id: json['deleted_id'] as int,
    deleted_date:json['deleted_date'] == null ? null :
    const CustomDateTimeConverter().fromJson(json['deleted_date'] as String),
    created_id:json['created_id']   as	 int,
    created_date:json['created_date'] == null ? null :
    const CustomDateTimeConverter().fromJson(json['created_date'] as String),
    updated_id:json['updated_id']   as	 int,
    updated_date:json['updated_date'] == null ? null :
    const CustomDateTimeConverter().fromJson(json['updated_date'] as String) ,
    version: json['version'] as int,
    item_code_order: json['item_code_order'] as String,
    quotation_item_id: json['quotation_item_id'] as int,
    unitName:json['unitName'] as String,
  );
}

Map<String, dynamic> _$RequestPoItemViewToJson(RequestPoItemView instance) =>
    <String, dynamic>{
      'id': instance.id,
      'req_po_id':instance.req_po_id,
      'item_id': instance.item_id,
      'item_code': instance.item_code,
      'item_name': instance.item_name,
      'item_code_origin': instance.item_code_origin,
      'item_name_origin': instance.item_name_origin,
      'brand':instance.brand,
      'unit_id': instance.unit_id,
      'unit_name': instance.unit_name,
      'qty': instance.qty,
      'customer_id': instance.customer_id,
      'customer_name': instance.customer_name,
      'quotation_id': instance.quotation_id,
      'quotation_code': instance.quotation_code,
      'contract_id':instance.contract_id,
      'contract_code': instance.contract_code,
      'req_inventory_out_id': instance.req_inventory_out_id,
      'req_inventory_out_code': instance.req_inventory_out_code,
      'sort': instance.sort,
      'notes': instance.notes,
      'status': instance.status,
      'deleted': instance.deleted,
      'deleted_id': instance.deleted_id,
      'deleted_date':instance.deleted_date== null ? null : const CustomDateTimeConverter().toJson(instance.deleted_date),
      'created_id':instance.created_id,
      'created_date':instance.created_date== null ? null : const CustomDateTimeConverter().toJson(instance.created_date),
      'updated_id':instance.updated_id,
      'updated_date':instance.updated_date== null ? null : const CustomDateTimeConverter().toJson(instance.updated_date),
      'version':instance.version,
      'item_code_order': instance.item_code_order,
      'quotation_item_id': instance.quotation_item_id,
      'unitName':instance.unitName
    };


RequestPoItemFromQuotation _$RequestPoItemFromQuotationfromJson(Map<String, dynamic> json) {
  return RequestPoItemFromQuotation(
    id: json['id'] as int,
    item_id: json['item_id'] as int,
    item_code: json['item_code'] as String,
    item_name: json['item_name'] as String,
    item_code_origin: json['item_code_origin'] as String,
    item_name_origin: json['item_name_origin'] as String,
    brand: json['brand'] as String,
    unit_id: json['unit_id'] as int,
    unit_name: json['unit_name'] as String,
    qty: json['qty'] == null ? null :json['qty'].toDouble(),
    item_code_order: json['item_code_order'] as String,

  );
}

Map<String, dynamic> _$RequestPoItemFromQuotationToJson(RequestPoItemFromQuotation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item_id': instance.item_id,
      'item_code': instance.item_code,
      'item_name': instance.item_name,
      'item_code_origin': instance.item_code_origin,
      'item_name_origin': instance.item_name_origin,
      'brand':instance.brand,
      'unit_id': instance.unit_id,
      'unit_name': instance.unit_name,
      'qty': instance.qty,
      'item_code_order' : instance.item_code_order,
    };
