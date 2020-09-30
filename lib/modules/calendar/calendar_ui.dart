import 'package:flutter/material.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/modules/calendar/day/day_api.dart';
import 'package:mobile/modules/calendar/day/day_bloc.dart';
import 'package:mobile/style/text_style.dart';

import 'scalendar.dart';

class CalendarUI extends StatefulWidget {
  CalendarUI({
    Key key,
  }) : super(key: key);

  @override
  State<CalendarUI> createState() {
    GlobalParam.calendarUIState = CalendarUIState();
    return GlobalParam.calendarUIState;
  }
}

class CalendarUIState extends State<CalendarUI> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildRecentChatList();
  }

  Widget _buildRecentChatList() {
    return Scaffold(
        backgroundColor: STextStyle.BACKGROUND_COLOR,
        body: SCalendar()
    );
  }
}
