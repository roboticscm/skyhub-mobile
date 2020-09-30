import 'dart:convert';

import 'package:mobile/common/http.dart';
import 'package:mobile/common/tuple.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/calendar/cal_util.dart';
import 'package:mobile/modules/calendar/model.dart';
import 'package:mobile/common/util.dart';

class DayAPI {
  Future<List<ScheduleView>> findScheduleByDate({DateTime date}) async {
    const URL = 'schedule/find-schedule-by-date';
    try {
      var url = '$URL?date=${Uri.encodeComponent(Util.getDmyStr(date))}';
      var response = await Http.get(url);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        var sortedList = list.map((model) => ScheduleView.fromJson(model))
          .map((s) {
            if (CalUtil.isSameYmd(s.startDate, s.endDate)) {
              if (s.endDate.difference(s.startDate).inMinutes <= 0) {
                var tempStartDate = DateTime(s.startDate.year, s.startDate.month, s.startDate.day, s.endDate.hour, s.endDate.minute);
                s.endDate = DateTime(s.endDate.year, s.endDate.month, s.endDate.day, s.startDate.hour, s.startDate.minute);
                s.startDate = tempStartDate;
              }
            }
            s.dayCoordinate = CalUtil.convertTimeInDayToCoordinate((s.allDay??0)==1, date, s.startDate, s.endDate);
            if(s.dayCoordinate.top.toInt() == 0 && s.dayCoordinate.height.toInt() ==((23 + 59/60.0)*CAL_ROW_HEIGHT).toInt()) {
              s.allDay = 1;
            }
            return s;
        }).toList();
        sortedList.sort((s1, s2) => CalUtil.sortByTimeAndTitle(s1, s2));
        return sortedList;
      } else {
        return null;
      }
    }
    catch (e) {
      print('error ' + e.toString());
      rethrow;
    }
  }

  Future<Tuple2<ScheduleView, String>> saveOrUpdateSchedule(ScheduleView scheduleView) async {
    const URL = 'schedule/save-or-update';
    try {
      var jsonData = json.encode(scheduleView);
      var response = await Http.post(URL, jsonData);
      if (response.statusCode == 200) {
        var saved = json.decode(response.body);
        return Tuple2(ScheduleView.fromJson(saved), null);
      } else {
        return Tuple2(null, '${L10n.ofValue().resourceError} \n ${response.statusCode} \n ${response.body}' );
      }
    }
    catch (e) {
      print('error ' + e.toString());
      return Tuple2(null, '${L10n.ofValue().connectApiError}' );
      //rethrow;
    }
  }

  Future<Tuple2<ScheduleView, String>> deleteSchedule(ScheduleView scheduleView) async {
    const URL = 'schedule/delete';
    try {
      var url = '$URL?scheduleId=${scheduleView.scheduleId}&scheduleItemId=${scheduleView.scheduleItemId}';
      var response = await Http.delete(url);
      if (response.statusCode == 200) {
        var deleted = json.decode(response.body);
        return Tuple2(ScheduleView.fromJson(deleted), null);
      } else {
        return Tuple2(null, '${L10n.ofValue().resourceError} \n ${response.statusCode} \n ${response.body}' );
      }
    }
    catch (e) {
      print('error ' + e.toString());
      return Tuple2(null, '${L10n.ofValue().connectApiError}' );
    }
  }
}