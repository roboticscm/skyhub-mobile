import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class MessageListDetailsEvent extends Equatable {
  MessageListDetailsEvent([List props = const []]) : super(props);
}

class OnTapMessageListDetails extends MessageListDetailsEvent {
  final int senderId;
  final int receiverId;
  final int groupId;
  final int currentPage;
  final int pageSize;

  OnTapMessageListDetails({
    @required this.senderId,
    @required this.receiverId,
    @required this.groupId,
    @required this.currentPage,
    @required this.pageSize,
  }) : super([senderId, receiverId, groupId, currentPage, pageSize]);
}

class OnTapSubmitApproveDeny extends MessageListDetailsEvent {
  final int userId;
  final int groupId;
  final int currentPage;
  final int pageSize;
  final int task;
  final int sourceId;

  OnTapSubmitApproveDeny({
    @required this.userId,
    @required this.groupId,
    @required this.currentPage,
    @required this.pageSize,
    @required this.task,
    @required this.sourceId
  }) : super([userId, groupId, currentPage, pageSize,task,sourceId]);
}
