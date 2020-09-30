import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/common/http.dart';

import 'search_details_model.dart';

class SearchDetailsAPI {
  Future<List<SearchDetailsResult>> findInventoryByIdAndUserId({int userId, String code, String dateStr, bool exactlySearch, int currentPage, int pageSize}) async {
    const URL = 'search-details/find-inventory-by-code-and-userid';
    try {
      var url = '$URL?userId=$userId&code=${Uri.encodeComponent(code)}&dateStr=${Uri.encodeComponent(dateStr)}&exactlySearch=$exactlySearch&page=$currentPage&pageSize=$pageSize';
      print(url);
      var response = await Http.get(url);

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => SearchDetailsResult.fromJson(model)).toList();
      }
    }
    catch (e) {
      debugPrint('error1 ' + e.toString());
      return null;
    }
    return null;
  }
}