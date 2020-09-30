import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/main.dart';
import 'package:mobile/modules/calendar/day/day_api.dart';
import 'package:mobile/modules/calendar/day/day_bloc.dart';
import 'package:mobile/modules/calendar/event/event_ui.dart';
import 'package:mobile/modules/calendar/month/month_api.dart';
import 'package:mobile/modules/calendar/month/month_bloc.dart';
import 'package:mobile/modules/home/home_page.dart';
import 'package:mobile/modules/office/holiday/holiday_ui.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/system/loader/data.dart';
import 'package:mobile/widgets/scircular_progress_indicator.dart';
import 'package:mobile/widgets/stab.dart';
import 'package:mobile/widgets/stext.dart';
import 'package:mobile/modules/calendar/day/day_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'filter/filter_ui.dart';
import 'model.dart';
import 'package:mobile/modules/calendar/month/month_view.dart';
import 'package:mobile/modules/calendar/week/week_view.dart';
import 'package:mobile/modules/calendar/year/year_view.dart';

class SCalendar extends StatefulWidget {
  static const int TYPE_EVENT = 1;
  static const int TYPE_MEETING = 2;
  static const int TYPE_TASK = 3;
  static const int TYPE_REMINDER = 4;
  static const int TYPE_TRAVELING = 5;
  static const int TYPE_HOLIDAY = 6;
  static const int TYPE_LEAD_ACTIVITY = 7;
  static const int TYPE_OPPORTUNITY_ACTIVITY = 8;

  static const int REMIND_TIME_UNIT_MINUTE = 1;
  static const int REMIND_TIME_UNIT_HOURS = 60;
  static const int REMIND_TIME_UNIT_DAY = 1440;
  static const int REMIND_TIME_UNIT_WEEK = 10080;

  static const int BEGIN_YEAR = 1970;
  static SCalendarState calendarState;
  @override
  SCalendarState createState(){
    calendarState = SCalendarState();
    return calendarState;
  }

  static Future<void> checkNotify() async {
    MonthAPI monthAPI = new MonthAPI();
    var startDate = DateTime.now().subtract(Duration(minutes: 1));
    var endDate = startDate.add(Duration(minutes: 3));
    List<ScheduleView> list = await monthAPI.findScheduleNotify(startDate: startDate, endDate: endDate, empId: GlobalParam.EMPLOYEE_ID);
    AppState.showScheduleNotify(list);

    var ret = await monthAPI.findTotalScheduleNotify(empId: GlobalParam.EMPLOYEE_ID);
    if(ret != null && ret > 0)
      HomePage.homePageState.calendarNotify(ret);
  }
}

enum ViewType {
  year, month, week, day
}

enum Status {
  busy, idle
}

class SCalendarState extends State<SCalendar> {
  static const double SUB_APP_BAR_HEIGHT = 80;
  static const double BUTTON_PADDING = 15;
  DateTime _currentDateTime = DateTime.now();
  ViewType _currentViewType = ViewType.month;
  DayBloc _dayBloc;
  MonthBloc _monthBloc;
  StreamController<String> _titleStreamController = StreamController();
  int _selectedEmpId;
  String _selectedEmpName;
  SharedPreferences _prefs;

  StreamController<bool> _loadStreamController = StreamController();
  StreamController<IconData> viewModeIconStreamController = StreamController() ;
  List<int> filterEventTypes;
  @override
  void initState() {
    _init ();
    super.initState();
  }

  void _init () async {
    _dayBloc = DayBloc(dayAPI: DayAPI());
    _monthBloc = MonthBloc(monthAPI: MonthAPI());

    _prefs = await SharedPreferences.getInstance();

    _currentViewType = ViewType.values[_prefs.getInt("calendar.viewBy")??ViewType.day.index];
    _selectedEmpId = _prefs.getInt("calendar.selectedEmplyeeId")??GlobalParam.EMPLOYEE_ID;
    if (_selectedEmpId == -1)
      _selectedEmpId = null;
    _selectedEmpName = GlobalData.getEmpName(_selectedEmpId);

    ///load event type
    filterEventTypes = _getSettingsEvent();

    if(!_loadStreamController.isClosed)
      _loadStreamController.sink.add(true);
  }

  List<int> _getSettingsEvent() {
    var list = List<int>();
    if(_prefs.getBool("calendar.checkedEvent")??false)
      list.add(SCalendar.TYPE_EVENT);

    if(_prefs.getBool("calendar.checkedMeetings")??false)
      list.add(SCalendar.TYPE_MEETING);

    if(_prefs.getBool("calendar.checkedTask")??false)
      list.add(SCalendar.TYPE_TASK);

    if(_prefs.getBool("calendar.checkedReminder")??false)
      list.add(SCalendar.TYPE_REMINDER);

    if(_prefs.getBool("calendar.checkedHoliday")??false)
      list.add(SCalendar.TYPE_HOLIDAY);

    if(_prefs.getBool("calendar.checkedTraveling")??false)
      list.add(SCalendar.TYPE_TRAVELING);

    if(_prefs.getBool("calendar.checkedPotential")??false)
      list.add(SCalendar.TYPE_LEAD_ACTIVITY);

    if(_prefs.getBool("calendar.checkedOpportunity")??false)
      list.add(SCalendar.TYPE_OPPORTUNITY_ACTIVITY);
    return list;
  }

  @override
  void dispose() {
    super.dispose();
    _titleStreamController.close();
    _loadStreamController.close();
    viewModeIconStreamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _loadStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return Scaffold(
            appBar: _buildAppBar(),
            body: _buildBody()
          );
        else
          return SCircularProgressIndicator.buildSmallCenter();
      }
    );
  }

  int _getSelectedEmpId() {
    return _selectedEmpId;
  }

  Widget _buildAddEventPopup() {
    return PopupMenuButton<int>(
        child: Container(
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: const EdgeInsets.only(left: BUTTON_PADDING, right: BUTTON_PADDING),
              child: STab(text: L10n.ofValue().addNew, icon: Icon(Icons.add_circle, color: Colors.blue,)),
            )
        ),
        onSelected: (value) {
          switch(value) {
            case SCalendar.TYPE_EVENT:
              _onShowAddEventDialog();
              break;
            case SCalendar.TYPE_TRAVELING:
              break;
            case SCalendar.TYPE_HOLIDAY:
              _showHoliday();
              break;
          }

          setState(() {

          });
        },
        itemBuilder: (context) => [
          PopupMenuItem<int>(
            value: SCalendar.TYPE_EVENT,
            child: SText(L10n.ofValue().event),
          ),
          PopupMenuItem<int>(
            value: SCalendar.TYPE_HOLIDAY,
            child: SText(L10n.ofValue().holiday),
          ),
          PopupMenuItem<int>(
            value: SCalendar.TYPE_TRAVELING,
            child: SText(L10n.ofValue().traveling),
          ),

        ]
    );
  }

  void _showHoliday() {
    Navigator.push(context,
      MaterialPageRoute(builder: (context) =>
          HolidayUI(
            icon: FontAwesomeIcons.umbrella,
          )
      ),
    ).then((onValue) async{

    });
  }
  void _onShowAddEventDialog() {
    showDialog (
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return EventUI(title: L10n.ofValue().addEvent);
      },
    ).then((value){
      if (value != null) {
        _loadData(_currentDateTime);
      }
    });
  }

  void _updateCurrentDateTime(DateTime newDateTime) {
    _currentDateTime = newDateTime;
    setState(() {
    });
  }

  Widget _buildBody() {
    switch (_currentViewType) {
      case ViewType.year:
        return YearView(
          updateCurrentDateTimeCallback: _updateCurrentDateTime,
          prevDateTime: _currentDateTime,
          showMonthCallback: _showMonth,
          monthBloc: _monthBloc,
          setTitleCallback: setTitle,
          getSelectedEmpIdCallback: _getSelectedEmpId,
          changeToggleIconCallback: _changeToggleIcon,
          prefs: _prefs,
        );
        break;
      case ViewType.month:
        return MonthView(
          updateCurrentDateTimeCallback: _updateCurrentDateTime,
          prevDateTime: _currentDateTime,
          showDayCallback: _showDay,
          monthBloc: _monthBloc,
          setTitleCallback: setTitle,
          getSelectedEmpIdCallback: _getSelectedEmpId,
          changeToggleIconCallback: _changeToggleIcon,
          prefs: _prefs,
        );
        break;
      case ViewType.week:
        return WeekView(
          updateCurrentDateTimeCallback: _updateCurrentDateTime,
          prevDateTime: _currentDateTime,
          monthBloc: _monthBloc,
          setTitleCallback: setTitle,
          showDayCallback: _showDayAndHour,
          getSelectedEmpIdCallback: _getSelectedEmpId,
          changeToggleIconCallback: _changeToggleIcon,
          prefs: _prefs,
        );
        break;
      case ViewType.day:
        return DayView(
          updateCurrentDateTimeCallback: _updateCurrentDateTime,
          prevDateTime: _currentDateTime,
          dayBloc: _dayBloc,
          setTitleCallback: setTitle,
          getSelectedEmpIdCallback: _getSelectedEmpId,
          prefs: _prefs,
          changeToggleIconCallback: _changeToggleIcon,
        );
        break;
    }
    return Container();
  }

  void setTitle(String title) {
    _selectedEmpName = GlobalData.getEmpName(_selectedEmpId);
    _titleStreamController.sink.add(title??'');
  }


  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(SUB_APP_BAR_HEIGHT),
      child: Container(
        padding: EdgeInsets.all(5),
        child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                TableCell(
                  child: Row(
                    children: <Widget>[
                      _currentViewType != ViewType.year ? Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                              onTap: (){
                                _onBack();
                              },
                              child: Icon(Icons.arrow_back)
                          )
                      ) : Container(),
                      Container(
                        child: SText('    ' + _selectedEmpName, style: TextStyle(fontWeight: FontWeight.bold),)
                      ),
                      StreamBuilder(
                        stream: _titleStreamController.stream,
                        builder: (context, snapshot){
                          if(snapshot.hasData)
                            return SText('  -   ' + snapshot.data?.toString(), style: TextStyle(fontSize: 14, color: Colors.orange));
                          else
                            return SText('');
                        },
                      ),
                    ],
                  ),
                ),
              ]
            ),
            TableRow(
                children: [
                  TableCell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Spacer(),
                        _buildAddEventPopup(),
                        InkWell(
                          child: Padding(
                              padding: EdgeInsets.only(left: BUTTON_PADDING, right: BUTTON_PADDING),
                              child: StreamBuilder<IconData>(
                                stream: viewModeIconStreamController.stream,
                                builder: (context, snapshot) {
                                  return STab(text: L10n.ofValue().mode, icon: Icon(snapshot.data??Icons.view_comfy, color: Colors.black,));
                                }
                              )
                          ),
                          onTap: _onToggleGraphAndAgenda,
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(left: BUTTON_PADDING, right: BUTTON_PADDING),
                            child: STab(icon: Icon(Icons.filter_list,), text: L10n.ofValue().filter),
                          ),
                          onTap: _onFilter,
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(left: BUTTON_PADDING, right: BUTTON_PADDING),
                            child: STab(icon: Icon(Icons.filter_center_focus, color: Colors.red,), text: L10n.ofValue().today),
                          ),
                          onTap: _onToday,
                        ),
                        _buildViewPopupMenu(),
                      ],
                    ),
                  ),
                ]
            )
          ],
        ),
      )
    );
  }

  void _onFilter() {
    showDialog (
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return FilterUI();
      },
    ).then((value){
      if(value != null) {
        _selectedEmpId = value.item1;
        _selectedEmpName = GlobalData.getEmpName(_selectedEmpId);
        filterEventTypes = value.item2;

        switch (_currentViewType) {
          case ViewType.year:
            YearView.yearViewState.filter(selectedEmp: value.item1, events: value.item2);
            break;
          case ViewType.month:
            MonthView.monthViewState.filter(selectedEmp: value.item1, events: value.item2);
            break;
          case ViewType.week:
            WeekView.weekViewState.filter(selectedEmp: value.item1, events: value.item2);
            break;
          case ViewType.day:
            DayView.dayViewState.filter(selectedEmp: value.item1, events: value.item2);
            break;
          default:
            break;
        }
        setState(() {
        });
      }
    });
  }

  void _onBack() {
    switch (_currentViewType) {
      case ViewType.month:
        _currentViewType = ViewType.year;
        break;
      case ViewType.week:
        _currentViewType = ViewType.month;
        break;
      case ViewType.day:
//        _currentViewType = ViewType.month;
        _currentViewType = ViewType.week;
        break;
      default:
        break;
    }
    setState(() {
    });
  }

  void _changeToggleIcon(bool graphMode) {
    if (graphMode)
      viewModeIconStreamController.sink.add(Icons.view_comfy);
    else
      viewModeIconStreamController.sink.add(Icons.format_list_bulleted);
  }

  void _onToggleGraphAndAgenda() {
    switch (_currentViewType) {
      case ViewType.year:
        YearView.yearViewState.toggleGraphAndAgenda();
        break;
      case ViewType.month:
        MonthView.monthViewState.toggleGraphAndAgenda();
        break;
      case ViewType.week:
        WeekView.weekViewState.toggleGraphAndAgenda();
        break;
      case ViewType.day:
        DayView.dayViewState.toggleGraphAndAgenda();
        break;
    }
    setState(() {
    });
  }

  void _onToday() {
    _currentDateTime = DateTime.now();
    _loadData(_currentDateTime);
  }

  void _loadData(DateTime date) {
    switch (_currentViewType) {
      case ViewType.year:
        YearView.yearViewState.loadData(date);
        break;
      case ViewType.month:
        MonthView.monthViewState.loadData(date);
        break;
      case ViewType.week:
        WeekView.weekViewState.loadData(date);
        break;
      case ViewType.day:
        DayViewState.loadData(date);
        break;
    }
  }

  void _showMonth(int month) {
    _currentDateTime = DateTime(_currentDateTime.year, month, _currentDateTime.day);
    _currentViewType = ViewType.month;
    setState(() {
    });
  }

  void _showDay(int day) {
    _currentDateTime = DateTime(_currentDateTime.year, _currentDateTime.month, day);
    _currentViewType = ViewType.day;
    setState(() {
    });
  }

  void _showDayAndHour(int day, int hour) {
    ///TODO
    _currentDateTime = DateTime(_currentDateTime.year, _currentDateTime.month, day);
    _currentViewType = ViewType.day;
    setState(() {
    });
  }

  Widget _buildViewPopupMenu() {
    return PopupMenuButton<ViewType>(
      child: Container(
        alignment: AlignmentDirectional.center,
        child: Padding(
          padding: const EdgeInsets.only(left: BUTTON_PADDING, right: BUTTON_PADDING),
          child: STab(text: L10n.ofValue().view, icon: Icon(Icons.arrow_drop_down_circle, color: Colors.orange,)),
        )
      ),
      onSelected: (ViewType viewType) async {
        _currentViewType = viewType;
        await _prefs.setInt("calendar.viewBy", viewType.index);
        setState(() {
        });
      },
      itemBuilder: (context) => [
        PopupMenuItem<ViewType>(
          value: ViewType.year,
          child: SText(L10n.of(context).year),
        ),
        PopupMenuItem<ViewType>(
          value: ViewType.month,
          child: SText(L10n.of(context).month),
        ),
        PopupMenuItem<ViewType>(
          value: ViewType.week,
          child: SText(L10n.of(context).week),
        ),
        PopupMenuItem<ViewType>(
          value: ViewType.day,
          child: SText(L10n.of(context).day),
        ),
      ]
    );
  }
}