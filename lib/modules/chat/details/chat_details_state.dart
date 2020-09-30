import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../chat_model.dart';

abstract class ChatDetailsState extends Equatable {
  ChatDetailsState([List props = const []]) : super(props);
}

class ChatDetailsInitial extends ChatDetailsState {}

class ChatDetailsLoading extends ChatDetailsState {
  List<ChatHistoryDetails> chatHistoryDetailsList;
  ChatDetailsLoading(this.chatHistoryDetailsList);
}

class ChatDetailsFailure extends ChatDetailsState {
  final String error;

  ChatDetailsFailure({@required this.error}) : super([error]);
}