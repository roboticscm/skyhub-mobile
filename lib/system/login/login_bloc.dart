import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:mobile/system/authentication/authentication.dart';
import 'package:mobile/system/login/login.dart';
import 'package:mobile/system/login/login_api.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginAPI loginAPI;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.loginAPI,
    @required this.authenticationBloc,
  })  : assert(loginAPI != null),
        assert(authenticationBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        final authResponse = await loginAPI.authenticate(
          companyId: event.companyId,
          branchId: event.branchId,
          username: event.username,
          password: event.password,
          autoLogin: event.autoLogin
        );

        if ("SUCCESS" == authResponse.loginResult) {
          authenticationBloc.dispatch(LoggedIn(token: authResponse.token));
          yield LoginInitial();
        } else {
          yield LoginFailure(error: authResponse.loginResult);
        }
      } catch (error) {
        yield LoginFailure(error:  error.toString());
      }
    } else if (event is ForgotPasswordButtonPressed) {
      yield ResetPasswordLoading();
      try {
        final resetResponse = await loginAPI.resetPassword(
          username: event.username,
          urlPrefix: event.urlPrefix,
        );
        yield LoginFailure(error:  resetResponse);
      } catch (error) {
        yield LoginFailure(error:  error.toString());
      }
    }
  }
}
