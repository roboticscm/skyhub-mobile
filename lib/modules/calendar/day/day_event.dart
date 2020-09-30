import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class DayEvent extends Equatable {
  DayEvent([List props = const []]) : super(props);
}

class OnDayLoad extends DayEvent {
  final DateTime date;

  OnDayLoad({
    @required this.date,
  }) : super([date]);
}
