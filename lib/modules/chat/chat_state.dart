import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'chat_model.dart';

abstract class ChatState extends Equatable {
  ChatState([List props = const []]) : super(props);
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {
  final List<ChatHistory> chatHistoryList;
  ChatLoading(this.chatHistoryList);
}

class ChatFailure extends ChatState {
  final String error;

  ChatFailure({@required this.error}) : super([error]);
}
