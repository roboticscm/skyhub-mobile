import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/locale/r2.dart';
import 'package:mobile/modules/calendar/cal_util.dart';
import 'package:mobile/modules/calendar/model.dart';
import 'package:mobile/modules/home/home_page.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/system/authentication/authentication.dart';
import 'package:mobile/system/config/app_loader.dart';
import 'package:mobile/system/login/login.dart';
import 'package:mobile/system/login/login_api.dart';
import 'package:mobile/system/splash/splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile/widgets/loading_indicator.dart';
import 'package:rxdart/rxdart.dart';
import 'common/common.dart';
import 'modules/home/settings_ui.dart';
import 'system/loader/data.dart';

import 'package:devicelocale/devicelocale.dart';

void main () async {
  await AppLoader.load();
  await R2.loadFromAPI();
  runApp(App(loginAPI: LoginAPI()));
  App.appState.setLocale(LanguageConfig.values[GlobalParam.LANGUAGE_INDEX]??0);
}

class App extends StatefulWidget {
  final LoginAPI loginAPI;
  static AppState appState;
  App({Key key, @required this.loginAPI}) : super(key: key);

  @override
  State<App> createState(){
    appState = AppState();
    return appState;
  }
}

class AppState extends State<App> {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  AuthenticationBloc _authenticationBloc;
  LoginAPI get _loginAPI => widget.loginAPI;
  var _localeSubject = BehaviorSubject<Locale>();
  @override
  void initState() {
    _authenticationBloc = AuthenticationBloc(loginAPI: _loginAPI);
    _authenticationBloc.dispatch(AppStarted());

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/logo');
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);

    super.initState();
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    _localeSubject.close();
    super.dispose();
  }

  void setLocale(LanguageConfig langConfig) async{
    String system = await Devicelocale.currentLocale;
    system = system.split("_")[0];
    String lang;
    switch(langConfig) {
      case LanguageConfig.system:
        lang = system;
        break;
      case LanguageConfig.vietnamese:
        lang = 'vi';
        break;
      case LanguageConfig.english:
        lang = 'en';
        break;
    }
    _localeSubject.sink.add( Locale(lang,''));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: _authenticationBloc,
      child: StreamBuilder<Object>(
        stream: _localeSubject.stream,
        //initialData: Locale('en',''),
        builder: (context, localSnapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: STextStyle.PRIMARY_TEXT_COLOR,
//          tabBarTheme: TabBarTheme(
//            labelColor: STextStyle.ACTIVE_BOTTOM_BAR_COLOR,
//            unselectedLabelColor: STextStyle.BOTTOM_BAR_COLOR,
//          ),
            ),
            locale: localSnapshot.data,
            localizationsDelegates: [
              const L10nDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            supportedLocales: [
              Locale('vi', ''),
              if (Platform.isAndroid)
              Locale('en', '')
            ],
            onGenerateTitle: (BuildContext context) => L10n.of(context).appName,
            home: BlocBuilder<AuthenticationEvent, AuthenticationState>(
              bloc: _authenticationBloc,
              builder: (BuildContext context, AuthenticationState state) {
                GlobalParam.appContext = context;
                if (state is AuthenticationUninitialized) {
                  return SplashPage();
                }
                if (state is AuthenticationAuthenticated) {
                  ///load branch, department, group, employee
                  GlobalData.loadData();
                  return HomePage();
                }
                if (state is AuthenticationUnauthenticated) {
                  return LoginPage(loginAPI: _loginAPI);
                }
                if (state is AuthenticationLoading) {
                  return LoadingIndicator();
                }

                return LoginPage(loginAPI: _loginAPI);
              },
            ),
          );
        }
      ),
    );
  }

  static void showNotification(int numOfNotification) async {
    if ((numOfNotification ?? 0) <= 0)
      return;

    if (numOfNotification != GlobalParam.previousTotalNotify){
      var android = new AndroidNotificationDetails(
          'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
          priority: Priority.High,importance: Importance.Max
      );
      var iOS = new IOSNotificationDetails();
      var platform = new NotificationDetails(android, iOS);

      var desc = await Util.getNotificationDesc(GlobalParam.notify);
      await flutterLocalNotificationsPlugin.show(
          0, '${L10n.of(GlobalParam.appContext).youHave} $numOfNotification ${L10n.of(GlobalParam.appContext).newMessage}',
          desc , platform,
          payload: desc.contains(L10n.ofValue().message) ? 'message' : 'notification');

      GlobalParam.previousTotalNotify = numOfNotification;
    }
  }







  static void showScheduleNotify(List<ScheduleView> list) async {
    if (list == null || list.length == 0)
      return;

    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High,importance: Importance.Max
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    for(var s in list)
      await flutterLocalNotificationsPlugin.show(
          0, CalUtil.getEventTypeName(s.eventType),
          '${s.title} - ${s.startDate} -> ${s.endDate}' , platform,
          payload: 'calendar:${s.scheduleItemId}');
  }

  Future onSelectNotification(String payload) {
    if (payload.startsWith("calendar")) {
      HomePage.homePageState.setSelectedTabIndex(HomePageState.CALENDAR_TAB_INDEX);
    } else if (payload.startsWith("notification")) {
      HomePage.homePageState.setSelectedTabIndex(HomePageState.NOTIFICATION_TAB_INDEX);
    }else if (payload.startsWith("message")) {
      HomePage.homePageState.setSelectedTabIndex(HomePageState.MESSAGE_TAB_INDEX);
    }else
      HomePage.homePageState.setSelectedTabIndex(HomePageState.HOME_TAB_INDEX);
  }
}
