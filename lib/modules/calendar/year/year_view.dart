import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/calendar/day/day_view.dart';
import 'package:mobile/modules/calendar/filter/filter_ui.dart';
import 'package:mobile/modules/calendar/model.dart';
import 'package:mobile/modules/calendar/month/month_api.dart';
import 'package:mobile/modules/calendar/month/month_bloc.dart';
import 'package:mobile/modules/calendar/month/month_event.dart';
import 'package:mobile/modules/calendar/month/month_state.dart';
import 'package:mobile/modules/calendar/month/month_view.dart';
import 'package:mobile/modules/calendar/scalendar.dart';
import 'package:mobile/modules/calendar/cal_util.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/widgets/scircular_progress_indicator.dart';
import 'package:mobile/widgets/stext.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YearView extends StatefulWidget {
  final Function updateCurrentDateTimeCallback;
  final Function showMonthCallback;
  final Function setTitleCallback;
  final Function getSelectedEmpIdCallback;
  final DateTime prevDateTime;
  static YearViewState yearViewState;
  final MonthBloc monthBloc;
  final SharedPreferences prefs;
  final Function changeToggleIconCallback;
  YearView({
    this.updateCurrentDateTimeCallback,
    this.showMonthCallback,
    this.prevDateTime,
    this.setTitleCallback,
    this.monthBloc,
    this.getSelectedEmpIdCallback,
    this.prefs,
    this.changeToggleIconCallback,
  });

  @override
  YearViewState createState() {
    yearViewState = YearViewState();
    return yearViewState;
  }
}

class YearViewState extends State<YearView> {
  PageController _pageController;
  get _updateCurrentDateTimeCallback => widget.updateCurrentDateTimeCallback;
  get _showMonthCallback => widget.showMonthCallback;
  DateTime get _prevDateTime => widget.prevDateTime;
  DateTime _currentDateTime;
  int _startIndex = DateTime.now().year - SCalendar.BEGIN_YEAR;
  var _wdNames = ['',
    L10n.ofValue().shortMonday, L10n.ofValue().shortTuesday, L10n.ofValue().shortWednesday, L10n.ofValue().shortThursday,
    L10n.ofValue().shortFriday, L10n.ofValue().shortSaturday, L10n.ofValue().shortSunday,
  ];
  var _defaultStyle = TextStyle(fontSize: 10, color: Colors.black);
  var _sundayStyle = TextStyle(fontSize: 10, color: Colors.red);
  var _headerStyle = TextStyle(fontSize: 12, color: STextStyle.LIGHT_TEXT_COLOR);
  var _todayStyle = TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold);
  MonthBloc get _monthBloc => widget.monthBloc;
  List<int> _events;
  List<ScheduleView> _list;
  List<ScheduleView> _filteredList;
  List<ScheduleView>  _groupFilteredList;
  List<ScheduleView>  _groupFilteredByDayList;
  bool _graphMode;
  MonthAPI _monthAPI = new MonthAPI();
  StreamController<List<ScheduleView>> _apiStreamController = StreamController();
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _startIndex);
    _graphMode =  widget.prefs.getBool("calendar.yearView.graphMode") ?? true;
    widget.changeToggleIconCallback(_graphMode);
    _currentDateTime = _prevDateTime;

    _events = SCalendar.calendarState.filterEventTypes;
    loadData(_currentDateTime);
  }

  void loadData(DateTime currentDate) async {
    _currentDateTime = currentDate;
    DateTime startDate = DateTime(currentDate.year, 1, 1);
    DateTime endDate = DateTime(currentDate.year, 12,
        CalUtil.getLastDayOfMonth(currentDate.year, 12)
    );
    _list = await _monthAPI.findScheduleByMonth(
      startDate: startDate,
      endDate: endDate,
      empId: widget.getSelectedEmpIdCallback()
    );

    _apiStreamController.sink.add(_list ?? []);

//    _monthBloc.dispatch(OnMonthLoad(
//      startDate: startDate,
//      endDate: endDate,
//      empId: widget.getSelectedEmpIdCallback()
//    ));
  }


  @override
  void dispose() {
    super.dispose();
    _apiStreamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScheduleView>>(
      stream: _apiStreamController.stream,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          _filter();
          return  _buildUI();
        } else
          return SCircularProgressIndicator.buildSmallCenter();
      }
    );
  }

//  @override
//  Widget build(BuildContext context) {
//    return BlocBuilder<MonthEvent, MonthState>(
//      bloc: _monthBloc,
//      builder: (BuildContext context, MonthState state) {
//        if (state is MonthFailure) {
//          _onWidgetDidBuild(() {
//            Scaffold.of(context).showSnackBar(
//              SnackBar(
//                content: SText(state.error),
//                backgroundColor: Colors.red,
//              ),
//            );
//          });
//        }
//        if (state is MonthLoading) {
//          _list = state.list;
//          _filter();
//        }
//        return state is MonthLoading ? _buildUI() : SCircularProgressIndicator.buildSmallCenter();
//      },
//    );
//  }

  void _filter() {
    if (_list == null || _list.length == 0) {
      _filteredList = null;
      _setTitle(0);
      return;
    }

    if (_events != null && _events.length > 0 && _events.length != FilterUIState.TOTAL_EVENT){
      _filteredList = List.from(_list.where((item) => _events.contains(item.eventType)));
    } else
      _filteredList = List.from(_list);
    _setTitle(_filteredList.length);
  }

  void _setTitle(int count) {
    String title = DateFormat.y().format(_currentDateTime);
    if(count > 0)
      title += ' - ($count)';

    widget.setTitleCallback(title);
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  void toggleGraphAndAgenda () async {
    _graphMode = !_graphMode;
    widget.changeToggleIconCallback(_graphMode);
    setState(() {
    });
    await widget.prefs.setBool("calendar.yearView.graphMode", _graphMode);
  }

  Widget _buildUI() {
    return _graphMode ? PageView.builder(
      controller: _pageController,
        onPageChanged: (index) {
          _updateCurrentDate(index);
        },

      itemBuilder: (BuildContext context, int index) {
        return _buildYearCalendar();
      }) : PageView.builder(
        controller: _pageController,

        onPageChanged: (index) {
          _updateCurrentDate(index);
        },

        itemBuilder: (BuildContext context, int index) {
          return _buildYearAgenda();
        });
  }


  Widget _buildYearAgenda() {
    List list = [];
    bool hasData = false;
    for(var month = 1; month <= 12; month++) {
      var temp = _buildGroupContent(month, month == 11);
      if (temp.length > 0)
        hasData = true;
      list.add(temp);
    }

    return CustomScrollView(
      slivers: <Widget>[
        if (!hasData)
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegate(
              minHeight: 25.0,
              maxHeight: 55.0,
              child: Center(
                child: Text(L10n.ofValue().noDataFound),
              ),
            )
          )
        else
          for(var month = 1; month <= 12; month++)
            ...list[month-1]
      ],
    );
  }

  void _groupFilter(DateTime startDate, DateTime endDate) {
    if ((_filteredList?.length??0) == 0) {
      _groupFilteredList = null;
      return;
    }

    _groupFilteredList = List.from(_filteredList.where((item) {
      return CalUtil.dateDiffWithoutTime(item.startDate, endDate) <= 0 && CalUtil.dateDiffWithoutTime(item.endDate, startDate) >= 0;
    }));
  }

  List<Widget> _buildGroupContent(int month, bool isLastItem) {
    var startDate = DateTime(_currentDateTime.year, month, 1);
    var endDate = DateTime(_currentDateTime.year, month, CalUtil.getLastDayOfMonth(_currentDateTime.year, month));

    _groupFilter(startDate, endDate);


    List<Widget> list = [];
    if ((_groupFilteredList?.length??0) ==0)
      return list;

    list.add(makeGroupHeader(_groupFilteredList, '${CalUtil.getMonthName(month)} - ${startDate.day} -> ${endDate.day}', _groupFilteredList?.length, isLastItem));
    list.add(SliverList(delegate: SliverChildListDelegate([
      ..._buildAgendaListInGroup(startDate, endDate)
    ])));
    return list;
  }

  void _groupFilterByDay(DateTime date) {
    if (_filteredList == null || _filteredList.length == 0) {
      _groupFilteredByDayList = null;
      return;
    }

    _groupFilteredByDayList = List.from(_filteredList.where((item) {
      return CalUtil.dateDiffWithoutTime(item.startDate, date) <= 0 && CalUtil.dateDiffWithoutTime(item.endDate, date) >= 0;
    }).map((s){
      if (date.difference(s.startDate).inDays > 0)
        s.allDay = 1;

      return s;
    }));

    _groupFilteredByDayList.sort((s1, s2) => CalUtil.sortByTimeAndTitle(s1, s2));
  }

  List<Widget> _buildAgendaListInGroup(DateTime startDate, DateTime endDate) {
    List<Widget> list = [];
    var dateDiff =  CalUtil.dateDiffWithoutTime(endDate, startDate);
    for(var d = 0; d <= dateDiff; d++){
      _groupFilterByDay(startDate);

      if(_groupFilteredByDayList != null && _groupFilteredByDayList.length > 0)
        list.add(Text('${CalUtil.getWeekDayName(startDate.weekday)} - ${Util.getDateStr(startDate)}' + "(" + Util.getShortLunarDateStringTuple(Util.convertToLunarDate(startDate))  + ")",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic
            ),
          )
        );
      for(var i = 0; i < _groupFilteredByDayList?.length??0; i++)
        list.add(DayViewState.buildDayAgendaItem(context, startDate, _groupFilteredByDayList[i], _groupFilteredByDayList.length-1 == i));

      startDate = startDate.add(Duration(days: 1));
    }

    return list;
  }

  static int getTotalItemOfEvent(List<ScheduleView> list, int eventType){
    if (list == null || list.length ==0)
      return 0;

    return list.where((s)=>s.eventType == eventType).length;
  }

  static SliverPersistentHeader makeGroupHeader(List<ScheduleView> list, String headerText, int totalItem, bool isLastItem) {
    List<String> subEvents = List();

    int event = getTotalItemOfEvent(list, SCalendar.TYPE_EVENT);
    if (event > 0)
      subEvents.add('${L10n.ofValue().event}: $event');

    int meetings = getTotalItemOfEvent(list, SCalendar.TYPE_MEETING);
    if (meetings > 0)
      subEvents.add('${L10n.ofValue().meetings}: $meetings');

    int task = getTotalItemOfEvent(list, SCalendar.TYPE_TASK);
    if (task > 0)
      subEvents.add('${L10n.ofValue().task}: $task');

    int reminder = getTotalItemOfEvent(list, SCalendar.TYPE_REMINDER);
    if (reminder > 0)
      subEvents.add('${L10n.ofValue().reminder}: $reminder');

    int holiday = getTotalItemOfEvent(list, SCalendar.TYPE_HOLIDAY);
    if (holiday > 0)
      subEvents.add('${L10n.ofValue().holiday}: $holiday');

    int traveling = getTotalItemOfEvent(list, SCalendar.TYPE_TRAVELING);
    if (traveling > 0)
      subEvents.add('${L10n.ofValue().traveling}: $traveling');

    int potential = getTotalItemOfEvent(list, SCalendar.TYPE_LEAD_ACTIVITY);
    if (potential > 0)
      subEvents.add('${L10n.ofValue().potential}: $potential');

    int opportunity = getTotalItemOfEvent(list, SCalendar.TYPE_OPPORTUNITY_ACTIVITY);
    if (opportunity > 0)
      subEvents.add('${L10n.ofValue().opportunity}: $opportunity');

    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 25.0,
        maxHeight: 55.0,
        child: Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
                color: STextStyle.GRADIENT_COLOR1,
                border: isLastItem ? null : Border(
                    bottom: BorderSide(
                        color: Colors.blueGrey,
                        width: 1
                    )
                )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: SText(
                      headerText + '- ${L10n.ofValue().totalItem}: $totalItem',
                      style: TextStyle(color: Colors.white, fontSize: 12)
                  ),
                ),
                Flexible(
                    child: SText(
                        subEvents.join(" - "),
                        style: TextStyle(color: Colors.lightGreen, fontSize: 11)
                    )
                ),
              ],
            )
        ),
      ),
    );
  }

  void filter({int selectedEmp, List<int> events}) {
    _events = events;
    loadData(_currentDateTime);
  }

  Widget _buildYearCalendar() {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1.15,
      children: <Widget>[
        for(var month = 1; month <= 12; month++)
          _buildMonthCalendar(month)
      ],
    );
  }

  Widget _buildMonthCalendar(int month) {
    var totalEvent = CalUtil.countByMonth(_filteredList, _currentDateTime.year, month);
    return Card(
      margin: EdgeInsets.all(2),
      color: CalUtil.isNowYm(_currentDateTime.year, month) ? Colors.white70 : Colors.white,
      child: InkWell(
        onTap: () {
          _showMonthCallback(month);
        },
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: STextStyle.GRADIENT_COLOR1,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SText(
                        '${CalUtil.getMonthName(month)}',
                        textAlign: TextAlign.center,
                        style: _headerStyle,
                      ),

//                      Text(
//                        " (" + Util.getShortLunarMonthStringTuple(Util.convertToLunarDate(DateTime(_currentDateTime.year, month, 1)))  + ")",
//                        textAlign: TextAlign.center,
//                        style: TextStyle(
//                          fontStyle: FontStyle.italic,
//                          fontSize: 9,
//                          color: Colors.lightGreenAccent
//                        ),
//                      )
                    ],
                  ),
                ),
                Table(
                  children: [
                    _buildMonthCalendarHeader(),
                    ..._buildMonCalendarContent(month)
                  ],
                ),
              ],
            ),
            if((totalEvent??0) > 0)
              Padding(
                padding: EdgeInsets.only(bottom: 4, right: 30),
                child: Text('${L10n.ofValue().event}:', style: TextStyle(fontSize: 10, color: Colors.red),),
              ),
            if((totalEvent??0) > 0)
              Padding(
                padding: EdgeInsets.only(bottom: 2, right: 5),
                child: InkWell(
                  onTap: (){
                    print('select $month');
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.yellow,
                    maxRadius: 10,
                    child: Text('$totalEvent', style: TextStyle(fontSize: 10, color: Colors.red),),
                  ),
                ),
              )

          ],
        ),
      ),
    );
  }

  TableRow _buildMonthCalendarHeader() {
    return TableRow(
      children: [
        for (int wd = 1; wd <= 7; wd++)
          TableCell(
            child: Text(
              _wdNames[wd],
              textAlign: TextAlign.center,
              style: (wd == 7) ? _sundayStyle : _defaultStyle
            ),
          ),
      ]
    );
  }


  List<TableRow> _buildMonCalendarContent(int month) {
    var rows = List<TableRow>();
    var daysOfMonth = CalUtil.getLastDayOfMonth(_currentDateTime.year, month);

    var drawDay = 1;
    var dayBeginMonth = CalUtil.getDayBeginMonth(_currentDateTime.year, month);
    for (var w = 1 ; w <= daysOfMonth; w++) {
      var start;
      if(w==1)///fist week
        start = dayBeginMonth;
      else
        start = 1;

      if(drawDay > daysOfMonth)
        break;

      rows.add(TableRow(
        children: [
          for (var wd = 1; wd <= 7; wd++ )
//            onTap: () {
//              print('Tap on day ${((w-1)*7) + wd - dayBeginMonth + 1 } of month $month');
//            },
            TableCell(
              child: Text(
                wd < start ? '' : (drawDay > daysOfMonth) ? '' : '${drawDay++}',
                textAlign: TextAlign.center,
                style: CalUtil.isNowYmd(_currentDateTime.year, month, drawDay-1) ? _todayStyle : wd == 7 ? _sundayStyle : _defaultStyle,
//                  style: TextStyle(
////                    fontSize: 10,
////                    fontWeight: Util.isNowYmd(_currentDateTime.year, month, drawDay-1) ? FontWeight.bold : FontWeight.normal,
////                    color: (wd==7) ? Colors.red : Colors.black
////                  ),
              )
          )
        ],
      ));
    }
    return rows;
  }

  void today() {
    _startIndex = DateTime.now().year - SCalendar.BEGIN_YEAR;
    _currentDateTime = DateTime.now();
    loadData(_currentDateTime);
  }

  void _updateCurrentDate(int index) {
    var currentDateTime;

    if(index > _startIndex)
      currentDateTime = DateTime(_currentDateTime.year + 1, _currentDateTime.month, _currentDateTime.day);
    else
      currentDateTime = DateTime(_currentDateTime.year - 1, _currentDateTime.month, _currentDateTime.day);

    _updateCurrentDateTimeCallback(currentDateTime);
    loadData(currentDateTime);
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent)
  {
    return new SizedBox.expand(child: child);
  }
  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
