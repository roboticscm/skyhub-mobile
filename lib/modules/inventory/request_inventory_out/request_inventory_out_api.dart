import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/common/http.dart';
import 'package:mobile/common/tuple.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/inventory/request_inventory_out/request_inventory_out_model.dart';
import 'package:mobile/system/loader/model.dart';

class RequestInventoryOutAPI {
  Future<Tuple2<List<RequestInventoryOutView>, String>> textSearch({
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
    const URL = 'inventory/reqinvout/text-search';
    print(URL);
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
      var response = await Http.get(url);

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return Tuple2(
            list.map((model) => RequestInventoryOutView.fromJson(model)).map((
                item) {
              if (text != null && text.length > 0) {
                item.code = item.code.replaceAll(text, "<mark>" + text + "</mark>");
                item.content = item.content.replaceAll(text, "<mark>" + text + "</mark>");
                item.partnerName = item.partnerName.replaceAll(text, "<mark>" + text + "</mark>");
              }

              if (refNo != null && refNo.length > 0) {
                item.code = item.code.replaceAll(refNo, "<mark>" + refNo + "</mark>");
              }
              if (content != null && content.length > 0) {
                item.content = item.content.replaceAll(content, "<mark>" + content + "</mark>");
              }
              if (customerName != null && customerName.length > 0) {
                item.partnerName = item.partnerName.replaceAll(customerName, "<mark>" + customerName + "</mark>");
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

  Future<Tuple2<List<RequestInventoryOutItemView>,
      String>> findRequestInventoryOutItem({
    int reqInvOutId}) async {
    const URL = 'inventory/reqinvout/find-reqinvout-item';

    try {
      var url = '$URL?reqInvOutId=${reqInvOutId ?? ""}';
      var response = await Http.get(url);
      print(response.body);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return Tuple2(
            list.map((model) => RequestInventoryOutItemView.fromJson(model))
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

  Future<List<Warehouse>> findWarehouseByParentId(int parentId) async {
    const URL = 'inventory/find-warehouse-by-parent-id';
    try {
      var url = '$URL?parentId=$parentId';
      var response = await Http.get(url);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => Warehouse.fromJson(model)).toList();
      }else {
        print(response.body);
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }

  Future<int> findOtherWaitingOutQtyOfItem({int itemId, int empId}) async {
    const URL = 'inventory/reqinvout/find-other-waiting-out-qty-of-item';
    try {
      var url = '$URL?itemId=$itemId&empId=$empId';
      var response = await Http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body)['otherWaitingOutQty'];
      }else {
        print(response.body);
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }

  Future<List<RequestInventoryOutItemWaiting>> findOtherWaitingOutQtyOfItemDetails({int empId, List<int> statusRange, List<int> itemIdRange}) async {
    const URL = 'inventory/reqinvout/find-other-waiting-out-qty-of-item-details';
    try {
      var url = '$URL?empId=$empId&statusRange=${statusRange != null ? statusRange.join(",") : ""}&itemIdRange=${itemIdRange != null ? itemIdRange.join(",") : ""}';
      var response = await Http.get(url);
      print(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => RequestInventoryOutItemWaiting.fromJson(model)).toList();
      }else {
        print(response.body);
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }

  Future<Tuple2<RequestInventoryOutView, String>> saveOrUpdate(RequestInventoryOutView item) async {
    const URL = 'inventory/reqinvout/save-or-update';
    try {
      var jsonData = json.encode(item);
     print(jsonData);
      var response = await Http.post(URL, jsonData);
      if (response.statusCode == 200) {
        var saved = json.decode(response.body);
        //print(saved);
        return Tuple2(RequestInventoryOutView.fromJson(saved), null);
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

  Future<Tuple2<bool, String>> saveOrUpdateItem(List<RequestInventoryOutItemView> list) async {
    const URL = 'inventory/reqinvout/save-or-update-item';
    try {
      var jsonData = json.encode(list);
      print(jsonData);
      var response = await Http.post(URL, jsonData);
      if (response.statusCode == 200) {
        //var saved = json.decode(response.body);
        print(json.decode(response.body));
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

  Future<Tuple2<List<RequestInventoryOutView>,String>> findReqInventoryOutById(int id) async {
    const URL = 'inventory/reqinvout/reqinventoryout-by-id';
    try {
      var url ='$URL?id=$id';

      print(url);
      var response = await Http.get(url);
      if (response.statusCode == 200) {
        //var deleted = json.decode(response.body);
        //return Tuple2(true, null);
        Iterable list = json.decode(response.body);
        return Tuple2(
            list.map((model) => RequestInventoryOutView.fromJson(model))
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

  Future<Tuple2<List<RequestInventoryOutView>,String>> findReqInventoryOutByQuotationId(int id) async {
    const URL = 'inventory/reqinvout/reqinventoryout-by-quotation-id';
    try {
      var url ='$URL?id=$id';

      print(url);
      var response = await Http.get(url);
      if (response.statusCode == 200) {
         Iterable list = json.decode(response.body);
        return Tuple2(
            list.map((model) => RequestInventoryOutView.fromJson(model))
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

}