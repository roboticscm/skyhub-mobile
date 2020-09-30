import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/common/common.dart';
import 'package:mobile/common/http.dart';
import 'package:mobile/common/native_code.dart';
import 'package:mobile/system/config/prefs_key.dart';
import 'package:mobile/system/login/login_model.dart';
import 'package:mobile/system/register_devices/register_devices_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginAPI {
  bool _autoLogin = false;
  String _username;
  String _fullName;
  int _userId;
  int _employeeId;

  Future<AuthResponse> authenticate({
    @required bool autoLogin,
    @required num companyId,
    @required num branchId,
    @required String username,
    @required String password }) async {
    _autoLogin = autoLogin;
    final url = '${GlobalParam.BASE_API_URL}system/auth/login';
    var requestData = json.encode(AuthRequest(
        companyId: companyId,
        branchId: branchId,
        resetToken: '',
        username: username,
        password: password));

    try{
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: requestData
      ).timeout(Duration(seconds: GlobalParam.CONNECTION_TIMEOUT));
      this._username = username;
      var authResponse = AuthResponse.fromJson(json.decode(response.body));
      this._userId = authResponse.userId;
      this._employeeId = authResponse.employeeId;
      this._fullName = authResponse.fullName;
      if(authResponse.loginResult == "SUCCESS"){
//        var  verifyDevice = await RegisterDevicesAPI.verifyDeviceProcess(
//          userId: authResponse.userId,
//          account: username,
//          fullName: authResponse.fullName,
//          token: authResponse.token
//        );
//        if (verifyDevice != "SUCCESS")
//          return AuthResponse(loginResult: verifyDevice);
      }
      return authResponse;
    } catch (e) {
      debugPrint('error: ' + e.toString());
    }

    return AuthResponse(loginResult: 'NETWORK_ERROR');
  }


  Future<void> deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(PrefsKey.token.toString());
    GlobalParam.TOKEN = null;
    return;
  }

  Future<void> persistToken(String token) async {
    GlobalParam.TOKEN = '||| ' + token;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PrefsKey.username.toString(), _username);
    prefs.setString(PrefsKey.fullName.toString(), _fullName);
    prefs.setInt(PrefsKey.employeeId.toString(), _employeeId);
    prefs.setInt(PrefsKey.userId.toString(), _userId);

    GlobalParam.USER_NAME = _username;
    GlobalParam.USER_ID = _userId;
    GlobalParam.EMPLOYEE_ID = _employeeId;
    GlobalParam.FULL_NAME = _fullName;

    if (!_autoLogin)
      return;

    prefs.setString(PrefsKey.token.toString(), token);

    return;
  }

  Future<bool> hasToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final token = prefs.getString(PrefsKey.token.toString());
    if (token != null) {
      GlobalParam.TOKEN = '||| ' + token;
    }

    return token != null;
  }

  Future<String> resetPassword({@required String username, @required String urlPrefix}) async {
    try{
      final data = json.encode({
        'username': username,
        'urlPrefix': urlPrefix,
      });
      debugPrint('data $data');

      final response = await Http.post('system/auth/reset-password', data);
      if (response.statusCode == 200)
        return "RESET_PASSWORD_CHECK_MAIL";
      else
        return response.body.toString();

    }catch(e){
      return "NETWORK_ERROR";
    }
  }
}
