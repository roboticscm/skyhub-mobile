import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class NativeCall {
  static const platform = const MethodChannel('vn.com.sky.native');
  static const MethodChannel backgroundChannel = MethodChannel("flutter_plugin_background");

  static void setMethodCallHandler(Future<dynamic> handler(MethodCall call)) {
    platform.setMethodCallHandler(handler);
  }

  static Future<bool> showMainActivity() async {
    try {
      if (Platform.isAndroid)
        return await platform.invokeMethod('showMainActivity');
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<void> sendAppToBackground() async {
    try {
      if (Platform.isAndroid)
        await platform.invokeMethod('sendAppToBackground');
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }


  static Future<void> createNativeView(Function backgroundTask) async {
    try {
      if (Platform.isAndroid) {
        CallbackHandle handle = PluginUtilities.getCallbackHandle(backgroundTask);
        if (handle != null)
          await platform.invokeMethod('createNativeView', {'handle': handle.toRawHandle()});
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> startService() async {
    try {
      if (Platform.isAndroid) {
        await platform.invokeMethod('startService');
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> stopService() async {
    try {
      if (Platform.isAndroid)
        await platform.invokeMethod('stopService');
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }
  static Future<void> turnOnScreen() async {

    try {
      if (Platform.isAndroid)
        await platform.invokeMethod('turnOnScreen');
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> turnOffScreen() async {
    try {
      if (Platform.isAndroid)
        await platform.invokeMethod('turnOffScreen');
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }
}