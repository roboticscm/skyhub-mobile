import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/calendar/cal_util.dart';
import 'package:mobile/modules/calendar/day/day_api.dart';
import 'package:mobile/modules/calendar/scalendar.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/widgets/particular/constants.dart';
import 'package:mobile/widgets/particular/sclose_button.dart';
import 'package:mobile/widgets/particular/sdelete_button.dart';
import 'package:mobile/widgets/particular/ssave_button.dart';
import 'package:mobile/widgets/scheckbox.dart';
import 'package:mobile/widgets/scontainer.dart';
import 'package:mobile/widgets/sflat_button.dart';
import 'package:mobile/widgets/sdialog.dart';
import 'package:mobile/widgets/sradio.dart';
import 'package:mobile/widgets/stext.dart';
import 'package:mobile/widgets/stext_form_field.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:toast/toast.dart';

import '../model.dart';

class EventUI extends StatefulWidget{
  final DateTime startDateSuggested;
  final String title;
  final ScheduleView scheduleView;
  EventUI({this.title, this.scheduleView,  this.startDateSuggested});

  @override
  _EventUIState createState() => _EventUIState();
}

class _EventUIState extends State<EventUI> {
  String get _title => widget.title;
  ScheduleView _scheduleView;
  DateTime get _startDateSuggested => widget.startDateSuggested;
  int _currentEventType = SCalendar.TYPE_EVENT;
  Status _currentStatus = Status.busy;

  bool _checkedAllDay = false;
  bool _checkedNotice = true;
  DateTime _startDate;
  DateTime _endDate;
  DateTime _noticeTime;
  int _currentRemindTimeUnit = SCalendar.REMIND_TIME_UNIT_MINUTE;
  var _locationTextController = TextEditingController();
  var _titleTextController = TextEditingController();
  var _descriptionTextController = TextEditingController();
  var _noticeBeforeTimeAmountTextController = TextEditingController(text: '1');
  var _titleFocus = FocusNode();
  var _startDateFocus = FocusNode();
  var _endDateFocus = FocusNode();
  var _noticeBeforeTimeAmountFocus = FocusNode();
  final _formats = {
    InputType.both: DateFormat.yMd().add_Hm(),
    InputType.date: DateFormat.yMd(),
  };
  InputType _inputType = InputType.both;
  DayAPI _dayAPI = DayAPI();
  bool _enableAllWidget = true;
  @override
  void initState() {
    super.initState();
    _scheduleView = widget.scheduleView;
    if(_scheduleView != null) {//edit mode
      _currentEventType = _scheduleView.eventType;
      _titleTextController.text = _scheduleView.title;
      if (CalUtil.dateDiffWithoutTime(_scheduleView.endDate, _scheduleView.startDate) == 0)
        _checkedAllDay = _scheduleView.allDay==1;

      _startDate = _scheduleView.startDate;
      _endDate = _scheduleView.endDate;
      _locationTextController.text = _scheduleView.location;
      _descriptionTextController.text = _scheduleView.description;
      _currentStatus = CalUtil.getStatusEnum(_scheduleView.showMeAs);

      _noticeTime = _scheduleView.notifyTime;
      _noticeBeforeTimeAmountTextController.text = _scheduleView.remindTimeQty!=null ? _scheduleView.remindTimeQty.toString() : '';
      _currentRemindTimeUnit = _scheduleView.remindTimeUnit;
      _checkedNotice = _scheduleView.remindTimeQty!=null;

      if(_scheduleView.empId != GlobalParam.EMPLOYEE_ID)
        _enableAllWidget = false;

    } else { //new mode
      if(_startDateSuggested != null ) {
        _startDate = _startDateSuggested;
      } else {
        _startDate = DateTime.now().add(Duration(hours: 1));
      }
      _endDate = _startDate.add(Duration(hours: 1));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _onAfterBuild(context));
  }

  void _onAfterBuild(BuildContext context){
    FocusScope.of(context).requestFocus(_titleFocus);
  }

  bool _validateInput() {
    if (_titleTextController.text.trim().length == 0) {
      FocusScope.of(context).requestFocus(_titleFocus);
      Toast.show(L10n.ofValue().youMustEnterTheTitle, context, gravity: Toast.CENTER);

      return false;
    }

    if (_startDate == null) {
      //FocusScope.of(context).requestFocus(_startDateFocus);
      Toast.show(L10n.ofValue().youMustEnterTheFromDateTime, context, gravity: Toast.CENTER);
      return false;
    }

    if (_endDate == null) {
      //FocusScope.of(context).requestFocus(_endDateFocus);
      Toast.show(L10n.ofValue().youMustEnterTheToDateTime, context, gravity: Toast.CENTER);
      return false;
    }

    if (_checkedAllDay) {
      if (_endDate.difference(_startDate).inDays < 0) {
        FocusScope.of(context).requestFocus(_endDateFocus);
        Toast.show(L10n.ofValue().fromDateTimeMustBeLessThanToDateTime, context, gravity: Toast.CENTER);
        return false;
      }

    } else {
      if (_endDate.difference(_startDate).inMinutes < 1) {
        FocusScope.of(context).requestFocus(_endDateFocus);
        Toast.show(L10n.ofValue().fromDateTimeMustBeLessThanToDateTime, context, gravity: Toast.CENTER);
        return false;
      }
    }

    if (_checkedNotice) {
      if (_noticeBeforeTimeAmountTextController.text.length == 0) {
        FocusScope.of(context).requestFocus(_noticeBeforeTimeAmountFocus);
        Toast.show(L10n.ofValue().valueOfTimeMustGreaterThanZero, context, gravity: Toast.CENTER);
        return false;
      }

      var beforeTimeAmount = int.parse(_noticeBeforeTimeAmountTextController.text);
      if (beforeTimeAmount < 1) {
        FocusScope.of(context).requestFocus(_noticeBeforeTimeAmountFocus);
        Toast.show(L10n.ofValue().valueOfTimeMustGreaterThanZero, context, gravity: Toast.CENTER);
        return false;
      }

      if (_checkedAllDay && _noticeTime == null) {
        Toast.show(L10n.ofValue().youMustEnterNoticeTime, context, gravity: Toast.CENTER);
        return false;
      }
    }

    return true;
  }
  @override
  Widget build(BuildContext context) {
    return SDialog(
      contentPadding: EdgeInsets.all(0),
      title: SText(_title),
      content: AbsorbPointer(
        absorbing: !_enableAllWidget,
        child: SingleChildScrollView(child: _buildBody())
      ),
      actions: <Widget>[
        Container(
          width: Util.getScreenWidth()-BUTTON_PADDING*3,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (_scheduleView != null && _scheduleView.empId == GlobalParam.EMPLOYEE_ID)
                SDeleteButton(onTap: () async {
                  var buttonPressed = await SDialog.confirm("Calendar", '${L10n.ofValue().doYouWantToDelete} - ${_titleTextController.text.trim()}?');

                  if(buttonPressed == DialogButton.no) return;

                  var result = await _dayAPI.deleteSchedule(_scheduleView);
                  if(result.item1 != null ) {
                    SCalendar.checkNotify();
                    Navigator.of(context).pop(result.item1);
                  } else{

                    Toast.show(result.item2, context, duration: 3);
                  }
                }),
              Spacer(),
              SCloseButton(),
              if(_scheduleView == null || _scheduleView.empId == GlobalParam.EMPLOYEE_ID)
                SSaveButton(
                  onTap: () async {
                    if(!_validateInput()) return;
                    if (_scheduleView == null) { // save
                      _scheduleView = ScheduleView(
                        empId: GlobalParam.EMPLOYEE_ID,
                      );
                    }
                    _scheduleView.eventType = _currentEventType;
                    _scheduleView.title = _titleTextController.text.trim();
                    _scheduleView.allDay = _checkedAllDay ? 1 : 0;
                    _scheduleView.startDate = _startDate;
                    _scheduleView.endDate = _endDate;
                    _scheduleView.location = _locationTextController.text.trim();
                    _scheduleView.description = _descriptionTextController.text.trim();
                    if (_checkedNotice) {
                      _scheduleView.remindTimeQty = int.parse( _noticeBeforeTimeAmountTextController.text);
                      _scheduleView.remindTimeUnit = _currentRemindTimeUnit;
                      if(_checkedAllDay) {
                        var now = DateTime.now();
                        _scheduleView.remindTime = DateTime(now.year, now.month, now.day, _noticeTime.hour, _noticeTime.minute);
                      } else {
                        _scheduleView.remindTime = null;
                      }
                      _scheduleView.notifyTime = _calcNotifyDateTime(_scheduleView.startDate, _scheduleView.remindTimeQty, _scheduleView.remindTimeUnit, _scheduleView.remindTime);
                    } else {
                      _scheduleView.remindTimeQty = null;
                      _scheduleView.remindTimeUnit = null;
                      _scheduleView.remindTime = null;
                      _scheduleView.notifyTime = null;
                    }
                    _scheduleView.showMeAs = CalUtil.getStatusNum(_currentStatus);

                    var result = await _dayAPI.saveOrUpdateSchedule(_scheduleView);
                    if(result.item1 != null ) {
                      SCalendar.checkNotify();
                      Navigator.of(context).pop(result.item1);
                    } else{
                      print(result.item2);
                      Toast.show(result.item2, context, duration: 3);
                    }
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  DateTime _calcNotifyDateTime(DateTime startDate, int beforeAmount, int remindTimeInMinute, DateTime atTime) {
    if (_checkedAllDay && atTime != null) {
      var tempDate = startDate.subtract(Duration(minutes: beforeAmount*remindTimeInMinute));
      return DateTime(tempDate.year, tempDate.month, tempDate.day, atTime.hour, atTime.minute);
    } else {
      return startDate.subtract(Duration(minutes: beforeAmount*remindTimeInMinute));
    }
  }

  Widget _buildBody() {
    return SContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if(_scheduleView != null)
            SText(_scheduleView.empName??'', style: TextStyle(color: Colors.grey),),
          _buildEventType(),
          STextFormField(
            enabled: _enableAllWidget,
            focusNode: _enableAllWidget ? _titleFocus : null,
            controller: _titleTextController,
            decoration: InputDecoration(
              labelText: L10n.ofValue().title
            )
          ),
          Row(
            children: <Widget>[
              SCheckbox(
                useTapTarget: false,
                value: _checkedAllDay,
                onChanged: (value) {
                  setState(() {
                    _checkedAllDay = value;
                    if (value) {
                      _currentRemindTimeUnit = SCalendar.REMIND_TIME_UNIT_DAY;
                      _inputType = InputType.date;
                    } else {
                      _currentRemindTimeUnit = SCalendar.REMIND_TIME_UNIT_MINUTE;
                      _inputType = InputType.both;
                    }

                  });
                },
              ),
              SText(L10n.ofValue().allDay),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: DateTimePickerFormField(
                  focusNode: _startDateFocus,
                  inputType: _inputType,
                  initialValue: _startDate,
                  format: _formats[_inputType],
                  editable: true,
                  decoration: InputDecoration(
                      labelText: L10n.ofValue().fromDateTime, hasFloatingPlaceholder: false),
                  onChanged: (dt) {
                    _startDate = dt;
                  },
                ),
              ),
              SizedBox(child: Container(), width: 10,),
              Flexible(
                child: DateTimePickerFormField(
                  focusNode: _endDateFocus,
                  inputType: _inputType,
                  initialValue: _endDate,
                  format: _formats[_inputType],
                  editable: true,
                  decoration: InputDecoration(
                      labelText: L10n.ofValue().toDateTime, hasFloatingPlaceholder: false),
                  onChanged: (dt) {
                    _endDate = dt;
                  },
                ),
              )
            ],
          )

          ,
          STextFormField(
            controller: _locationTextController,
            decoration: InputDecoration(
                labelText: L10n.ofValue().location
            )
          ),
          STextFormField(
            controller: _descriptionTextController,
            decoration: InputDecoration(
                labelText: L10n.ofValue().notes
            )
          ),
          if (_checkedAllDay)
            _buildAllDayNotice()
          else
            _buildNotice(),
          _buildStatus(),

        ],
      ),
    );
  }

  Widget _buildStatus() {
    return Row(
      children: <Widget>[
        SText(L10n.ofValue().status + ": "),
        SRadio(
          value: Status.busy,
          groupValue: _currentStatus,
          onChanged: (value){
            setState(() {
              _currentStatus = value;
            });
          },
        ),
        SText(L10n.ofValue().busy),
        SRadio(
          value: Status.idle,
          groupValue: _currentStatus,
          onChanged: (value){
            setState(() {
              _currentStatus = value;
            });
          },
        ),
        SText(L10n.ofValue().idle),
      ],
    );
  }


  Widget _buildNotice() {
    return Row(
      children: <Widget>[
        SCheckbox(
          value: _checkedNotice,
          onChanged: (value) {
            setState(() {
              _checkedNotice = value;
            });
          },
        ),
        SText(L10n.ofValue().notice),
        SizedBox(
          width: 10,
        ),
        Visibility(
          visible: _checkedNotice,
          child: Flexible(
            child: Container(
              width: 20,
              child: STextFormField(
                controller: _noticeBeforeTimeAmountTextController,
                keyboardType: TextInputType.number,
              )
            ),
          ),
        ),
        Visibility(
          visible: _checkedNotice,
          child: _buildRemindTypeUnitPopup()
        ),
      ],
    );
  }

  Widget _buildRemindTypeUnitPopup() {
    return DropdownButton(
        onChanged: (value) {
          if (!mounted) return;
          setState(() {
            _currentRemindTimeUnit = value;
          });
        },
        value: _currentRemindTimeUnit,
        items: [
          DropdownMenuItem(
            child: Text(_getRemindTimeUnit(SCalendar.REMIND_TIME_UNIT_MINUTE)),
            value: SCalendar.REMIND_TIME_UNIT_MINUTE,
          ),
          DropdownMenuItem(
            child: Text(_getRemindTimeUnit(SCalendar.REMIND_TIME_UNIT_HOURS)),
            value: SCalendar.REMIND_TIME_UNIT_HOURS,
          ),
          DropdownMenuItem(
            child: Text(_getRemindTimeUnit(SCalendar.REMIND_TIME_UNIT_DAY)),
            value: SCalendar.REMIND_TIME_UNIT_DAY,
          ),
          DropdownMenuItem(
            child: Text(_getRemindTimeUnit(SCalendar.REMIND_TIME_UNIT_WEEK)),
            value: SCalendar.REMIND_TIME_UNIT_WEEK,
          ),
        ]
    );
  }

  Widget _buildAllDayRemindTypeUnitPopup() {
    return DropdownButton(
        onChanged: (value) {
          if (!mounted) return;
          setState(() {
            print(value);
            _currentRemindTimeUnit = value;
          });
        },
        value: _currentRemindTimeUnit,
        items: [
          DropdownMenuItem(
            child: Text(_getRemindTimeUnit(SCalendar.REMIND_TIME_UNIT_DAY)),
            value: SCalendar.REMIND_TIME_UNIT_DAY,
          ),
          DropdownMenuItem(
            child: Text(_getRemindTimeUnit(SCalendar.REMIND_TIME_UNIT_WEEK)),
            value: SCalendar.REMIND_TIME_UNIT_WEEK,
          ),
        ]
    );
  }
  String _getRemindTimeUnit(int typeUnit) {
    switch (typeUnit){
      case SCalendar.REMIND_TIME_UNIT_MINUTE:
        return L10n.ofValue().minute;
      case SCalendar.REMIND_TIME_UNIT_HOURS:
        return L10n.ofValue().hour;
      case SCalendar.REMIND_TIME_UNIT_DAY:
        return L10n.ofValue().day;
      case SCalendar.REMIND_TIME_UNIT_WEEK:
        return L10n.ofValue().week;
    }
    return '';
  }

  Widget _buildAllDayNotice() {
    return Row(
      children: <Widget>[
        SCheckbox(
          value: _checkedNotice,
          onChanged: (value) {
            setState(() {
              _checkedNotice = value;
            });
          },
        ),
        SText(L10n.ofValue().notice),
        SizedBox(
          width: 10,
        ),
        Visibility(
          visible: _checkedNotice,
          child: Flexible(
            child: Container(
                width: 20,
                child: STextFormField(
                  controller: _noticeBeforeTimeAmountTextController,
                  keyboardType: TextInputType.number,
                )
            ),
          ),
        ),
        Visibility(visible: _checkedNotice, child: _buildAllDayRemindTypeUnitPopup()),
        Visibility(visible: _checkedNotice, child: SText(L10n.ofValue().at)),
        SizedBox(
          width: 10,
        ),
        Visibility(
          visible: _checkedNotice,
          child: Flexible(
            child: Container(
              child: DateTimePickerFormField(
                focusNode: _noticeBeforeTimeAmountFocus,
                initialValue: _noticeTime,
                inputType: InputType.time,
                format: DateFormat.Hm(),
                editable: true,
                onChanged: (dt) {
                  _noticeTime = dt;
                },
              ),
            ),
          ),
        )
      ],
    );
  }
  Widget _buildEventType() {
    return Row(
      children: <Widget>[
        SRadio(
          value: SCalendar.TYPE_EVENT,
          groupValue: _currentEventType,
          onChanged: _onEventTypeChanged,
          activeColor: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_EVENT),
        ),
        SText(L10n.ofValue().event, style: TextStyle(fontSize: 13, color: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_EVENT)),),
        SRadio(
          value: SCalendar.TYPE_MEETING,
          groupValue: _currentEventType,
          onChanged: _onEventTypeChanged,
          activeColor: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_MEETING),
        ),
        SText(L10n.ofValue().meetings, style: TextStyle(fontSize: 13,color: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_MEETING))),
        SRadio(
          value: SCalendar.TYPE_TASK,
          groupValue: _currentEventType,
          onChanged: _onEventTypeChanged,
          activeColor: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_TASK),
        ),
        SText(L10n.ofValue().task, style: TextStyle(fontSize: 13,color: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_TASK))),
        SRadio(
          value: SCalendar.TYPE_REMINDER,
          groupValue: _currentEventType,
          onChanged: _onEventTypeChanged,
          activeColor: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_REMINDER),
        ),
        SText(L10n.ofValue().reminder, style: TextStyle(fontSize: 13,color: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_REMINDER))),
      ],
    );
  }

  void _onEventTypeChanged(int value) {
    if(!mounted) return;

    setState(() {
      _currentEventType = value;
    });
  }
}