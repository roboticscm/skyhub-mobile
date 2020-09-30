import 'package:flutter/material.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/system/config/prefs_key.dart';
import 'package:mobile/system/config/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLoader {
  static Future load() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    GlobalParam.SERVER_URL = prefs.getString(PrefsKey.serverURL.toString()) ?? Server.DEFAULT_SERVER_URL;
    GlobalParam.CHAT_SERVER_URL = prefs.getString(PrefsKey.chatServerURL.toString()) ?? Server.DEFAULT_WS_SERVER_URL;
    GlobalParam.IMAGE_SERVER_URL = prefs.getString(PrefsKey.imageServerURL.toString()) ?? Server.DEFAULT_IMAGE_SERVER_URL;
    GlobalParam.CONNECTION_TIMEOUT = prefs.getInt(PrefsKey.connectionTimeout.toString()) ?? Server.DEFAULT_CONNECTION_TIMEOUT;
    GlobalParam.TOKEN = prefs.getString(PrefsKey.token.toString()) ?? '';
    GlobalParam.USER_NAME = prefs.getString(PrefsKey.username.toString()) ?? "admin";
    GlobalParam.FULL_NAME = prefs.getString(PrefsKey.fullName.toString()) ?? "Administrator";
    GlobalParam.USER_ID = prefs.getInt(PrefsKey.userId.toString()) ?? 0;
    GlobalParam.EMPLOYEE_ID = prefs.getInt(PrefsKey.employeeId.toString()) ?? 0;
    GlobalParam.LANGUAGE_INDEX = prefs.getInt(PrefsKey.language.toString()) ?? 0;
  }
}