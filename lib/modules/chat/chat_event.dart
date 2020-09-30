import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ChatEvent extends Equatable {
  ChatEvent([List props = const []]) : super(props);
}

class ScrollList extends ChatEvent {
  final int userId;
  final int groupId;
  final int currentPage;
  final int pageSize;

  ScrollList({
    @required this.userId,
    @required this.groupId,
    @required this.currentPage,
    @required this.pageSize,
  }) : super([userId, groupId, currentPage, pageSize]);
}

