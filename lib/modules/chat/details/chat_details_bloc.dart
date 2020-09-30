import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/chat/details/chat_details_web_socket.dart';

import 'chat_details_api.dart';
import 'chat_details_event.dart';
import 'chat_details_state.dart';

class ChatDetailsBloc extends Bloc<ChatDetailsEvent, ChatDetailsState> {
  final ChatDetailsAPI chatDetailsAPI;
  final ChatDetailsWebSocket chatDetailsWebSocket;

  ChatDetailsBloc({
    @required this.chatDetailsAPI,
    @required this.chatDetailsWebSocket,
  })  : assert(chatDetailsAPI != null);

  @override
  ChatDetailsState get initialState => ChatDetailsInitial();

  @override
  Stream<ChatDetailsState> mapEventToState(ChatDetailsEvent event) async* {
    if (event is TapDetails) {
      yield ChatDetailsInitial();
      try {
        final response = await chatDetailsAPI.findMessageDetailsByUserIdOnChat(
            senderId: event.senderId,
            receiverId: event.receiverId,
            groupId: event.groupId,
            currentPage: event.currentPage,
            pageSize: event.pageSize
        );

        if (response != null ) {
          yield ChatDetailsLoading(response);
        } else {
          yield ChatDetailsFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
        }
      } catch (error) {
        debugPrint(error.toString());
        yield ChatDetailsFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
      }
    }
  }


}
