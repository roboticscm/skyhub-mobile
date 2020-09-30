import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/common/http.dart';
import 'package:mobile/modules/user_business/user_business_model.dart';


class UserBusinessListAPI {
  Future<UserBusiness> getUserBusinessWithUserIdAndBusiness({@required dynamic userId, @required dynamic business}) async {
    const URL = 'userbusiness/get-userbusiness-with-userid-and-business';
    try {
      var response = await Http.get('$URL?userId=$userId&business=$business');
      if (response.statusCode == 200) {
          return  UserBusiness.fromJson(json.decode(response.body));
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }


}