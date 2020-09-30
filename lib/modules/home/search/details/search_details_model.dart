import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/common/convertor.dart';

part 'search_details_model.g.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class SearchDetailsResult {
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
  SearchDetailsResult({
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

  factory SearchDetailsResult.fromJson(Map<String, dynamic> json) =>
      _$SearchDetailsResultFromJson(json);

  Map<String, dynamic> toJson() => _$SearchDetailsResultToJson(this);
}