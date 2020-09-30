import 'dart:convert';

import 'package:mobile/common/http.dart';
import 'package:mobile/common/tuple.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/inventory/request_inventory_out/request_inventory_out_model.dart';

import 'inventory_out_model.dart';

class InventoryOutAPI {
  Future<Tuple2<List<InventoryOutView>, String>> textSearch({
    bool defaultSearch,
    int userId,
    int empId,
    int customerId,
    String text,
    String itemCode,
    String content,
    String refNo,
    String customerName,
    List<int> invTypeRange,
    List<int> statusRange,
    List<int> yearRange,
    int currentPage,
    int pageSize}) async {
    const URL = 'inventory/out/text-search';
    print(URL);
    try {
      var url = '$URL?empId=${empId ?? ""}' +
          '&userId=${userId ?? ""}' +
          '&customerId=${customerId ?? ""}' +
          '&defaultSearch=$defaultSearch' +
          '&invTypeRange=${invTypeRange != null
              ? invTypeRange.join(",")
              : ""}' +
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

      print(url);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return Tuple2(
            list.map((model) => InventoryOutView.fromJson(model)).map((
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


  Future<Tuple2<List<InventoryOutItemView>, String>> findInventoryOutItem({int inventoryOutId}) async {
    const URL = 'inventory/out/find-inventory-out-item';
    print(URL);
    try {
      var url = '$URL?inventoryOutId=${inventoryOutId ?? ""}';
      var response = await Http.get(url);

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return Tuple2(
            list.map((model) => InventoryOutItemView.fromJson(model))
                .toList(), null);
      } else {
        return Tuple2(null, response.body);
      }
    }
    catch (e) {
      print('error1 ' + e.toString());
      return Tuple2(null, e.toString());
    }
  }
}