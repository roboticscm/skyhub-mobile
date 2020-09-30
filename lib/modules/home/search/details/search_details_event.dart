import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SearchDetailsEvent extends Equatable {
  SearchDetailsEvent([List props = const []]) : super(props);
}

class OnSearchInventoryDetails extends SearchDetailsEvent {
  final int userId;
  final String code;
  final int currentPage;
  final int pageSize;
  final String dateStr;
  final bool exactlySearch;

  OnSearchInventoryDetails({
    @required this.userId,
    @required this.code,
    @required this.currentPage,
    @required this.pageSize,
    @required this.dateStr,
    @required this.exactlySearch,
  }) : super([userId, code, currentPage, pageSize]);
}