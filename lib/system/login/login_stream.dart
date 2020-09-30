import 'dart:async';

import 'package:mobile/locale/locales.dart';
import 'package:rxdart/rxdart.dart';

class LoginStream {
  final _usernameSubject = BehaviorSubject<String>();
  final _passwordSubject = BehaviorSubject<String>();
  final _loginSubject = BehaviorSubject<bool>();

  Stream<bool> get loginStream => _loginSubject.stream;

  Stream<String> get usernameStream => _usernameSubject
      .stream.transform(StreamTransformer<String, String>.fromHandlers(
          handleData: (username, sink){
            if((username?.length??0) < 1)
              sink.add(L10n.ofValue().usernameMustBeNotEmpty);
            else
              sink.add(null);
          }));
  Sink<String> get usernameSink => _usernameSubject.sink;

  Stream<String> get passwordStream => _passwordSubject
      .stream.transform(StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink){
        if((password?.length??0) < 1)
          sink.add(L10n.ofValue().passwordMustBeNotEmpty);
        else
          sink.add(null);
      }));
  Sink<String> get passwordSink => _passwordSubject.sink;

  LoginStream() {
    Observable.combineLatest2(_usernameSubject, _passwordSubject, (String username, String password){
      return (username?.length??0) >= 1 && (password?.length??0) >= 1;
    }).listen((bool enable){
      _loginSubject.sink.add(enable);
    });
  }

  void dispose() {
    _usernameSubject.close();
    _passwordSubject.close();
    _loginSubject.close();
  }
}