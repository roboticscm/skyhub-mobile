import 'dart:convert';

import 'package:mobile/common/http.dart';
import 'package:mobile/common/tuple.dart';
import 'package:mobile/locale/locales.dart';

import 'holiday_model.dart';

class HolidayAPI {

  Future<Tuple2<List<HolidayView>, String>> textSearch({
    bool defaultSearch,
    int userId,
    int empId,
    String text,
    String content,
    String refNo,
    List<String> holidayTypeRange,
    List<int> statusRange,
    List<int> yearRange,
    int currentPage,
    int pageSize}) async {
    const URL = 'holiday/text-search';
    print(URL);
    try {
      var url = '$URL?empId=${empId??""}' +
          '&userId=${userId??""}' +
          '&defaultSearch=$defaultSearch' +
          '&holidayTypeRange=${holidayTypeRange != null
              ? holidayTypeRange.join(",")
              : ""}' +
          '&yearRange=${yearRange != null ? yearRange.join(",") : ""}' +
          '&statusRange=${statusRange != null ? statusRange.join(",") : "" }' +
          '&text=${Uri.encodeComponent(text ?? "")}' +
          '&refNo=${Uri.encodeComponent(refNo ?? "")}' +
          '&content=${Uri.encodeComponent(content ?? "")}' +
          '&page=$currentPage' +
          '&pageSize=$pageSize';
      var response = await Http.get(url);

      print(url);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return Tuple2(
            list.map((model) => HolidayView.fromJson(model)).map((
                item) {
//              if (text != null && text.length > 0) {
//                item.code = item.code.replaceAll(text, "<mark>" + text + "</mark>");
//                item.content = item.content.replaceAll(text, "<mark>" + text + "</mark>");
//              }
//
//              if (refNo != null && refNo.length > 0) {
//                item.code = item.code.replaceAll(refNo, "<mark>" + refNo + "</mark>");
//              }
//              if (content != null && content.length > 0) {
//                item.content = item.content.replaceAll(content, "<mark>" + content + "</mark>");
//              }
              return item;
            }).toList(), null);
      } else {
        return Tuple2(null, response.body);
      }
    }
    catch (e) {
      print('error1 ' + e.toString());
      return Tuple2(null, L10n
          .ofValue()
          .connectApiError);
    }
  }

  Future<Tuple2<List<HolidayView>, String>> findHolidayByEmpId({int empId}) async {
    const URL = 'holiday/find-by-empid';
    try {
      var url = '$URL?empId=${empId??-1}';
      var response = await Http.get(url);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return Tuple2(list.map((model) => HolidayView.fromJson(model)).toList(), null);
      } else {
        return Tuple2(null, '${L10n.ofValue().resourceError} \n ${response.statusCode} \n ${response.body}' );
      }
    }
    catch (e) {
      print('error ' + e.toString());
      return Tuple2(null, '${L10n.ofValue().connectApiError}' );
    }
  }

  Future<Tuple2<HolidayView, String>> findHolidayById({int id}) async {
    const URL = 'holiday/find-by-id';

    try {
      var url = '$URL?id=$id';
      print(url);
      var response = await Http.get(url);
      if (response.statusCode == 200) {
        return Tuple2(HolidayView.fromJson(json.decode(response.body)), null);
      } else {
        return Tuple2(null, '${L10n.ofValue().resourceError} \n ${response.statusCode} \n ${response.body}' );
      }
    }
    catch (e) {
      print('error ' + e.toString());
      return Tuple2(null, '${L10n.ofValue().connectApiError}' );
    }
  }

  Future<Tuple2<HolidayParam, String>> findHolidayParamByEmpId({int empId}) async {
    const URL = 'holiday/find-param-by-empid';
    try {
      var url = '$URL?empId=$empId';
      var response = await Http.get(url);
      if (response.statusCode == 200) {
        return Tuple2(HolidayParam.fromJson(json.decode(response.body)), null);
      } else {
        return Tuple2(null, '${L10n.ofValue().resourceError} \n ${response.statusCode} \n ${response.body}' );
      }
    }
    catch (e) {
      print('error ' + e.toString());
      return Tuple2(null, '${L10n.ofValue().connectApiError}' );
    }
  }

  Future<Tuple2<HolidayView, String>> saveOrUpdate(HolidayView hv) async {
    const URL = 'holiday/save-or-update';
    try {
      var jsonData = json.encode(hv);
      var response = await Http.post(URL, jsonData);
      if (response.statusCode == 200) {
        var saved = json.decode(response.body);
        print(saved);
        return Tuple2(HolidayView.fromJson(saved), null);
      } else {
        return Tuple2(null, '${L10n.ofValue().resourceError} \n ${response.statusCode} \n ${response.body}' );
      }
    }
    catch (e) {
      print('error ' + e.toString());
      return Tuple2(null, '${L10n.ofValue().connectApiError}' );
    }
  }

  Future<Tuple2<bool, String>> delete(List<int> ids) async {
    const URL = 'holiday/delete-by-ids';
    try {
      var url = '$URL?ids=${ids.join(",")}';
      var response = await Http.delete(url);
      if (response.statusCode == 200) {
        return Tuple2(true, null);
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