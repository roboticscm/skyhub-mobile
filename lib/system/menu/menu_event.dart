import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class MenuEvent extends Equatable {
  MenuEvent([List props = const []]) : super(props);
}

class OnMenuLoad extends MenuEvent {
  final int userId;

  OnMenuLoad({
    @required this.userId,
  }) : super([userId]);
}