import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/chat/chat_api.dart';
import 'package:mobile/modules/chat/chat_model.dart';

import 'message_list_api.dart';
import 'message_list_event.dart';
import 'message_list_state.dart';

class MessageListBloc extends Bloc<MessageListEvent, MessageListState> {
  final MessageListAPI messageListAPI;
  final ChatAPI chatAPI;
  MessageListBloc({
    @required this.messageListAPI,
    @required this.chatAPI,
  })  : assert(messageListAPI != null);

  @override
  MessageListState get initialState => MessageListInitial();

  @override
  Stream<MessageListState> mapEventToState(MessageListEvent event) async* {
    if (event is OnTapEmployeeList) {
      yield MessageListInitial();
      try {
        final response = await chatAPI.findMessageWithStatusByUserId(
            userId: event.userId,
            groupId: event.groupId,
            currentPage: event.currentPage,
            pageSize: event.pageSize
        );

        if (response != null ) {
          yield MessageListLoading(response);
        } else {
          yield MessageListFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
        }
      } catch (error) {
        debugPrint(error.toString());
        yield MessageListFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
      }
    }else if (event is OnTapMessageList) {
      yield MessageListInitial();
      try {
        final response = await messageListAPI.findMessageWithTaskByUserId(
            userId: event.userId,
            groupId: event.groupId,
            currentPage: event.currentPage,
            pageSize: event.pageSize
        );

        if (response != null ) {
          yield MessageListLoading(response);
        } else {
          yield MessageListFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
        }
      } catch (error) {
        debugPrint(error.toString());
        yield MessageListFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
      }
    }
    else if (event is OnTapDashboard) {
      yield MessageListInitial();
      try {
        final response = await messageListAPI.findDashboardMessageWithTaskByUserId(
            userId: event.userId,
            groupId: event.groupId,
            currentPage: event.currentPage,
            pageSize: event.pageSize
        );

        if (response != null ) {
          yield MessageListLoading(response);
        } else {
          yield MessageListFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
        }
      } catch (error) {
        debugPrint(error.toString());
        yield MessageListFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
      }
    }
    else if(event is OnTapSubmitApproveDeny){
      yield MessageListInitial();
      try {
        final response = await messageListAPI.findDashboardMessageWithTaskByUserId(
            userId: event.userId,
            groupId: event.groupId,
            currentPage: event.currentPage,
            pageSize: event.pageSize

        );

        if (response != null ) {
          yield MessageListLoading(response);
        } else {
          yield MessageListFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
        }
      } catch (error) {
        debugPrint(error.toString());
        yield MessageListFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
      }
    }
  }

}
