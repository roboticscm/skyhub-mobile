import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/tuple.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/locale/r2.dart';
import 'package:mobile/modules/sales/quotation/details/quotation_details_ui.dart';
import 'package:mobile/modules/sales/quotation/quotation_api.dart';
import 'package:mobile/modules/sales/quotation/quotation_model.dart';
import 'package:mobile/modules/user_business/user_business_list_api.dart';
import 'package:mobile/modules/user_business/user_business_model.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/system/menu/sub/sub_menu_model.dart';
import 'package:mobile/widgets/data_widget/customer_auto_complete.dart';
import 'package:mobile/widgets/data_widget/customer_auto_textfield.dart';
import 'package:mobile/widgets/data_widget/employee_dropdown.dart';
import 'package:mobile/widgets/data_widget/employee_split_name_dropdown.dart';
import 'package:mobile/widgets/data_widget/generic_status_dropdown.dart';
import 'package:mobile/widgets/data_widget/neighbour_employee_dropdown.dart';
import 'package:mobile/widgets/data_widget/neighbour_user_dropdown.dart';
import 'package:mobile/widgets/data_widget/user_dropdown.dart';
import 'package:mobile/widgets/data_widget/year_dropdown.dart';
import 'package:mobile/widgets/scircular_progress_indicator.dart';
import 'package:mobile/widgets/scontainer.dart';
import 'package:mobile/widgets/shtml.dart';
import 'package:mobile/widgets/stext.dart';
import 'package:mobile/widgets/stext_form_field.dart';

class QuotationUI extends StatefulWidget {
  final SubMenu menu;

  const QuotationUI({Key key, this.menu}) : super(key: key);
  @override
  _QuotationUIState createState() => _QuotationUIState();
}

class _QuotationUIState extends State<QuotationUI> {
  IconData _moreLessIcon = Icons.expand_more;
  bool _showAdvancedSearch = false;
  var _contentTextController = TextEditingController();
  var _refNoTextController = TextEditingController();
  var _searchTextController = TextEditingController();
  List<int> _selectedStatus;
  int _selectedYear;
  QuotationAPI _quotationAPI = QuotationAPI();
  var _quotationViewStreamController = StreamController<List<QuotationView>>();
  int _totalRecord;
  int _selectedCustomerId;
  int _selectedEmpId = GlobalParam.EMPLOYEE_ID;
  CustomerAutoTextField _customerAutoTextField;
  UserBusiness userBusiness;

  @override
  void initState() {
    super.initState();
    _selectedStatus = [
      GenericStatusDropdown.STATUS_NEW,
      GenericStatusDropdown.STATUS_REJECT,
      GenericStatusDropdown.STATUS_WAITING,
      GenericStatusDropdown.STATUS_SUBMIT,
      GenericStatusDropdown.STATUS_MANAGER,
      GenericStatusDropdown.STATUS_FOLLOW_UP,
      GenericStatusDropdown.STATUS_APPROVED,
      GenericStatusDropdown.STATUS_SOLD
    ];
    _selectedYear = DateTime.now().year;
    _defaultSearch();
    _loadData();
  }
   Future <void> _loadData() async {

     userBusiness = await UserBusinessListAPI().getUserBusinessWithUserIdAndBusiness(
         userId: GlobalParam.getUserId(), business: "sle03");

   }

  Future<void> _defaultSearch() async {
    _quotationViewStreamController.sink.add(null);
    var data = await _quotationAPI.textSearch(
      defaultSearch: false,
      pageSize: 500,
      currentPage: 0,
      text: '',
      userId: GlobalParam.USER_ID,
//      empId: _selectedEmpId,
      customerId: null,
      statusRange: [QuotationView.STATUS_NEW, QuotationView.STATUS_WAITING],
//      yearRange: [DateTime.now().year],
    );
    _quotationViewStreamController.sink.add(data.item1 != null ? data.item1 : []);
    if(mounted) {
      _totalRecord = data.item1?.length ?? 0;
      setState(() {
      });
    }
  }

  Future<void> _lessSearch() async {
    if (_searchTextController.text.trim().length == 0) {
      _defaultSearch();
      return;
    }
    _quotationViewStreamController.sink.add(null);
    var data = await _quotationAPI.textSearch(
      defaultSearch: false,
      pageSize: 500,
      currentPage: 0,
      text: _searchTextController.text.trim(),
      userId: GlobalParam.USER_ID,
      empId: null,
      customerId: null,
      statusRange: [QuotationView.STATUS_NEW, QuotationView.STATUS_WAITING],
      //yearRange: [DateTime.now().year],
    );
    _quotationViewStreamController.sink.add(data.item1 != null ? data.item1 : []);
    if(mounted) {
      _totalRecord = data.item1?.length ?? 0;
      setState(() {
      });
    }
  }

  Future<void> _moreSearch() async {
    _quotationViewStreamController.sink.add(null);
    var data = await _quotationAPI.textSearch(
      defaultSearch: false,
      pageSize: 500,
      currentPage: 0,
      text: '',
      content: _contentTextController.text.trim(),
      refNo: _refNoTextController.text.trim(),
      customerName: _customerAutoTextField.customerAutoTextFieldState.getSelectedText(),
      empId: _selectedEmpId,
      userId: GlobalParam.USER_ID,
      customerId: _selectedCustomerId,
      statusRange: _selectedStatus,
      yearRange: _selectedYear == null ? null : _selectedYear == -1 ? [DateTime.now().year-1, DateTime.now().year] : [_selectedYear],
    );
    _quotationViewStreamController.sink.add(data.item1 != null ? data.item1 : []);
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
              Icon(FontAwesomeIcons.moneyCheckAlt, color: STextStyle.LIGHT_TEXT_COLOR),
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
                child: GenericStatusDropdown(
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
              ),
            ],
          ),
          Row(
            children: <Widget>[
              FittedBox(
                child: NeighbourEmployeeDropdown(selectedId: _selectedEmpId,
                  business: 'sle03',
                  onChanged: (value) {
                    _selectedEmpId = value;
                  },
                ),
              ),

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
              Flexible(child: _customerAutoTextField = CustomerAutoTextField(selectedId: _selectedCustomerId, onChanged: (int value){
                _selectedCustomerId = value;
              },)),

              InkWell(
                onTap: () {
                  _selectedCustomerId = _customerAutoTextField.customerAutoTextFieldState.getSelectedId();
                  print(_customerAutoTextField.customerAutoTextFieldState.getSelectedText());
                  print(_selectedCustomerId);
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
    return StreamBuilder<List<QuotationView>>(
      stream: _quotationViewStreamController.stream,
      builder: (BuildContext context, snapshot){
        if (snapshot.hasData)
          return _buildListView(snapshot.data);
        else
          return SCircularProgressIndicator.buildSmallCenter();
      }
    );
  }

  void _showDetails(QuotationView item) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
      return QuotationDetailsUI(
        quotation: item,
        quotationAPI: _quotationAPI,
        userBusiness: userBusiness,
      );
    }));
  }

  Widget _buildListItem(QuotationView item, int index) {
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

  Widget _buildListItemContent(QuotationView item, int index) {
    var style = TextStyle(color: Colors.black, fontSize: 13);
    var dateStyle = style.merge(TextStyle(color: Colors.grey));
    var empStyle = style.merge(TextStyle(color: STextStyle.GRADIENT_COLOR1));
    var aprrover= _getApprover(item);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.receipt, size: 13,),
                LimitedBox(maxWidth: 150, child: SHtml(data: ' &ensp;${item.code}', maxLines: 1, defaultTextStyle: style.merge(TextStyle(fontWeight: FontWeight.bold)),)),
              ],
            ),
            Flexible(
//              child: Row(
//                children: <Widget>[
//
//                  GenericStatusDropdown.getStatusIcon(item.status, 15),
//                  SText('  ${GenericStatusDropdown.getStatusName(item.status)} ${item.status == GenericStatusDropdown.STATUS_TIMEOUT ? '' : _getLevel(item)??''}',
//                    style: style.merge(TextStyle(color: GenericStatusDropdown.getStatusColor(item.status))),),
//                ],
//              ),
              child: _buildStatus(item),
            ),
            SText('  ${Util.getDateStr(item.quotationDate)}', style: dateStyle,),
          ],
        ),
        Row(
          children: <Widget>[
            Icon(FontAwesomeIcons.userSecret, size: 13,),
            Flexible(child: SHtml(data: '&ensp;${item.customerName}', maxLines: 1, defaultTextStyle: style,)),
          ],
        ),
        Row(
          children: <Widget>[
            Icon(FontAwesomeIcons.stickyNote, size: 13,),
            Flexible(child: SHtml(data: '&ensp;${item.content}', maxLines: 1, defaultTextStyle: style,)),
          ],
        ),
        Row(
          children: <Widget>[
            Icon(FontAwesomeIcons.userTie, size: 13, color: STextStyle.GRADIENT_COLOR1,),
            SText("  ${item.empName ?? ''}", style: empStyle,)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.userEdit, size: 13,),
                SText('  ${item.creatorName}', style: style,),
              ],
            ),
            SText(' ${Util.getDateStr(item.createdDate)}', style: dateStyle,),
          ],
        ),
        if (aprrover.item1.length > 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.userCheck, size: 13, color: GenericStatusDropdown.getStatusColor(GenericStatusDropdown.STATUS_APPROVED),),
                  SText('  ${aprrover.item1}', style: style.merge(TextStyle(fontWeight: FontWeight.bold, color: GenericStatusDropdown.getStatusColor(GenericStatusDropdown.STATUS_APPROVED))),),
                ],
              ),
              SText('${Util.getDateStr(aprrover.item2)}', style: dateStyle.merge(TextStyle(color: GenericStatusDropdown.getStatusColor(GenericStatusDropdown.STATUS_APPROVED)))),
            ],
          ),
      ],
    );
  }

  Widget _buildStatus(QuotationView item) {
    var style = TextStyle(color: Colors.black, fontSize: 13);
    var level = _getLevel(item);

    if ([GenericStatusDropdown.STATUS_APPROVED, GenericStatusDropdown.STATUS_MANAGER, GenericStatusDropdown.STATUS_SUBMIT].contains(item.status) ) {
      return Row(
        children: <Widget>[
          for(var i = 1; i <= level; i++)
            GenericStatusDropdown.getStatusIcon(item.status, 15),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          GenericStatusDropdown.getStatusIcon(item.status, 15),
          SText('  ${GenericStatusDropdown.getStatusName(item.status)} ${[GenericStatusDropdown.STATUS_NEW ,GenericStatusDropdown.STATUS_TIMEOUT].contains(item.status) ? '' : _getLevel(item)??''}',
            style: style.merge(TextStyle(color: GenericStatusDropdown.getStatusColor(item.status))),),
        ],
      );
    }
  }

  Tuple2<String, DateTime> _getApprover(QuotationView item) {
    if(item.approvalName3 != null)
      return Tuple2(item.approvalName3, item.approvalDate3);
    if(item.approvalName2 != null)
      return Tuple2(item.approvalName2, item.approvalDate2);
    if(item.approvalName1 != null)
      return Tuple2(item.approvalName1, item.approvalDate1);
    return Tuple2('', null);
  }

  int _getLevel(QuotationView item) {
    if(item.approvalName3 != null)
      return 3;
    if(item.approvalName2 != null)
      return 2;
    if(item.approvalName1 != null)
      return 1;
    return 0;
  }

  Widget _buildListView(List<QuotationView> list) {
    return ListView(
      children: <Widget>[
        for (var i = 0; i < list.length; i++)
          _buildListItem(list[i], i),
      ],
    );
  }


  @override
  void dispose() {
    super.dispose();
    _quotationViewStreamController.close();
  }


}