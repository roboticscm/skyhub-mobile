import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/common/convertor.dart';
import 'package:mobile/locale/locales.dart';

part 'home_page_search_model.g.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class SearchResult {
  static const int STATUS_NEW = 1;
  static const int STATUS_REJECT = 2;
  static const int STATUS_WAITING = 3;
  static const int STATUS_SUBMIT = 4;
  static const int STATUS_MANAGER = 5;
  static const int STATUS_APPROVED = 6;
  static const int STATUS_FOLLOW_UP = 7;
  static const int STATUS_SOLD = 8;
  static const int STATUS_CANCEL = 9;
  static const int STATUS_TIMEOUT = 10;
  static const int STATUS_FAILED = -1;

  static const int STATUS_TRAILWORK = 1;
  static const int STATUS_OFFICIAL = 2;
  static const int STATUS_LEAVE_JOB = -1;

  final int id;
  final String category;
  String code;
  String barcode;
  final int type;
  final DateTime date;
  String title;
  final String detail;
  String content;
  String customerName;
  final int status;
  final num sumAmount;
  final num sumTotalAmount;
  final String notes;
  final int createdId;

  SearchResult({
    this.id,
    this.category,
    this.code,
    this.barcode,
    this.type,
    this.date,
    this.title,
    this.detail,
    this.content,
    this.customerName,
    this.status,
    this.sumAmount,
    this.sumTotalAmount,
    this.notes,
    this.createdId
});
  factory SearchResult.fromJson(Map<String, dynamic> json) => _$SearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$SearchResultToJson(this);

  static String getQuotationStatusDesc(BuildContext context, int status) {
    switch (status){
      case STATUS_NEW:
        return L10n.of(context).newStatus;
      case STATUS_REJECT:
        return L10n.of(context).rejectStatus;
      case STATUS_WAITING:
        return L10n.of(context).waitingStatus;
      case STATUS_SUBMIT:
        return L10n.of(context).submitStatus;
      case STATUS_MANAGER:
        return L10n.of(context).managerStatus;
      case STATUS_APPROVED:
        return L10n.of(context).approvedStatus;
      case STATUS_FOLLOW_UP:
        return L10n.of(context).followUpStatus;
      case STATUS_SOLD:
        return L10n.of(context).soldStatus;
      case STATUS_CANCEL:
        return L10n.of(context).cancelStatus;
      case STATUS_TIMEOUT:
        return L10n.of(context).timeoutStatus;
      case STATUS_FAILED:
        return L10n.of(context).failedStatus;
    }
    return '';
  }

  static String getEmployeeStatusDesc(BuildContext context, int status) {
    switch (status){
      case STATUS_TRAILWORK:
        return L10n.of(context).trailWorkStatus;
      case STATUS_OFFICIAL:
        return L10n.of(context).officialStatus;
      case STATUS_LEAVE_JOB:
        return L10n.of(context).leaveJobStatus;
    }

    return '';
  }

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
