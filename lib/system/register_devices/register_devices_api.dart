import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/http.dart';
import 'package:mobile/common/sky_websocket.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/chat/chat_model.dart';
import 'package:mobile/modules/chat/details/chat_details_api.dart';

class RegisterDevicesAPI {
  static Future<bool> verifyDevice({
    @required String account,
    @required String uuid,
    @required String token,
    }) async {

    const URL = 'register-devices/verify-device';
    try {
      var response = await Http.getWithToken('$URL?account=$account&uuid=$uuid', '||| $token');
      if (response.statusCode == 200) {
        var result;
        if (response.body != null && (response.body?.length??0) > 0)
          result = json.decode(response.body);
        return result;
//        return true;
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }

  static Future<List<dynamic>> _findUserIdByRoleCode({
    @required String roleCode,
    @required String token,
  }) async {
    const URL = 'register-devices/find-userid-by-role-code';
    try {
      var response = await Http.getWithToken('$URL?roleCode=$roleCode', '||| $token');

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.toList();
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }

  static Future<String> verifyDeviceProcess({int userId, String account, String token, String fullName}) async {
    if(!SkyWebSocket.isConnected) {
      await SkyWebSocket.connect();
      await SkyWebSocket.join();
    }
    var uuid = await Util.generateUUID();
    var verifyDeviceResult = await RegisterDevicesAPI.verifyDevice(account: account, uuid: uuid, token: token);
    GlobalParam.adminIds = await _findUserIdByRoleCode(roleCode: 'admin', token: token);
    print(GlobalParam.adminIds);
    if (verifyDeviceResult == null) {
      await RegisterDevicesAPI.save(userId: userId, uuid: uuid, token: token, fullName: fullName);
      return 'UNREGISTER_DEVICE';
    } else if (verifyDeviceResult == false) {
      await RegisterDevicesAPI.promptAdmin(userId: userId, uuid: uuid, token: token, fullName: fullName);
      return 'WAITING_ADMIN_ACCEPT';
    }

    return "SUCCESS";
  }


  static Future<void> save({@required int userId, @required String uuid, @required String token, String fullName}) async {
    const URL = 'register-devices/save';
    var os = await Util.getDeviceOS();
    var device = await Util.getDeviceName();
    try {
      var jsonData = json.encode({
        "userId": userId,
        "uuid": uuid,
        "device": device,
        "os": os,
      });
      var response = await Http.postWithToken(URL, jsonData, '||| $token');
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        await _notifyNewDeviceToAdmin(token: token, userId: userId, fullName: fullName, uuid: uuid, device: device, os: os);
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
    }
  }

  static Future<void> promptAdmin({@required int userId, @required String uuid, @required String token, String fullName}) async {
    var os = await Util.getDeviceOS();
    var device = await Util.getDeviceName();

    var msgContent = '''
            ${L10n.of(GlobalParam.appContext).pleaseAccept}<br>
            ${L10n.of(GlobalParam.appContext).uuid} <b>$uuid</b><br>
            ${L10n.of(GlobalParam.appContext).device} <b>$device</b><br>
            ${L10n.of(GlobalParam.appContext).os} <b>$os</b><br>
          ''';
    GlobalParam.adminIds.forEach((adminId) async {
      if (userId != adminId) {
        await _save(senderId: userId,
            receiverId: adminId,
            token: token,
            message: msgContent);
        SkyWebSocket.send(json.encode({
          "action": "chat",
          "chatData": ChatData(
            msgContent: msgContent,
            fromId: userId,
            toId: adminId,
            senderName: fullName,
            time: Util.getTimeStr(DateTime.now()),
            avatar: '${GlobalParam.IMAGE_SERVER_URL}/avartar?id=$userId',
            datetime: Util.getDateStr(DateTime.now()),
          )
        }));
      }
    });
  }

  static Future<void> _notifyNewDeviceToAdmin({String token, int userId, String fullName, String uuid, String device, String os}) async {
    var msgContent = '''
            ${L10n.of(GlobalParam.appContext).newDeviceToRegister}<br>
            ${L10n.of(GlobalParam.appContext).uuid} <b>$uuid</b><br>
            ${L10n.of(GlobalParam.appContext).device} <b>$device</b><br>
            ${L10n.of(GlobalParam.appContext).os} <b>$os</b><br>
          ''';
    GlobalParam.adminIds.forEach((adminId) async {
      if(adminId != userId) {
        await _save(senderId: userId, receiverId: adminId, token: token, message: msgContent);
        SkyWebSocket.send(json.encode({
          "action": "chat",
          "chatData": ChatData(
            msgContent: msgContent,
            fromId: userId,
            toId: adminId,
            senderName: fullName ,
            time: Util.getTimeStr(DateTime.now()),
            avatar: '${GlobalParam.IMAGE_SERVER_URL}/avartar?id=$userId',
            datetime: Util.getDateStr(DateTime.now()),
          )
        }));
      }
    });
  }

  static Future<void> _save({int senderId, int receiverId, String token, String message}) async {
      await ChatDetailsAPI.saveMessageWithToken(
        token: token,
        senderId: senderId,
        receiverId: receiverId,
        groupId: SkyNotification.GROUP_MESSAGE,
        message: message,
    );
  }

}
