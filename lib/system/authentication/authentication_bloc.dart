import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:mobile/common/api_util.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/global_function.dart';
import 'package:mobile/common/http.dart';
import 'package:mobile/common/native_code.dart';
import 'package:mobile/common/sky_websocket.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/r2.dart';
import 'package:mobile/system/authentication/authentication.dart';
import 'package:mobile/system/loader/data.dart';
import 'package:mobile/system/login/login_api.dart';
import 'package:mobile/system/register_devices/register_devices_api.dart';
//import 'package:background_execute_plugin/background_execute_plugin.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final LoginAPI loginAPI;

  AuthenticationBloc({@required this.loginAPI})
      : assert(loginAPI != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final bool hasToken = await loginAPI.hasToken();

      if (hasToken) {
        if(R2.languages.length==0)
          await R2.loadFromAPI();

        var verifyDeviceResult = await RegisterDevicesAPI.verifyDeviceProcess(
          userId: GlobalParam.USER_ID,
          fullName: GlobalParam.FULL_NAME,
          account: GlobalParam.USER_NAME,
          token: GlobalParam.TOKEN.replaceAll("||| ", "")
        );

        if("SUCCESS" != verifyDeviceResult) {
          yield AuthenticationUnauthenticated();
        }else {
          yield AuthenticationAuthenticated();
          await _joinChatServer();
        }
      } else {
        yield AuthenticationUnauthenticated();
      }
    }
    if (event is LoggedIn) {
      if(R2.languages.length==0)
        await R2.loadFromAPI();
      GlobalParam.isLoggedin = true;
      yield AuthenticationLoading();
      await loginAPI.persistToken(event.token);
      await _joinChatServer();

      yield AuthenticationAuthenticated();
    }
    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await _leaveChatServer();
      await loginAPI.deleteToken();
      yield AuthenticationUnauthenticated();
      GlobalParam.isLoggedin = false;
      Http.showError401 = false;
    }
  }

  Future<void> _joinChatServer() async {
    if (!SkyWebSocket.isConnected) {
      await SkyWebSocket.connect();
      await SkyWebSocket.join();
    }
    GlobalParam.webSocketTimer = Timer.periodic(Duration(seconds: GlobalParam.keepAliveTime), (timer) {
      SkyWebSocket.reconnect();
    });
    await ApiUtil.updateLastAccessByUserId(GlobalParam.USER_ID);
    await NativeCall.startService();
//    BackgroundExecutePlugin.initBackgroundService();
//    BackgroundExecutePlugin.executeCode(1, 2);
  }

  Future<void> _leaveChatServer() async {
    await NativeCall.stopService();
    ApiUtil.updateLastAccessByUserId(GlobalParam.USER_ID);
    GlobalParam.webSocketTimer.cancel();
    SkyWebSocket.leave();
  }
}
