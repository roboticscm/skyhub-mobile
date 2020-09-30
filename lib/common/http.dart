import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/system/authentication/authentication_bloc.dart';
import 'package:mobile/system/authentication/authentication_event.dart';
import 'package:mobile/system/login/login_api.dart';
import 'package:mobile/system/login/login_ui.dart';
import 'package:mobile/widgets/sdialog.dart';

class Http {
  static bool showError401 = false;
  static void error401Message() async {
    if (!showError401 && GlobalParam.isLoggedin){
      SDialog.confirm(L10n.ofValue().tokenExpire, L10n.ofValue().maybeYourTokenIsExpired_doDouwantResigin, barrierDismissible: false).then((value){
        if (value == DialogButton.yes) {
          final AuthenticationBloc authenticationBloc =
          BlocProvider?.of<AuthenticationBloc>(GlobalParam.homePageState?.context);
          authenticationBloc.dispatch(LoggedOut());
          if(LoginUI.loginUIState.context !=null && Navigator.of(LoginUI.loginUIState.context).canPop())
            Navigator.of(LoginUI.loginUIState.context).pop();
        }
      });
      showError401 = true;
    }
  }

  static Future<Response> get(String subUrl) async {
    return await getWithToken(subUrl, GlobalParam.TOKEN);
  }

  static Future<Response> getWithoutToken(String subUrl, int timeoutInSeconds) async {
    return await http.get('${GlobalParam.BASE_API_URL}$subUrl', headers: {
      'Content-Type': 'application/json',
    }).timeout(Duration(seconds: timeoutInSeconds));
  }

  static Future<Response> getWithToken(String subUrl, String token) async {
    var ret = await http.get('${GlobalParam.BASE_API_URL}$subUrl', headers: {
      'Content-Type': 'application/json',
      'Authorization': '$token',
    }).timeout(Duration(seconds: GlobalParam.CONNECTION_TIMEOUT));

    if (ret.statusCode == 401)
      error401Message();

    return ret;
  }

  static Future<Response> post(String subUrl, dynamic data) async {
    return await postWithToken(subUrl, data, GlobalParam.TOKEN);
  }

  static Future<Response> postWithToken(String subUrl, dynamic data, String token) async {
    var ret = await http.post('${GlobalParam.BASE_API_URL}$subUrl', headers: {
      'Content-Type': 'application/json',
      'Authorization': '$token',
    }, body: data).timeout(Duration(seconds: GlobalParam.CONNECTION_TIMEOUT));

    if (ret.statusCode == 401)
      error401Message();

    return ret;
  }

  static Future<Response> put(String subUrl, dynamic data) async {
    var ret = await http.put('${GlobalParam.BASE_API_URL}$subUrl', headers: {
      'Content-Type': 'application/json',
      'Authorization': '${GlobalParam.TOKEN}',
    }, body: data).timeout(Duration(seconds: GlobalParam.CONNECTION_TIMEOUT));

    if (ret.statusCode == 401)
      error401Message();

    return ret;
  }

  static Future<Response> delete(String subUrl) async {
    var ret = await http.delete('${GlobalParam.BASE_API_URL}$subUrl', headers: {
      'Content-Type': 'application/json',
      'Authorization': '${GlobalParam.TOKEN}',
    }).timeout(Duration(seconds: GlobalParam.CONNECTION_TIMEOUT));

    if (ret.statusCode == 401)
      error401Message();

    return ret;
  }
}