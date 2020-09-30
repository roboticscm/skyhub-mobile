import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/common/http.dart';
import 'package:mobile/common/tuple.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/sales/request_po/request_po_model.dart';
import 'package:mobile/system/loader/model.dart';

class RequestPoAPI {
  Future<Tuple2<List<RequestPoView>, String>> textSearch({
    bool defaultSearch,
    int userId,
    int empId,
    int customerId,
    String text,
    String itemCode,
    String content,
    String refNo,
    String customerName,
    List<int> reqTypeRange,
    List<int> statusRange,
    List<int> yearRange,
    int currentPage,
    int pageSize}) async {
    const URL = 'sales/reqpo/text-search';

    try {
      var url = '$URL?empId=${empId ?? ""}' +
          '&userId=${userId ?? ""}' +
          '&customerId=${customerId ?? ""}' +
          '&defaultSearch=$defaultSearch' +
          '&reqTypeRange=${reqTypeRange != null ? reqTypeRange.join(",") : ""}' +
          '&yearRange=${yearRange != null ? yearRange.join(",") : ""}' +
          '&statusRange=${statusRange != null ? statusRange.join(",") : "" }' +
          '&text=${Uri.encodeComponent(text ?? "")}' +
          '&itemCode=${Uri.encodeComponent(itemCode ?? "")}' +
          '&refNo=${Uri.encodeComponent(refNo ?? "")}' +
          '&content=${Uri.encodeComponent(content ?? "")}' +
          '&customerName=${Uri.encodeComponent(customerName ?? "")}' +
          '&page=$currentPage' +
          '&pageSize=$pageSize';

   //   print(url);
      var response = await Http.get(url);

      if (response.statusCode == 200) {

        Iterable list = json.decode(response.body);
        return Tuple2(
            list.map((model) => RequestPoView.fromJson(model)).map((
                item) {
              if (text != null && text.length > 0) {
                item.code = item.code.replaceAll(text, "<mark>" + text + "</mark>");
                item.content = item.content.replaceAll(text, "<mark>" + text + "</mark>");
                //item..createdDate = item.submitName3.replaceAll(text, "<mark>" + text + "</mark>");
              }

              if (refNo != null && refNo.length > 0) {
                item.code = item.code.replaceAll(refNo, "<mark>" + refNo + "</mark>");
              }
              if (content != null && content.length > 0) {
                item.content = item.content.replaceAll(content, "<mark>" + content + "</mark>");
              }
              if (customerName != null && customerName.length > 0) {
                //item.partnerName = item.partnerName.replaceAll(customerName, "<mark>" + customerName + "</mark>");
              }
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


  Future<Tuple2<List<RequestPoItemView>,
      String>> findRequestPoItem({
    int reqPoId}) async {
    const URL = 'sales/reqpo/find-reqpo-item';
   // print(URL);
    try {
      var url = '$URL?reqPoId=${reqPoId ?? ""}';
      print(url);
      var response = await Http.get(url);

      if (response.statusCode == 200) {

        Iterable list = json.decode(response.body);

        return Tuple2(
            list.map((model) => RequestPoItemView.fromJson(model))
                .toList(), null);
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

  Future<Tuple2<List<RequestPoView>,String>> findReqPoById(int id) async {
    const URL = 'sales/reqpo/reqpo-by-id';
    try {
      var url ='$URL?id=$id';
      print(url);
      var response = await Http.get(url);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return Tuple2(
            list.map((model) => RequestPoView.fromJson(model))
                .toList(), null);
      } else {
        return Tuple2(null, '${L10n.ofValue().resourceError} \n ${response.statusCode} \n ${response.body}' );
      }
    }
    catch (e) {
      print('error ' + e.toString());
      return Tuple2(null, '${L10n.ofValue().connectApiError}' );
    }
  }

  Future<Tuple2<List<RequestPoView>,String>> findReqPoByQuotationId(int id) async {
    const URL = 'sales/reqpo/reqpo-by-quotation-id';
    try {
      var url ='$URL?id=$id';
      print(url);
      var response = await Http.get(url);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return Tuple2(
            list.map((model) => RequestPoView.fromJson(model))
                .toList(), null);
      } else {
        return Tuple2(null, '${L10n.ofValue().resourceError} \n ${response.statusCode} \n ${response.body}' );
      }
    }
    catch (e) {
      print('error ' + e.toString());
      return Tuple2(null, '${L10n.ofValue().connectApiError}' );
    }
  }

  Future<Tuple2<RequestPoView, String>> saveOrUpdate(RequestPoView item) async {
    const URL = 'sales/reqpo/save-or-update';
    try {

      var jsonData = json.encode(item);
     // print(jsonData);
      var response = await Http.post(URL, jsonData);
      //print(response.statusCode);
      if (response.statusCode == 200) {
        var saved = json.decode(response.body);
        print(saved);
        return Tuple2(RequestPoView.fromJson(saved), null);
      } else {
        print(response.body);
        return Tuple2(null, '${L10n.ofValue().resourceError} \n ${response.statusCode} \n ${response.body}' );
      }
    }
    catch (e) {
      print('error ' + e.toString());
      return Tuple2(null, '${L10n.ofValue().connectApiError}' );
    }
  }

  Future<Tuple2<bool, String>> saveOrUpdateItem(List<RequestPoItemView> list) async {
    const URL = 'sales/reqpo/save-or-update-reqpo-item';
    try {
      var jsonData = json.encode(list);
     // print(list.length);
    // print(list[0].item_id);
      var response =  await Http.post(URL, jsonData);
      //print(response.toString());
     print(json.decode(response.body));
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

  Future<Tuple2<bool, String>> deleteItemByIds({int userId, List<int> ids}) async {
    const URL = 'inventory/reqinvout/delete-item-by-ids';
    try {
      var url ='$URL?userId=$userId&ids=${ids.join(",")}';
      print(url);
      var response = await Http.delete(url);
      if (response.statusCode == 200) {
        //var deleted = json.decode(response.body);
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

  Future<Tuple2<RequestPoView,String>> findReqInventoryOutById(int id) async {
    const URL = 'inventory/reqinvout/reqinventoryout-by-id';
    try {
      var url ='$URL?id=$id';
      print(url);
      var response = await Http.get(url);
      if (response.statusCode == 200) {
        //var deleted = json.decode(response.body);
        //return Tuple2(true, null);
        return Tuple2(RequestPoView.fromJson(json.decode(response.body)),null);
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