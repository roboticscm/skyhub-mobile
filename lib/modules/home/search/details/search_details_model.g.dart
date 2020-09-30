part of 'search_details_model.dart';

SearchDetailsResult _$SearchDetailsResultFromJson(Map<String, dynamic> json) {
  return SearchDetailsResult(
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

Map<String, dynamic> _$SearchDetailsResultToJson(SearchDetailsResult instance) =>
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