import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mobile/system/menu/sub/sub_menu_model.dart';

abstract class SubMenuState extends Equatable {
  SubMenuState([List props = const []]) : super(props);
}

class SubMenuInitial extends SubMenuState {}

class SubMenuLoading extends SubMenuState {
  final List<SubMenu> list;
  SubMenuLoading(this.list);
}

class SubMenuFailure extends SubMenuState {
  final String error;

  SubMenuFailure({@required this.error}) : super([error]);
}