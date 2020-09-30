
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'menu_model.dart';

abstract class MenuState extends Equatable {
  MenuState([List props = const []]) : super(props);
}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {
  final List<Menu> list;
  MenuLoading(this.list);
}

class MenuFailure extends MenuState {
  final String error;

  MenuFailure({@required this.error}) : super([error]);
}