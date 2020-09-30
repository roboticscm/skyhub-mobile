import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'home_page_search_model.dart';

abstract class SearchState extends Equatable {
  SearchState([List props = const []]) : super(props);
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {
  final List<SearchResult> list;
  SearchLoading(this.list);
}

class SearchFailure extends SearchState {
  final String error;

  SearchFailure({@required this.error}) : super([error]);
}