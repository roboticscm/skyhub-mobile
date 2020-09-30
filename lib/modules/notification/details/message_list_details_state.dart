import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mobile/modules/chat/chat_model.dart';


abstract class MessageListDetailsState extends Equatable {
  MessageListDetailsState([List props = const []]) : super(props);
}

class MessageListDetailsInitial extends MessageListDetailsState {}

class MessageListDetailsLoading extends MessageListDetailsState {
  List<ChatHistoryDetails> messageDetailsList;
  MessageListDetailsLoading(this.messageDetailsList);
}

class MessageListDetailsFailure extends MessageListDetailsState {
  final String error;

  MessageListDetailsFailure({@required this.error}) : super([error]);
}