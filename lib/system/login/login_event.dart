import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}

class LoginButtonPressed extends LoginEvent {
  final num companyId;
  final num branchId;
  final String username;
  final String password;
  final bool autoLogin;

  LoginButtonPressed({
    this.companyId,
    this.branchId,
    @required this.username,
    @required this.password,
    @required this.autoLogin,
  }) : super([username, password, autoLogin]);
}

class ForgotPasswordButtonPressed extends LoginEvent {
  final String username;
  final String urlPrefix;

  ForgotPasswordButtonPressed({
    @required this.username,
    @required this.urlPrefix,
  }) : super([username, urlPrefix]);
}
