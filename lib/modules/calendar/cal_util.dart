import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/common/tuple.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/calendar/model.dart';
import 'package:mobile/modules/calendar/scalendar.dart';
import 'package:rxdart/rxdart.dart';

const double CAL_ROW_HEIGHT = 40;
const double CAL_DELTA = 13;
const double CAL_PADDING = 5;

class CalUtil {
  static int getLastDayOfMonth(int year, int month) {
    DateTime date;
    if (month < 12)
      date = DateTime (year, month + 1, 0);
    else
      date = DateTime (year + 1, 1, 0);
    return date.day;
  }

  static int getDayBeginMonth(int year, int month) {
    DateTime date = DateTime(year, month, 1);
    return date.weekday;
  }

  static String getShortWeekDayName(int weekDay) {
    switch (weekDay) {
      case 1:
        return L10n.ofValue().shortMonday;
      case 2:
        return L10n.ofValue().shortTuesday;
      case 3:
        return L10n.ofValue().shortWednesday;
      case 4:
        return L10n.ofValue().shortThursday;
      case 5:
        return L10n.ofValue().shortFriday;
      case 6:
        return L10n.ofValue().shortSaturday;
      case 7:
        return L10n.ofValue().shortSunday;
    }
    return'';
  }


  static String getWeekDayName(int weekDay) {
    switch (weekDay) {
      case 1:
        return L10n.ofValue().monday;
      case 2:
        return L10n.ofValue().tuesday;
      case 3:
        return L10n.ofValue().wednesday;
      case 4:
        return L10n.ofValue().thursday;
      case 5:
        return L10n.ofValue().friday;
      case 6:
        return L10n.ofValue().saturday;
      case 7:
        return L10n.ofValue().sunday;
    }
    return'';
  }

  static String getMonthName(int month) {
    switch (month) {
      case 1:
        return L10n.ofValue().january;
      case 2:
        return L10n.ofValue().february;
      case 3:
        return L10n.ofValue().march;
      case 4:
        return L10n.ofValue().april;
      case 5:
        return L10n.ofValue().may;
      case 6:
        return L10n.ofValue().june;
      case 7:
        return L10n.ofValue().july;
      case 8:
        return L10n.ofValue().august;
      case 9:
        return L10n.ofValue().september;
      case 10:
        return L10n.ofValue().october;
      case 11:
        return L10n.ofValue().november;
      case 12:
        return L10n.ofValue().december;
    }
    return'';
  }

  static bool isNow(DateTime testDate) {
    var now = DateTime.now();

    return (now.year == testDate.year) && (now.month == testDate.month) && (now.day == testDate.day);
  }

  static bool isNowYmd(int year, int month, int day) {
    var now = DateTime.now();

    return (now.year == year) && (now.month == month) && (now.day == day);
  }

  static bool isSameYmd(DateTime d1, DateTime d2) {
    return (d1.year == d2.year) && (d1.month == d2.month) && (d1.day == d2.day);
  }

  static bool isNowYm(int year, int month) {
    var now = DateTime.now();

    return (now.year == year) && (now.month == month) ;
  }

  static int getWeekOfYear(DateTime date) {
     int dayOfYear = int.parse(DateFormat("D").format(date));
     return ((dayOfYear - date.weekday + 10) / 7).floor();

  }

  static double convertTimeToCoordinate(int hour, int minute) {
    return (hour + minute/60.0)*CAL_ROW_HEIGHT;
  }

  static Tuple2<int, int> getStartTimeForDayCal(DateTime currentDate, DateTime startDate) {
    if (isSameYmd(currentDate, startDate))
      return Tuple2(startDate.hour, startDate.minute);
    else
      return Tuple2(0, 0);
  }

  static Tuple2<int, int> getEndTimeForDayCal(bool allDay, DateTime currentDate, DateTime endDate) {
    if (isSameYmd(currentDate, endDate))
      if (allDay && endDate.hour == 0 && endDate.minute == 0)
        return Tuple2(23, 59);
      else
        return Tuple2(endDate.hour, endDate.minute);
    else
      return Tuple2(23, 59);
  }

  static Rect convertTimeInDayToCoordinate(bool allDay, DateTime currentDate, DateTime startDate, DateTime endDate) {
    Tuple2<int, int> startTime = getStartTimeForDayCal(currentDate, startDate );
    Tuple2<int, int> endTime = getEndTimeForDayCal(allDay, currentDate, endDate );
    return Rect.fromLTWH(
      0, ///we calc left of rect later
      convertTimeToCoordinate(startTime.item1, startTime.item2),
      0, ///we calc width of rect later
      convertTimeToCoordinate(endTime.item1 - startTime.item1, endTime.item2 - startTime.item2));
  }


  static bool hasEventAtHour(bool allDay, DateTime testDate, int testHour, DateTime startDate, DateTime endDate) {
    Tuple2<int, int> startTime = getStartTimeForDayCal(testDate, startDate );
    Tuple2<int, int> endTime = getEndTimeForDayCal(allDay, testDate, endDate );

    return (testHour <= endTime.item1 && testHour >= startTime.item1);
  }

  static Rect reCalcLeftOfRect(List<Rect> list, Rect source, double width) {
    if (list.length == 0)
      return Rect.fromLTWH(CAL_PADDING*6, source.top, width + 2*CAL_PADDING, source.height);

    return Rect.fromLTWH(reCalcLeft(list, source), source.top, width + 2*CAL_PADDING, source.height);
  }

  static double reCalcLeft(List<Rect> list, Rect source) {
    bool isBeginRect = true;
    double left = 0;
    for (Rect r in list){
      if (isInterference(r, source)) {
        left = max(left, r.left + r.width);

        if (left >= Util.getScreenWidth() - source.width-CAL_PADDING*6) {
          return -1;
        } else
          isBeginRect = false;
      }
    }

    if (isBeginRect)
      return CAL_PADDING*6;
    else
      return CAL_PADDING + left;
  }

  static bool isInterference(Rect r1, Rect r2) {
    return !(r1.top >= r2.bottom || r1.bottom <= r2.top);
  }

  static Color getBackgroundColorByEventType(int eventType) {
    var color = Colors.white;
    switch (eventType) {
      case SCalendar.TYPE_EVENT:
        color = Color.fromRGBO(0xE7, 0x4C, 0x3C, 1);
        break;
      case SCalendar.TYPE_MEETING:
        color = Color.fromRGBO(0xE6, 0x7E, 0x22, 1);
        break;
      case SCalendar.TYPE_TASK:
        color = Color.fromRGBO(0x9B, 0x59, 0xB6, 1);
        break;
      case SCalendar.TYPE_REMINDER:
        color = Color.fromRGBO(0xF1, 0xC4, 0x0F, 1);
        break;
      case SCalendar.TYPE_TRAVELING:
        color = Color.fromRGBO(0x59, 0xA3, 0x6B, 1);
        break;
      case SCalendar.TYPE_HOLIDAY:
        color = Color.fromRGBO(0x6B, 0x72, 0x6F, 1);
        break;
      case SCalendar.TYPE_LEAD_ACTIVITY:
        color = Color.fromRGBO(0x3E, 0x6F, 0xE0, 1);
        break;
      case SCalendar.TYPE_OPPORTUNITY_ACTIVITY:
        color = Color.fromRGBO(0x3F, 0x51, 0xB5, 1);
        break;
    }
    return color;
  }

  static String getEventTypeName(int eventType) {
    switch (eventType) {
      case SCalendar.TYPE_EVENT:
        return L10n.ofValue().event;
      case SCalendar.TYPE_MEETING:
        return L10n.ofValue().meetings;
      case SCalendar.TYPE_TASK:
        return L10n.ofValue().task;
      case SCalendar.TYPE_REMINDER:
        return L10n.ofValue().reminder;
      case SCalendar.TYPE_TRAVELING:
        return L10n.ofValue().traveling;
      case SCalendar.TYPE_HOLIDAY:
        return L10n.ofValue().holiday;
      case SCalendar.TYPE_LEAD_ACTIVITY:
        return L10n.ofValue().potential;
      case SCalendar.TYPE_OPPORTUNITY_ACTIVITY:
        return L10n.ofValue().opportunity;
    }

    return '#$eventType';
  }

  static Color getOpposingColor(Color source) {
    //return Color.fromRGBO((~source.red) & 0xff, (~source.green) & 0xff, (~source.blue) & 0xff, 1);
    return Colors.white;
  }
  
  static int sortByTimeAndTitle(ScheduleView s1, ScheduleView s2) {
    if (s1.allDay != s2.allDay) {
      return s2.allDay - s1.allDay;
    } else{
      if(s1.allDay==1 || s2.allDay==1) {
        return s1.title?.toLowerCase()?.compareTo(s2.title?.toLowerCase());
      } else {
        var comparedTime = s1.startDate?.compareTo(s2.endDate);
        if (comparedTime == 0)
          return s1.title?.toLowerCase()?.compareTo(s2.title?.toLowerCase());
        else
          return comparedTime;
      }
    }
  }

  static Future<List<Tuple3<int, DateTime, DateTime>>> getWeeksOfMonth(int year, int month) async {
    int lasDayOfMonth = getLastDayOfMonth(year, month);

    List<Tuple3<int, DateTime, DateTime>> weeks = [];
    for(var d = 1; d <= lasDayOfMonth; d++){
      var date = DateTime(year, month, d);
      weeks.add(Tuple3(getWeekOfYear(date), date, date));
    }

    var startDateList = Observable.fromIterable(weeks)
      .groupBy((w) => w.item1)
      .flatMap((g) {
        return g.max((w1, w2) => w2.item2.compareTo(w1.item2)).asObservable();
      }).distinct();

    return await Observable.fromIterable(weeks)
      .groupBy((w) => w.item1)
      .flatMap((g) {
        return g.min((w1, w2) => w2.item3.compareTo(w1.item3)).asObservable();
      }).distinct().zipWith(startDateList, (o1, o2) => Tuple3(o2.item1 as int, o2.item2 as DateTime, o1.item2)).toList();
  }

  static Tuple2<DateTime, DateTime> getStartEndDateOfWeek(int year, int week) {
    var weekday = DateTime(year, 1, 3).weekday;
    var startDate = DateTime(year, 1, week*7 - weekday - 3);
    var endDate = startDate.add(Duration(days: 6));

    return Tuple2(startDate, endDate);
  }

  static int dateDiffWithoutTime(DateTime dt1, DateTime dt2) {
    return DateTime(dt1.year, dt1.month, dt1.day).difference(DateTime(dt2.year, dt2.month, dt2.day)).inDays;
  }

  static ScheduleView findScheduleViewById(List<ScheduleView> list, int id) {
    return list.singleWhere((s)=>s.scheduleItemId==id);
  }

  static List<ScheduleView> updateScheduleViewById(List<ScheduleView> list, ScheduleView item) {
    return List.from(list.map((s){
      if(s.scheduleItemId == item.scheduleItemId){
        return item;
      } else
        return s;
    }));
  }

  static int countByDates(List<ScheduleView> list, DateTime startDate, DateTime endDate) {
    if(list == null || list.length == 0)
      return 0;
    var _list = List.from(list);
    return _list.where((item) {
      return CalUtil.dateDiffWithoutTime(item.startDate, endDate) <= 0 && CalUtil.dateDiffWithoutTime(item.endDate, startDate) >= 0;
    }).length;
  }

  static int countByDate(List<ScheduleView> list, DateTime date) {
    if(list == null || list.length == 0)
      return 0;
    var _list = List.from(list);
    return _list.where((item) {
      return CalUtil.dateDiffWithoutTime(item.startDate, date) <= 0 && CalUtil.dateDiffWithoutTime(item.endDate, date) >= 0;
    }).length;
  }

  static int countByDay(List<ScheduleView> list, int year, int month, int day) {
    if (day > getLastDayOfMonth(year, month))
      return 0;

    return countByDate(list, DateTime(year, month, day));
  }

  static int countByMonth(List<ScheduleView> list, int year, int month) {
    return countByDates(list, DateTime(year, month, 1), DateTime(year, month, getLastDayOfMonth(year, month)));
  }

  static Status getStatusEnum(int showMeAs) {
    switch (showMeAs) {
      case 1:
        return Status.idle;
    }
    return Status.busy;
  }

  static int getStatusNum(Status status) {
    switch (status) {
      case Status.busy:
        return 0;
      case Status.idle:
        return 1;
    }
    return 0;
  }
}

