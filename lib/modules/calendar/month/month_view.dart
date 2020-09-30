import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile/common/tuple.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/calendar/day/day_view.dart';
import 'package:mobile/modules/calendar/filter/filter_ui.dart';
import 'package:mobile/modules/calendar/model.dart';
import 'package:mobile/modules/calendar/month/month_bloc.dart';
import 'package:mobile/modules/calendar/month/month_event.dart';
import 'package:mobile/modules/calendar/month/month_state.dart';
import 'package:mobile/modules/calendar/scalendar.dart';
import 'package:mobile/modules/calendar/cal_util.dart';
import 'package:mobile/modules/calendar/year/year_view.dart';
import 'package:mobile/widgets/scircular_progress_indicator.dart';
import 'package:mobile/widgets/stext.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'month_api.dart';

class MonthView extends StatefulWidget {
  final Function updateCurrentDateTimeCallback;
  final Function showDayCallback;
  final Function getSelectedEmpIdCallback;
  final Function changeToggleIconCallback;
  final Function setTitleCallback;
  final DateTime prevDateTime;
  static MonthViewState monthViewState;
  final MonthBloc monthBloc;
  final SharedPreferences prefs;
  MonthView({
    this.updateCurrentDateTimeCallback,
    this.showDayCallback,
    this.setTitleCallback,
    this.prevDateTime,
    this.monthBloc,
    this.prefs,
    this.changeToggleIconCallback,
    this.getSelectedEmpIdCallback,
  });

  @override
  MonthViewState createState() {
    monthViewState = MonthViewState();
    return monthViewState;
  }
}

class MonthViewState extends State<MonthView> {
  static const double CELL_HEIGHT = 95;
  PageController _pageController;
  get _updateCurrentDateTimeCallback => widget.updateCurrentDateTimeCallback;
  get _showDayCallback => widget.showDayCallback;
  MonthBloc get _monthBloc => widget.monthBloc;

  DateTime get _prevDateTime => widget.prevDateTime;
  DateTime _currentDateTime;

  int _startIndex = (DateTime.now().year - SCalendar.BEGIN_YEAR)*12;
  bool _graphMode;
  List<int> _events;
  List<ScheduleView> _list;
  List<ScheduleView> _filteredList;
  List<ScheduleView>  _groupFilteredList;
  List<ScheduleView>  _groupFilteredByDayList;
  List<Tuple3<int, DateTime, DateTime>> _weeks;
  static const int NUM_ITEM_PER_CELL = 2;
  static const double ITEM_HEIGHT = 30;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _startIndex);
    _currentDateTime = _prevDateTime;
    _graphMode =  widget.prefs.getBool("calendar.monthView.graphMode") ?? true;
    widget.changeToggleIconCallback(_graphMode);
    _events = SCalendar.calendarState.filterEventTypes;
    loadData(_currentDateTime);
  }


  void toggleGraphAndAgenda () async {
    _graphMode = !_graphMode;
    widget.changeToggleIconCallback(_graphMode);
    setState(() {
    });
    await widget.prefs.setBool("calendar.monthView.graphMode", _graphMode);
  }

  Future<void> loadData(DateTime currentDate) async {
    _currentDateTime = currentDate;
    _weeks = await CalUtil.getWeeksOfMonth(_currentDateTime.year, _currentDateTime.month);
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);
    DateTime endDate = DateTime(currentDate.year, currentDate.month,
      CalUtil.getLastDayOfMonth(currentDate.year, currentDate.month)
    );
    _monthBloc.dispatch(OnMonthLoad(
      startDate: startDate,
      endDate: endDate
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonthEvent, MonthState>(
      bloc: _monthBloc,
      builder: (BuildContext context, MonthState state) {
        if (state is MonthFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: SText(state.error),
                backgroundColor: Colors.red,
              ),
            );
          });
        }
        if (state is MonthLoading) {
          _list = state.list;
          _filter();
        }
        return state is MonthLoading ? _buildUI() : SCircularProgressIndicator.buildSmallCenter();
      },
    );
  }

  void _filter() {
    if (_list == null) {
      _filteredList = null;
      _setTitle(0);
      return;
    }

    if (widget.getSelectedEmpIdCallback() != null) {
      _filteredList = List.from(_list.where((item) => item.empId == widget.getSelectedEmpIdCallback()));
    } else
      _filteredList = List.from(_list);

    if (_events != null && _events.length > 0 && _events.length != FilterUIState.TOTAL_EVENT){
      _filteredList = List.from(_filteredList.where((item) => _events.contains(item.eventType)));
    }
    _setTitle(_filteredList.length);
  }

  void _setTitle(int count) {
    String title = DateFormat.yM().format(_currentDateTime);
    if(count > 0)
      title += ' - ($count)';

    widget.setTitleCallback(title);
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  Widget _buildUI() {
    return _graphMode ?
      PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          _updateCurrentDate(index);
        },

        itemBuilder: (BuildContext context, int index) {
          return _buildMonthCalendar(_currentDateTime.month);
        }): PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            _updateCurrentDate(index);
          },

          itemBuilder: (BuildContext context, int index) {
              return _buildMonthAgenda();
          });
  }

  List<Widget> _buildGroupContent(Tuple3<int, DateTime, DateTime> week, bool isLastItem) {
    _groupFilter(week.item2, week.item3);

    List<Widget> list = [];
    if( (_groupFilteredList?.length??0) ==0 )
      return list;

    list.add(YearViewState.makeGroupHeader(_groupFilteredList, '${L10n.ofValue().week}: ${week.item1}' + ' - ${Util.getDateStr(week.item2)} -> ${Util.getDateStr(week.item3)}', _groupFilteredList?.length??0, isLastItem));
    list.add(SliverList(delegate: SliverChildListDelegate([
      ..._buildAgendaListInGroup(week.item2, week.item3)
    ])));
    return list;
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

  void _groupFilterByDay(DateTime date) {
    if ((_filteredList?.length??0) == 0) {
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
    var dateDiff = CalUtil.dateDiffWithoutTime(endDate, startDate);
    for(var d = 0; d <= dateDiff; d++){
      _groupFilterByDay(startDate);

      if(_groupFilteredByDayList != null && _groupFilteredByDayList.length > 0)
        list.add(Text('${CalUtil.getWeekDayName(startDate.weekday)} - ${Util.getDateStr(startDate)}' + " (" + Util.getShortLunarDateStringTuple(Util.convertToLunarDate(startDate))  + ")",
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

  Widget _buildMonthAgenda() {

    List list = [];
    bool hasData = false;
    for(var i = 0; i < (_weeks?.length??0); i++) {
      var temp = _buildGroupContent(_weeks[i], _weeks.length-1==i);
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
          for(var i = 0; i < _weeks.length; i++)
            ...list[i]
      ],
    );
  }

  Widget _buildMonthCalendar(int month) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Table(
              columnWidths: {5: FixedColumnWidth(30), 6: FixedColumnWidth(30)},
              children: [
                _buildMonthCalendarHeader(),
                ..._buildMonCalendarContent(month)
              ],
            )
          ],
        ),
      ),
    );
  }

  TableRow _buildMonthCalendarHeader() {
    var wdNames = ['',
      L10n.ofValue().monday, L10n.ofValue().tuesday, L10n.ofValue().wednesday, L10n.ofValue().thursday,
      L10n.ofValue().friday, L10n.ofValue().saturday, L10n.ofValue().sunday,
    ];
    return TableRow(
        children: [
          for (int wd = 1; wd <= 7; wd++)
            TableCell(
              child: SText(
                wdNames[wd],
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10,
                    color: (wd==7) ? Colors.red : Colors.black
                ),
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
    var countByDay = 0;
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
            TableCell(
              child: InkWell(
                onTap: () {
                  var selectedDay = ((w-1)*7) + wd - dayBeginMonth + 1;
                  if(selectedDay >=0 && selectedDay <= daysOfMonth) {
                    _showDayCallback(selectedDay);
                  }

                },
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: (  wd < start || drawDay > daysOfMonth ) ? Colors.grey : Colors.white,
                        border: Border.all(
                          color: CalUtil.isNowYmd(_currentDateTime.year, month, drawDay) ? Colors.green : Colors.black12,
                        )
                      ),
                      height: CELL_HEIGHT,
                      width: double.infinity,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                wd < start ? '' : (drawDay > daysOfMonth) ? '' : '${drawDay++}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: (wd==7) ? Colors.red : Colors.black
                                ),
                              ),
                              if (wd<6)
                              Text(
                                wd < start ? '' : (drawDay-1 > daysOfMonth) ? '' : ' (${Util.getShortLunarDateStringTuple(Util.convertToLunarDate(DateTime(_currentDateTime.year, month, drawDay-1)))})',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 9,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey
                                ),
                              ),
                            ],
                          ),
                          _buildFavEventsForCell(_currentDateTime.year, month, ((w-1)*7) + wd - dayBeginMonth + 1)??Container(),
                        ],
                      ),
                    ),
                    if((countByDay = CalUtil.countByDay(_filteredList, _currentDateTime.year, month, ((w-1)*7) + wd - dayBeginMonth + 1)) > NUM_ITEM_PER_CELL)
                      Padding(
                        padding: EdgeInsets.only(bottom: 2, right: 2),
                        child: _buildMoreEventPopup('+${countByDay - NUM_ITEM_PER_CELL}', _currentDateTime.year, month, ((w-1)*7) + wd - dayBeginMonth + 1),
                      )
                  ],
                ),
              )
            )
        ],
      ));
    }
    return rows;
  }

  Widget _buildMoreEventPopup(String title, int year, int month, int day) {
    if ((_filteredList?.length??0) == 0)
      return null;

    var date = DateTime(year, month, day);
    List<ScheduleView> list = List.from(_filteredList.where((test){
      return CalUtil.dateDiffWithoutTime(test.startDate, date) <= 0 && CalUtil.dateDiffWithoutTime(test.endDate, date) >= 0;
    }).skip(NUM_ITEM_PER_CELL));

    if ((list?.length??0) == 0)
      return null;

    return PopupMenuButton<ScheduleView>(
        child: CircleAvatar(
          backgroundColor: Colors.yellow,
          maxRadius: 9,
          child: Text(title, style: TextStyle(fontSize: 9, color: Colors.red),),
        ),
        onSelected: (ScheduleView s) {
          DayViewState.showEditEventDialog(context, s);
        },
        itemBuilder: (context) => [
          for(var i = 0; i < list.length; i++)
            PopupMenuItem<ScheduleView>(
              value: list[i],
              child: Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: SText(DayViewState.getPopupItemTitle(list[i]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
                decoration: BoxDecoration(
                    color: CalUtil.getBackgroundColorByEventType(list[i].eventType)
                ),
              ),
            ),
        ]
    );
  }

  Widget _buildFavEventsForCell(int year, int month, int day) {
    if ((_filteredList?.length??0) == 0)
      return null;

    var date = DateTime(year, month, day);
    List<ScheduleView> list =List.from(_filteredList.where((test){
      return CalUtil.dateDiffWithoutTime(test.startDate, date) <= 0 && CalUtil.dateDiffWithoutTime(test.endDate, date) >= 0;
    }));

    if ((list?.length??0) == 0)
      return null;

    var showItem = min(NUM_ITEM_PER_CELL, list.length);
    return Column(
      children: <Widget>[
        for(var i = 0; i < showItem; i++)
          _buildCellItem(list[i])

      ],
    );
  }

  Widget _buildCellItem(ScheduleView item) {
    var bgColor = CalUtil.getBackgroundColorByEventType(item.eventType);
    return InkWell(
      onTap: (){
        DayViewState.showEditEventDialog(context, item);
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(2),
        width: double.infinity,
        height: ITEM_HEIGHT,
        margin: EdgeInsets.all(0.5),
        color: bgColor,
        child: Text(
          item.title??'',
          style: TextStyle(
            color: CalUtil.getOpposingColor(bgColor),
            fontSize: 10
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  void filter({int selectedEmp, List<int> events}) {
    setState(() {
      _events = events;
    });
  }

  void _updateCurrentDate(int index) {
    DateTime currentDateTime;
    if(index > _startIndex)
      currentDateTime = DateTime(_currentDateTime.year, _currentDateTime.month + 1, _currentDateTime.day);
    else
      currentDateTime = DateTime(_currentDateTime.year, _currentDateTime.month - 1, _currentDateTime.day);

    _updateCurrentDateTimeCallback(currentDateTime);
    loadData(currentDateTime);
  }
}
