import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/native_code.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/system/config/server.dart';
import 'package:mobile/system/login/login.dart';
import 'package:mobile/widgets/gradient_button.dart';
import 'package:mobile/widgets/gradient_button.dart';
import 'package:mobile/widgets/scontainer.dart';
import 'package:mobile/widgets/sflat_button.dart';
import 'package:mobile/widgets/ssingle_child_scroll_view.dart';
import 'package:mobile/widgets/stext.dart';
import 'package:mobile/widgets/stext_form_field.dart';

import 'login_stream.dart';


class LoginUI extends StatefulWidget {
  final LoginBloc loginBloc;

  LoginUI({
    Key key,
    @required this.loginBloc,
  }) : super(key: key);

  static _LoginUIState loginUIState;
  @override
  State<LoginUI> createState() {
    loginUIState = _LoginUIState();
    return loginUIState;
  }
}

class _LoginUIState extends State<LoginUI> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  var _hitCount = 0;
  var _autoLogin = false;
  var _uuid = '';
  LoginBloc get _loginBloc => widget.loginBloc;
  var _obscureText = true;
  var _loginSubject = LoginStream();

  @override
  void initState() {
    super.initState();
    _generateUUID();

    _usernameController.addListener((){
      _loginSubject.usernameSink.add(_usernameController.text.trim());
    });

    _passwordController.addListener((){
      _loginSubject.passwordSink.add(_passwordController.text.trim());
    });
  }

  void _generateUUID() async {
    GlobalParam.uuid = await Util.generateUUID();
    if (mounted) {
      setState(() {
        _uuid = GlobalParam.uuid;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _loginBloc,
      listener: (context, LoginState state){
        if (state is LoginFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error == "WRONG_USERNAME" ?
                L10n.of(context).usernameDoesNotExisted : state.error == "UNREGISTER_DEVICE" ?
                L10n.of(context).unregisterDevice : state.error == "WAITING_ADMIN_ACCEPT" ?
                L10n.of(context).waitingAdminAccept : state.error == "WRONG_PASSWORD" ?
                L10n.of(context).wrongPassword : state.error == "RESET_PASSWORD_CHECK_MAIL" ?
                L10n.of(context).resetPasswordCheckMail : state.error == "NETWORK_ERROR" ?
                L10n.of(context).connectToServerFailed : state.error.contains("Username") ?
                L10n.of(context).maybeYourUsernameIsIncorrect_PleaseTryAnotherOne : state.error.contains("Email") ?
                L10n.of(context).pleaseContactToTheAdminToGetAnEmailAddress : state.error),
                backgroundColor: Colors.red,
              ),
            );
          });
        }
      },
      child: BlocBuilder<LoginEvent, LoginState>(
        bloc: _loginBloc,
        builder: (
          BuildContext context,
          LoginState state,
        ) {
          return Form(
            child: SSingleChildScrollView(
              child: Column(
                children: [
                  FlatButton(
                    child: Image.asset("assets/logo.png", height: 120, fit: BoxFit.fill,),
                    onPressed: () {
                      if (++_hitCount == GlobalParam.TAP_COUNT) {
                        Server.showConfigDialog(context);
                        _hitCount = 0;
                      }
                    },
                  ),
                  StreamBuilder<Object>(
                    stream: _loginSubject.usernameStream,
                    builder: (context, snapshot) {
                      return STextFormField(
                        autocorrect: false,
                        decoration: InputDecoration(
                          errorText: snapshot.data,
                          labelText: L10n.of(context).username,
                        ),
                        controller: _usernameController,
                      );
                    }
                  ),
                   StreamBuilder<Object>(
                     stream: _loginSubject.passwordStream,
                     builder: (context, snapshot) {
                       return STextFormField(
                        autocorrect: false,
                        decoration: InputDecoration(
                          errorText: snapshot.data,
                          labelText: L10n.of(context).password,
                          suffixIcon: InkWell(
                            child: Icon(Icons.remove_red_eye),
                            onTap: () {
                              _obscureText = !_obscureText;
                              setState(() {

                              });
                            },
                          )
                        ),
                        controller: _passwordController,
                        obscureText: _obscureText,
                  );
                     }
                   ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: _autoLogin,
                        checkColor: STextStyle.LIGHT_TEXT_COLOR,
                        activeColor: STextStyle.GRADIENT_COLOR1,
                        onChanged: (newValue) {
                          setState(() {
                            _autoLogin = newValue;
                          });
                        },
                      ),
                      SText(L10n.of(context).autoLoginNextTimes)
                    ],
                  ),
                  StreamBuilder<Object>(
                    stream: _loginSubject.loginStream,
                    builder: (context, snapshot) {
                      return SGradientButton(
                        onPressed: state is! LoginLoading ? (snapshot.data==true ? _onLoginButtonPressed : null ) : null,
                        text: L10n.of(context).login,
                      );
                    }
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SFlatButton(
                    onPressed: state is! ResetPasswordLoading ? _onForgotPasswordButtonPressed : null,
                    child:  Text(L10n.of(context).forgotPassword),
                  ),
                  SContainer(
                    child:
                        state is LoginLoading || state is ResetPasswordLoading ? CircularProgressIndicator() : null,
                  ),

                  SizedBox(
                    height: 1000,
                  ),
                  Column(
                    children: <Widget>[
                      SText(
                        '${L10n.of(context).deviceID}'
                      ),
                      SText(
                        '$_uuid',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  _onLoginButtonPressed() async {
    _loginBloc.dispatch(LoginButtonPressed(
      username: _usernameController.text,
      password: _passwordController.text,
      autoLogin: _autoLogin,
      companyId: 1,
      branchId: 2,
    ));
  }

  _onForgotPasswordButtonPressed() {
    _loginBloc.dispatch(ForgotPasswordButtonPressed(
      username: _usernameController.text,
      urlPrefix: GlobalParam.SERVER_URL,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _loginSubject.dispose();
  }


}
