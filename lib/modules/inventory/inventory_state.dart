import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'inventory_model.dart';


abstract class InventoryState extends Equatable {
  InventoryState([List props = const []]) : super(props);
}

class InventoryInitial extends InventoryState {}
class InventorySearchInitial extends InventoryState {}
class InventorySearchDetailsInitial extends InventoryState {}
class ReqPoItemSearchInitial extends InventoryState {}

class ReqPoItemSearchLoading extends InventoryState {
  final List<ReqPoItemSearchResult> list;
  ReqPoItemSearchLoading(this.list);
}
class InventorySearchLoading extends InventoryState {
  final List<InventorySearchResult> list;
  InventorySearchLoading(this.list);
}

class InventorySearchDetailsLoading extends InventoryState {
  final List<InventorySearchDetailsResult> list;
  InventorySearchDetailsLoading(this.list);
}

class InventorySearchFailure extends InventoryState {
  final String error;

  InventorySearchFailure({@required this.error}) : super([error]);
}

class ReqPoItemSearchFailure extends InventoryState {
  final String error;

  ReqPoItemSearchFailure({@required this.error}) : super([error]);
}

class InventorySearchDetailsFailure extends InventoryState {
  final String error;

  InventorySearchDetailsFailure({@required this.error}) : super([error]);
}