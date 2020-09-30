import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_incall_manager/incall.dart';
import 'package:mobile/modules/calendar/calendar_ui.dart';
import 'package:mobile/modules/chat/chat_model.dart';
import 'package:mobile/modules/chat/chat_ui.dart';
import 'package:mobile/modules/employee/employee_ui.dart';
import 'package:mobile/modules/event/event_ui.dart';
import 'package:mobile/modules/home/home_page.dart';
import 'package:mobile/modules/home/home_ui.dart';
import 'package:mobile/modules/notification/message_list_ui.dart';
import 'package:mobile/modules/notification/notification_ui.dart';
import 'package:mobile/modules/sales/request_po/request_po_model.dart';
import 'package:mobile/system/register_devices/register_devices_ui.dart';
import 'package:mobile/modules/video_call/calling_ui.dart';
import 'package:mobile/system/config/server.dart';

class GlobalParam {
  static String SERVER_URL = Server.DEFAULT_SERVER_URL;
  static String BASE_API_URL = '${SERVER_URL}/api/';
  static String TOKEN = '||| token';
  static int CONNECTION_TIMEOUT = 10;
  static String CHAT_SERVER_URL = Server.DEFAULT_WS_SERVER_URL;
  static String USER_NAME = 'admin';
  static String FULL_NAME = 'Administrator';
  static int USER_ID = 0;
  static int EMPLOYEE_ID = 0;
  static const int PAGE_SIZE = 500;
  static String IMAGE_SERVER_URL = Server.DEFAULT_IMAGE_SERVER_URL;
  static const double BIGGER_FONT_SIZE = 16;
  static const double DEFAULT_FONT_SIZE = 14;
  static const double SMALLER_FONT_SIZE = 12;
  static int COMPANY_ID = 1;
  static int BRANCH_ID = 101;

  static BuildContext appContext;

  static const int WAITING_RINGTONE = 10;

  static const int TAP_COUNT = 3;

  static GlobalKey<CallingUIState> callingPageGlobalKey ;
  static GlobalKey chatDetailsPageGlobalKey = new GlobalKey();

  static bool isActivatedChat = false;
  static bool isAppInBackground = false;

  static IncallManager inCall;
  static List<SkyNotification> notify;
  static HomePageState homePageState;
  static CallingUIState callingUIState;

  static ChatUIState chatUIState;

  static Map<dynamic, dynamic> onlineUsers;

  static EventUIState eventUIState;

  static int currentGroupId;

  static NotificationUIState notificationUIState;

  static CalendarUIState calendarUIState;

  static Timer webSocketTimer;

  static List<dynamic> adminIds;

  static RegisterDevicesUIState registerDevicesUIState;

  static String uuid;

  static int keepAliveTime = 60;//second

  static EmployeeUIState employeeUIState;

  static HomeUIState homeUIState;

  static MessageListUIState messageListUIState;

  static GlobalKey messageListDetailsPageGlobalKey = new GlobalKey();

  static int previousTotalNotify;

  static bool isLoggedin = false;

  static int LANGUAGE_INDEX = 0;

  static  RequestPoView reqPo;
  static  List<RequestPoItemView> requestPoItemList;
  static  List<RequestPoItemView> requestPoItemDeleteList;
  static int getUserId(){
    if(GlobalParam.USER_ID != 0){
      return  GlobalParam.USER_ID;
    }
    else{
      //get from file
    }
  }
}