import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/system/authentication/authentication.dart';
import 'package:mobile/system/login/login.dart';

class LoginPage extends StatefulWidget {
  final LoginAPI loginAPI;

  LoginPage({Key key, @required this.loginAPI})
      : assert(loginAPI != null),
        super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;

  LoginAPI get _loginAPI => widget.loginAPI;

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc = LoginBloc(
      loginAPI: _loginAPI,
      authenticationBloc: _authenticationBloc,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).login),
        flexibleSpace: Container(
            decoration: STextStyle.appBarDecoration()
        ),
      ),
      body: LoginUI(
        loginBloc: _loginBloc,
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}
