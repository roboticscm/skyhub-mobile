import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/global_function.dart';
import 'package:mobile/common/tuple.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/locale/r2.dart';
import 'package:mobile/modules/sales/request_po/request_po_api.dart';
import 'package:mobile/modules/sales/request_po/request_po_model.dart';
import 'package:mobile/modules/user_business/user_business_list_api.dart';
import 'package:mobile/modules/user_business/user_business_model.dart';
import 'package:mobile/widgets/data_widget/customer_auto_textfield.dart';
import 'package:mobile/widgets/data_widget/employee_split_name_dropdown.dart';
import 'package:mobile/widgets/data_widget/neighbour_employee_dropdown.dart';
import 'package:mobile/modules/inventory/request_inventory_out/request_inventory_out_api.dart';
import 'package:mobile/modules/inventory/request_inventory_out/request_inventory_out_model.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/system/menu/sub/sub_menu_model.dart';
import 'package:mobile/widgets/data_widget/customer_auto_complete.dart';
import 'package:mobile/widgets/data_widget/reqintout_type_dropdown.dart';
import 'package:mobile/widgets/data_widget/reqpo_status_dropdown.dart';
import 'package:mobile/widgets/data_widget/user_dropdown.dart';
import 'package:mobile/widgets/data_widget/year_dropdown.dart';
import 'package:mobile/widgets/scircular_progress_indicator.dart';
import 'package:mobile/widgets/scontainer.dart';
import 'package:mobile/widgets/shtml.dart';
import 'package:mobile/widgets/stext.dart';
import 'package:mobile/widgets/stext_form_field.dart';
import 'detail/reqpo_details_ui.dart';



class RequestPoUI extends StatefulWidget {
  final SubMenu menu;
  final IconData icon;
  const RequestPoUI({Key key, this.menu,this.icon}) : super(key: key);
  @override
  _RequestPoUIState createState() => _RequestPoUIState();
}

class _RequestPoUIState extends State<RequestPoUI> {
  IconData _moreLessIcon = Icons.expand_more;
  bool _showAdvancedSearch = false;
  var _contentTextController = TextEditingController();
  var _refNoTextController = TextEditingController();
  var _searchTextController = TextEditingController();
  var _itemCodeTextController = TextEditingController();
  List<int> _selectedStatus;
  List<int> _selectedType;
  int _selectedYear;
  RequestPoAPI _requestPoAPI = RequestPoAPI();
  var _RequestPoViewStreamController = StreamController<List<RequestPoView>>();
  int _totalRecord;
  int _selectedCustomerId;
  int _selectedEmpId;
  String _lastSearch = "defaultSearch";
  CustomerAutoTextField _customerAutoTextField;
  UserBusiness _userBusiness;
  var _userBusinessListAPI = UserBusinessListAPI();
  @override
  void initState() {
    super.initState();
    _selectedStatus = null;//[ReqinvoutStatusDropdown.STATUS_NEW, ReqinvoutStatusDropdown.STATUS_WAITING];
    _selectedYear = DateTime.now().year;
    _defaultSearch();
    _loadDataControl();
  }
  Future<void> _loadDataControl() async {
    _userBusiness =
    await _userBusinessListAPI.getUserBusinessWithUserIdAndBusiness(
        userId: GlobalParam.getUserId(), business: getBusinessCode());


  }
  Future<void> _defaultSearch() async {

    _lastSearch = "defaultSearch";
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _RequestPoViewStreamController.sink.add(null);
    var data = await _requestPoAPI.textSearch(
      defaultSearch: false,
      pageSize: 500,
      currentPage: 0,
      text: '',
      itemCode: '',
      userId: GlobalParam.USER_ID,
///      empId: _selectedEmpId,
      customerId: null,
      statusRange: [ReqPoStatusDropdown.STATUS_NEW, ReqPoStatusDropdown.STATUS_WAITING],
      reqTypeRange: null,
      yearRange: [DateTime.now().year],
    );

    _RequestPoViewStreamController.sink.add(data.item1 != null ? data.item1 : []);
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
    _RequestPoViewStreamController.sink.add(null);
    var data = await _requestPoAPI.textSearch(
      defaultSearch: false,
      pageSize: 500,
      currentPage: 0,
      text: _searchTextController.text.trim(),
      itemCode: '',
      userId: GlobalParam.USER_ID,
      empId: null,
      customerId: null,
      statusRange: null,
      //yearRange: [DateTime.now().year],
    );
    _RequestPoViewStreamController.sink.add(data.item1 != null ? data.item1 : []);
    if(mounted) {
      _totalRecord = data.item1?.length ?? 0;
      setState(() {
      });
    }
  }

  Future<void> _moreSearch() async {
    _lastSearch = "moreSearch";
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _RequestPoViewStreamController.sink.add(null);
    var data = await _requestPoAPI.textSearch(
      defaultSearch: false,
      pageSize: 500,
      currentPage: 0,
      text: '',
      itemCode: _itemCodeTextController.text.trim(),
      content: _contentTextController.text.trim(),
      refNo: _refNoTextController.text.trim(),
     // customerName: _customerAutoTextField.customerAutoTextFieldState.getSelectedText(),
      empId: _selectedEmpId,
      userId: GlobalParam.USER_ID,
      customerId: _selectedCustomerId,
      reqTypeRange: _selectedType,
      statusRange: _selectedStatus,
      yearRange: _selectedYear == null ? null : _selectedYear == -1 ? [DateTime.now().year-1, DateTime.now().year] : [_selectedYear],
    );
    _RequestPoViewStreamController.sink.add(data.item1 != null ? data.item1 : []);
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
      body: _buildUI(),
      floatingActionButton: _buildFloatingButton(),
      bottomNavigationBar: SContainer(
//        height: 25.0,
        color: STextStyle.GRADIENT_COLOR1,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SText(
            (_totalRecord ?? 0) > 0 ?
            '${_totalRecord == GlobalParam.PAGE_SIZE ? L10n.of(context).moreThan : ""} '
                '$_totalRecord ${ L10n.of(context).record}' : L10n.of(context).noRecordFound,
          style: TextStyle(color: STextStyle.LIGHT_TEXT_COLOR),
        )
      ),
    );
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
              Icon(FontAwesomeIcons.fileExport, color: STextStyle.LIGHT_TEXT_COLOR),
              Icon(_moreLessIcon, color: STextStyle.LIGHT_TEXT_COLOR)
            ],
          ),
        ),
        Flexible(
          child: _showAdvancedSearch ? Container(
            child: SText(
              R2.r(widget.menu.resourceKey)  + ' - ' + L10n.ofValue().advancedSearch,
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

  Widget _buildUI() {
    return Column(
      children: <Widget>[
        if(_showAdvancedSearch)
          _buildFilter(),
        Expanded(child: _buildList()),
      ],
    );
  }

  Widget _buildFilter() {
    return Container(
      //color: STextStyle.GRADIENT_COLOR1,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
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
                child: ReqPoStatusDropdown(
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
              FittedBox(
//                child: EmployeeSplitNameDropdown(
//                  width: 140,
//                  selectedId: _selectedEmpId,
//                  onChanged: (value) {
//                    _selectedEmpId = value;
//                  },
//                ),
                child: NeighbourEmployeeDropdown(
                  business: 'pur11',
                  width: 150,
                  selectedId: _selectedEmpId, onChanged: (value) {
                  _selectedEmpId = value;
                },),
              ),
             /* SizedBox(width: 10,),
              Flexible(
                child: ReqinvoutTypeDropdown(
                  smallWidget: false,
                  selectedId: _selectedType == null ? null :  _selectedType.join(","),
                  onChanged: (String value){
                    _selectedType = value == null ? null : value.split(",").map((str) => int.parse(str)).toList();
                  },
                ),
              ),*/

            ],
          ),
          Row(
            children: <Widget>[
              LimitedBox(
                maxWidth: 150,
                child: STextFormField(
                  controller: _itemCodeTextController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 6, top: 6),
                    hintText: L10n.ofValue().itemCode,
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Flexible(
                child: STextFormField(
                  controller: _contentTextController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 6, top: 6),
                    hintText: L10n.ofValue().content,
                  ),
                ),
              ),
            ],
          ),
         Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              /*Flexible(
                child: _customerAutoTextField = CustomerAutoTextField(
                  selectedId: _selectedCustomerId,
                  onChanged: (int value){
                    _selectedCustomerId = value;
                  },
                ),
              ),*/

              InkWell(
                onTap: () {
                  //if (_customerAutoTextField.customerAutoTextFieldState.getSelectedId() == null)
                  //  _selectedCustomerId = null;

                  _moreSearch();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Icon(Icons.search, size: 30),
                ),
              )
            ],
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

  Widget _buildList() {
    return StreamBuilder<List<RequestPoView>>(
      stream: _RequestPoViewStreamController.stream,
      builder: (BuildContext context, snapshot){
        if (snapshot.hasData)
          return _buildListView(snapshot.data);
        else
          return SCircularProgressIndicator.buildSmallCenter();
      }
    );
  }

  void _showDetails(RequestPoView item) async {
     RequestPoView requestPo ;
     if(item != null) {
       var tmpRequestPo = await _requestPoAPI.findReqPoById(item.id);
       if (tmpRequestPo != null) {
         requestPo = tmpRequestPo.item1[0] as RequestPoView;
         log2(requestPo);
       }
     }
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
      //ReqPoDetailsUI.reqPo = null;
      return ReqPoDetailsUI(
       // requestOrder: item,
        createNew: item == null? true :false,
        requestPoAPI: _requestPoAPI,
        reqPo: requestPo == null ? new RequestPoView():requestPo,
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

  Widget _buildListItemContent(RequestPoView item, int index) {
    var style = TextStyle(color: Colors.black, fontSize: 13);
    var dateStyle = style.merge(TextStyle(color: Colors.grey));
    var aprrover= _getApprover(item);

   // log2(item.code);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
       Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            LimitedBox(maxWidth: 150,
                child: SHtml(data: '${item.code??L10n.ofValue().noCode}', maxLines: 1, defaultTextStyle: style.merge(TextStyle(fontWeight: FontWeight.bold)),)),
            Flexible(
              child: Row(
                children: <Widget>[
                  ReqPoStatusDropdown.getStatusIcon(item.status, 15),
                  SText('  ${ReqPoStatusDropdown.getStatusName(item.status)} ${_getLevel(item)??''}',
                    style: style.merge(TextStyle(color: ReqPoStatusDropdown.getStatusColor(item.status))),),
                ],
              ),
            ),
            SText('  ${Util.getDateStr(item.createdDate)}', style: dateStyle,),
          ],
        ),
        Row(
          children: <Widget>[
            LimitedBox(
              maxWidth: 150,
              child: Row(children: <Widget>[
                Icon(Icons.label, size: 13,),
                SText(item.brand??""),
              ],),
            ),
            Flexible(child: SHtml(data: item.content, maxLines: 1,))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.userTie, size: 13,),
                Icon(Icons.border_color, size: 13,),
                SText('  ${item.creatorName}', style: style,),
              ],
            ),
            SText(' ${Util.getDateStr(item.createdDate)}', style: dateStyle,),
          ],
        ),
        if(item.requesterName != null)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.userTie, size: 13,),
                Icon(Icons.keyboard_tab, size: 13,),
                SText('  ${item.requesterName}', style: style,),
              ],
            ),
            SText(' ${Util.getDateStr(item.requestDate)}', style: dateStyle,),
          ],
        ),

        if(item.status == RequestPoView.STATUS_SUBMIT)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.check_circle, size: 13,),

                  SText('  ${item.approverName1}', style: style,),
                ],
              ),
              SText(' ${Util.getDateStr(item.approvalDate1)}', style: dateStyle,),
            ],
          ),
        if(item.status == RequestPoView.STATUS_PUR)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.check_circle, size: 13,),
                  Icon(Icons.check_circle, size: 13,),

                  SText('  ${item.approverName2}', style: style,),
                ],
              ),
              SText(' ${Util.getDateStr(item.approvalDate2)}', style: dateStyle,),
            ],
          ),
        if(item.status == RequestPoView.STATUS_APPROVED)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.check_circle, size: 13,),
                  Icon(Icons.check_circle, size: 13,),
                  Icon(Icons.check_circle, size: 13,),

                  SText('  ${item.approverName3}', style: style,),
                ],
              ),
              SText(' ${Util.getDateStr(item.approvalDate3)}', style: dateStyle,),
            ],
          ),

      ],
    );
  }
  Widget _buildListItem(RequestPoView item, int index) {
    return Container(
      margin: EdgeInsets.only(left: 5, top: 5, right: 5),
      padding: EdgeInsets.only(top: 2, right: 2, bottom: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              color: Colors.grey,
              width: 2
          )
      ),
      child: InkWell(
        onTap: () {
          _showDetails(item);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RotatedBox(
              quarterTurns: 3,
              child: SizedBox(
                child: Text(
                  '${index + 1}',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(width: 2,),
            Flexible(child: _buildListItemContent(item, index)),
          ],
        ),
      ),
    );
  }

  Tuple2<String, DateTime> _getApprover(RequestPoView item) {
  /*  if(item != null)
      return Tuple2(item.approvalName3, item.approvalDate3);
    if(item.approvalName2 != null)
      return Tuple2(item.approvalName2, item.approvalDate2);
    if(item.approvalName1 != null)
      return Tuple2(item.approvalName1, item.approvalDate1);
    return Tuple2('', null);*/
  }

  String _getLevel(RequestPoView item) {
    /*if(item.approvalName3 != null)
      return 'L3';
    if(item.approvalName2 != null)
      return 'L2';
    if(item.approvalName1 != null)
      return 'L1';*/
    return null;
  }

  Widget _buildListView(List<RequestPoView> list) {
    return ListView(
      children: <Widget>[
        for (var i = 0; i < list.length; i++)
          _buildListItem(list[i], i),
      ],
    );
  }

  String getBusinessCode(){
    return "pur11";
  }
  @override
  void dispose() {
    super.dispose();
    _RequestPoViewStreamController.close();
  }


}