import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class MonthEvent extends Equatable {
  MonthEvent([List props = const []]) : super(props);
}

class OnMonthLoad extends MonthEvent {
  final DateTime startDate;
  final DateTime endDate;
  final int empId;

  OnMonthLoad({
    @required this.startDate,
    @required this.endDate,
    this.empId,
  }) : super([startDate, endDate]);
}