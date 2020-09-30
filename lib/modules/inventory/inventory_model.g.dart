part of 'inventory_model.dart';

/*
String code;
String name;
String codeOrigin;
String codeOrder;
String nameOrigin;
String brandName;
int unitId;
String unitName;
double standardPrice;
String vatRate;
String incenRate;
String comissionRate;
String exw;
double costPrice;
String currency;
String desc;
 */

ReqPoItemSearchResult _$ReqPoItemSearchResultFromJson(Map<String, dynamic> json) {
  return ReqPoItemSearchResult(
    id:json['id'] as int,
    code:json['code'] as String,
    name:json['name'] as String,
    codeOrigin:json['code_origin'] as String,
    codeOrder:json['code_order'] as String,
    nameOrigin:json['name_origin'] as String,
    brandName:json['brand_name'] as String,
    unitId:json['unit_id'] as int,
    unitName:json['unit_name'] as String,
    standardPrice:json['standard_price'] == null ? null :json['standard_price'].toDouble(),
    vatRate:json['vat_rate']  == null ? null :json['vat_rate'].toDouble(),
    incenRate:json['incen_rate'] as int,
    comissionRate:json['comission_rate'] as int,
    exw:json['exw']== null ? null :json['exw'].toDouble(),
    costPrice:json['cost_price']  == null ? null :json['cost_price'].toDouble(),
    currency:json['currency'] as String,
  // desc:json['code'] +":" + json['name']+ ":" + json['unit_name'] as String,
    searchId: json['searchId'] as int,
    searchCode: json['searchCode'] as String,
    searchName: json['searchName'] as String,


  );
}

Map<String, dynamic> _$ReqPoItemSearchResultToJson(ReqPoItemSearchResult instance) =>
    <String, dynamic>{
      'value': instance.id,
      'code': instance.code,
      'name': instance.name,
      'codeOrigin': instance.codeOrigin,
      'codeOrder': instance.codeOrder,
      'nameOrigin': instance.nameOrigin,
      'brandName': instance.brandName,
      'unitId': instance.unitId,
      'unitName': instance.unitName,
      'standardPrice': instance.standardPrice,
      'vatRate': instance.vatRate,
      'incenRate': instance.incenRate,
      'comissionRate': instance.comissionRate,
      'exw': instance.exw,
      'costPrice': instance.costPrice,
      'currency': instance.currency,
      'desc': instance.desc,
      'searchId':instance.searchId,
      'searchCode':instance.searchCode,
      'searchName':instance.searchName
    };


InventorySearchResult _$InventorySearchResultFromJson(Map<String, dynamic> json) {
  return InventorySearchResult(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
      originName: json['originName'] as String,
      stock: json['stock'] as num,
      unit: json['unit'] as String,
  );
}

Map<String, dynamic> _$InventorySearchResultToJson(InventorySearchResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'originName': instance.originName,
      'unit': instance.unit,
      'stock': instance.stock,
    };


InventorySearchDetailsResult _$InventorySearchDetailsResultFromJson(Map<String, dynamic> json) {
  return InventorySearchDetailsResult(
      code: json['code'] as String,
      name: json['name'] as String,
      barcode: json['barcode'] as String,
      nameOrigin: json['nameOrigin'] as String,
      brand: json['brand'] as String,
      stock: json['stock'] as int,
      unit: json['unit'] as String,
      type: json['type'] as int,
      lot: json['lot'] as String,
      model: json['model'] as String,
      serial: json['serial'] as String,
      locationCode: json['locationCode'] as String,
      locationDesc: json['locationDesc'] as String,
      group: json['group'] as String,
      warehouse: json['warehouse'] as String,
      order: json['order'] as String,
      requesterForDelivery: json['requesterForDelivery'] as String,
      expireDate: json['expireDate'] == null ? null
          : const CustomDateTimeConverter().fromJson(json['expireDate'] as String));
}

Map<String, dynamic> _$InventorySearchDetailsResultToJson(InventorySearchDetailsResult instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'barcode': instance.barcode,
      'nameOrigin': instance.nameOrigin,
      'brand': instance.brand,
      'stock': instance.stock,
      'unit': instance.unit,
      'type': instance.type,
      'lot': instance.lot,
      'model': instance.model,
      'serial': instance.serial,
      'locationCode': instance.locationCode,
      'locationDesc': instance.locationDesc,
      'group': instance.group,
      'warehouse': instance.warehouse,
      'order': instance.order,
      'requesterForDelivery': instance.requesterForDelivery,
      'expireDate' : instance.expireDate == null ? null : const CustomDateTimeConverter().toJson(instance.expireDate)
    };