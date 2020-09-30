import 'package:flutter/material.dart';

import 'http.dart';

class ApiUtil {
  static Future<bool> updateLastAccessByUserId(int userId) async{
    final url = 'chat/update-last-access-by-userid?userId=$userId';
    try {
      var response = await Http.put(url, null);
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        return true;
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return false;
    }
    return false;
  }
}