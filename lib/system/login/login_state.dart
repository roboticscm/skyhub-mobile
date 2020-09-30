import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  LoginState([List props = const []]) : super(props);
}

class LoginInitial extends LoginState {
  final String uuid;
  LoginInitial({@required this.uuid}) : super([uuid]);

  @override
  String toString() => 'LoginInitial';
}

class LoginLoading extends LoginState {
  @override
  String toString() => 'LoginLoading';
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'LoginFailure { error: $error }';
}

class ResetPasswordLoading extends LoginState {
  @override
  String toString() => 'ForgotPassword';
}

class ResetPasswordFailure extends LoginState {
  final String error;

  ResetPasswordFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'ResetPasswordFailure { error: $error }';
}