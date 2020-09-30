import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/common/http.dart';
import 'package:mobile/common/tuple.dart';

import 'inventory_model.dart';

class InventoryAPI {
  Future<Tuple2<List<InventorySearchResult>, String>> textSearch({int userId, String text, int currentPage, int pageSize}) async {
    const URL = 'inventory/text-search';
    try {
      var url = '$URL?userId=$userId&text=${Uri.encodeComponent(text)}&page=$currentPage&pageSize=$pageSize';

      var response = await Http.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return Tuple2(list.map((model) => InventorySearchResult.fromJson(model))
          .map((item) {
            item.code = item.code.replaceAll(text, "<mark>" + text + "</mark>");
            item.name = item.name.replaceAll(text, "<mark>" + text + "</mark>");
            item.originName = item.originName.replaceAll(text, "<mark>" + text + "</mark>");
            return item;
          }).toList(), null);
      } else
        return Tuple2(null, response.body);
    }
    catch (e) {
      debugPrint('error1 ' + e.toString());
      rethrow;
    }
  }
  Future<Tuple2<List<ReqPoItemSearchResult>, String>> textSearchReqPoItem({int userId, String text,String typeSearch, int currentPage, int pageSize}) async {
    const URL = 'sales/reqpo/text-search-reqpo-item';

    try {
      var url = '$URL?userId=$userId&text=${Uri.encodeComponent(text)}&page=$currentPage&pageSize=$pageSize&typeSearch=$typeSearch';
      print(url);
      var response = await Http.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return Tuple2(list.map((model) => ReqPoItemSearchResult.fromJson(model))
            .map((item) {
         // item.code = item.code.replaceAll(text, "<mark>" + text + "</mark>");
          //item.name = item.name.replaceAll(text, "<mark>" + text + "</mark>");
         // item.originName = item.originName.replaceAll(text, "<mark>" + text + "</mark>");

          return item;
        }).toList(), null);
      } else
        return Tuple2(null, response.body);
    }
    catch (e) {
      debugPrint('error1 ' + e.toString());
      rethrow;
    }
  }

  Future<List<InventorySearchDetailsResult>> textSearchDetails({int userId, String code, String dateStr, bool exactlySearch, int currentPage, int pageSize}) async {
    const URL = 'search-details/find-inventory-by-code-and-userid';
    try {
      var url = '$URL?userId=$userId&code=${Uri.encodeComponent(code)}&dateStr=${Uri.encodeComponent(dateStr)}&exactlySearch=$exactlySearch&page=$currentPage&pageSize=$pageSize';
      print(url);
      var response = await Http.get(url);

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => InventorySearchDetailsResult.fromJson(model)).toList();
      }
    }
    catch (e) {
      debugPrint('error1 ' + e.toString());
      return null;
    }
    return null;
  }




}