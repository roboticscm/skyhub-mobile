import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/common/http.dart';

import 'menu_model.dart';

class MenuAPI {
  Future<List<Menu>> findByUserId({int userId}) async {
    const URL = 'menu/find-by-userid';
    try {
      var url = '$URL?userId=$userId';
      var response = await Http.get(url);

      if (response.statusCode == 200) {
        print('api call');
        Iterable list = json.decode(response.body);
        return list.map((model) => Menu.fromJson(model)).toList();
      }
    }
    catch (e) {
      debugPrint('error1 ' + e.toString());
      return null;
    }
    return null;
  }
}