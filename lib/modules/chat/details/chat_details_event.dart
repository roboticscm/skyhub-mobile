import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ChatDetailsEvent extends Equatable {
  ChatDetailsEvent([List props = const []]) : super(props);
}

class TapDetails extends ChatDetailsEvent {
  final int senderId;
  final int receiverId;
  final int groupId;
  final int currentPage;
  final int pageSize;

  TapDetails({
    @required this.senderId,
    @required this.receiverId,
    @required this.groupId,
    @required this.currentPage,
    @required this.pageSize,
  }) : super([senderId, receiverId, groupId, currentPage, pageSize]);
}

