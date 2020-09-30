import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class MessageListEvent extends Equatable {
  MessageListEvent([List props = const []]) : super(props);
}

class OnTapMessageList extends MessageListEvent {
  final int userId;
  final int groupId;
  final int currentPage;
  final int pageSize;

  OnTapMessageList({
    @required this.userId,
    @required this.groupId,
    @required this.currentPage,
    @required this.pageSize,
  }) : super([userId, groupId, currentPage, pageSize]);
}

class OnTapEmployeeList extends MessageListEvent {
  final int userId;
  final int groupId;
  final int currentPage;
  final int pageSize;

  OnTapEmployeeList({
    @required this.userId,
    @required this.groupId,
    @required this.currentPage,
    @required this.pageSize,
  }) : super([userId, groupId, currentPage, pageSize]);
}

class OnTapDashboard extends MessageListEvent {
  final int userId;
  final int groupId;
  final int currentPage;
  final int pageSize;

  OnTapDashboard({
    @required this.userId,
    @required this.groupId,
    @required this.currentPage,
    @required this.pageSize,
  }) : super([userId, groupId, currentPage, pageSize]);
}

class OnTapSubmitApproveDeny extends MessageListEvent {
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

