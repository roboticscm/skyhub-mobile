import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SubMenuEvent extends Equatable {
  SubMenuEvent([List props = const []]) : super(props);
}

class OnSubMenuLoad extends SubMenuEvent {
  final int userId;
  final int mainId;

  OnSubMenuLoad({
    @required this.userId,
    @required this.mainId,
  }) : super([userId, mainId]);
}