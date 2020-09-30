import 'dart:convert';

import 'package:mobile/common/http.dart';
import 'package:mobile/modules/calendar/model.dart';
import 'package:mobile/common/util.dart';

class MonthAPI {
  Future<List<ScheduleView>> findScheduleByMonth({DateTime startDate, DateTime endDate, int empId}) async {
    const URL1 = 'schedule/find-schedule-by-month';
    const URL2 = 'schedule/find-schedule-by-month-and-empid';
    try {
      var url1 = '$URL1?startDate=${Uri.encodeComponent(Util.getDmyStr(startDate))}&endDate=${Uri.encodeComponent(Util.getDmyStr(endDate))}';
      var url2 = '$URL2?empId=$empId&startDate=${Uri.encodeComponent(Util.getDmyStr(startDate))}&endDate=${Uri.encodeComponent(Util.getDmyStr(endDate))}';
      var response = await Http.get((empId==null) ? url1 : url2);
      print(url2);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => ScheduleView.fromJson(model)).toList();
      } else {
        return null;
      }
    }
    catch (e) {
      print('error 1 ' + e.toString());
      rethrow;
    }
  }

  Future<List<ScheduleView>> findScheduleNotify({DateTime startDate, DateTime endDate, int empId}) async {
    const URL = 'schedule/find-schedule-notify-by-empid';
    try {

      var url = '$URL?empId=$empId&startDate=${Uri.encodeComponent(Util.getDmyHmsStr(startDate))}&endDate=${Uri.encodeComponent(Util.getDmyHmsStr(endDate))}';

      var response = await Http.get(url);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => ScheduleView.fromJson(model)).toList();
      } else {
        return null;
      }
    }
    catch (e) {
      print('error 1 ' + e.toString());
      rethrow;
    }
  }

  Future<int> findTotalScheduleNotify({int empId}) async {
    const URL = 'schedule/find-total-schedule-notify-by-empid';
    try {
      var url = '$URL?empId=${empId??''}';

      var response = await Http.get(url);
      if (response.statusCode == 200) {
        var ret = json.decode(response.body);
        print(ret['count']);
        return ret['count'];
      } else {
        return null;
      }
    }
    catch (e) {
      print('error ' + e.toString());
      rethrow;
    }
  }
}