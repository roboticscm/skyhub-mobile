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
import 'package:mobile/widgets/data_widget/customer_auto_textfield.dart';
import 'package:mobile/widgets/data_widget/employee_split_name_dropdown.dart';
import 'package:mobile/widgets/data_widget/neighbour_employee_dropdown.dart';
import 'package:mobile/widgets/data_widget/reqintout_type_dropdown.dart';
import 'package:mobile/widgets/data_widget/reqinvout_status_dropdown.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/system/menu/sub/sub_menu_model.dart';
import 'package:mobile/widgets/data_widget/customer_auto_complete.dart';
import 'package:mobile/widgets/data_widget/user_dropdown.dart';
import 'package:mobile/widgets/data_widget/year_dropdown.dart';
import 'package:mobile/widgets/scircular_progress_indicator.dart';
import 'package:mobile/widgets/scontainer.dart';
import 'package:mobile/widgets/shtml.dart';
import 'package:mobile/widgets/stext.dart';
import 'package:mobile/widgets/stext_form_field.dart';

import 'details/inventory_out_details_ui.dart';
import 'inventory_out_api.dart';
import 'inventory_out_model.dart';

class InventoryOutUI extends StatefulWidget {
  final SubMenu menu;

  const InventoryOutUI({Key key, this.menu}) : super(key: key);
  @override
  _InventoryOutUIState createState() => _InventoryOutUIState();
}

class _InventoryOutUIState extends State<InventoryOutUI> {
  IconData _moreLessIcon = Icons.expand_more;
  bool _showAdvancedSearch = false;
  var _contentTextController = TextEditingController();
  var _refNoTextController = TextEditingController();
  var _searchTextController = TextEditingController();
  var _itemCodeTextController = TextEditingController();
  List<int> _selectedStatus;
  List<int> _selectedType;
  int _selectedYear;
  InventoryOutAPI _inventoryOutAPI = InventoryOutAPI();
  var _inventoryOutStreamController = StreamController<List<InventoryOutView>>();
  int _totalRecord;
  int _selectedCustomerId;
  int _selectedEmpId ;
  CustomerAutoTextField _customerAutoTextField;
  @override
  void initState() {
    super.initState();
    _selectedStatus = null;//[ReqinvoutStatusDropdown.STATUS_NEW, ReqinvoutStatusDropdown.STATUS_WAITING];
    _selectedEmpId = null;//GlobalParam.EMPLOYEE_ID;
    _selectedYear = DateTime.now().year;
    _defaultSearch();
  }

  Future<void> _defaultSearch() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _inventoryOutStreamController.sink.add(null);
    var data = await _inventoryOutAPI.textSearch(
      defaultSearch: false,
      pageSize: 500,
      currentPage: 0,
      text: '',
      itemCode: '',
      userId: GlobalParam.USER_ID,
      empId: null,
      customerId: null,
      statusRange: [ReqinvoutStatusDropdown.STATUS_NEW, ReqinvoutStatusDropdown.STATUS_WAITING],
      invTypeRange: null,
      yearRange: [DateTime.now().year],
    );
    _inventoryOutStreamController.sink.add(data.item1 != null ? data.item1 : []);
    if(mounted) {
      _totalRecord = data.item1?.length ?? 0;
      setState(() {
      });
    }
  }

  Future<void> _lessSearch() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (_searchTextController.text.trim().length == 0) {
      _defaultSearch();
      return;
    }
    _inventoryOutStreamController.sink.add(null);
    var data = await _inventoryOutAPI.textSearch(
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
    _inventoryOutStreamController.sink.add(data.item1 != null ? data.item1 : []);
    if(mounted) {
      _totalRecord = data.item1?.length ?? 0;
      setState(() {
      });
    }
  }

  Future<void> _moreSearch() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _inventoryOutStreamController.sink.add(null);


    if (NeighbourEmployeeDropdown.state.itemCount == 1)
      _selectedEmpId = GlobalParam.EMPLOYEE_ID;

    var data = await _inventoryOutAPI.textSearch(
      defaultSearch: false,
      pageSize: 500,
      currentPage: 0,
      text: '',
      itemCode: _itemCodeTextController.text.trim(),
      content: _contentTextController.text.trim(),
      refNo: _refNoTextController.text.trim(),
      customerName: _customerAutoTextField.customerAutoTextFieldState.getSelectedText(),
      userId: GlobalParam.USER_ID,
      empId: _selectedEmpId,
      customerId: _selectedCustomerId,
      invTypeRange: _selectedType,
      statusRange: _selectedStatus,
      yearRange: _selectedYear == null ? null : _selectedYear == -1 ? [DateTime.now().year-1, DateTime.now().year] : [_selectedYear],
    );
    _inventoryOutStreamController.sink.add(data.item1 != null ? data.item1 : []);
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
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1))
      ),
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
                child: ReqinvoutStatusDropdown(
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
                  business: 'inv04',
                  width: 150,
                  selectedId: _selectedEmpId, onChanged: (value) {
                  _selectedEmpId = value;
                },),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: ReqinvoutTypeDropdown(
                  width: 150,
                  smallWidget: false,
                  selectedId: _selectedType == null ? null :  _selectedType.join(","),
                  onChanged: (String value){
                    _selectedType = value == null ? null : value.split(",").map((str) => int.parse(str)).toList();
                    print(_selectedType);
                  },
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
                  _moreSearch();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Icon(Icons.search, size: 30),
                ),
              )
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
    return StreamBuilder<List<InventoryOutView>>(
        stream: _inventoryOutStreamController.stream,
        builder: (BuildContext context, snapshot){
          if (snapshot.hasData)
            return _buildListView(snapshot.data);
          else
            return SCircularProgressIndicator.buildSmallCenter();
        }
    );
  }

  void _showDetails(InventoryOutView item) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
      return InventoryOutDetailsUI(
        inventoryOut: item,
        inventoryOutAPI: _inventoryOutAPI,
      );
    }));
  }

  Widget _buildListItemContent(InventoryOutView item, int index) {
    var style = TextStyle(color: Colors.black, fontSize: 13);
    var dateStyle = style.merge(TextStyle(color: Colors.grey));
    var aprrover= _getApprover(item);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            LimitedBox(maxWidth: 150, child: SHtml(data: '${item.code??L10n.ofValue().noCode}', maxLines: 1, defaultTextStyle: style.merge(TextStyle(fontWeight: FontWeight.bold)),)),
            Flexible(
              child: Row(
                children: <Widget>[
                  ReqinvoutStatusDropdown.getStatusIcon(item.status, 15),
                  SText('  ${ReqinvoutStatusDropdown.getStatusName(item.status)} ${_getLevel(item)??''}',
                    style: style.merge(TextStyle(color: ReqinvoutStatusDropdown.getStatusColor(item.status))),),
                ],
              ),
            ),
            SText('  ${Util.getDateStr(item.requestDate)}', style: dateStyle,),
          ],
        ),
        Row(
          children: <Widget>[
            LimitedBox(
              maxWidth: 150,
              child: Row(children: <Widget>[
                Icon(Icons.category, size: 13,),
                SText('  ' + ReqinvoutTypeDropdown.getTypeName(item.inventoryType)),
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
                SText('  ${item.requesterName}', style: style,),
              ],
            ),
            SText(' ${Util.getDateStr(item.requestDate)}', style: dateStyle,),
          ],
        ),
        if (aprrover.item1.length > 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.userCheck, size: 13, color: ReqinvoutStatusDropdown.getStatusColor(ReqinvoutStatusDropdown.STATUS_APPROVED),),
                  SText('  ${item.stockerName}', style: style.merge(TextStyle(fontWeight: FontWeight.bold, color: ReqinvoutStatusDropdown.getStatusColor(ReqinvoutStatusDropdown.STATUS_APPROVED))),),
                ],
              ),
              SText('${Util.getDateStr(aprrover.item2)}', style: dateStyle.merge(TextStyle(color: ReqinvoutStatusDropdown.getStatusColor(ReqinvoutStatusDropdown.STATUS_APPROVED)))),
            ],
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.userSecret, size: 13,),
                LimitedBox(maxWidth: Util.getScreenWidth()-60, child: SHtml(data: '  &ensp;${item.partnerName}', maxLines: 1, defaultTextStyle: style)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildListItem(InventoryOutView item, int index) {

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

  Tuple2<String, DateTime> _getApprover(InventoryOutView item) {
    if(item.approvalName3 != null)
      return Tuple2(item.approvalName3, item.approvalDate3);
    if(item.approvalName2 != null)
      return Tuple2(item.approvalName2, item.approvalDate2);
    if(item.approvalName1 != null)
      return Tuple2(item.approvalName1, item.approvalDate1);
    return Tuple2('', null);
  }

  String _getLevel(InventoryOutView item) {
    if(item.approvalName3 != null)
      return 'L3';
    if(item.approvalName2 != null)
      return 'L2';
    if(item.approvalName1 != null)
      return 'L1';
    return null;
  }

  Widget _buildListView(List<InventoryOutView> list) {
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
    _inventoryOutStreamController.close();
  }


}