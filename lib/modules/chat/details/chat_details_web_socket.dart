import 'dart:convert';

import 'package:mobile/common/common.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/modules/chat/chat_model.dart';
import 'package:mobile/common/sky_websocket.dart';

class ChatDetailsWebSocket {
  void sendMessageToWebSocketServer(ChatHistoryDetails chatHistoryDetails) {
    SkyWebSocket.send(json.encode({
      "action": "chat",
      "chatData": ChatData(
        msgContent: chatHistoryDetails.message,
        fromId: chatHistoryDetails.senderId,
        toId: chatHistoryDetails.receiverId,
        senderName: chatHistoryDetails.name ,
        time: Util.getTimeStr(chatHistoryDetails.sendDate),
        avatar: '${GlobalParam.IMAGE_SERVER_URL}/avartar?id=${chatHistoryDetails.senderId}',
        datetime: Util.getDateStr(chatHistoryDetails.sendDate),
      )
    }));
  }

  void sendTypingMessageToWebSocketServer(ChatHistoryDetails chatHistoryDetails) {
    SkyWebSocket.send(json.encode({
      "action": "typing",
      "chatData": ChatData(
        fromId: chatHistoryDetails.senderId,
        toId: chatHistoryDetails.receiverId,
      )
    }));
  }

  void sendEndTypingMessageToWebSocketServer(ChatHistoryDetails chatHistoryDetails) {
    SkyWebSocket.send(json.encode({
      "action": "endTyping",
      "chatData": ChatData(
        fromId: chatHistoryDetails.senderId,
        toId: chatHistoryDetails.receiverId,
      )
    }));
  }
}