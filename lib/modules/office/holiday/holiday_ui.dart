import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/tuple.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/locale/r2.dart';
import 'package:mobile/modules/user_business/user_business_list_api.dart';
import 'package:mobile/modules/user_business/user_business_model.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/system/menu/sub/sub_menu_model.dart';
import 'package:mobile/widgets/data_widget/employee_dropdown.dart';
import 'package:mobile/widgets/data_widget/employee_split_name_dropdown.dart';
import 'package:mobile/widgets/data_widget/generic_status_dropdown.dart';
import 'package:mobile/widgets/data_widget/holiday_status_dropdown.dart';
import 'package:mobile/widgets/data_widget/holiday_type_dropdown.dart';
import 'package:mobile/widgets/data_widget/neighbour_employee_dropdown.dart';
import 'package:mobile/widgets/data_widget/user_dropdown.dart';
import 'package:mobile/widgets/data_widget/year_dropdown.dart';
import 'package:mobile/widgets/scircular_progress_indicator.dart';
import 'package:mobile/widgets/scontainer.dart';
import 'package:mobile/widgets/stext.dart';
import 'package:mobile/widgets/stext_form_field.dart';

import 'details/holiday_details_ui.dart';
import 'holiday_api.dart';
import 'holiday_model.dart';
import 'holiday_util.dart';

class HolidayUI extends StatefulWidget{
  final HolidayView selectedHolidayView;
  final SubMenu menu;
  final IconData icon;

  HolidayUI({
    this.selectedHolidayView,
    this.menu,
    this.icon,
    Key key,
  }) : super(key: key);


  @override
  _HolidayUIState createState() => _HolidayUIState();
}

class _HolidayUIState extends State<HolidayUI> {
  var _holidayAPI = HolidayAPI ();
  var _holidayViewStreamController = StreamController<List<HolidayView>>();
  int _selectedEmpId;
  HolidayParam _holidayParam;
  bool _showAdvancedSearch = false;
  IconData _moreLessIcon = Icons.expand_more;

  var _contentTextController = TextEditingController();
  var _refNoTextController = TextEditingController();
  var _searchTextController = TextEditingController();
  List<int> _selectedStatus;
  String _selectedType;
  int _selectedYear;
  int _totalRecord = 0;
  String _lastSearch = "defaultSearch";
  UserBusiness _userBusiness;
  var _userBusinessListAPI = UserBusinessListAPI();
  @override
  void initState() {
    super.initState();
    _selectedStatus = null;//[GenericStatusDropdown.STATUS_NEW, GenericStatusDropdown.STATUS_WAITING];
    _selectedYear = DateTime.now().year;
    _selectedEmpId = null; //GlobalParam.EMPLOYEE_ID;
    //_loadParam(_selectedEmpId);
    _defaultSearch();
    _loadData();
  }

  Future<void> _loadParam(selectedEmpId) async {
    var temp = await _holidayAPI.findHolidayParamByEmpId(
      empId: selectedEmpId
    );
    if (temp.item1 != null) {
      _holidayParam = temp.item1;
    }

  }
  Future<void> _loadData() async {
    _userBusiness =
    await _userBusinessListAPI.getUserBusinessWithUserIdAndBusiness(
        userId: GlobalParam.getUserId(), business: getBusinessCode());

  }
  Future<void> _defaultSearch() async {

    _lastSearch = "defaultSearch";
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _holidayViewStreamController.sink.add(null);
    var data = await _holidayAPI.textSearch(
      defaultSearch: false,
      pageSize: 500,
      currentPage: 0,
      text: '',
      userId: GlobalParam.USER_ID,
      statusRange: [GenericStatusDropdown.STATUS_NEW, GenericStatusDropdown.STATUS_WAITING],
      holidayTypeRange: null,
      yearRange: [DateTime.now().year],
    );
    _holidayViewStreamController.sink.add(data.item1 != null ? data.item1 : []);
    if(mounted) {
      _totalRecord = data.item1?.length ?? 0;
      setState(() {
      });
    }
  }

  Future<void> _lessSearch() async {
    _lastSearch = "lessSearch";
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (_searchTextController.text.trim().length == 0) {
      _defaultSearch();
      return;
    }
    _holidayViewStreamController.sink.add(null);
    var data = await _holidayAPI.textSearch(
      defaultSearch: false,
      pageSize: 500,
      currentPage: 0,
      text: _searchTextController.text.trim(),
      userId: GlobalParam.USER_ID,
      statusRange: null,
      holidayTypeRange: null,
      //yearRange: [DateTime.now().year-1, DateTime.now().year],
    );
    _holidayViewStreamController.sink.add(data.item1 != null ? data.item1 : []);
    if(mounted) {
      _totalRecord = data.item1?.length ?? 0;
      setState(() {
      });
    }
  }

  Future<void> _moreSearch() async {
    _lastSearch = "moreSearch";
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _holidayViewStreamController.sink.add(null);
    var data = await _holidayAPI.textSearch(
      defaultSearch: false,
      pageSize: 500,
      currentPage: 0,
      text: '',
      content: _contentTextController.text.trim(),
      refNo: _refNoTextController.text.trim(),
      empId: _selectedEmpId,
      userId: GlobalParam.USER_ID,
      holidayTypeRange: _selectedType != null ? [_selectedType] : null,
      statusRange: _selectedStatus,
      yearRange: _selectedYear == null ? null : _selectedYear == -1 ? [DateTime.now().year-1, DateTime.now().year] : [_selectedYear],
    );
    _holidayViewStreamController.sink.add(data.item1 != null ? data.item1 : []);
    if(mounted) {
      _totalRecord = data.item1?.length ?? 0;
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingButton(),
      body: StreamBuilder<List<HolidayView>>(
        stream: _holidayViewStreamController.stream,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData)
            return _buildUI(snapshot.data);
          else
            return SCircularProgressIndicator.buildSmallCenter();
        },
      ),
      bottomNavigationBar: SContainer(
//          height: 25.0,
          color: STextStyle.GRADIENT_COLOR1,
          padding: EdgeInsets.only(left: 5, bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SText(
            (_totalRecord ?? 0) > 0 ?
            '${_totalRecord == GlobalParam.PAGE_SIZE ? L10n.of(context).moreThan : ""} '
                '$_totalRecord ${ L10n.of(context).record}' : L10n.of(context).noRecordFound,
            style: TextStyle(color: STextStyle.LIGHT_TEXT_COLOR),
          )
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
          decoration: STextStyle.appBarDecoration()
      ),
      titleSpacing: -10,
      backgroundColor: Colors.white,
      title: Row(children: <Widget>[
        InkWell(
          onTap: () {
            if (_showAdvancedSearch)
              _moreLessIcon = Icons.expand_more;
            else
              _moreLessIcon = Icons.expand_less;
            _showAdvancedSearch = !_showAdvancedSearch;
            setState(() {
            });
          },
          child: Row(
            children: <Widget>[
              Icon(widget.icon, color: STextStyle.LIGHT_TEXT_COLOR),
              Icon(_moreLessIcon, color: STextStyle.LIGHT_TEXT_COLOR)
            ],
          ),
        ),
        Flexible(
          child: _showAdvancedSearch ? Container(
            child: SText(
              (widget.menu != null ? R2.r(widget.menu.resourceKey) : L10n.ofValue().holiday)   + ' - ' + L10n.ofValue().advancedSearch,
              style: TextStyle(fontSize: 16),
            ),
          ) : TextField(
            autofocus: true,
            onSubmitted: (_){
              _lessSearch();
            },
            onChanged: (value){

            },
            controller: _searchTextController,
            textAlign: TextAlign.center,
            style: TextStyle(color: STextStyle.BACKGROUND_COLOR),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                prefixIcon: IconButton(
                  icon: Icon(FontAwesomeIcons.barcode, color: STextStyle.BACKGROUND_COLOR),
                  onPressed: (){
                    _showScanBarcode();
                  },
                ),

                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: STextStyle.BACKGROUND_COLOR),
                  onPressed: () {
                    _lessSearch();
                  },
                ),
                hintText: '${L10n.ofValue().search}...',
                hintStyle: TextStyle(
                    fontSize: 16,
                    color: STextStyle.BACKGROUND_COLOR
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                contentPadding: EdgeInsets.all(10),
                fillColor: STextStyle.GRADIENT_COLOR_AlPHA
            ),
          ),
        )
        ,
        SizedBox(
          width: 20,
        ),

      ],
      ),
    );
  }

  Future<void> _showScanBarcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", L10n.of(context).cancel, true);
    } catch( e){
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _searchTextController.text = barcodeScanRes;
      _lessSearch();
    });
  }

  Widget _buildFloatingButton() {
    return FloatingActionButton(
      child: IconButton(
        icon: Icon(Icons.add, color: Colors.white),
      ),
      onPressed: () {
        _showDetails(null);
      },
    );
  }

  Widget _buildUI(List<HolidayView> list) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          if(_showAdvancedSearch)
            _buildFilter(),
          Flexible(
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                if ((list?.length??0) > 0)
                  for (var i = 0; i < list.length; i++ )
                    _buildListItem(list[i], i == list.length-1)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilter() {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1))
      ),
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Flexible(
                child: STextFormField(
                  controller: _refNoTextController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 5, top: 10),
                    hintText: L10n.ofValue().refNo,
                  ),
                ),
              ),
              SizedBox(width: 10,),
              LimitedBox(
                child: HolidayStatusDropdown(
                  selectedId: _selectedStatus == null ? null :  _selectedStatus.join(","),
                  onChanged: (String value){
                    _selectedStatus = value == null ? null : value.split(",").map((str) => int.parse(str)).toList();
                    print(_selectedStatus);
                  },
                ),
              ),
              SizedBox(width: 10,),
              LimitedBox(
                child: YearDropdown(
                  selectedId: _selectedYear,
                  onChanged: (int value){
                    print(value);
                    _selectedYear = value;
                  },
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: NeighbourEmployeeDropdown(
                  width: 150,
                  business: 'hrm41',
                  selectedId: _selectedEmpId,
                  onChanged: (value) {
                    _selectedEmpId = value;
                  },),
//                child: EmployeeSplitNameDropdown(
//                  width: 170,
//                  selectedId: _selectedEmpId, onChanged: (value) {
//                    _selectedEmpId = value;
//                  }
//                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: HolidayTypeDropdown(
                  width: 130,
                  selectedId: _selectedType,
                  onChanged: (String value){
                    _selectedType = value;
                  },
                ),
              ),

            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: STextFormField(
                  controller: _contentTextController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 6, top: 6),
                    hintText: L10n.ofValue().content,
                  ),
                ),
              ),
              SizedBox(width: 10,),
              InkWell(
                onTap: () {
                  _moreSearch();
                },
                child: Icon(Icons.search, size: 30,),
              )
            ],
          ),
        ],
      ),
    );
  }

  double _calcLeavesDay(DateTime startDateTime, DateTime endDateTime) {
    if(startDateTime == null || endDateTime == null)
      return 0;

    var numOfDay = endDateTime.difference(startDateTime).inDays;
    startDateTime = DateTime(endDateTime.year, endDateTime.month, endDateTime.day, startDateTime.hour, startDateTime.minute);
    var numOfHour = endDateTime.difference(startDateTime).inHours;
    return numOfDay + Util.round0_5((numOfHour-1)/8);
  }

  double _getLeavesDayForDisplay(HolidayView holiday) {
    if (holiday.holidayType == HolidayView.TYPE_PERSONAL_LEAVE){
      return _calcLeavesDay(holiday.startDate, holiday.endDate);
    } else
      return holiday.numOfDay;
  }

  void _showDetails(HolidayView holiday) async {

    await _loadParam(GlobalParam.EMPLOYEE_ID);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context){
          return HolidayDetailsUI(
            selectedHoliday: holiday,
            holidayAPI: _holidayAPI,
            holidayParam: _holidayParam,
            userBusiness: _userBusiness,
          );
        })).then((value){
      switch(_lastSearch) {
        case "defaultSearch":
          _defaultSearch();
          break;
        case "lessSearch":
          _lessSearch();
          break;
        case "moreSearch":
          _moreSearch();
          break;
      }
        });
  }

  Widget _buildListItem(HolidayView holiday, bool isLastItem) {
    return InkWell(
      onTap: () {
        _showDetails(holiday);
      },
      child: Container(
          margin: EdgeInsets.only(left: 5, right: 5),
//          decoration: BoxDecoration(
//            border: isLastItem ? null : Border(
//              bottom: BorderSide(
//                  color: Color.fromRGBO(0, 0, 0, 1),
//                  width: 0.2
//              )
//            )
//          ),
          height: 60,
          child: Row(children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: 5),
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: STextStyle.GRADIENT_COLOR1,
                  )
                ),
                child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: SText(
                            '${Util.getShortDateTimeStr(holiday.startDate)}',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.black
                            ),
                          ),
                        ),
                        Flexible(
                          child: SText(
                            '${Util.getShortDateTimeStr(holiday.endDate)}',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.black
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(child: _buildItemContent(holiday)),
                ],
              )),
            ),
            Container(
              width: 70,
              alignment: Alignment.centerRight,
              child: _buildStatus(holiday)
            ),
          ]
          )),
    );
  }

  Widget _buildItemContent(HolidayView holiday){
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              if ( holiday.employeeId != GlobalParam.EMPLOYEE_ID)
                Flexible(
                  child: Text(
                    (holiday.account??'') + " - ",
                    maxLines: 1,
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              Flexible(
                child: Text(
                  HolidayUtil.getHolidayTypeName(holiday.holidayType)??'',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontStyle: FontStyle.italic
                  ),
                ),
              ),
            ],
          ),

          Row(
            children: <Widget>[
              SText(
                holiday.code??'',
                style: TextStyle(
                  fontSize: 10,
                ),
              ),

              SText(
                ' - (${_getLeavesDayForDisplay(holiday)} ${L10n.ofValue().dayInLowerCase} )',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                ),
              ),

              Flexible(
                child: Text(' - ' + holiday.content??'',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget _buildStatus(HolidayView h) {
    switch(h.status) {
      case HolidayView.STATUS_SUBMIT:
      case HolidayView.STATUS_APPROVED:
      case HolidayView.STATUS_HR:
        return Tooltip(
            message: L10n.ofValue().approve,
            child: _buildApproveStatus(h)
        );
      case HolidayView.STATUS_WAITING:
        return Tooltip(
            message: L10n.ofValue().submit,
            child: _buildApprovePendingStatus(h)
        );
      case HolidayView.STATUS_NEW:
        return Tooltip(
            message: L10n.ofValue().newStatus,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.new_releases, color: Colors.green),
                SText(
                  Util.getShortDateTimeStr(h.createdDate),
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ],
            )
        );
      case HolidayView.STATUS_REJECT:
        return Tooltip(
            message: L10n.ofValue().rejectStatus,
            child: Icon(Icons.arrow_back, color: Colors.grey)
        );
      case HolidayView.STATUS_CANCELED:
        return Tooltip(
            message: L10n.ofValue().cancel,
            child: Icon(Icons.cancel, color: Colors.red)
        );
    }
    return SText('${h.status}');
  }

  Widget _buildApproveStatus (HolidayView h) {
    var tempApprove = _getApprover(h);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              for (var i = 1; i <= tempApprove.item3; i++)
              Icon(
                Icons.check,
                color: Colors.blue,
                size: 16,
              ),
            ],
          ),
        ),
        Flexible(
          child: SText(
            tempApprove.item1,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        Flexible(
          child: SText(
            Util.getShortDateTimeStr(tempApprove.item2),
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }

  Widget _buildApprovePendingStatus (HolidayView h) {
    Tuple3<String, DateTime, int> submitter = _getSubmitter(h);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              for (var i = 0; i <= submitter.item3; i++)
              Icon(
                Icons.arrow_upward,
                color: Colors.orange,
                size: 16,
              ),
            ],
          ),
        ),
        Flexible(
          child: SText(
            submitter.item1??'',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        Flexible(
          child: SText(
            Util.getShortDateTimeStr(submitter.item2),
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }

  Tuple3<String, DateTime, int> _getApprover(HolidayView h) {
    if(h.approvalName3 != null)
      return Tuple3(h.approvalName3, h.approvalDate3, 3);
    if(h.approvalName2 != null)
      return Tuple3(h.approvalName2, h.approvalDate2, 2);
    if(h.approvalName1 != null)
      return Tuple3(h.approvalName1, h.approvalDate1, 1);
    return Tuple3('', null, 0);
  }

  Tuple3<String, DateTime, int> _getSubmitter(HolidayView h) {
    if(h.submitName3 != null)
      return Tuple3(h.submitName3, h.requestDate ?? h.createdDate , 3);
    if(h.submitName2 != null)
      return Tuple3(h.submitName2, h.requestDate ?? h.createdDate, 2);
    if(h.submitName1 != null)
      return Tuple3(h.submitName1, h.requestDate ?? h.createdDate, 1);

    return Tuple3(h.submitName0, h.requestDate ?? h.createdDate, 0);
  }
  String getBusinessCode(){
    return "hrm41";
  }
  @override
  void dispose() {
    super.dispose();
    _holidayViewStreamController.close();
  }


}