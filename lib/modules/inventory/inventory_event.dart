import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class InventoryEvent extends Equatable {
  InventoryEvent([List props = const []]) : super(props);
}

class OnReqPoItemSearch extends InventoryEvent {
  final int userId;
  final String text;
  final int currentPage;
  final int pageSize;
  final String searchType;
  OnReqPoItemSearch({
    @required this.userId,
    @required this.text,
    @required this.currentPage,
    @required this.pageSize,
    @required this.searchType,
  }) : super([userId, text, currentPage,searchType, pageSize]);
}

class OnInventorySearch extends InventoryEvent {
  final int userId;
  final String text;
  final int currentPage;
  final int pageSize;

  OnInventorySearch({
    @required this.userId,
    @required this.text,
    @required this.currentPage,
    @required this.pageSize,
  }) : super([userId, text, currentPage, pageSize]);
}

class OnInventorySearchDetails extends InventoryEvent {
  final int userId;
  final String code;
  final int currentPage;
  final int pageSize;
  final String dateStr;
  final bool exactlySearch;

  OnInventorySearchDetails({
    @required this.userId,
    @required this.code,
    @required this.currentPage,
    @required this.pageSize,
    @required this.dateStr,
    @required this.exactlySearch,
  }) : super([userId, code, currentPage, pageSize]);
}