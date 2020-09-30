import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/tuple.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/calendar/cal_util.dart';
import 'package:mobile/modules/calendar/scalendar.dart';
import 'package:mobile/system/loader/data.dart';
import 'package:mobile/system/loader/model.dart';
import 'package:mobile/widgets/data_widget/branch_dropdown.dart';
import 'package:mobile/widgets/data_widget/employee_split_name_dropdown.dart';
import 'package:mobile/widgets/particular/sclose_button.dart';
import 'package:mobile/widgets/particular/select_button.dart';
import 'package:mobile/widgets/particular/ssave_button.dart';
import 'package:mobile/widgets/scheckbox.dart';
import 'package:mobile/widgets/scontainer.dart';
import 'package:mobile/widgets/sdialog.dart';
import 'package:mobile/widgets/stext.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class FilterUI extends StatefulWidget{
  @override
  FilterUIState createState() => FilterUIState();
}

class FilterUIState extends State<FilterUI> {
  int _currentBranchId;
  int _currentDepartmentId;
  int _currentGroupId;
  int _currentEmployeeId;

  List<Department> _filterDepartmentList;
  List<Employee> _filterEmployeeList;
  
  bool _checkedEvent;
  bool _checkedMeetings;
  bool _checkedTask;
  bool _checkedReminder;
  bool _checkedTraveling;
  bool _checkedHoliday;
  bool _checkedPotential;
  bool _checkedOpportunity;

  static const int TOTAL_EVENT = 8;
  List<Department> _departmentList;
  List<Employee> _employeeList;

  SharedPreferences _prefs;
  StreamController<SharedPreferences> _prefsStreamController = StreamController.broadcast();
  bool _isStreamActive = false;

  @override
  void initState() {
    super.initState();
    _init();
    _departmentList = List.from(GlobalData.departmentList);
    _departmentList.insert(0, Department(
      name: '${L10n.ofValue().department}: ${L10n.ofValue().all}',
    ));
    _filterDepartmentList = _departmentList;

    _employeeList = List.from(GlobalData.employeeList);
    _employeeList.insert(0, Employee(
      name: '${L10n.ofValue().employee}: ${L10n.ofValue().all}',
    ));
    _filterEmployeeList = _employeeList;

    GlobalData.itemGroupList.insert(0, ItemGroup(
      code: '${L10n.ofValue().group}: ${L10n.ofValue().all}',
    ));


  }

  void _init() async {
    _prefs = await SharedPreferences.getInstance();
    _prefsStreamController.sink.add(_prefs);
  }

  List<int> _getCheckedEvent() {
    var list = List<int>();
    if(_checkedEvent)
      list.add(SCalendar.TYPE_EVENT);

    if(_checkedMeetings)
      list.add(SCalendar.TYPE_MEETING);

    if(_checkedTask)
      list.add(SCalendar.TYPE_TASK);

    if(_checkedReminder)
      list.add(SCalendar.TYPE_REMINDER);

    if(_checkedHoliday)
      list.add(SCalendar.TYPE_HOLIDAY);

    if(_checkedTraveling)
      list.add(SCalendar.TYPE_TRAVELING);

    if(_checkedPotential)
      list.add(SCalendar.TYPE_LEAD_ACTIVITY);

    if(_checkedOpportunity)
      list.add(SCalendar.TYPE_OPPORTUNITY_ACTIVITY);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return SDialog(
      contentPadding: EdgeInsets.all(0),
      title: SText(L10n.ofValue().filter),
      content: SingleChildScrollView(child: _buildBody()),
      actions: <Widget>[
        SCloseButton(),
        SSelectButton(
          onTap: () {
            List<int> checkedEvents = _getCheckedEvent();
            var filter = Tuple2<int, List<int>>(
              _currentEmployeeId,
              checkedEvents
            );
            Navigator.of(context).pop(filter);
          },
        ),
        SSaveButton(
          onTap: () {
            List<int> checkedEvents = _getCheckedEvent();
            _saveSettings();
            var filter = Tuple2<int, List<int>>(
                _currentEmployeeId,
                checkedEvents
            );
            Navigator.of(context).pop(filter);
          },
        ),
      ],
    );
  }

  void _saveSettings() async {
    await _prefs.setInt("calendar.selectedEmplyeeId", _currentEmployeeId ?? -1);
    await _prefs.setBool("calendar.checkedEvent", _checkedEvent);
    await _prefs.setBool("calendar.checkedMeetings", _checkedMeetings);
    await _prefs.setBool("calendar.checkedTask", _checkedTask);
    await _prefs.setBool("calendar.checkedReminder", _checkedReminder);
    await _prefs.setBool("calendar.checkedTraveling", _checkedTraveling);
    await _prefs.setBool("calendar.checkedHoliday", _checkedHoliday);
    await _prefs.setBool("calendar.checkedOpportunity", _checkedOpportunity);
    await _prefs.setBool("calendar.checkedPotential", _checkedPotential);
  }
  Widget _buildBody() {
    return StreamBuilder<SharedPreferences>(
      stream: _prefsStreamController.stream,
      builder: (context, snapshot) {
        print('${snapshot.hasData} - ${snapshot.connectionState}');

        if(snapshot.hasData && !_isStreamActive){
          _prefs ??= snapshot.data;
          _currentEmployeeId ??= _prefs.getInt("calendar.selectedEmplyeeId")??GlobalParam.EMPLOYEE_ID;
          if (_currentEmployeeId == -1)
            _currentEmployeeId = null;

          _checkedEvent ??= _prefs.getBool("calendar.checkedEvent") ?? true;
          _checkedMeetings ??= _prefs.getBool("calendar.checkedMeetings") ?? true;
          _checkedTask ??= _prefs.getBool("calendar.checkedTask") ?? true;
          _checkedReminder ??= _prefs.getBool("calendar.checkedReminder") ?? true;
          _checkedTraveling ??= _prefs.getBool("calendar.checkedTraveling") ?? true;
          _checkedHoliday ??= _prefs.getBool("calendar.checkedHoliday") ?? true;
          _checkedOpportunity ??= _prefs.getBool("calendar.checkedOpportunity") ?? true;
          _checkedPotential ??= _prefs.getBool("calendar.checkedPotential") ?? true;
          _isStreamActive = true;
        }
        return SContainer(
          child: Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildBranch(),
                  _buildDepartment(),
                  _buildGroup(),
                  _buildEmployee(),
                  ..._buildCheckBoxList()
                ],
              ),
            ],
          ),
        );
      }
    );
  }

  List<Widget> _buildCheckBoxList(){
    var list = List<Widget>();

    list.add(_buildEventCheckBox());
    list.add(_buildMeetingsCheckBox());
    list.add(_buildWorksCheckBox());
    list.add(_buildReminderCheckBox());
    list.add(_buildTravelingCheckBox());
    list.add(_buildHolidayCheckBox());
    list.add(_buildPotentialCheckBox());
    list.add(_buildOpportunityCheckBox());

    return list;
  }

  Widget _buildEventCheckBox() {
    return Row(
      children: <Widget>[
        SCheckbox(
          activeColor: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_EVENT),
          useTapTarget: false,
          value: _checkedEvent??true,
          onChanged: (value) {
            if (!mounted) return;
            setState(() {
              _checkedEvent = value;
            });
          },
        ),
        SizedBox(width: 8,),
        SText(L10n.ofValue().event, style: TextStyle(color: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_EVENT)),),
      ],
    );
  }

  Widget _buildMeetingsCheckBox() {
    return Row(
      children: <Widget>[
        SCheckbox(
          activeColor: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_MEETING),
          useTapTarget: false,
          value: _checkedMeetings??true,
          onChanged: (value) {
            if (!mounted) return;
            setState(() {
              _checkedMeetings = value;
            });
          },
        ),
        SizedBox(width: 8,),
        SText(L10n.ofValue().meetings, style: TextStyle(color: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_MEETING))),
      ],
    );
  }

  Widget _buildWorksCheckBox() {
    return Row(
      children: <Widget>[
        SCheckbox(
          activeColor: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_TASK),
          useTapTarget: false,
          value: _checkedTask??true,
          onChanged: (value) {
            if (!mounted) return;
            setState(() {
              _checkedTask = value;
            });
          },
        ),
        SizedBox(width: 8,),
        SText(L10n.ofValue().task, style: TextStyle(color: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_TASK))),
      ],
    );
  }

  Widget _buildReminderCheckBox() {
    return Row(
      children: <Widget>[
        SCheckbox(
          activeColor: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_REMINDER),
          useTapTarget: false,
          value: _checkedReminder??true,
          onChanged: (value) {
            if (!mounted) return;
            setState(() {
              _checkedReminder = value;
            });
          },
        ),
        SizedBox(width: 8,),
        SText(L10n.ofValue().reminder, style: TextStyle(color: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_REMINDER))),
      ],
    );
  }

  Widget _buildTravelingCheckBox() {
    return Row(
      children: <Widget>[
        SCheckbox(
          activeColor: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_TRAVELING),
          useTapTarget: false,
          value: _checkedTraveling??true,
          onChanged: (value) {
            if (!mounted) return;
            setState(() {
              _checkedTraveling = value;
            });
          },
        ),
        SizedBox(width: 8,),
        SText(L10n.ofValue().traveling, style: TextStyle(color: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_TRAVELING))),
      ],
    );
  }

  Widget _buildHolidayCheckBox() {
    return Row(
      children: <Widget>[
        SCheckbox(
          activeColor: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_HOLIDAY),
          useTapTarget: false,
          value: _checkedHoliday??true,
          onChanged: (value) {
            if (!mounted) return;
            setState(() {
              _checkedHoliday = value;
            });
          },
        ),
        SizedBox(width: 8,),
        SText(L10n.ofValue().holiday, style: TextStyle(color: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_HOLIDAY))),
      ],
    );
  }

  Widget _buildPotentialCheckBox() {
    return Row(
      children: <Widget>[
        SCheckbox(
          activeColor: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_LEAD_ACTIVITY),
          useTapTarget: false,
          value: _checkedPotential??true,
          onChanged: (value) {
            if (!mounted) return;
            setState(() {
              _checkedPotential = value;
            });
          },
        ),
        SizedBox(width: 8,),
        SText(L10n.ofValue().potential, style: TextStyle(color: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_LEAD_ACTIVITY))),
      ],
    );
  }

  Widget _buildOpportunityCheckBox() {
    return Row(
      children: <Widget>[
        SCheckbox(
          activeColor: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_OPPORTUNITY_ACTIVITY),
          useTapTarget: false,
          value: _checkedOpportunity??true,
          onChanged: (value) {
            if (!mounted) return;
            setState(() {
              _checkedOpportunity = value;
            });
          },
        ),
        SizedBox(width: 8,),
        SText(L10n.ofValue().opportunity, style: TextStyle(color: CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_OPPORTUNITY_ACTIVITY))),
      ],
    );
  }

  Widget _buildBranch() {
    return BranchDropdown(
      selectedId: _currentBranchId,
      onChanged: (value) {
        if (!mounted) return;
        setState(() {
          _currentBranchId = value;
        });
        _filterDepartment(value);
        _filterEmpByBranch(value);
      },
    );
  }
  
  void _filterDepartment(int branchId) {
    if (branchId == null) {
      _filterDepartmentList = _departmentList;
      return;
    }

    _filterDepartmentList = _departmentList.where((item) {
      if (item.id == null)
        return true;
      return item.branchId == branchId;
    }).toList();

    if(!mounted) return;
    setState(() {
      _currentDepartmentId = null;
    });
  }

  void _filterEmpByDep(int departmentId) {
    print(_currentBranchId);
    print(departmentId);
    if (departmentId == null) {
      _filterEmpByBranch(_currentBranchId);
      return;
    }

    print(_filterEmployeeList.length);
    _filterEmployeeList =_employeeList.where((item) {
      if (item.id == null)
        return true;
      return item.departmentId == departmentId;
    }).toList();

    if(!mounted) return;
    setState(() {
      _currentEmployeeId = null;
    });
  }

  void _filterEmpByBranch(int branchId) {
    if (branchId == null) {
      _filterEmployeeList = _employeeList;
      return;
    }

    _filterEmployeeList = _employeeList.where((item) {
      if (item.id == null)
        return true;
      print('${item.branchId}');
      return item.branchId == branchId;
    }).toList();

    if(!mounted) return;
    setState(() {
      _currentEmployeeId = null;
    });
  }

  Widget _buildDepartment() {
    return DropdownButton(
        onChanged: (value) {
          if (!mounted) return;
          setState(() {
            _currentDepartmentId = value;
          });

          _filterEmpByDep(value);
        },

        value: _currentDepartmentId,
        items: _filterDepartmentList.map((item){
          return DropdownMenuItem(
            child: Text(item.name),
            value: item.id,
          );
        }).toList()
    );
  }

  Widget _buildGroup() {
    return DropdownButton(
        onChanged: (value) {
          if (!mounted) return;
          setState(() {
            _currentGroupId = value;
          });
        },
        value: _currentGroupId,
        items: GlobalData.itemGroupList.map((item){
          return DropdownMenuItem(
            child: Text(item.code),
            value: item.id,
          );
        }).toList()
    );
  }

  Widget _buildEmployee() {
    return EmployeeSplitNameDropdown(
      selectedId: _currentEmployeeId,
      onChanged: (value) {
        setState(() {
          _currentEmployeeId = value;
          print(_currentEmployeeId);
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _prefsStreamController.close();
  }


}