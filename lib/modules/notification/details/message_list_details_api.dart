import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/common/http.dart';
import 'package:mobile/modules/chat/chat_model.dart';

class MessageListDetailsAPI {
  Future<List<ChatHistoryDetails>> findMessageDetailsByUserId(
      {@required dynamic senderId, @required dynamic receiverId , @required dynamic groupId,
        @required int currentPage, @required int pageSize}) async {
    const URL = 'chat/find-message-details-by-userid';
    print('$senderId, $receiverId, $groupId');
    try {
      var response = await Http.get('$URL?senderId=$senderId&receiverId=$receiverId&groupId=$groupId&page=$currentPage&pageSize=$pageSize');
       print('$URL?senderId=$senderId&receiverId=$receiverId&groupId=$groupId&page=$currentPage&pageSize=$pageSize');
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        print('list');
        print(list);
        return  list.map((model) => ChatHistoryDetails.fromJson(model)).toList();
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }
  Future<List<ChatHistoryDetails>> findMessageDetailsByUserIdAndApproveOnly(
      {@required dynamic senderId, @required dynamic receiverId , @required dynamic groupId,@required dynamic business,
        @required int currentPage, @required int pageSize}) async {
    const URL = 'chat/find-message-details-by-userid-and-approve-only';
    print('$senderId, $receiverId, $groupId');
    try {
      var response = await Http.get('$URL?senderId=$senderId&receiverId=$receiverId&groupId=$groupId&business=$business&page=$currentPage&pageSize=$pageSize');
      print('$URL?senderId=$senderId&receiverId=$receiverId&groupId=$groupId&business=$business&page=$currentPage&pageSize=$pageSize');
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        print('list');
        print(list);
        return  list.map((model) => ChatHistoryDetails.fromJson(model)).toList();
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }
  Future<List<ChatHistoryDetails>> findMessageDetailsByUserIdAndSearchChar(
      {@required dynamic searchChar, @required dynamic receiverId , @required dynamic groupId,
        @required int currentPage, @required int pageSize}) async {
    const URL = 'chat/find-message-details-by-userid-and-search-char';
       print(URL);
    try {
      var response = await Http.get('$URL?searchChar=$searchChar&receiverId=$receiverId&groupId=$groupId&page=$currentPage&pageSize=$pageSize');
       print('$URL?searchChar=$searchChar&receiverId=$receiverId&groupId=$groupId&page=$currentPage&pageSize=$pageSize');
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        print('list');
        print(list);
        return  list.map((model) => ChatHistoryDetails.fromJson(model)).toList();
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }

  Future<bool> updateReceiveMessageTask(int senderId, int receiverId, groupId, int status) async{
    final url = 'chat/update-receive-message-task-by-userid?senderId=$senderId&receiverId=$receiverId&groupId=$groupId&status=$status';
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

  Future<bool> updateReceiveMessageStatus(int senderId, int receiverId, int groupId, int status) async{
    final url = 'chat/update-receive-message-status-by-userid?senderId=$senderId&receiverId=$receiverId&groupId=$groupId&status=$status';
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