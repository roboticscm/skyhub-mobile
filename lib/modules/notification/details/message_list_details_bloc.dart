import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/locale/locales.dart';

import 'message_list_details_api.dart';
import 'message_list_details_event.dart';
import 'message_list_details_state.dart';


class MessageListDetailsBloc extends Bloc<MessageListDetailsEvent, MessageListDetailsState> {
  final MessageListDetailsAPI messageListDetailsAPI;

  MessageListDetailsBloc({
    @required this.messageListDetailsAPI,
  })  : assert(messageListDetailsAPI != null);

  @override
  MessageListDetailsState get initialState => MessageListDetailsInitial();

  @override
  Stream<MessageListDetailsState> mapEventToState(MessageListDetailsEvent event) async* {
    if (event is OnTapMessageListDetails) {
      yield MessageListDetailsInitial();
      try {
        final response = await messageListDetailsAPI.findMessageDetailsByUserId(
            senderId: event.senderId,
            receiverId: event.receiverId,
            groupId: event.groupId,
            currentPage: event.currentPage,
            pageSize: event.pageSize
        );

        if (response != null ) {
          yield MessageListDetailsLoading(response);
        } else {
          yield MessageListDetailsFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
        }
      } catch (error) {
        debugPrint(error.toString());
        yield MessageListDetailsFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
      }
    }
  }


}
