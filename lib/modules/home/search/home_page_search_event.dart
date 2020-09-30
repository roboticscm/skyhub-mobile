import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SearchEvent extends Equatable {
  SearchEvent([List props = const []]) : super(props);
}

class OnSearch extends SearchEvent {
  final int userId;
  final String text;
  final int currentPage;
  final int pageSize;

  OnSearch({
    @required this.userId,
    @required this.text,
    @required this.currentPage,
    @required this.pageSize,
  }) : super([userId, text, currentPage, pageSize]);
}