import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'search_details_model.dart';

abstract class SearchDetailsState extends Equatable {
  SearchDetailsState([List props = const []]) : super(props);
}

class SearchDetailsInitial extends SearchDetailsState {}

class SearchDetailsLoading extends SearchDetailsState {
  final List<SearchDetailsResult> list;
  SearchDetailsLoading(this.list);
}

class SearchDetailsFailure extends SearchDetailsState {
  final String error;

  SearchDetailsFailure({@required this.error}) : super([error]);
}