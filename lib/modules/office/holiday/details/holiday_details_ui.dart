import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/constant.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/notification/task_approve_submit/task_approve_submit_list_api.dart';
import 'package:mobile/modules/user_business/user_business_list_api.dart';
import 'package:mobile/modules/user_business/user_business_model.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/widgets/data_widget/holiday_type_dropdown.dart';
import 'package:mobile/widgets/particular/approve_button.dart';
import 'package:mobile/widgets/particular/cancel_approve_button.dart';
import 'package:mobile/widgets/particular/cancel_submit_button.dart';
import 'package:mobile/widgets/particular/submit_button.dart';
import 'package:mobile/widgets/sdialog.dart';
import 'package:mobile/widgets/stab.dart';
import 'package:mobile/widgets/stext.dart';
import 'package:intl/intl.dart';
import 'package:mobile/widgets/stext_form_field.dart';
import 'package:toast/toast.dart';
import '../holiday_api.dart';
import '../holiday_model.dart';
import '../holiday_util.dart';

class HolidayDetailsUI extends StatefulWidget {
  HolidayView selectedHoliday;
  HolidayParam holidayParam;
  final HolidayAPI holidayAPI;
  UserBusiness userBusiness;
  HolidayDetailsUI({
    this.selectedHoliday,
    this.holidayParam,
    this.holidayAPI,
    this.userBusiness
  });

  @override
  _HolidayDetailsUIState createState() => _HolidayDetailsUIState();
}

class _HolidayDetailsUIState extends State<HolidayDetailsUI> {
  HolidayView _selectedHoliday;
  HolidayParam _holidayParam;
  HolidayAPI get _holidayAPI => widget.holidayAPI;
  UserBusiness userBusiness;
  final _numberFormatter = NumberFormat("#,###.##");
  DateTime _startDateTime;
  DateTime _endDateTime;
  var _contentFocus = FocusNode();
  var _startDateTimeFocus = FocusNode();
  var _endDateTimeFocus = FocusNode();
  var _contentTextController = TextEditingController();
  var _notesTextController = TextEditingController();
  var _startDateTimeController = TextEditingController();
  var _endDateTimeController = TextEditingController();
  var _currentHolidayType;
  double _totalRemained;
  double _leavesDay;
  bool _enableWidgets = true;
  var _createdDate = DateTime.now();
  var _refNo = '';
  String _saveText;

  @override
  void initState() {
    super.initState();
    _selectedHoliday = widget.selectedHoliday;
    _holidayParam = widget.holidayParam;

    _startDateTimeFocus.addListener((){
      if(!_startDateTimeFocus.hasFocus) {
        setState(() {
          _leavesDay = _calcLeavesDay(_startDateTime, _endDateTime);
        });
      }
    });

    _endDateTimeFocus.addListener((){
      if(!_endDateTimeFocus.hasFocus) {
        setState(() {
          _leavesDay = _calcLeavesDay(_startDateTime, _endDateTime);
        });
      }
    });

    if(_selectedHoliday == null) {
      _resetInput();
    } else {
      _editLeavesRequest(_selectedHoliday);
    }
    _totalRemained = _calcTotalRemained();

    userBusiness = widget.userBusiness;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: STextStyle.appBarDecoration()
        ),
        titleSpacing: -5,
        title: Text(L10n.ofValue().holiday + " - " + (_selectedHoliday != null ? L10n.ofValue().update : L10n.ofValue().addNew)),
      ),
      body: SingleChildScrollView(child: Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: _buildUI())
      ),
    );
  }

  Widget _buildUI() {
    return Column(
      children: <Widget>[
        Container(
            child: Table(
              children: [
                TableRow(
                  children: [
                    TableCell(
                        child: _buildTextWidget(_selectedHoliday != null ? _selectedHoliday.empName : GlobalParam.FULL_NAME)
                    ),
                    TableCell(
                        child: _buildTextWidget(_selectedHoliday != null ? _selectedHoliday.deptName : _holidayParam?.deptName)
                    ),
                  ]
                ),
                TableRow(
                  children: [
                    TableCell(
                        child: _buildTextWidget(
                            '${L10n.ofValue().totalLeave}: ${_numberFormatter.format(
                                _selectedHoliday != null ? (_selectedHoliday.holidayDay??0) : (_holidayParam?.holidayDay??0)
                            )}'
                        )
                    ),
                    TableCell(
                        child: _buildTextWidget(
                            '${L10n.ofValue().compensatedLeave}: ${_numberFormatter.format(
                                _selectedHoliday != null ?
                                _getLastYearBalance(_selectedHoliday.createdDate, _selectedHoliday.lastYearExp, _selectedHoliday.lastYearBalance)
                                    : _getLastYearBalance(DateTime.now(), _holidayParam?.lastYearExp, _holidayParam?.lastYearBalance)
                            )}'
                        )
                    ),
                  ]
                ),
                TableRow(
                  children: [
                    TableCell(
                        child: _buildTextWidget(
                          '${L10n.ofValue().used}: ${_numberFormatter.format(
                              _selectedHoliday != null ? (_selectedHoliday.used??0) : (_holidayParam?.used??0)
                          )}'
                        )
                    ),
                    TableCell(
                        child: _buildTextWidget(
                          '${L10n.ofValue().remained}: ${_numberFormatter.format(
                              _totalRemained??0
                          )}'
                        )
                    ),
                  ]
                ),
              ],
            )
        ),
        Container(
          height: 1,
          color: Colors.grey,
        ),
        SizedBox(height: 10,),
        _buildInputWidgets(),
        _buildController(),
      ],
    );
  }

  void _editLeavesRequest(HolidayView holiday) {
    _enableWidgets = (holiday.employeeId == GlobalParam.EMPLOYEE_ID);
    _selectedHoliday = holiday;
    _saveText = L10n.ofValue().update;
    _refNo = _selectedHoliday.code ?? '';
    _createdDate = _selectedHoliday.createdDate;
    _startDateTime = _selectedHoliday.startDate;
    _startDateTimeController.text =  _dateToString(_startDateTime, DateFormat.yMd().add_Hm());
    _endDateTime = _selectedHoliday.endDate;
    _endDateTimeController.text =  _dateToString(_endDateTime, DateFormat.yMd().add_Hm());
    _leavesDay = _calcLeavesDay(_startDateTime, _endDateTime);
    _contentTextController.text = _selectedHoliday.content;
    _notesTextController.text = _selectedHoliday.notes;
    _currentHolidayType = _selectedHoliday.holidayType;

    switch(holiday.status) {
      case HolidayView.STATUS_WAITING:

        break;
      case HolidayView.STATUS_SUBMIT:
      case HolidayView.STATUS_HR:
      case HolidayView.STATUS_APPROVED:

        break;
    }
  }

  bool _validateInput() {
    if ((_holidayParam?.holidayDay??0) == 0) {
      Toast.show(L10n.ofValue().youHaveNotBeenGrantedTheLeavesDay, context, gravity: Toast.CENTER);
      return false;
    }

    if (_startDateTime == null) {
      Toast.show(L10n.ofValue().youMustEnterTheFromDateTime, context, gravity: Toast.CENTER);
      return false;
    }

    if (_endDateTime == null) {
      Toast.show(L10n.ofValue().youMustEnterTheToDateTime, context, gravity: Toast.CENTER);
      return false;
    }

    if (_endDateTime.difference(_startDateTime).inMinutes < 1) {
      FocusScope.of(context).requestFocus(_endDateTimeFocus);
      Toast.show(L10n.ofValue().fromDateTimeMustBeLessThanToDateTime, context, gravity: Toast.CENTER);
      return false;
    }

    if(_leavesDay <= 0) {
      FocusScope.of(context).requestFocus(_endDateTimeFocus);
      Toast.show(L10n.ofValue().leavesDayMustBeGreaterThanZero, context, gravity: Toast.CENTER);
      return false;
    }

    if (_contentTextController.text.trim().length == 0) {
      FocusScope.of(context).requestFocus(_contentFocus);
      Toast.show(L10n.ofValue().youMustEnterTheContent, context, gravity: Toast.CENTER);
      return false;
    }

    if (_currentHolidayType == null) {
      Toast.show(L10n.ofValue().youMustSelectLeavesRequestType, context, gravity: Toast.CENTER);
      return false;
    }

    if (_selectedHoliday == null) {
      if ((_totalRemained < _leavesDay) && _currentHolidayType != HolidayView.TYPE_PERSONAL_LEAVE) {
        SDialog.confirm(
          L10n.ofValue().holiday,
          L10n.ofValue().youHaveUsedUpTheLeavesDay + "." + L10n.ofValue().doYouWantToSelectThis + "?",
        ).then((buttonPressed){
          if (buttonPressed == DialogButton.yes) {
            setState(() {
              _currentHolidayType = HolidayView.TYPE_PERSONAL_LEAVE;
            });
          }
        });
        return false;
      }
    } else {
      if (((_totalRemained + _selectedHoliday.numOfDay) < _leavesDay) && _currentHolidayType != HolidayView.TYPE_PERSONAL_LEAVE) {
        SDialog.confirm(
          L10n.ofValue().holiday,
          L10n.ofValue().youHaveUsedUpTheLeavesDay + "." + L10n.ofValue().doYouWantToSelectThis + "?",

        ).then((buttonPressed){
          if (buttonPressed == DialogButton.yes) {
            setState(() {
              _currentHolidayType = HolidayView.TYPE_PERSONAL_LEAVE;
            });
          }
        });
        return false;
      }
    }
    return true;
  }

  void _onDeleteOne(){
    if(_selectedHoliday == null) return;

    _holidayAPI.delete([_selectedHoliday.id]).then((value){
      if (value != null) {
        _selectedHoliday = null;
        _resetInput();
      } else {
        Toast.show(value.item2, context);
      }
    });

  }

  String _getDeleteMessage(HolidayView h) {
    return HolidayUtil.getHolidayTypeName(h?.holidayType) + " - " +
        Util.getShortDateTimeStr(h.startDate) + " - " + Util.getShortDateTimeStr(h.endDate);
  }


  double _calcTotalRemained() {
    return (_holidayParam.holidayDay??0) +
        _getLastYearBalance(DateTime.now(), _holidayParam.lastYearExp, _holidayParam.lastYearBalance) - (_holidayParam.used??0);
  }

  Future<void> _loadParam(selectedEmpId) async {
    var temp = await _holidayAPI.findHolidayParamByEmpId(
        empId: selectedEmpId
    );
    if (temp.item1 != null) {
      _holidayParam = temp.item1;
      _totalRemained = _calcTotalRemained();
    }
  }

  void _initDateTime() {
    var now = DateTime.now();
    _startDateTime = DateTime(now.year, now.month, now.day + 1, 8, 0);
    _endDateTime = DateTime(now.year, now.month, now.day + 1, 17, 0);
    _leavesDay = _calcLeavesDay(_startDateTime, _endDateTime);

    if(!mounted) return;
    _startDateTimeController.text =  _dateToString(_startDateTime, DateFormat.yMd().add_Hm());
    _endDateTimeController.text =  _dateToString(_endDateTime, DateFormat.yMd().add_Hm());
  }

  String _dateToString(DateTime date, DateFormat formatter) {
    if (date != null) {
      try {
        return formatter.format(date);
      } catch (e) {
        print('Error formatting date: $e');
      }
    }
    return '';
  }

  double _calcLeavesDay(DateTime startDateTime, DateTime endDateTime) {
    print(startDateTime);
    print(endDateTime);
    if(startDateTime == null || endDateTime == null)
      return 0;

    var numOfDay = endDateTime.difference(startDateTime).inDays;
    startDateTime = DateTime(endDateTime.year, endDateTime.month, endDateTime.day, startDateTime.hour, startDateTime.minute);
    var numOfHour = endDateTime.difference(startDateTime).inHours;
    return numOfDay + Util.round0_5((numOfHour-1)/8);
  }

  void _resetInput() async {
    await _loadParam(GlobalParam.EMPLOYEE_ID);

    _saveText = L10n.ofValue().save;
    _createdDate = DateTime.now();
    _refNo = '';
    _initDateTime();
    _contentTextController.text ='';
    _notesTextController.text = '';
    _currentHolidayType = null;
    _enableWidgets = true;
    FocusScope.of(context).requestFocus(_contentFocus);
    setState(() {
    });
  }

  HolidayView _bindingData() {
    return HolidayView(
      id: _selectedHoliday != null ? _selectedHoliday.id : null,
      code : _selectedHoliday != null ? _selectedHoliday.code : null,
      holidayType: _currentHolidayType,
      employeeId: GlobalParam.EMPLOYEE_ID,
      content: _contentTextController.text.trim(),
      notes:  _notesTextController.text.trim(),
      startDate: _startDateTime,
      endDate: _endDateTime,
      numOfDay: (HolidayView.TYPE_PERSONAL_LEAVE == _currentHolidayType) ? 0 : _leavesDay,
      departmentId: _holidayParam.deptId,
      createdId: GlobalParam.USER_ID,
      creatorId: GlobalParam.EMPLOYEE_ID,
      requesterId: GlobalParam.EMPLOYEE_ID,
      status: HolidayView.STATUS_NEW,
      companyId: GlobalParam.COMPANY_ID,
      branchId: GlobalParam.BRANCH_ID,
    );
  }

  Widget _buildController() {
    return Row (
      children: <Widget>[
        if (_selectedHoliday != null && GlobalParam.EMPLOYEE_ID == _selectedHoliday.employeeId && _selectedHoliday.status == HolidayView.STATUS_NEW)
          InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: STab(
                  icon: Icon(Icons.delete, color: STextStyle.HOT_COLOR,),
                  text: L10n.ofValue().delete,
                ),
              ),
              onTap: () {
                SDialog.confirm(L10n.ofValue().holiday, L10n.ofValue().delete + " [<b>" + _getDeleteMessage(_selectedHoliday) + "</b>]. "+ L10n.ofValue().areYouSure + "?")
                    .then((onValue){
                  if(onValue == DialogButton.yes){
                    _onDeleteOne();
                  }
                });
              }
          ),

        if(_selectedHoliday != null)
          InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: STab(
                  icon: Icon(Icons.new_releases, color: Colors.green,),
                  text: L10n.ofValue().addNew,
                ),
              ),
              onTap: () {
                _selectedHoliday = null;
                _resetInput();
              }
          ),
        if (_selectedHoliday == null || GlobalParam.EMPLOYEE_ID == _selectedHoliday.employeeId && _selectedHoliday.status == HolidayView.STATUS_NEW)
          InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: STab(
                  icon: Icon(Icons.save),
                  text: _saveText,
                ),
              ),
              onTap: () {
                if (!_validateInput())
                  return;
                _onSaveOrUpdate(_bindingData());
              }
          ),
        Spacer(),
        ///TODO
        if(roleControl("cbSubmit",_selectedHoliday)== true)
        SubmitButton(
            color: Colors.orange,
                        onTap: (){
             // _onSaveOrUpdate(_bindingData());
              _onSubmit(_bindingData());
            },
            onAskMessage:() {
              return '${L10n.ofValue().submit} <b>${_getDeleteMessage(_selectedHoliday)}</b>. ${L10n.ofValue().areYouSure}?';
            }
        ),
        if(roleControl("cbCancelSubmit",_selectedHoliday)== true)
          CancelSubmitButton(
              color: Colors.orange,
              onTap: (){
                _onCancelSubmit(_selectedHoliday);
              },
              onAskMessage:() {
                return '${L10n.ofValue().cancelSubmit} <b>${_getDeleteMessage(_selectedHoliday)}</b>. ${L10n.ofValue().areYouSure}?';
              }
          ),
        ///TODO
        if(roleControl("cbApprove",_selectedHoliday)== true)
        ApproveButton(
          color: Colors.blue,
          onTap: (){
             _onApprove(_bindingData());
          },
          onAskMessage: () {
            return '${L10n.ofValue().approve} <b>${_getDeleteMessage(_selectedHoliday)}</b>. ${L10n.ofValue().areYouSure}?';
          },
        ),

        if(roleControl("cbCancelApprove",_selectedHoliday)== true)
          CancelApproveButton(
            color: Colors.blue,
            onTap: (){
              _onCancelApprove(_bindingData());
            },
            onAskMessage: () {
              return '${L10n.ofValue().cancelApprove} <b>${_getDeleteMessage(_selectedHoliday)}</b>. ${L10n.ofValue().areYouSure}?';
            },
          ),
      ],
    );
  }

  void _onSubmit(HolidayView h) {
        var _taskApproveSubmitListAPI = TaskApproveSubmitListAPI();
        _taskApproveSubmitListAPI
            .doApproveSubmitWithUserIdAndGroupIdAndSourceIdAndTask(
            userId: GlobalParam.USER_ID,
            groupId: 10,
            sourceId: h.id,
            task: 1 ).then((response) {
          //_loadData();
          if(response.status.toString() == "success"){
            int submit = json.decode(response.updateObject)["submit"];
            int status = json.decode(response.updateObject)["status"];

            _selectedHoliday.submit = submit;
            _selectedHoliday.status = status;

            setState(() {
            });
            if(response.message.length >0)SDialog.alert("",response.message);
          }
          else{
            SDialog.alert("",response.message);
          }

        });
   }

  void _onCancelSubmit(HolidayView h) {
    var _taskApproveSubmitListAPI = TaskApproveSubmitListAPI();
    _taskApproveSubmitListAPI
        .doApproveSubmitWithUserIdAndGroupIdAndSourceIdAndTask(
        userId: GlobalParam.USER_ID,
        groupId: 10,
        sourceId: h.id,
        task: 2 ).then((response) {
      //_loadData();
      if(response.status.toString() == "success"){
        int submit = json.decode(response.updateObject)["submit"];
        int status = json.decode(response.updateObject)["status"];
        _selectedHoliday.submit = submit;
        _selectedHoliday.status = status;
        setState(() {
         });
        if(response.message.length >0)SDialog.alert("",response.message);
      }
      else{
        SDialog.alert("",response.message);
      }

    });
  }

  void _onApprove(HolidayView h) {

        var _taskApproveSubmitListAPI = TaskApproveSubmitListAPI();
        _taskApproveSubmitListAPI
            .doApproveSubmitWithUserIdAndGroupIdAndSourceIdAndTask(
            userId: GlobalParam.USER_ID,
            groupId: 10,
            sourceId: h.id,
            task: 3 ).then((response) {

          if(response.status.toString() == "success"){

            int submit = json.decode(response.updateObject)["submit"];
            int status = json.decode(response.updateObject)["status"];
            _selectedHoliday.submit = submit;
            _selectedHoliday.status = status;
            setState(() {

            });
            if(response.message.length >0)SDialog.alert("",response.message);
          }
          else{
            SDialog.alert("",response.message);
          }

        });


  }
  void _onCancelApprove(HolidayView h) {

    var _taskApproveSubmitListAPI = TaskApproveSubmitListAPI();
    _taskApproveSubmitListAPI
        .doApproveSubmitWithUserIdAndGroupIdAndSourceIdAndTask(
        userId: GlobalParam.USER_ID,
        groupId: 10,
        sourceId: h.id,
        task: 4 ).then((response) {

      if(response.status.toString() == "success"){
        int submit = json.decode(response.updateObject)["submit"];
        int status = json.decode(response.updateObject)["status"];

        _selectedHoliday.submit = submit;
        _selectedHoliday.status = status;
        setState(() {


        });
        if(response.message.length >0)SDialog.alert("",response.message);
      }
      else{
        SDialog.alert("",response.message);
      }

    });


  }
  void _onSaveOrUpdate(HolidayView h) {
    _holidayAPI.saveOrUpdate(h).then((value) async{
      if (value.item1 == null) {
        Toast.show(value.item2, context);
      } else {
        await _loadParam(GlobalParam.EMPLOYEE_ID);
        _selectedHoliday = value.item1;
        _selectedHoliday.deptName =  _holidayParam?.deptName;
        _selectedHoliday.empName = widget.selectedHoliday !=null ? widget.selectedHoliday.empName : GlobalParam.FULL_NAME;
        _selectedHoliday.holidayDay =  (_holidayParam?.holidayDay??0);
        _selectedHoliday.used = (_holidayParam?.used??0);

        _selectedHoliday.startDate = DateTime(
            _selectedHoliday.startDate.year,
            _selectedHoliday.startDate.month,
            _selectedHoliday.startDate.day,
            _selectedHoliday.startDate.hour,
            _selectedHoliday.startDate.minute
        );

        _selectedHoliday.endDate = DateTime(
            _selectedHoliday.endDate.year,
            _selectedHoliday.endDate.month,
            _selectedHoliday.endDate.day,
            _selectedHoliday.endDate.hour,
            _selectedHoliday.endDate.minute
        );

        _selectedHoliday.lastYearBalance = _getLastYearBalance(
            _selectedHoliday.createdDate,
            _selectedHoliday.lastYearExp,
            _selectedHoliday.lastYearBalance
        );

        _editLeavesRequest(_selectedHoliday);
        Toast.show(L10n.of(context).saveOrUpdateSuccess, context);
        setState(() {

        });
      }
    });
  }

  Widget _buildTextWidget(String text) {
    return Padding(
      padding: const EdgeInsets.only(top : 5, bottom: 5),
      child: SText(
          text??''
      ),
    );
  }

  double _getLastYearBalance(DateTime currentDate, DateTime exp, double lastYearBalance) {
    if(currentDate == null || exp == null)
      return lastYearBalance??0;

    if (currentDate.compareTo(exp) > 0)
      return 0;
    else
      return lastYearBalance;
  }

  Widget _buildInputWidgets() {
    return AbsorbPointer(
      absorbing: !_enableWidgets,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(child: SText('${L10n.ofValue().refNo}: $_refNo')),
                Expanded(child: SText('${L10n.ofValue().createdDate}: ${Util.getDateStr(_createdDate)}')),
              ],
            ),
            _buildStartDateEndDate(),
            STextFormField(
              focusNode: _contentFocus,
              controller: _contentTextController,
              decoration: InputDecoration(
                  labelText: L10n.ofValue().content
              ),
            ),
            STextFormField(
              controller: _notesTextController,
              decoration: InputDecoration(
                  labelText: L10n.ofValue().notes
              ),
            ),
            Row(
              children: <Widget>[
                SText(L10n.ofValue().leavesRequestType + ": "),
                HolidayTypeDropdown(
                  selectedId: _currentHolidayType,
                  showAllItem: false,
                  width: double.infinity,
                  onChanged: (value){
                    _currentHolidayType = value;
                  },
                ),
              ],
            ),
//            _buildHolidayTypePopup(),
          ],
        ),
      ),
    );
  }

  Widget _buildStartDateEndDate() {
    return Row (
      children: <Widget>[
        Flexible(
          child: DateTimePickerFormField(
            style: TextStyle(
                fontSize: 13
            ),
            controller: _startDateTimeController,
            inputType: InputType.both,
            initialValue:_startDateTime,
            format: DateFormat.yMd().add_Hm(),
            editable: true,
            focusNode: _startDateTimeFocus,
            decoration: InputDecoration(
                helperText: '${L10n.ofValue().leavesDay} : $_leavesDay',
                labelText: L10n.ofValue().fromDateTime, hasFloatingPlaceholder: true),
            onChanged: (dt) {
              _startDateTime = dt;
              _leavesDay = _calcLeavesDay(_startDateTime, _endDateTime);
            },
          ),
        ),
        SizedBox(width: 10,),
        Flexible(
          child: DateTimePickerFormField(
            style: TextStyle(
                fontSize: 13
            ),
            controller: _endDateTimeController,
            inputType: InputType.both,
            initialValue: _endDateTime,
            focusNode: _endDateTimeFocus,
            format: DateFormat.yMd().add_Hm(),
            editable: true,
            decoration: InputDecoration(
                helperText: '',
                labelText: L10n.ofValue().toDateTime, hasFloatingPlaceholder: true),
            onChanged: (dt) {
              _endDateTime = dt;
              _leavesDay = _calcLeavesDay(_startDateTime, _endDateTime);
            },
          ),
        ),
      ],
    );
  }




  Widget _buildDropdownItem(String text, String key) {
    return DropdownMenuItem(
      child: Text(text),
      value: key,
    );
  }
  String getBusinessCode(){
    return "hrm41";
  }
  bool roleControl(String buttonName, HolidayView holiday){
    int id = 0;
    int creatorId =0 ;
    int status = HolidayView.STATUS_NEW;
    int submit = Constant.SUBMIT_0;
    int loginUserId = GlobalParam.USER_ID ;
    int ownerApprove =0;
    if(holiday != null) {
      id = holiday.id;
      creatorId = holiday.createdId != null? holiday.createdId : loginUserId;
      status = holiday.status;
      status = status == null ? HolidayView.STATUS_NEW : status;
      submit = holiday.submit != null ? holiday.submit : 0;
      ownerApprove = getApproveLevel(holiday);
    }
    bool isApproveLevel1 = userBusiness.isLevel1;
    bool isApproveLevel2 = userBusiness.isLevel2;
    bool isApproveLevel3 = userBusiness.isLevel3;


    if (HolidayView.STATUS_NEW == status) {

      if(buttonName == "cbApprove"){
        if (isApproveLevel1 || isApproveLevel2 || isApproveLevel3) {
          return true;
        }
      }
      if(buttonName == "cbSubmit"){
        if ( !isApproveLevel3) {
          return true;
        }
      }

    } else if (HolidayView.STATUS_REJECT == holiday.status) {
         if(buttonName == "cbApprove"){
        if (isApproveLevel1 || isApproveLevel2 || isApproveLevel3) {
          return true;
        }
      }
      if(buttonName == "cbSubmit"){
        if ( !isApproveLevel3) {
          return true;
        }
      }
    } else if (HolidayView.STATUS_WAITING == status) {


      if (Constant.SUBMIT_3 == submit ) {
        if (isApproveLevel3) {
           if (buttonName == "cbApprove") return true;
        } else if (isApproveLevel2) {
            if(buttonName == "cbCancelSubmit") return true;
        } else if (isApproveLevel1) {
        }
      } else if (Constant.SUBMIT_2 == submit) {
        if (isApproveLevel3) {
          if(buttonName == "cbApprove") return true;
        } else if (isApproveLevel2) {
          if(buttonName == "cbSubmit") return true;
          if(buttonName == "cbApprove") return true;

        } else if (isApproveLevel1) {
          if(buttonName == "cbCancelSubmit") return true;
        }
      } else if (Constant.SUBMIT_1 == submit ) {
        if (isApproveLevel3) {
          //if(buttonName == "cbSubmit") return true;
          if(buttonName == "cbApprove") return true;
        } else if (isApproveLevel2) {
          if(buttonName == "cbSubmit") return true;
          if(buttonName == "cbApprove") return true;
        } else if (isApproveLevel1) {
          if(buttonName == "cbSubmit") return true;
          if(buttonName == "cbApprove") return true;
        }

      }
      else if (Constant.SUBMIT_0 == submit ) {
        if (isApproveLevel3) {
          //if(buttonName == "cbSubmit") return true;
          if(buttonName == "cbApprove") return true;
        } else if (isApproveLevel2) {
          if(buttonName == "cbSubmit") return true;
          if(buttonName == "cbApprove") return true;
        } else if (isApproveLevel1) {
          if(buttonName == "cbSubmit") return true;
          if(buttonName == "cbApprove") return true;
        }

      }



      if (GlobalParam.EMPLOYEE_ID == holiday.employeeId
          || GlobalParam.EMPLOYEE_ID == holiday.requesterId || loginUserId == creatorId ) {

         if (submit <= (ownerApprove + 1)) {
          if(buttonName == "cbCancelSubmit"){
            return true;
          }
        }
      }
    } else if (HolidayView.STATUS_SUBMIT == status) {
      if(buttonName == "cbCancelApprove"){
        if(isApproveLevel1) return true;
      }

    } else if (HolidayView.STATUS_HR == status) {
      if(buttonName == "cbCancelApprove"){
        if(isApproveLevel2) return true;
      }
    } else if (HolidayView.STATUS_APPROVED == status) {
        if(buttonName == "cbCancelApprove"){
        if(isApproveLevel3) return true;
      }
    } else if (HolidayView.STATUS_CANCELED == status) {

    }
    return false;
  }

   int getApproveLevel(HolidayView holiday) {
    int level = 0;
      if (holiday.isOwnerApproveLevel3 == 1) {
        level = 3;
      } else if (holiday.isOwnerApproveLevel2 == 1) {
        level = 2;
      } else if (holiday.isOwnerApproveLevel1 == 1) {
        level = 1;
      }
    return level;
  }
  @override
  void dispose() {
    super.dispose();
  }
}