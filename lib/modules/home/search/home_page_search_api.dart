import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/common/http.dart';

import 'home_page_search_model.dart';

class SearchAPI {
  Future<List<SearchResult>> findByTextAndUserId({int userId, String text, int currentPage, int pageSize}) async {
    const URL = 'search/find-by-text-and-userid';
    try {
      var url = '$URL?userId=$userId&text=${Uri.encodeComponent(text)}&page=$currentPage&pageSize=$pageSize';
      var response = await Http.get(url);

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => SearchResult.fromJson(model))
          .map((item) {
            item.code = item.code.replaceAll(text, "<mark>" + text + "</mark>");
            item.content = item.content.replaceAll(text, "<mark>" + text + "</mark>");
            item.customerName = item.customerName.replaceAll(text, "<mark>" + text + "</mark>");
            item.title = item.title.replaceAll(text, "<mark>" + text + "</mark>");
            return item;
          }).toList();
      }
    }
    catch (e) {
      debugPrint('error1 ' + e.toString());
      return null;
    }
    return null;
  }
}