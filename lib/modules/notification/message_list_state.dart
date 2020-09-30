import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/modules/chat/chat_model.dart';

abstract class MessageListState extends Equatable {
  MessageListState([List props = const []]) : super(props);
}

class MessageListInitial extends MessageListState {}

class MessageListLoading extends MessageListState {
  final List<ChatHistory> messageList;
  MessageListLoading(this.messageList);
}

class MessageListFailure extends MessageListState {
  final String error;

  MessageListFailure({@required this.error}) : super([error]);
}
