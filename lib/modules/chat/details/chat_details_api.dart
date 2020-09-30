import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/http.dart';

import '../chat_model.dart';

class ChatDetailsAPI {
  Future<List<ChatHistoryDetails>> findMessageDetailsByUserId(
      {@required dynamic senderId, @required dynamic receiverId , @required dynamic groupId,
        @required int currentPage, @required int pageSize}) async {
    const URL = 'chat/find-message-details-by-userid';
    try {
      var response = await Http.get('$URL?senderId=$senderId&receiverId=$receiverId&groupId=$groupId&page=$currentPage&pageSize=$pageSize');
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return  list.map((model) => ChatHistoryDetails.fromJson(model)).toList();
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }

  Future<List<ChatHistoryDetails>> findMessageDetailsByUserIdOnChat(
      {@required dynamic senderId, @required dynamic receiverId , @required dynamic groupId,
        @required int currentPage, @required int pageSize}) async {
    const URL = 'chat/find-message-details-by-userid-on-chat';
    try {
      var response = await Http.get('$URL?senderId=$senderId&receiverId=$receiverId&groupId=$groupId&page=$currentPage&pageSize=$pageSize');
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return  list.map((model) => ChatHistoryDetails.fromJson(model)).toList();
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }

  static Future<bool> saveMessage(
      {@required int senderId, @required int receiverId , @required int groupId,
        @required String message}) async {
    const URL = 'chat/save-message';
    try {
      var jsonData = json.encode({
        "senderId": senderId,
        "message": message,
        "displayId": groupId,
        "replyMessageId": receiverId,
      });
      var response = await Http.post('$URL?companyId=${GlobalParam.COMPANY_ID}&branchId=${GlobalParam.BRANCH_ID}', jsonData);
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

  static Future<bool> saveMessageWithToken(
      {@required int senderId, @required int receiverId , @required int groupId, @required String token,
        @required String message}) async {
    const URL = 'chat/save-message';
    try {
      var jsonData = json.encode({
        "senderId": senderId,
        "message": message,
        "displayId": groupId,
        "replyMessageId": receiverId,
      });
      var response = await Http.postWithToken('$URL?companyId=${GlobalParam.COMPANY_ID}&branchId=${GlobalParam.BRANCH_ID}', jsonData, '||| $token');
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

  Future<bool> updateReceiveMessageStatus(int senderId, int receiverId, int groupId, int status) async{
    final url = 'chat/update-receive-message-status-by-userid?senderId=$senderId&receiverId=$receiverId&groupId=$groupId&status=$status';
    try {
      var response = await Http.put(url, null);
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