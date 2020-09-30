import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/tuple.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/calendar/cal_util.dart';
import 'package:mobile/modules/calendar/day/day_bloc.dart';
import 'package:mobile/modules/calendar/day/day_calendar_painter.dart';
import 'package:mobile/modules/calendar/day/day_event.dart';
import 'package:mobile/modules/calendar/day/day_state.dart';
import 'package:mobile/modules/calendar/event/event_ui.dart';
import 'package:mobile/modules/calendar/filter/filter_ui.dart';
import 'package:mobile/modules/calendar/model.dart';
import 'package:mobile/modules/calendar/scalendar.dart';
import 'package:mobile/modules/office/holiday/details/holiday_details_ui.dart';
import 'package:mobile/modules/office/holiday/holiday_api.dart';
import 'package:mobile/modules/user_business/user_business_list_api.dart';
import 'package:mobile/modules/user_business/user_business_model.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/widgets/scircular_progress_indicator.dart';
import 'package:mobile/widgets/stext.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class DayView extends StatefulWidget {
  final Function updateCurrentDateTimeCallback;
  final Function setTitleCallback;
  final Function changeToggleIconCallback;
  final DateTime prevDateTime;
  final Function getSelectedEmpIdCallback;
  final DayBloc  dayBloc;
  final SharedPreferences prefs;
  static DayViewState dayViewState;
  DayView({
    this.updateCurrentDateTimeCallback,
    this.getSelectedEmpIdCallback,
    this.changeToggleIconCallback,
    this.setTitleCallback,
    this.prevDateTime,
    this.prefs,
    this.dayBloc,
  });

  @override
  DayViewState createState() {
    dayViewState = DayViewState();
    return dayViewState;
  }
}

class DayViewState extends State<DayView> {
  static const double ROW_HEIGHT = 25;
  static const int MAX_VIEW_ROW = 3;

  PageController _pageController;
  get _updateCurrentDateTimeCallback => widget.updateCurrentDateTimeCallback;
  DateTime get _prevDateTime => widget.prevDateTime;
  static DateTime _currentDateTime;
  static DayBloc _dayBloc;
  static HolidayAPI _holidayAPI = HolidayAPI();
  int _startIndex = (DateTime.now().year - SCalendar.BEGIN_YEAR)*12*365;
  int _scheduleItemId = -1;
  List<int> _events;
  List<ScheduleView> _list;
  List<ScheduleView> _filteredList;
  List<ScheduleView> _filteredWithoutAllDayList;
  List<ScheduleView> _allDayFilteredList;

  ScrollController _scrollController;
  bool _graphMode;
  StreamController<Tuple2<int, List<ScheduleView>>> _invisibleItemStreamController = StreamController.broadcast();
  static UserBusiness _userBusiness;
  List<int> _excludeScheduleItemIds;
  Offset _currentOffset;
  @override
  void initState() {
    super.initState();
    _dayBloc = widget.dayBloc;
    _pageController = PageController(initialPage: _startIndex);
    _scrollController = ScrollController(initialScrollOffset: 310);
    _currentDateTime = _prevDateTime;
    _graphMode =  widget.prefs.getBool("calendar.dayView.graphMode") ?? true;
    widget.changeToggleIconCallback(_graphMode);
    _events = SCalendar.calendarState.filterEventTypes;
    _loadDataControl();
    loadData(_currentDateTime);
  }

  Future<void> _loadDataControl() async {
    _userBusiness =
    await UserBusinessListAPI().getUserBusinessWithUserIdAndBusiness(
        userId: GlobalParam.getUserId(), business: "hrm41");
  }

  static void loadData(DateTime dateTime) {
    _currentDateTime = dateTime;
    _dayBloc.dispatch(OnDayLoad(
      date: dateTime
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DayEvent, DayState>(
      bloc: _dayBloc,
      builder: (BuildContext context, DayState state) {
        if (state is DayFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: SText(state.error),
                backgroundColor: Colors.red,
              ),
            );
          });
        }
        if (state is DayLoading) {
          _list = state.list;
          _filter();
        }

        return state is DayLoading  ? _buildUI() : SCircularProgressIndicator.buildSmallCenter();
      },
    );
  }


  void _filter() {
    if (_list == null) {
      _filteredList = null;
      _allDayFilteredList = null;
      _filteredWithoutAllDayList = null;
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

    _allDayFilteredList = List.from(_filteredList.where((item) => item.allDay == 1));
    _filteredWithoutAllDayList = List.from(_filteredList.where((item) => item.allDay != 1));

    _setTitle(_filteredList?.length??0);
  }

  void _setTitle(int count) {
    String title = '${CalUtil.getWeekDayName(_currentDateTime.weekday)} - ${DateFormat.yMd().format(_currentDateTime)}';

    title += ' (${Util.getLunarDateStringTuple(Util.convertToLunarDate(_currentDateTime))})';

    if(count > 0)
     title += ' - ($count)';

    widget.setTitleCallback(title);
  }

  Widget _buildFloatingButton(int count, List<ScheduleView> invisibleList) {
    return PopupMenuButton(
      child: CircleAvatar(
        child: Text('+$count', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.red,
        radius: 25,
      ),
        onSelected: (ScheduleView s) {
          switch (s.eventType) {
            case SCalendar.TYPE_HOLIDAY:
              showEditHolidayDialog(context, s);
              break;
            default:
              showEditEventDialog(context, s);
              break;
          }

        },
        itemBuilder: (context) => [
          for(var i = 0; i < invisibleList.length; i++)
            PopupMenuItem<ScheduleView>(
              value: invisibleList[i],
              child: Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: SText(getPopupItemTitle(invisibleList[i]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
                decoration: BoxDecoration(
                    color: CalUtil.getBackgroundColorByEventType(invisibleList[i].eventType)
                ),
              ),
            ),
        ]
    );
  }

  void _drawInvisibleItem(int count, List<ScheduleView> invisibleList){
    _invisibleItemStreamController.sink.add(Tuple2(count, invisibleList));
  }

  @override
  void dispose() {
    super.dispose();
    _invisibleItemStreamController.close();
  }

  Widget _buildUI() {
    return _graphMode ?
      StreamBuilder<Tuple2<int, List<ScheduleView>>>(
        stream: _invisibleItemStreamController.stream,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return Scaffold(
              floatingActionButton: snapshot.data.item1 > 0 ? _buildFloatingButton(snapshot.data.item1, snapshot.data.item2) : Container(),
              appBar: _buildAppBar(),
              body: _graphPageViewBuilder(),
            );
          } else {
            return Scaffold(
              appBar: _buildAppBar(),
              body: _graphPageViewBuilder(),
            );
          }
        },
      ) : Scaffold(body: _agendaPageViewBuilder());
  }

  Widget _agendaPageViewBuilder() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        _updateCurrentDate(index);
      },
      itemBuilder: (BuildContext context, int index) {
        return _buildDayAgenda();
      }
    );
  }
  Widget _graphPageViewBuilder() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        _updateCurrentDate(index);
      },
      itemBuilder: (BuildContext context, int index) {
        return SingleChildScrollView(
          controller: _scrollController,
          child: _dayCalendarPaint(_currentDateTime.day),
        );
      }
    );
  }
  Widget _buildDayAgenda() {
    if ((_filteredList?.length??0) == 0)
      return Container(margin: EdgeInsets.only(top: 10), alignment: Alignment.topCenter, child: Text(L10n.ofValue().noDataFound));
    return ListView.builder(
      itemBuilder: (BuildContext context, int index){
        return buildDayAgendaItem(context, null, _filteredList[index], _filteredList.length-1 == index);
      },
    itemCount: _filteredList?.length??0,
    );
  }

  static Widget buildDayAgendaItem(BuildContext context, DateTime date, ScheduleView s, bool isLastItem) {
    return InkWell(
      onTap: () {
        switch (s.eventType) {
          case SCalendar.TYPE_HOLIDAY:
            showEditHolidayDialog(context,s);
            break;
          default:
            showEditEventDialog(context, s);
            break;
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
          border: isLastItem ? null : Border(
            bottom: BorderSide(
              color: Color.fromRGBO(0, 0, 0, 1),
              width: 0.2
            )
          )
        ),
        height: 60,
        child: Tooltip(
          message: CalUtil.getEventTypeName(s.eventType),
          child: Row(children: [
            Container(
              height: 40,
              width: 70,
              padding: EdgeInsets.only(left: 3, right: 3),
              decoration: BoxDecoration(
                color: CalUtil.getBackgroundColorByEventType(s.eventType),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SText(
                    _getTime(date, s),
                    style: TextStyle(
                      fontSize: 10,
                      color: CalUtil.getOpposingColor(CalUtil.getBackgroundColorByEventType(s.eventType))
                    ),
                  ),

                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if ( s.empId != GlobalParam.EMPLOYEE_ID)
                      Flexible(
                        child: Text(
                          s.empName??'',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey
                          ),
                        ),
                      ),
                    Flexible(
                      child: Text(s.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                    Flexible(
                      child: SText(s.location??'',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blueGrey),
                      )
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 30,
              child: IconButton(
                icon: Icon(Icons.notification_important, size: 20, color: _getNotifyColorState(s)),
              ),
            ),
          ]
      ),
        )),
    );
  }

  static Color _getNotifyColorState(ScheduleView s) {
    var ret = DateTime.now().compareTo(s.endDate);
    if(ret <= 0)
      return Colors.red;
    else
      return Colors.grey;
  }

  static String _getTime(DateTime currentDate, ScheduleView s) {
    if ((s?.allDay??1) == 1 || (currentDate !=null && currentDate.difference(s.startDate).inDays > 0))
      return L10n.ofValue().allDay;
    else
      return '${Util.getTimeStr(s.startDate)} - ${Util.getTimeStr(s.endDate)}';
  }

  Widget _buildAppBar(){
    var allDayEvents = _allDayFilteredList?.length??0;
    if (allDayEvents ==0 )
      return null;

    return PreferredSize(
      preferredSize: Size(double.infinity, ROW_HEIGHT*min(allDayEvents, MAX_VIEW_ROW)),
      child: Container(
        color: Colors.black12,
        child: Row(
          children: <Widget>[
            Text('  ${L10n.ofValue().allDay}  '),
            Flexible(
              child: Container(
                child: _buildAllDayEvent(allDayEvents)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllDayEvent(int count) {
    var maxViewRow = min (count, MAX_VIEW_ROW);
    _excludeScheduleItemIds = [];
    return Column(
      children: <Widget>[
        for( var i = 0; i < maxViewRow; i++)
          _buildTopDayEvent(_allDayFilteredList[i], i)
      ],
    );
  }

  Widget _buildTopDayEvent(ScheduleView item, int i) {
    var isLastRow = _isLastRow(i);
    if(!isLastRow)
      _excludeScheduleItemIds.add(item.scheduleItemId);

      return InkWell(
      onTap: (){
        var s = CalUtil.findScheduleViewById(_filteredList, item.scheduleItemId);
        switch (s.eventType) {
          case SCalendar.TYPE_HOLIDAY:
            showEditHolidayDialog(context,s);
            break;
          default:
            showEditEventDialog(context, s);
            break;
        }
      },
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        height: ROW_HEIGHT,
        color: isLastRow ? Colors.grey : CalUtil.getBackgroundColorByEventType(item.eventType),
        child: Tooltip(
          message: L10n.ofValue().tapToSeeMore,
          child: (isLastRow) ? _buildMoreEventPopup('+ ${_allDayFilteredList.length - i}...') : Text(
            item.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isLastRow ? Colors.black : CalUtil.getOpposingColor(CalUtil.getBackgroundColorByEventType(item.eventType))
            ),
          ),
        ),
      ),
    );
  }


  bool _isLastRow(int i) {
    if (i < MAX_VIEW_ROW - 1)
      return false;
    else {
      if (MAX_VIEW_ROW == _allDayFilteredList.length)
        return false;
    }
    return true;
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  void onShowAddEventDialog() {
    var suggestHour = (_currentOffset.dy/CAL_ROW_HEIGHT).floor();

    DateTime startDateSuggested = new DateTime(_currentDateTime.year, _currentDateTime.month, _currentDateTime.day, suggestHour);
    showDialog (
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return EventUI(startDateSuggested: startDateSuggested, title: L10n.ofValue().addEvent);
      },
    ).then((value){
      if (value != null) {
        loadData(_currentDateTime);
      }
    });
  }

  static void showEditHolidayDialog(BuildContext context, ScheduleView s) async {
    var ret = await _holidayAPI.findHolidayById(id: s.scheduleItemId);
    if (ret.item1 == null) {
      Toast.show(ret.item2, context);
      return;
    }

    var param = await _holidayAPI.findHolidayParamByEmpId(
        empId: s.empId
    );

    showDialog (
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return HolidayDetailsUI(
          selectedHoliday: ret.item1,
          holidayAPI: _holidayAPI,
          holidayParam: param.item1,
          userBusiness: _userBusiness,
        );
      },
    ).then((editedScheduleView){
      loadData(_currentDateTime);
    });
  }

  static void showEditEventDialog(BuildContext context, ScheduleView s) {
    showDialog (
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return EventUI(scheduleView: s, title: L10n.ofValue().editEvent + " - " + s.title);
      },
    ).then((editedScheduleView){
      if (editedScheduleView != null) {
        loadData(_currentDateTime);
      }
    });
  }

  Widget _buildMoreEventPopup(String title) {
    List<ScheduleView> list = [];

    list = List.from(_allDayFilteredList.where((s){
      return !_excludeScheduleItemIds.contains(s.scheduleItemId);
    }));

    return PopupMenuButton<ScheduleView>(
        child: Container(
            alignment: AlignmentDirectional.center,
            margin: EdgeInsets.only(right: 10),
            child: SText(title, style: TextStyle(fontSize: 14, color: STextStyle.PRIMARY_TEXT_COLOR),)
        ),
        onSelected: (ScheduleView s) {
          switch (s.eventType) {
            case SCalendar.TYPE_HOLIDAY:
              showEditHolidayDialog(context, s);
              break;
            default:
              showEditEventDialog(context, s);
              break;
          }

        },
        itemBuilder: (context) => [
          for(var i = 0; i < list.length; i++)
            PopupMenuItem<ScheduleView>(
              value: list[i],
              child: Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: SText(getPopupItemTitle(list[i]),
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

  static String getPopupItemTitle(ScheduleView item) {
    List<String> list = [];
    if(item.empId != GlobalParam.EMPLOYEE_ID)
      list.add(item.empName);
    if((item.title?.length??0) > 0)
      list.add(item.title);
    if((item.location?.length??0) > 0)
      list.add(item.location);
    if(item.startDate != null)
      list.add(Util.getDateTimeWithoutYearStr(item.startDate));

    return list.join(" - ");
  }

  void _updateCurrentDate(int index) {

    DateTime currentDateTime;
    if(index > _startIndex)
      currentDateTime = DateTime(_currentDateTime.year, _currentDateTime.month, _currentDateTime.day + 1);
    else
      currentDateTime = DateTime(_currentDateTime.year, _currentDateTime.month, _currentDateTime.day - 1);
    _updateCurrentDateTimeCallback(currentDateTime);
    loadData(currentDateTime);
  }

  DayCalendarPainter _dayCalendarPaint(int day) {
    return DayCalendarPainter(
      drawInvisibleItemCallback: _drawInvisibleItem,
      list: _filteredWithoutAllDayList,
      selectedId: _scheduleItemId,
      onTapCallback: (Offset offset){
        _currentOffset = offset;
      },
      onSelected: (id) {
        setState(() {
          _scheduleItemId = id;
        });
        if(id == -1){
          onShowAddEventDialog();
        } else {
          var s = CalUtil.findScheduleViewById(_filteredList, id);
          switch (s.eventType) {
            case SCalendar.TYPE_HOLIDAY:
              showEditHolidayDialog(context, s);
              break;
            default:
              showEditEventDialog(context, s);
              break;
          }

        }
      }
    );
  }

  void toggleGraphAndAgenda () async {
    _graphMode = !_graphMode;
    widget.changeToggleIconCallback(_graphMode);
    setState(() {
    });
    await widget.prefs.setBool("calendar.dayView.graphMode", _graphMode);
  }

  void filter({int selectedEmp, List<int> events}) {
    setState(() {
      _events = events;
    });
  }
}

