import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class WeekView extends StatefulWidget {
  final Function updateCurrentDateTimeCallback;
  final Function showDayCallback;
  final Function setTitleCallback;
  final Function getSelectedEmpIdCallback;
  final Function changeToggleIconCallback;
  final DateTime prevDateTime;
  static _WeekViewState weekViewState;
  final MonthBloc monthBloc;
  final SharedPreferences prefs;
  WeekView({
    this.updateCurrentDateTimeCallback,
    this.showDayCallback,
    this.setTitleCallback,
    this.prevDateTime,
    this.monthBloc,
    this.getSelectedEmpIdCallback,
    this.changeToggleIconCallback,
    this.prefs,
  });

  @override
  _WeekViewState createState() {
    weekViewState = _WeekViewState();
    return weekViewState;
  }
}

class _WeekViewState extends State<WeekView> {
  static const double CELL_HEIGHT = 95;
  PageController _pageController;
  get _updateCurrentDateTimeCallback => widget.updateCurrentDateTimeCallback;
  get _showDayCallback => widget.showDayCallback;
  MonthBloc get _monthBloc => widget.monthBloc;

  DateTime get _prevDateTime => widget.prevDateTime;
  DateTime _currentDateTime;
  static const double _ROW_HEIGHT = 46;

  int _startIndex = (DateTime.now().year - SCalendar.BEGIN_YEAR)*12*4;
  bool _graphMode;
  List<int> _events;
  List<ScheduleView> _list;
  List<ScheduleView> _filteredList;
  List<ScheduleView>  _groupFilteredByDayList;
  Tuple2<DateTime, DateTime> _startEndDateOfWeek;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _startIndex);
    _currentDateTime = _prevDateTime;
    _graphMode =  widget.prefs.getBool("calendar.weekView.graphMode") ?? true;
    widget.changeToggleIconCallback(_graphMode);
    _events = SCalendar.calendarState.filterEventTypes;
    loadData(_currentDateTime);
  }

  void toggleGraphAndAgenda () async {
    _graphMode = !_graphMode;
    widget.changeToggleIconCallback(_graphMode);
    setState(() {
    });
    await widget.prefs.setBool("calendar.weekView.graphMode", _graphMode);
  }

  void loadData(DateTime currentDate) {
    _currentDateTime = currentDate;
    int currentWeek = CalUtil.getWeekOfYear(_currentDateTime);
    _startEndDateOfWeek = CalUtil.getStartEndDateOfWeek(_currentDateTime.year, currentWeek);
    DateTime startDate = _startEndDateOfWeek.item1;
    DateTime endDate = _startEndDateOfWeek.item2;
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

    _setTitle(_filteredList?.length??0);
  }

  void _setTitle(int count) {
    var currentWeek = CalUtil.getWeekOfYear(_currentDateTime);
        Tuple2<DateTime, DateTime> dates = CalUtil.getStartEndDateOfWeek(_currentDateTime.year, currentWeek);
        String title = '${L10n
            .ofValue()
            .week} $currentWeek: ${Util.getShortDateStr(dates.item1)} - ${Util
            .getShortDateStr(dates.item2)}/${_currentDateTime.year}';

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
          return _buildWeekCalendar(CalUtil.getWeekOfYear(_currentDateTime));
        }): PageView.builder(
        controller: _pageController,

        onPageChanged: (index) {
          _updateCurrentDate(index);
        },

        itemBuilder: (BuildContext context, int index) {
          return _buildWeekAgenda();
        });
  }

  List<Widget> _buildGroupContent(DateTime date, bool isLastItem) {
    _groupFilterByDay(date);

    List<Widget> list = [];
    if( (_groupFilteredByDayList?.length??0) ==0 )
      return list;

    list.add(YearViewState.makeGroupHeader(_groupFilteredByDayList, Util.getDateStr(date) + " (" + Util.getShortLunarDateStringTuple(Util.convertToLunarDate(date))  + ")", _groupFilteredByDayList?.length, isLastItem));
    list.add(SliverList(delegate: SliverChildListDelegate([
      ..._buildAgendaListInGroup(date)
      ],
    )));
    return list;
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

  List<Widget> _buildAgendaListInGroup(DateTime date) {
    List<Widget> list = [];
    if(_groupFilteredByDayList == null ?? _groupFilteredByDayList.length == 0)
      return list;

    for (var i = 0; i < _groupFilteredByDayList.length; i++){
      list.add(DayViewState.buildDayAgendaItem(context, date, _groupFilteredByDayList[i], _groupFilteredByDayList.length-1 == i));
    }

    return list;
  }

  Widget _buildWeekAgenda() {
    int dateDiff = _startEndDateOfWeek.item2.difference(_startEndDateOfWeek.item1).inDays;
    List<DateTime> listDates = [];
    var startDate = _startEndDateOfWeek.item1;

    for(var i = 0; i < dateDiff; i++) {
      listDates.add(startDate);
      startDate = startDate.add(Duration(days: 1));
    }

    List list = [];
    bool hasData = false;
    for(var i = 0; i < dateDiff; i++) {
      var temp = _buildGroupContent(listDates[i], dateDiff-1==i);
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
          for(var i = 0; i < dateDiff; i++)
            ...list[i]
      ],
    );
  }

  Widget _buildWeekCalendar(int week) {
    var startDate = CalUtil.getStartEndDateOfWeek(_currentDateTime.year, week).item1;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        controller: ScrollController(initialScrollOffset: _ROW_HEIGHT*8),
        slivers: <Widget>[
          SliverPersistentHeader(
              pinned: true,
              delegate: SliverAppBarDelegate(
                minHeight: 40.0,
                maxHeight: 40.0,
                child: Container(
                  alignment: Alignment.center,
                  color: Color.fromRGBO(240, 240, 240, 1),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: {0: FixedColumnWidth(20), 6: FixedColumnWidth(30), 7: FixedColumnWidth(30)},
                    children: [
                      _buildWeekCalendarHeader(startDate)
                    ],
                  ),
                ),
              )
          ),
          SliverList(delegate: SliverChildListDelegate([
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(
                color: Colors.grey,
                width: 0.2
              ),
              columnWidths: {0: FixedColumnWidth(20), 6: FixedColumnWidth(30), 7: FixedColumnWidth(30)},
              children: [
                ..._buildWeekCalendarContent(startDate)
              ],
            )
          ])),
        ],
      ),
    );
  }

  TableRow _buildWeekCalendarHeader(DateTime startDate) {
    var wdNames = ['',
      L10n.ofValue().monday, L10n.ofValue().tuesday, L10n.ofValue().wednesday, L10n.ofValue().thursday,
      L10n.ofValue().friday, L10n.ofValue().saturday, L10n.ofValue().sunday,
    ];

    return TableRow(
        children: [
          for (int wd = 0; wd <= 7; wd++)
            if (wd == 0)
              TableCell(
                child: SText(''),
              )
            else
              TableCell(
                child: Container(
                  decoration: BoxDecoration(
                    color: _isNow(startDate, wd-1) ? Colors.orange : Color.fromRGBO(240, 240, 240, 1),
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.2
                    )
                  ),

                  child: Column(
                    children: <Widget>[
                      SText(
                        wdNames[wd],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: (wd==7) ? Colors.red : Colors.black
                        ),
                      ),
                      SText(
                        Util.getShortDateStr(startDate.add(Duration(days: wd-1))),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10,
                            color: (wd==7) ? Colors.red : Colors.black
                        ),
                      ),
                      SText(
                        "(" + Util.getShortLunarDateStringTuple(Util.convertToLunarDate(startDate.add(Duration(days: wd-1)))) + ")",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 9,
                            color: (wd==7) ? Colors.red : Colors.black
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ]
    );
  }

  bool _isNow(DateTime date, int addDay) {
    var testDate = date.add(Duration(days: addDay));
    return CalUtil.isNow(testDate);
  }

  List<TableRow> _buildWeekCalendarContent(DateTime startDate) {
    var rows = List<TableRow>();
    for (var h = 0; h <= 23; h++)
      rows.add(TableRow(
        children: [
          for (var wd = 0; wd <= 7; wd++ )
            if (wd == 0)
              TableCell(
                child: Container(height: _ROW_HEIGHT,
                  alignment: Alignment.center,
                  child: Text('$h', textAlign: TextAlign.center,)
                )
              )
            else
              TableCell(
                child: Container(
                  alignment: Alignment.topCenter,
                  height: _ROW_HEIGHT,
                  child: _buildWeekCalendarItem(startDate.add(Duration(days: wd - 1)), h)
                )
              )
        ],
      ));

    return rows;
  }

  Widget _buildWeekCalendarItem(DateTime date, int hour) {
    var totalEvent = _countEventByDayAndHour(date, hour);
    var favEvents = _getFavouriteEventByDayAndHour(date, hour);
    return InkWell(
      onTap: (){
        _showDayCallback(date.day, hour);
      },
      child: Container(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            Column(
              children: <Widget>[
                if (favEvents.item1.length > 0)
                Container(
                  width: double.infinity,
                  color: Colors.green,
                  margin: EdgeInsets.all(1),
                  padding: EdgeInsets.all(2),
                  child: Text(favEvents.item1,
                    style: TextStyle(
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                if (favEvents.item2.length > 0)
                Container(
                  color: Colors.red,
                  width: double.infinity,
                  margin: EdgeInsets.all(1),
                  padding: EdgeInsets.all(2),
                  child: Text(favEvents.item2,
                    style: TextStyle(
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            if (totalEvent > 2)
            CircleAvatar(
              backgroundColor: Colors.yellow,
              maxRadius: 10,
              child: Text('+${totalEvent-2}', style: TextStyle(fontSize: 10, color: Colors.red),),
            ),
          ],
        ),
      ),
    );
  }

  int _countEventByDayAndHour(DateTime date, int hour) {
//    if((_filteredList?.length??0) == 0)
//      return 0;
//
//    return List.from(_filteredList.where((test){
//      var testDay = CalUtil.dateDiffWithoutTime(test.startDate, date) <= 0 && CalUtil.dateDiffWithoutTime(test.endDate, date) >= 0;
//      return testDay && CalUtil.hasEventAtHour((test?.allDay??0)==1, date, hour, test.startDate, test.endDate);
//    })).length;
    return 0;
  }

  Tuple2<String, String> _getFavouriteEventByDayAndHour(DateTime date, int hour) {
    return Tuple2("", "");
  }

  void filter({int selectedEmp, List<int> events}) {
    setState(() {
      _events = events;
    });
  }

  void _updateCurrentDate(int index) {
    DateTime currentDateTime;
    if(index > _startIndex)
      currentDateTime = DateTime(_currentDateTime.year, _currentDateTime.month, _currentDateTime.day + 7);
    else
      currentDateTime = DateTime(_currentDateTime.year, _currentDateTime.month, _currentDateTime.day - 7);

    _updateCurrentDateTimeCallback(currentDateTime);
    loadData(currentDateTime);
  }
}

