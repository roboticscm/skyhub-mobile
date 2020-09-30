import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/common/convertor.dart';
import 'package:mobile/locale/locales.dart';

part 'inventory_model.g.dart';

@JsonSerializable()
class ReqPoItemSearchResult {
  int id;
  String code;
  String name;
  String codeOrigin;
  String codeOrder;
  String nameOrigin;
  String brandName;
  int unitId;
  String unitName;
  double standardPrice;
  double vatRate;
  int incenRate;
  int comissionRate;
  double exw;
  double costPrice;
  String currency;
  String desc;
  int searchId;
  String searchCode;
  String searchName;

  ReqPoItemSearchResult({
    this.id,
    this.code,
    this.name,
    this.codeOrigin,
    this.codeOrder,
    this.nameOrigin,
    this.brandName,
    this.unitId,
    this.unitName,
    this.standardPrice,
    this.vatRate,
    this.incenRate,
    this.comissionRate,
    this.exw,
    this.costPrice,
    this.currency,
    this.desc,
    this.searchId,
    this.searchCode,
    this.searchName,
  });

  factory ReqPoItemSearchResult.fromJson(Map<String, dynamic> json) => _$ReqPoItemSearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$ReqPoItemSearchResultToJson(this);
}

@JsonSerializable()
class InventorySearchResult {
  final int id;
  String code;
  String originName;
  String name;
  final String unit;
  final num stock;

  InventorySearchResult({this.id, this.code, this.originName, this.name, this.unit, this.stock});
  factory InventorySearchResult.fromJson(Map<String, dynamic> json) => _$InventorySearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$InventorySearchResultToJson(this);
}



@JsonSerializable()
@CustomDateTimeConverter()
class InventorySearchDetailsResult {
  final String code;
  final String name;
  final String barcode;
  final String nameOrigin;
  final String brand;
  final int stock;
  final String unit;
  final int type;
  final String lot;
  final DateTime expireDate;
  final String model;
  final String serial;
  final String locationCode;
  final String locationDesc;
  final String group;
  final String warehouse;
  final String order;
  final String requesterForDelivery;
  InventorySearchDetailsResult({
    this.code,
    this.name,
    this.barcode,
    this.nameOrigin,
    this.brand,
    this.stock,
    this.unit,
    this.type,
    this.lot,
    this.expireDate,
    this.model,
    this.serial,
    this.locationCode,
    this.locationDesc,
    this.group,
    this.warehouse,
    this.order,
    this.requesterForDelivery
  });

  factory InventorySearchDetailsResult.fromJson(Map<String, dynamic> json) =>
      _$InventorySearchDetailsResultFromJson(json);

  Map<String, dynamic> toJson() => _$InventorySearchDetailsResultToJson(this);

  static String getWarehouseTypeName(BuildContext context, int type) {
    if (type == null)
      return '';

    switch (type){
      case 1:
        return L10n.of(context).salesItem;
      case 2:
        return L10n.of(context).samplesItem;
      case 3:
        return L10n.of(context).consignmentItem;
      case 4:
        return L10n.of(context).forLoanItem;
      case 5:
        return L10n.of(context).forRentItem;
      case 6:
        return L10n.of(context).internalLoanItem;
      case 7:
        return L10n.of(context).loanedItem;
      case 8:
        return L10n.of(context).warrantyItem;
      case 9:
        return L10n.of(context).damagedItem;
      case 10:
        return L10n.of(context).promotionItem;
      case 11:
        return L10n.of(context).othersItem;
    }

    return '';
  }
}