import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/locale/locales.dart';

import 'chat_api.dart';
import 'chat_event.dart';
import 'chat_model.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatAPI chatAPI;

  ChatBloc({
    @required this.chatAPI,
  })  : assert(chatAPI != null);

  @override
  ChatState get initialState => ChatInitial();

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is ScrollList) {
      yield ChatInitial();
      try {
        final response = await chatAPI.findMessageWithStatusByUserId(
            userId: event.userId,
            groupId: event.groupId,
            currentPage: event.currentPage,
            pageSize: event.pageSize
        );

        if (response != null ) {
          yield ChatLoading(response);
        } else {
          yield ChatFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
        }
      } catch (error) {
        debugPrint(error.toString());
        yield ChatFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
      }
    }
  }

}
