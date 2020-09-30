import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mobile/modules/calendar/model.dart';

abstract class DayState extends Equatable {
  DayState([List props = const []]) : super(props);
}

class DayInitial extends DayState {}

class DayLoading extends DayState {
  final List<ScheduleView> list;
  DayLoading(this.list);
}

class DayFailure extends DayState {
  final String error;

  DayFailure({@required this.error}) : super([error]);
}