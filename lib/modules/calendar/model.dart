import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/common/convertor.dart';
import 'package:mobile/modules/calendar/scalendar.dart';
part 'model.g.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class ScheduleView {
  Rect dayCoordinate;

  final int scheduleId;
  final int scheduleItemId;
  final int empId;
  final String empName;
  int eventType;
  int repeatType;
  int cycle;
  int monRepeat;
  int tueRepeat;
  int wedRepeat;
  int thuRepeat;
  int friRepeat;
  int satRepeat;
  int sunRepeat;
  String title;
  String location;
  DateTime startDate;
  DateTime endDate;
  DateTime startTime;
  DateTime endTime;
  int allDay;
  int remindType;
  String description;
  int showMeAs;
  DateTime notifyTime;
  DateTime remindTime;
  int remindTimeUnit;
  int remindTimeQty;
  double numOfDay;

  ScheduleView ({
    this.notifyTime,
    this.remindTime,
    this.remindTimeUnit,
    this.remindTimeQty,
    this.scheduleId,
    this.scheduleItemId,
    this.empId,
    this.empName,
    this.eventType,
    this.repeatType,
    this.cycle,
    this.monRepeat,
    this.tueRepeat,
    this.wedRepeat,
    this.thuRepeat,
    this.friRepeat,
    this.satRepeat,
    this.sunRepeat,
    this.title,
    this.location,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.allDay,
    this.remindType,
    this.description,
    this.showMeAs,
    this.numOfDay,
  });

  factory ScheduleView.fromJson(Map<String, dynamic> json) =>
      _$ScheduleViewFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleViewToJson(this);
}

