import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/common/http.dart';
import 'package:mobile/system/menu/sub/sub_menu_model.dart';
class SubMenuAPI {
  Future<List<SubMenu>> findByUserIdAndMainId({int userId, int mainId}) async {
    const URL = 'menu/find-by-userid-and-mainid';
    try {
      var url = '$URL?userId=$userId&mainId=$mainId';
      var response = await Http.get(url);

      if (response.statusCode == 200) {
        print('api call');
        Iterable list = json.decode(response.body);
        return list.map((model) => SubMenu.fromJson(model)).toList();
      }
    }
    catch (e) {
      debugPrint('error1 ' + e.toString());
      return null;
    }
    return null;
  }
}