import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mobile/modules/calendar/model.dart';

abstract class MonthState extends Equatable {
  MonthState([List props = const []]) : super(props);
}

class MonthInitial extends MonthState {}

class MonthLoading extends MonthState {
  final List<ScheduleView> list;
  MonthLoading(this.list);
}

class MonthFailure extends MonthState {
  final String error;

  MonthFailure({@required this.error}) : super([error]);
}