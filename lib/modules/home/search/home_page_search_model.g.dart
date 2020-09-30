// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_page_search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) {
  return SearchResult(
      id: json['id'] as int,
      code: json['code'] as String,
      barcode: json['barcode'] as String,
      category: json['category'] as String,
      type: json['type'] as int,
      title: json['title'] as String,
      detail: json['detail'] as String,
      content: json['content'] as String,
      customerName: json['customerName'] as String,
      status: json['status'] as int,
      sumAmount: json['sumAmount'] as num,
      sumTotalAmount: json['sumTotalAmount'] as num,
      notes: json['notes'] as String,
      createdId: json['createdId'] as int,
      date: json['date'] == null ? null
          : const CustomDateTimeConverter().fromJson(json['date'] as String));
}

Map<String, dynamic> _$SearchResultToJson(SearchResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'barcode': instance.barcode,
      'category': instance.category,
      'type': instance.type,
      'title': instance.title,
      'detail': instance.detail,
      'content': instance.content,
      'customerName': instance.customerName,
      'status': instance.status,
      'sumAmount': instance.sumAmount,
      'sumTotalAmount': instance.sumTotalAmount,
      'createdId': instance.createdId,
      'notes': instance.notes,
      'date' : instance.date == null ? null : const CustomDateTimeConverter().toJson(instance.date)
    };