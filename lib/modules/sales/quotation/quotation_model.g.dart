part of 'quotation_model.dart';

QuotationView _$QuotationViewFromJson(Map<String, dynamic> json) {
  return QuotationView(
      id: json['id'] as int,
      code: json['code'] as String,
      empName: json['empName'] as String,
      status: json['status'] as int,
      submit: json['submit'] as int,
    grandTotal: json['grandTotal'] == null ? double.parse(json['sum_total_amount'].toString()) : double.parse(json['grandTotal'].toString()),
      content: json['content'] as String,
      customerName: json['customerName'] == null ? json['customer_name'] : json['customerName']as String,
      customerId: json['customerId'] == null ? json['customer_id']: json['customerId'] as int,
      creatorName: json['creatorName'] == null ? json['creator_name'] : json['creatorName'] as String,
      quotationDate: json['quotationDate'] == null ? const CustomDateTimeConverter().fromJson(json['quotation_date'] as String)
        : const CustomDateTimeConverter().fromJson(json['quotationDate'] as String),
    createdDate: json['createdDate'] == null ?  const CustomDateTimeConverter().fromJson(json['created_date'] as String)
        : const CustomDateTimeConverter().fromJson(json['createdDate'] as String),
      approvalName1: json['approvalName1'] == null ? json['approval_name1']:json['approvalName1'] as String,
      approvalName2: json['approvalName2'] == null ? json['approval_name2']:json['approvalName2']  as String,
      approvalName3: json['approvalName3'] == null ? json['approval_name3']:json['approvalName3'] as String,
     approvalDate1: json['approvalDate1'] == null ? (json['approval_date_1'] == null ? null : const CustomDateTimeConverter().fromJson(json['approval_date_1'] as String))
          : const CustomDateTimeConverter().fromJson(json['approvalDate1'] as String),
     approvalDate2: json['approvalDate2'] == null ? (json['approval_date_2'] == null ? null :const CustomDateTimeConverter().fromJson(json['approval_date_2'] as String))
          : const CustomDateTimeConverter().fromJson(json['approvalDate2'] as String),
      approvalDate3: json['approvalDate3'] == null ? (json['approval_date_1'] == null ? null :const CustomDateTimeConverter().fromJson(json['approval_date_3'] as String))
          : const CustomDateTimeConverter().fromJson(json['approvalDate3'] as String),

     creatorId: json['creatorId'] == null ? json['creator_id']:json['creatorId']as int,
      createdId: json['createdId'] == null ? json['created_id']: json['createdId']as int,
      requesterId: json['requesterId'] == null ? json['requester_id']:json['requesterId'] as int,
      picId: json['picId'] == null ? json['pic_id'] :json['picId'] as int,
      isOwnerApproveLevel1:json['isOwnerApproveLevel1'] as int,
      isOwnerApproveLevel2:json['isOwnerApproveLevel2'] as int,
      isOwnerApproveLevel3:json['isOwnerApproveLevel3'] as int,
    );
}

Map<String, dynamic> _$QuotationViewToJson(QuotationView instance) =>
    <String, dynamic>{
      'id': instance.id,
      'empName': instance.empName,
      'code' : instance.code,
      'status' : instance.status,
      'submit' : instance.submit,
      'content': instance.content,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'grandTotal': instance.grandTotal,
      'creatorName': instance.creatorName,
      'approvalName1' : instance.approvalName1,
      'approvalName2' : instance.approvalName2,
      'approvalName3' : instance.approvalName3,
      'createdDate' : instance.createdDate == null ? null : const CustomDateTimeConverter().toJson(instance.createdDate),
      'quotationDate' : instance.quotationDate == null ? null : const CustomDateTimeConverter().toJson(instance.quotationDate),
      'approvalDate1' : instance.approvalDate1 == null ? null : const CustomDateTimeConverter().toJson(instance.approvalDate1),
      'approvalDate2' : instance.approvalDate2 == null ? null : const CustomDateTimeConverter().toJson(instance.approvalDate2),
      'approvalDate3' : instance.approvalDate3 == null ? null : const CustomDateTimeConverter().toJson(instance.approvalDate3),
      'createdId': instance.createdId,
      'creatorId': instance.creatorId,
      'requesterId': instance.requesterId,
      'picId': instance.picId,
      'isOwnerApproveLevel1' : instance.isOwnerApproveLevel1,
      'isOwnerApproveLevel2' : instance.isOwnerApproveLevel2,
      'isOwnerApproveLevel3': instance.isOwnerApproveLevel3,

    };


QuotationItemView _$QuotationItemViewFromJson(Map<String, dynamic> json) {
  return QuotationItemView(
    id: json['id'] as int,
    quotationId: json['quotationId'] as int,
    itemId: json['itemId'] as int,
    itemCode: json['itemCode'] as String,
    itemName: json['itemName'] as String,
    qty: json['qty'] as int,
    price: json['price'] as int,
    qtyOut: json['qtyOut'] as int,
    stock: json['stock'] as int,
    itemCodeOrigin: json['itemCodeOrigin'] as String,
    itemNameOrigin: json['itemNameOrigin'] as String ,
    itemCodeOrder:json['itemCodeOrder'] as String,
    brand:json['brand'] as String ,
    unitId:json['unitId'] as int,
    unitName:json['unitName'] as String,
  );
}

Map<String, dynamic> _$QuotationItemViewToJson(QuotationItemView instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quotationId': instance.quotationId,
      'itemId' : instance.itemId,
      'itemCode' : instance.itemCode,
      'itemName': instance.itemName,
      'qty': instance.qty,
      'price': instance.price,
      'qtyOut' : instance.qtyOut,
      'stock' : instance.stock,
      'itemCodeOrigin' : instance.itemNameOrigin,
      'itemNameOrigin' :instance.itemNameOrigin,
      'itemCodeOrder':instance.itemCodeOrder,
      'brand':instance.brand,
      'unitId' : instance.unitId,
      'unitName' : instance.unitName,
    };



