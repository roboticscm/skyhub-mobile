import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/http.dart';
import 'chat_model.dart';

class ChatAPI {
  Future<List<ChatHistory>> findMessageWithStatusByUserId({@required dynamic userId, @required dynamic groupId, @required int currentPage, @required int pageSize}) async {
    const URL = 'chat/find-message-with-status-by-userid';
    try {
      var response = await Http.get('$URL?userId=$userId&groupId=$groupId&page=$currentPage&pageSize=$pageSize');
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => ChatHistory.fromJson(model)).map((ch){

          ch.devices = GlobalParam.onlineUsers!=null ? GlobalParam.onlineUsers[ch.userId.toString()] : null;
          ch.isOnline = (ch.devices != null);
          return ch;
        }).toList();
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }

  Future<List<SkyNotification>> findNotifyCountByUserId({int userId}) async {
    const URL = 'chat/find-notify-count-by-userid';
    try {
      var response = await Http.get('$URL?userId=$userId');
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => SkyNotification.fromJson(model)).toList();
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }
}