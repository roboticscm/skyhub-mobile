import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/constant.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/inventory/inventory_model.dart';
import 'package:mobile/modules/inventory/search/inventory_search_ui.dart';
import 'package:mobile/modules/notification/task_approve_submit/task_approve_submit_list_api.dart';
import 'package:mobile/modules/sales/quotation/quotation_model.dart';
import 'package:mobile/modules/sales/quotation/quotation_util.dart';
import 'package:mobile/modules/sales/request_po/detail/reqpo_details_ui.dart';
import 'package:mobile/modules/sales/request_po/request_po_api.dart';
import 'package:mobile/modules/sales/request_po/request_po_model.dart';
import 'package:mobile/modules/user_business/user_business_list_api.dart';
import 'package:mobile/modules/user_business/user_business_model.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/system/loader/data.dart';
import 'package:mobile/system/loader/model.dart';
import 'package:mobile/widgets/data_widget/customer_auto_complete.dart';
import 'package:mobile/widgets/data_widget/customer_auto_textfield.dart';
import 'package:mobile/widgets/data_widget/employee_dropdown.dart';
import 'package:mobile/widgets/data_widget/partner_type_dropdown.dart';
import 'package:mobile/widgets/data_widget/supplier_auto_complete.dart';
import 'package:mobile/widgets/data_widget/warehouse_details_dropdown.dart';
import 'package:mobile/widgets/data_widget/warehouse_dropdown.dart';
import 'package:mobile/widgets/particular/approve_button.dart';
import 'package:mobile/widgets/particular/cancel_approve_button.dart';
import 'package:mobile/widgets/particular/cancel_submit_button.dart';
import 'package:mobile/widgets/particular/order_request_button.dart';
import 'package:mobile/widgets/particular/sedit_button.dart';
import 'package:mobile/widgets/particular/ssave_button.dart';
import 'package:mobile/widgets/particular/submit_button.dart';
import 'package:mobile/widgets/scircular_progress_indicator.dart';
import 'package:mobile/widgets/sdatetime_picker_formfield.dart';
import 'package:mobile/widgets/sdialog.dart';
import 'package:mobile/widgets/shtml.dart';
import 'package:mobile/widgets/stext.dart';
import 'package:mobile/widgets/stext_field.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';

import 'package:mobile/widgets/data_widget/reqintout_type_dropdown.dart';
import 'package:mobile/widgets/data_widget/reqinvout_status_dropdown.dart';
import '../request_inventory_out_api.dart';
import '../request_inventory_out_model.dart';

class ReqinvoutDetailsUI extends StatefulWidget {
  RequestInventoryOutView requestInventoryOut;
  final RequestInventoryOutAPI requestInventoryOutAPI;
  final QuotationView quotation;
  final List<QuotationItemView> quotationItemList;
  final bool isFullControl;
  final UserBusiness userBusiness;

  ReqinvoutDetailsUI({
    Key key,
    this.requestInventoryOut,
    this.requestInventoryOutAPI,
    this.quotation,
    this.quotationItemList,
    this.userBusiness,
    this.isFullControl = true,
  }) : super(key: key);
  @override
  _ReqinvoutDetailsUIState createState() => _ReqinvoutDetailsUIState();
}

class _ReqinvoutDetailsUIState extends State<ReqinvoutDetailsUI> {
  var _notesTextController = TextEditingController();

  List<Warehouse> _subWarehouseList;

  RequestInventoryOutView _requestInventoryOut;
  bool _isEditing = false;
  QuotationView get _quotation => widget.quotation;
  StreamController<List<RequestInventoryOutItemView>> _reqinvoutItemStreamController = StreamController.broadcast();
  StreamController<bool> _saveOrUpdateStreamController = StreamController.broadcast();
  List<RequestInventoryOutItemView> _list;
  List<TextEditingController> _quantityTextControllers;
  List<TextEditingController> _notesTextControllers;
  List<TextEditingController> _limitDateTextControllers;
  List<DateTime> _limitDates;
  List<int> _stockQties;
  List<int> _waitingOutQties;
  List<String> _itemCodes;
  List<String> _itemNames;
  List<int> _itemIds;

  var _customerNameTextController = TextEditingController();
  var _contentTextController = TextEditingController();
  var _requestDateTextController = TextEditingController();

  var _refNoTextController = TextEditingController();
  var _contactNameTextController = TextEditingController();
  var _contactPhoneTextController = TextEditingController();

  var _tableBorder = TableBorder.all(color: Colors.grey, width: 0.2);
  List <int> _selectedReqinvoutType;
  int _selectedWarehouseId;
  List<int> _selectedWarehouseDetailsIds ;
  int _selectedPartnerId;
  String _selectedPartnerTypeId;
  DateTime _requestDate;

  List<int> _deleteReqinvoutItemIds;
  bool _draggable = false;
  bool get _isFullControl => widget.isFullControl;
  UserBusiness _userBusiness;

  @override
  void initState() {
    super.initState();
    _requestInventoryOut = widget.requestInventoryOut;
    _userBusiness = widget.userBusiness;
    _init();

  }

  Future<void> _init() async {
    _list=[];
    _quantityTextControllers = [];
    _notesTextControllers = [];
    _limitDateTextControllers = [];
    _limitDates = [];
    _stockQties = [];
    _waitingOutQties = [];
    _itemCodes = [];
    _itemNames = [];
    _itemIds = [];
    _selectedWarehouseDetailsIds = [];
    _deleteReqinvoutItemIds = [];

    if (_requestInventoryOut != null) {
      _customerNameTextController.text = (_requestInventoryOut.partnerName??'').replaceAll('<mark>', '').replaceAll("</mark>", '');
      _contentTextController.text = (_requestInventoryOut.content??'').replaceAll('<mark>', '').replaceAll("</mark>", '');
      _requestDateTextController.text = _dateToString(_requestInventoryOut.requestDate, DateFormat.yMd());
      _requestDate = _requestInventoryOut.requestDate;
      _refNoTextController.text = (_requestInventoryOut.code??'').replaceAll('<mark>', '').replaceAll("</mark>", '');
      _selectedReqinvoutType = [_requestInventoryOut.requestType];
      _selectedPartnerId = _requestInventoryOut.partnerId;
      _selectedPartnerTypeId = _requestInventoryOut.partnerType;
      _notesTextController.text = _requestInventoryOut.notes;
      _contactNameTextController.text = _requestInventoryOut.contactName;
      _contactPhoneTextController.text = _requestInventoryOut.contactPhone;
      _selectedWarehouseId = _requestInventoryOut.warehouseId;
      _subWarehouseList = await widget.requestInventoryOutAPI.findWarehouseByParentId(_selectedWarehouseId??0);
      await _loadData();

    } else if (_quotation != null) {//from quotation
      _customerNameTextController.text = (_quotation.customerName??'').replaceAll('<mark>', '').replaceAll("</mark>", '');
      _contentTextController.text = (_quotation.content??'').replaceAll('<mark>', '').replaceAll("</mark>", '');
      _requestDateTextController.text = _dateToString(_quotation.quotationDate, DateFormat.yMd());
      _refNoTextController.text = '';
      _notesTextController.text = '';
      _contactNameTextController.text = '';
      _contactPhoneTextController.text = '';
      _selectedWarehouseId = null;
      _selectedReqinvoutType = [ReqinvoutTypeDropdown.TYPE_SALES];
      _requestDate = DateTime.now();
      _selectedPartnerTypeId = PartnerTypeDropdown.CUSTOMER;
      _selectedPartnerId = _quotation.customerId;

      _list = _convertQuotationItemToReqinvoutItem(widget.quotationItemList);
      _buildDataList();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _reqinvoutItemStreamController.sink.add(_list);

      });
    } else {//add new
      _selectedReqinvoutType = [ReqinvoutTypeDropdown.TYPE_SALES];
      _requestDate = DateTime.now();
      _selectedPartnerTypeId = PartnerTypeDropdown.CUSTOMER;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onAddItem();

      });
    }


  }

  bool _isOwner() {
    if (_requestInventoryOut != null) {
      return ([_requestInventoryOut.requesterId].contains(GlobalParam.EMPLOYEE_ID)
        || [_requestInventoryOut.createdId].contains(GlobalParam.USER_ID));
    } else
      return true;
  }

  List<RequestInventoryOutItemView> _convertQuotationItemToReqinvoutItem(List<QuotationItemView> q) {
    return q.map((item) => RequestInventoryOutItemView(
      itemId: item.itemId,
      itemCode: item.itemCode,
      itemName: item.itemName,
      qty: item.qty,
      stock: item.stock
    )).toList();
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

  Future<void> _loadData() async {

    var ret = await widget.requestInventoryOutAPI.findRequestInventoryOutItem(reqInvOutId: _requestInventoryOut.id);


    if(ret.item1 != null) {
      _list = ret.item1;
      _buildDataList();

      _reqinvoutItemStreamController.sink.add(_list);

    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onAddItem();
      });
      _reqinvoutItemStreamController.sink.add([]);
      Toast.show(ret.item2, GlobalParam.appContext);
    }
  }

  static DateTime getLimitDate(int type) {
    if (type == null || type == ReqinvoutTypeDropdown.TYPE_SALES)
      return DateTime.now().add(Duration(days: GlobalData.functionalParam.saleLimitDay));
    else
      return DateTime.now().add(Duration(days: GlobalData.functionalParam.otherLimitDay));
  }

  void _buildDataList() {
    for(var i = 0 ; i < _list.length; i++) {
      _itemCodes.add('${_list[i].itemCode??""}');
      _itemNames.add('${_list[i].itemName??""}');
      _itemIds.add(null);
      _quantityTextControllers.add(TextEditingController(text: '${_list[i].qty??0}'));
      if (_quotation != null) {
        _limitDateTextControllers.add(TextEditingController(text: _dateToString(getLimitDate(ReqinvoutTypeDropdown.TYPE_SALES), DateFormat.yMd())));
        _limitDates.add(getLimitDate(ReqinvoutTypeDropdown.TYPE_SALES));
      } else {
        _limitDateTextControllers.add(TextEditingController(text: _dateToString(_list[i].limitDate, DateFormat.yMd())));
        _limitDates.add(_list[i].limitDate);
      }
      _limitDateTextControllers.add(TextEditingController(text: _dateToString(_list[i].limitDate, DateFormat.yMd())));
      _limitDates.add(_list[i].limitDate);
      _notesTextControllers.add(TextEditingController(text: _list[i].notes??''));
      _stockQties.add(_list[i].stock??0);
      //TODO
      _waitingOutQties.add(_list[i].otherWaitingOutQty??0);
      _selectedWarehouseDetailsIds.add(_list[i].warehouseId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottom()
    );
  }

  void _onAddItem({int index}) {
    if(index != null){
      _list.insert(index+1, RequestInventoryOutItemView());
      _itemIds.insert(index+1, null);
      _itemCodes.insert(index+1, L10n.ofValue().itemCode);
      _itemNames.insert(index+1, L10n.ofValue().itemName);
      _quantityTextControllers.insert(index+1, TextEditingController(text: '0'));
      _limitDateTextControllers.insert(index+1, TextEditingController(text: _dateToString(getLimitDate(_selectedReqinvoutType != null ?_selectedReqinvoutType[0] : null), DateFormat.yMd())));
      _notesTextControllers.insert(index+1, TextEditingController());
      _stockQties.insert(index+1, 0);
      _limitDates.insert(index+1, getLimitDate(_selectedReqinvoutType != null ?_selectedReqinvoutType[0] : null));
      _waitingOutQties.insert(index+1, 0);
      _selectedWarehouseDetailsIds.insert(index+1, null);
    } else {
      _list.add(RequestInventoryOutItemView());
      _itemIds.add(null);
      _itemCodes.add(L10n.ofValue().itemCode);
      _itemNames.add(L10n.ofValue().itemName);
      _quantityTextControllers.add(TextEditingController(text: '0'));
      _limitDateTextControllers.add(TextEditingController(text: _dateToString(getLimitDate(_selectedReqinvoutType != null ?_selectedReqinvoutType[0] : null), DateFormat.yMd())));
      _notesTextControllers.add(TextEditingController());
      _stockQties.add(0);
      _limitDates.add(getLimitDate(_selectedReqinvoutType != null ?_selectedReqinvoutType[0] : null));
      _waitingOutQties.add(0);
      _selectedWarehouseDetailsIds.add(null);
    }

    _reqinvoutItemStreamController.sink.add(_list);
  }

  RequestInventoryOutView _bindingData() {
    int customerId;
    int employeeId;
    int supplierId;
    String partnerName;

    switch(_selectedPartnerTypeId) {
      case PartnerTypeDropdown.CUSTOMER:
        customerId = _selectedPartnerId;
        partnerName = GlobalData.getCustomerName(customerId);
        break;
      case PartnerTypeDropdown.SUPPLIER:
        supplierId = _selectedPartnerId;
        partnerName = GlobalData.getSupplierName(supplierId);
        break;
      case PartnerTypeDropdown.EMPLOYEE:
        employeeId = _selectedPartnerId;
        partnerName = GlobalData.getEmpName(employeeId);
        break;
    }

    int quotationId = null;
    String fromBusinessCode = null;
    int fromBusinessId = null;
    if(_requestInventoryOut!= null)
      {
        if(_requestInventoryOut.quotationId != null){
          quotationId = _requestInventoryOut.quotationId;
          fromBusinessId = _requestInventoryOut.fromBusinessId;
          fromBusinessCode = "sle03";
        }

      }
    else{
      if(widget.quotation != null){
        quotationId = widget.quotation.id;
        fromBusinessId = widget.quotation.id;
        fromBusinessCode = "sle03";
      }
    }
    return RequestInventoryOutView(
      id: _requestInventoryOut != null ? _requestInventoryOut.id : null,
      code: _refNoTextController.text.trim().length > 0 ? _refNoTextController.text.trim() : null,
      requesterId: _requestInventoryOut != null ? _requestInventoryOut.requesterId : GlobalParam.EMPLOYEE_ID,
      requestType: _selectedReqinvoutType[0],
      requestDate: _requestDate,
      content: _contentTextController.text.trim(),
      partnerType: _selectedPartnerTypeId,
      partnerId: _selectedPartnerId,
      companyId: GlobalParam.COMPANY_ID,
      branchId: GlobalParam.BRANCH_ID,
      deleted: _requestInventoryOut != null ? _requestInventoryOut.deleted : 0,
      deletedId: _requestInventoryOut != null ? _requestInventoryOut.deletedId : null,
      createdId: _requestInventoryOut != null ? _requestInventoryOut.createdId : GlobalParam.USER_ID,
      updatedId: _requestInventoryOut != null ? _requestInventoryOut.updatedId : GlobalParam.USER_ID,
      createdDate: _requestInventoryOut != null ? _requestInventoryOut.createdDate : DateTime.now(),
      updatedDate: DateTime.now(),
      warehouseId: _selectedWarehouseId,
      deletedDate: _requestInventoryOut != null ? _requestInventoryOut.deletedDate : null,

      supplierId: supplierId,
      customerId: customerId,
      employeeId: employeeId,
      partnerName: partnerName,
      sumQty: _sumQty("qty").toDouble(),
      status: _requestInventoryOut != null ? _requestInventoryOut.status :  ReqinvoutStatusDropdown.STATUS_NEW,
      notes: _notesTextController.text.trim(),
      contactName: _contactNameTextController.text.trim(),
      contactPhone: _contactPhoneTextController.text.trim(),
      quotationId:quotationId,
      fromBusinessId:fromBusinessId,
      fromBusinessCode:fromBusinessCode,
    );
  }

  Widget _buildBottom() {

    return StreamBuilder<Object>(
        stream: _reqinvoutItemStreamController.stream,
        builder: (context, snapshot) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(
                        color: STextStyle.GRADIENT_COLOR1,
                        width: 1
                    ))
                ),
                alignment: Alignment.centerRight,
                height: 30,
                width: double.infinity,
                child: Row(
                  children: <Widget>[

                    Expanded(
                      child: Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        columnWidths: {0: FixedColumnWidth(40)},
                        border: _tableBorder,
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                child: SizedBox(
                                  width: 40,
                                  child: Text('\u03A3', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  height: 30,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 4),
                                  child: SText('${_sumQty("qty")}',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: QuotationUtil.getQtyColor("qty"),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  height: 30,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 4),
                                  child: SText('${_sumQty("stockQty")}',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: QuotationUtil.getQtyColor("stockQty"),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  height: 30,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 4),
                                  child: SText('${_sumQty("waitingOutQty")}',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color:  QuotationUtil.getQtyColor("waitingOutQty"),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 55,
                color: STextStyle.GRADIENT_COLOR1,
                child: Row(
                  children: <Widget>[
                    if(!_isEditing && _isOwner() &&  (_requestInventoryOut == null || _requestInventoryOut.status == RequestInventoryOutView.STATUS_NEW))
                      SEditButton(
                        color: Colors.white,
                        onTap: () {
                          _isEditing = true;
                          setState(() {

                          });
                        },
                      ),
                    if(_isEditing && _isOwner() && (_requestInventoryOut == null || _requestInventoryOut.status == RequestInventoryOutView.STATUS_NEW))
                      SSaveButton(
                        progressStream: _saveOrUpdateStreamController.stream,
                        isSaveMode: _requestInventoryOut != null ? false : true,
                        color: Colors.white,
                        onTap: () {
                          _onSaveOrUpdate(_bindingData());
                        },
                      ),
                    Spacer(),
                    //if(_isOwner())
                      OrderRequestButton(onTap : () async {
                        //Toast.show(L10n.ofValue().underConstruction, context);
                        if (!_validateRequestInventoryOut())
                          return;
                        UserBusiness userBusinessReqPo = await UserBusinessListAPI().getUserBusinessWithUserIdAndBusiness(
                            userId: GlobalParam.getUserId(), business: "pur11");
                        if(userBusinessReqPo == null) return;
                        RequestPoAPI requestPoAPI = new RequestPoAPI();
                        RequestPoView reqPo = new  RequestPoView() ;
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                          return ReqPoDetailsUI(
                            requestPoAPI: requestPoAPI,
                            reqPo: reqPo,
                            userBusiness: userBusinessReqPo,
                           requestInventoryOut: _requestInventoryOut,
                            requestInventoryOutItemList: _list,

                          );
                        }));

                      },),
                    if(roleControl("cbSubmit")== true)
                    SubmitButton(
                      onTap: (){
                        _onSubmit();
                      },
                      color: Colors.white,
                      onAskMessage: () {
                        return '${L10n.ofValue().submit} <b>${_requestInventoryOut.code}</b>. ${L10n.ofValue().areYouSure}?';
                      },
                    ),
                    if(roleControl("cbCancelSubmit")== true)
                    CancelSubmitButton(
                      onTap: (){
                        _onCancelSubmit();
                      },
                      color: Colors.white,
                      onAskMessage: () {
                        return '${L10n.ofValue().submit} <b>${_requestInventoryOut.code}</b>. ${L10n.ofValue().areYouSure}?';
                      },
                    ),
                    if(roleControl("cbApprove")== true)
                    ApproveButton(
                      onTap: (){
                        _onApprove();
                      },
                      color: Colors.white,
                      onAskMessage: () {
                        return '${L10n.ofValue().approve} <b>${_requestInventoryOut.code}</b>. ${L10n.ofValue().areYouSure}?';
                      },
                    ),
                    if(roleControl("cbCancelApprove")== true)
                    CancelApproveButton(
                      onTap: (){
                        _onCancelApprove();
                      },
                      color: Colors.white,
                      onAskMessage: () {
                        return '${L10n.ofValue().approve} <b>${_requestInventoryOut.code}</b>. ${L10n.ofValue().areYouSure}?';
                      },
                    ),
                  ],
                ),
              ),
            ],
          );

        }
    );
  }

  void _onSubmit() {
    var _taskApproveSubmitListAPI = TaskApproveSubmitListAPI();
    _taskApproveSubmitListAPI
        .doApproveSubmitWithUserIdAndGroupIdAndSourceIdAndTask(
        userId: GlobalParam.USER_ID,
        groupId: 6,
        sourceId: _requestInventoryOut.id,
        task: 1 ).then((response) async {
      //_loadData();
      if(response.status.toString() == "success"){
        int submit = json.decode(response.updateObject)["submit"];
        int status = json.decode(response.updateObject)["status"];

        _requestInventoryOut.submit = submit;
        _requestInventoryOut.status = status;

        setState(() {
        });
        if(response.message.length >0)SDialog.alert("",response.message);
      }
      else{

        int submit = json.decode(response.updateObject)["submit"];
        int status = json.decode(response.updateObject)["status"];

        _requestInventoryOut.submit = submit;
        _requestInventoryOut.status = status;
       // await _init();
        setState(() {
        });
        SDialog.alert("",response.message);
      }

    });
  }

  void _onCancelSubmit() {
    var _taskApproveSubmitListAPI = TaskApproveSubmitListAPI();
    _taskApproveSubmitListAPI
        .doApproveSubmitWithUserIdAndGroupIdAndSourceIdAndTask(
        userId: GlobalParam.USER_ID,
        groupId: 6,
        sourceId: _requestInventoryOut.id,
        task: 2 ).then((response) {
      //_loadData();
      if(response.status.toString() == "success"){
        int submit = json.decode(response.updateObject)["submit"];
        int status = json.decode(response.updateObject)["status"];
        _requestInventoryOut.submit = submit;
        _requestInventoryOut.status = status;
        setState(() {
        });
        if(response.message.length >0)SDialog.alert("",response.message);
      }
      else{
        int submit = json.decode(response.updateObject)["submit"];
        int status = json.decode(response.updateObject)["status"];
        _requestInventoryOut.submit = submit;
        _requestInventoryOut.status = status;
        setState(() {
        });
        SDialog.alert("",response.message);
      }

    });
  }

  void _onApprove() {

    var _taskApproveSubmitListAPI = TaskApproveSubmitListAPI();
    _taskApproveSubmitListAPI
        .doApproveSubmitWithUserIdAndGroupIdAndSourceIdAndTask(
        userId: GlobalParam.USER_ID,
        groupId: 6,
        sourceId: _requestInventoryOut.id,
        task: 3 ).then((response) {

      if(response.status.toString() == "success"){

        int submit = json.decode(response.updateObject)["submit"];
        int status = json.decode(response.updateObject)["status"];
        _requestInventoryOut.submit = submit;
        _requestInventoryOut.status = status;
        setState(() {

        });
        if(response.message.length >0)SDialog.alert("",response.message);
      }
      else{
        int submit = json.decode(response.updateObject)["submit"];
        int status = json.decode(response.updateObject)["status"];
        _requestInventoryOut.submit = submit;
        _requestInventoryOut.status = status;
        setState(() {

        });
        SDialog.alert("",response.message);
      }

    });


  }
  void _onCancelApprove() {

    var _taskApproveSubmitListAPI = TaskApproveSubmitListAPI();
    _taskApproveSubmitListAPI
        .doApproveSubmitWithUserIdAndGroupIdAndSourceIdAndTask(
        userId: GlobalParam.USER_ID,
        groupId: 6,
        sourceId: _requestInventoryOut.id,
        task: 4 ).then((response) {

      if(response.status.toString() == "success"){
        int submit = json.decode(response.updateObject)["submit"];
        int status = json.decode(response.updateObject)["status"];

        _requestInventoryOut.submit = submit;
        _requestInventoryOut.status = status;
        setState(() {


        });
        if(response.message.length >0)SDialog.alert("",response.message);
      }
      else{
        int submit = json.decode(response.updateObject)["submit"];
        int status = json.decode(response.updateObject)["status"];

        _requestInventoryOut.submit = submit;
        _requestInventoryOut.status = status;
        setState(() {


        });
        SDialog.alert("",response.message);
      }

    });


  }
  bool _isQtyValid(String text) {
    var test ;
    try {
      test = int.tryParse(text);
    }
    catch(e){
      print(e);
    }
    return  test != null && test > 0;
  }

  bool _validateInput() {
    for(var i = 0; i < _list.length; i++) {
      if (_list[i].itemId == null) {
        Toast.show(L10n.ofValue().youMustSelectItemAtLine + ' ${(i + 1)}', context);
        return false;
      }

      if (!_isQtyValid(_quantityTextControllers[i].text.trim())) {
        Toast.show(L10n.ofValue().quantity + " " + L10n.ofValue().atLine + " ${(i + 1)} " + L10n.ofValue().isInvalid, context);
        return false;
      }

      ///TODO validate Limit Date
    }
    return true;
  }

  List<RequestInventoryOutItemView> _bindingDataList(int reqInvOutId) {
    for(var i = 0; i < _list.length; i ++) {
//      if(_list[i].itemId == null)
//        continue;

      _list[i].reqInventoryOutId ??= reqInvOutId;
      _list[i].notes = _notesTextControllers[i].text.trim();
      try {
        _list[i].qty = int.tryParse(_quantityTextControllers[i].text.trim());
      }
      catch(e){
        print(e);
      }
      _list[i].limitDate = _limitDates[i];
      _list[i].createdId ??= GlobalParam.USER_ID;
      _list[i].employeeId ??= GlobalParam.EMPLOYEE_ID;
      _list[i].updatedId = GlobalParam.USER_ID;
      _list[i].updatedDate = DateTime.now();
      _list[i].warehouseId = _selectedWarehouseDetailsIds[i];
      _list[i].sort = i;
      _list[i].status  = _list[i].status == null ? ReqinvoutStatusDropdown.STATUS_NEW : _list[i].status;
    }
    return _list;
  }

  int _getCreatorId() {


    if (widget.requestInventoryOut != null)
      return widget.requestInventoryOut.requesterId;

    if(widget.quotation != null)
      return widget.quotation.creatorId;

    return null;
  }
  void _onSaveOrUpdateItem(List<RequestInventoryOutItemView> list) async {
    List<int> itemIds = List.from(list.map((item)=>item.itemId));
    List<RequestInventoryOutItemWaiting> waitingList = await widget.requestInventoryOutAPI.findOtherWaitingOutQtyOfItemDetails(
        empId: _getCreatorId(),
        ///TODO
        statusRange: [ReqinvoutStatusDropdown.STATUS_WAITING],
        itemIdRange: itemIds
    );

    if(_deleteReqinvoutItemIds.length > 0) {
      widget.requestInventoryOutAPI.deleteItemByIds(userId: GlobalParam.USER_ID, ids: _deleteReqinvoutItemIds).then((value){
        if(value.item1==null) {
          _saveOrUpdateStreamController.sink.add(false);
          Toast.show(value.item2, context);

          print(value.item2);
        } else {
          widget.requestInventoryOutAPI.saveOrUpdateItem(list).then((value) async{
            if (value.item1 == null) {
              Toast.show(value.item2, context);
            } else {
              await _init();
              setState(() {

              });
              _saveOrUpdateStreamController.sink.add(false);
              SDialog.customAlert(L10n.ofValue().reqInventoryOut, _buildWaitingSockMessage(waitingList));
            }
          });
        }
      });
    } else {
      widget.requestInventoryOutAPI.saveOrUpdateItem(list).then((value) async{
        if (value.item1 == null) {
          _saveOrUpdateStreamController.sink.add(false);
          Toast.show(value.item2, context);
          print('..................................');
          print(value.item2);
        } else {
          await _init();
          setState(() {

          });
          _saveOrUpdateStreamController.sink.add(false);
          SDialog.customAlert(L10n.ofValue().reqInventoryOut, _buildWaitingSockMessage(waitingList));
        }
      });
    }
  }

  Widget _buildWaitingSockMessage(List<RequestInventoryOutItemWaiting> waitingList) {
    var headerStyle = TextStyle();
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
//        SText(L10n.ofValue().saveOrUpdateSuccess, style: TextStyle(fontWeight: FontWeight.bold)),
          SText(L10n.ofValue().inventoryInfo + ":", style: TextStyle(color: Colors.blue),),
          Table(
            columnWidths: {0: FixedColumnWidth(80), 1: FixedColumnWidth(40), 2: FixedColumnWidth(45),},
            border: _tableBorder,
            children: [
              TableRow(
//              decoration: BoxDecoration(
//                color: Colors.grey
//              ),
                children: [
                  TableCell(
                    child: SText(
                      L10n.ofValue().itemCode,
                      textAlign: TextAlign.center,
                      style: headerStyle
                    ),
                  ),
                  TableCell(
                    child: SText(
                      L10n.ofValue().shortDeliveredQty,
                      textAlign: TextAlign.center,
                      style: headerStyle.merge(TextStyle(color: QuotationUtil.getQtyColor("deliveredQty")))
                    ),
                  ),
                  TableCell(
                    child: SText(
                      L10n.ofValue().shortStockQty,
                      textAlign: TextAlign.center,
                      style: headerStyle.merge(TextStyle(color: QuotationUtil.getQtyColor("stockQty")))
                    ),
                  ),
                  TableCell(
                    child: SText(
                      L10n.ofValue().waitingOut,
                      textAlign: TextAlign.center,
                      style: headerStyle.merge(TextStyle(color: QuotationUtil.getQtyColor("waitingOutQty")))
                    )
                  ),
                ]),
                ..._buildStockQty(waitingList),
            ],
          ),
        ],
      ),
    );
  }

  List<TableRow> _buildStockQty(List<RequestInventoryOutItemWaiting> waitingList) {
    List<TableRow> list = [];
    var bodyStyle = TextStyle(fontSize: 13);
    for(var i = 0 ; i < _list.length; i++) {
      list.add(TableRow(
        children: [
          TableCell(
            child: SText('${_list[i].itemCode}', style: bodyStyle),
          ),
          TableCell(
            child: SText(
              '${_list[i].qty}',
              textAlign: TextAlign.right,
              style: bodyStyle.merge(TextStyle(color: QuotationUtil.getQtyColor("deliveredQty")))
            ),
          ),
          TableCell(
            child: SText(
              '${_list[i].stock}',
              textAlign: TextAlign.right,
              style: bodyStyle.merge(TextStyle(color: QuotationUtil.getQtyColor("stockQty")))
            ),
          ),
          TableCell(
            child: FutureBuilder(
              future: getWaitingQtyPerItem(_list[i].itemId,  waitingList),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return SText(
                    snapshot.data,
                    textAlign: TextAlign.right,
                    style: bodyStyle.merge(TextStyle(color: QuotationUtil.getQtyColor("waitingOutQty")))
                  );
                else
                  return SText(
                      '',
                      textAlign: TextAlign.right,
                      style: bodyStyle.merge(TextStyle(color: QuotationUtil.getQtyColor("waitingOutQty")))
                  );
              }
            ),
          ),
        ]
      ));
    }

    return list;
  }

  static Future<String> getWaitingQtyPerItem(int itemId, List<RequestInventoryOutItemWaiting> waitingList) async {
    if (waitingList == null || waitingList.length == 0)
      return '';

    List<RequestInventoryOutItemWaiting> filterList = List.from(waitingList.where((test) => test.itemId == itemId));

    if (filterList == null || filterList.length == 0)
      return '';

    int sumQty = filterList
        .map((item) => item.qty)
        .reduce((x, y) => x + y);

    if (sumQty == 0)
      return '';

    var details = Observable.fromIterable(filterList)
        .groupBy((item) => item.account)
        .flatMap((g) => g.reduce((x, y) => RequestInventoryOutItemWaiting(
          account: x.account,
          qty: x.qty + y.qty,
    )).asObservable()).map((item) => '${item.account}: ${item.qty}').join(", ");


    return '($sumQty) ' + await details;
  }

  void _onSaveOrUpdate(RequestInventoryOutView reqinvout) async {
    if (!_validateInput())
      return;
    _saveOrUpdateStreamController.sink.add(true);
    widget.requestInventoryOutAPI.saveOrUpdate(reqinvout).then((value) async{
      if (value.item1 == null) {
        Toast.show(value.item2, context);
      } else {
        _requestInventoryOut = value.item1;
        _refNoTextController.text = _requestInventoryOut.code;
        _onSaveOrUpdateItem(_bindingDataList(value.item1.id));
      }
    });
  }

  int _sumQty(String type) {
    switch(type){
      case "qty":
        return _quantityTextControllers.isEmpty ? 0 : _quantityTextControllers.map((item) => int.parse(item.text.length > 0 ? item.text : '0'))
            .reduce((x, y) => x + y);
      case "stockQty":
        return _stockQties.isEmpty ? 0 : _stockQties.reduce((x, y) => x + y);
      case "waitingOutQty":
        return _waitingOutQties.isEmpty ? 0 : _waitingOutQties.reduce((x, y) => x + y);
    }
    return 0;
  }

  Widget _buildBody() {

    return StreamBuilder<List<RequestInventoryOutItemView>>(
      stream: _reqinvoutItemStreamController.stream,
      builder: (context, snapshot) {
        return _buildListView(snapshot.data);
      },
    );
  }

  Widget _buildHeaderForm(RequestInventoryOutView item) {
    var status = _requestInventoryOut != null ? _requestInventoryOut.status : ReqinvoutStatusDropdown.STATUS_NEW;
     //print(item.status);
    return IgnorePointer(
      ignoring: !_isEditing,
      child: PreferredSize(
        key: ValueKey(-1),
        child: Container(
          margin: EdgeInsets.only(left: 5, right: 5, top: 5),
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 0, 0, 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: STextStyle.GRADIENT_COLOR1,
              width: 2
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Table(
                //border: _tableBorder,
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: STextField(
                            decoration: InputDecoration(
                              hintText: L10n.ofValue().refNo,
                              contentPadding: EdgeInsets.only(top: 2, bottom: 2),
                              border: InputBorder.none
                            ),
                            controller: _refNoTextController,
                            maxLines: 1,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      TableCell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ReqinvoutStatusDropdown.getStatusIcon(status, 20),
                            SText(
                              ' ' + ReqinvoutStatusDropdown.getStatusName(status),
                            ),
                          ],
                        ),
                      ),

                      TableCell(
                        child: LimitedBox(
                          maxHeight: 20,
                          child: SDateTimePickerFormField(
                            style: TextStyle(
                              fontSize: 14
                            ),
                            textAlign: TextAlign.right,
                            controller: _requestDateTextController,
                            inputType: SInputType.date,
                            initialValue: _requestDate,
                            format: DateFormat.yMd(),
                            editable: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 5, top: 3),
                              border: InputBorder.none,
                              hintText: L10n.ofValue().createdDate,
                              hasFloatingPlaceholder: true
                            ),
                            onChanged: (dt) {
                              setState(() {
                                _requestDate = dt;
                              });
                            },
                          ),
                        ),
                      ),
                    ]
                  ),
                ],
              ),
              Table(
                //border: _tableBorder,
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: ReqinvoutTypeDropdown(
                            width: 160,
                            selectedId: _selectedReqinvoutType == null ? null : _selectedReqinvoutType.join(","),
                            onChanged: (value) {
                              _selectedReqinvoutType = value == null ? null : value.split(",").map((item){
                                return int.parse(item);
                              }).toList();
                            },
                          ),
                        ),
                      ),

                      TableCell(
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.only(left: 5),
                          child: WarehouseDropdown(
                            selectedId: _selectedWarehouseId,
                            onChanged: (value) async {
                              _selectedWarehouseId= value;
//                            _selectedWarehouseDetailsIds = _selectedWarehouseDetailsIds.map((item) => null).toList();
                              for (var i = 0; i < _selectedWarehouseDetailsIds.length; i++)
                                _selectedWarehouseDetailsIds[i] = null;

                              _subWarehouseList = await widget.requestInventoryOutAPI.findWarehouseByParentId(_selectedWarehouseId??0);
                              setState(() {

                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),


              Table(
                //border: _tableBorder,
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Row(
                            children: <Widget>[
                              SText(L10n.ofValue().outForPartner + ": "),
                              Flexible(
                                child: IgnorePointer(
                                  ignoring: !_isFullControl,
                                  child: PartnerTypeDropdown(
                                    selectedId: _selectedPartnerTypeId,
                                    onChanged: (value){
                                      _selectedPartnerTypeId = value;
                                      switch(_selectedPartnerTypeId){
                                        case PartnerTypeDropdown.EMPLOYEE:
                                          _selectedPartnerId = GlobalParam.EMPLOYEE_ID;
                                          break;
                                      }
                                      setState(() {

                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Table(
                //border: _tableBorder,
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: IgnorePointer(
                          ignoring: !_isFullControl,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                              child: LimitedBox(
                                child: _selectedPartnerTypeId == PartnerTypeDropdown.CUSTOMER ? CustomerAutoTextField(
                                  smallWidget: true,
                                  selectedId: _selectedPartnerId,
                                  onChanged: (value){
                                    _selectedPartnerId = value;
                                  },
                                ) : _selectedPartnerTypeId == PartnerTypeDropdown.SUPPLIER ? SupplierAutoComplete(
                                  selectedId: _selectedPartnerId,
                                  onChanged: (value){
                                    _selectedPartnerId = value;
                                  },
                                )
                                  : EmployeeDropdown(
                                  selectedId: _selectedPartnerId,
                                  showAllItem: false,
                                  onChanged: (value) {
                                    _selectedPartnerId = value;
                                  },
                                ),
                              ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Table(
                //border: _tableBorder,
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: STextField(
                          controller: _contactNameTextController,
                          decoration: InputDecoration(
                            hintText: L10n.ofValue().contactName,
                            contentPadding: EdgeInsets.only(top: 2, bottom: 2),
                            border: InputBorder.none
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: STextField(
                          controller: _contactPhoneTextController,
                          decoration: InputDecoration(
                            hintText: L10n.ofValue().contactPhone,
                            contentPadding: EdgeInsets.only(top: 2, bottom: 2),
                            border: InputBorder.none
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Table(
                // border: _tableBorder,
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: STextField(
                              decoration: InputDecoration(
                                  hintText: L10n.ofValue().content,
                                  contentPadding: EdgeInsets.only(top: 2, bottom: 2),
                                  border: InputBorder.none
                              ),
                              controller: _contentTextController
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Table(
                //border: _tableBorder,
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: STextField(
                            controller: _notesTextController,
                            decoration: InputDecoration(
                                hintText: L10n.ofValue().notes,
                                contentPadding: EdgeInsets.only(top: 2, bottom: 2),
                                border: InputBorder.none
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            ]
          ),
        ),
      ),
    );
  }

  Widget _buildListView(List<RequestInventoryOutItemView> list) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _draggable ? ReorderableListView (
            onReorder: _onReorder,
            children: <Widget>[
              _buildHeaderForm(_requestInventoryOut),
              for(var i = 0; i < (list?.length??0); i ++)
                _buildListItem(list[i], i)
            ],
          ) : ListView (
            children: <Widget>[
              _buildHeaderForm(_requestInventoryOut),
              for(var i = 0; i < (list?.length??0); i ++)
                _buildListItem(list[i], i)
            ],
          ),
        ),
      ],
    );
  }

  _onReorder(int oldIndex, int newIndex) {
    print('$oldIndex  $newIndex');
     //dragging from top to bottom
    if(oldIndex <1 || newIndex<1)
      return;

    if (newIndex > oldIndex) {
      newIndex--;
    }

    oldIndex--;
    newIndex--;
    var temp = _list.removeAt(oldIndex);
    _list.insert(newIndex, temp);

    var tmpItemId = _itemIds.removeAt(oldIndex);
    _itemIds.insert(newIndex, tmpItemId);

    var tmpItemCode = _itemCodes.removeAt(oldIndex);
    _itemCodes.insert(newIndex, tmpItemCode);

    var tmpItemName = _itemNames.removeAt(oldIndex);
    _itemNames.insert(newIndex, tmpItemName);

    var tmpQty = _quantityTextControllers.removeAt(oldIndex);
    _quantityTextControllers.insert(newIndex, tmpQty);

    var tmpExpDateController = _limitDateTextControllers.removeAt(oldIndex);
    _limitDateTextControllers.insert(newIndex, tmpExpDateController);

    var tmpExpDate = _limitDates.removeAt(oldIndex);
    _limitDates.insert(newIndex, tmpExpDate);

    var tmpStockQty = _stockQties.removeAt(oldIndex);
    _stockQties.insert(newIndex, tmpStockQty);

    var tmpWaitingOutQty = _waitingOutQties.removeAt(oldIndex);
    _waitingOutQties.insert(newIndex, tmpWaitingOutQty);

    var tmpNotes = _notesTextControllers.removeAt(oldIndex);
    _notesTextControllers.insert(newIndex, tmpNotes);

    _reqinvoutItemStreamController.add(_list);
  }

  void _showSearchProductDialog(int index) {

    showDialog (
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return InventorySearchUI(
          showDetails: false,
        );
      },
    ).then((value) async{
      if (value != null) {
        var item = value as InventorySearchResult;
        _list[index].itemName = item.name.replaceAll('<mark>', '').replaceAll("</mark>", '');
        _list[index].itemId = item.id;
        _list[index].itemCode = item.code.replaceAll('<mark>', '').replaceAll("</mark>", '');
        _list[index].stock = item.stock;
        _itemNames[index] = item.name;
        _itemCodes[index] = item.code;
        _itemIds[index] = item.id;
        _stockQties[index] = item.stock??0;
        //TODO
        _waitingOutQties[index] = await widget.requestInventoryOutAPI.findOtherWaitingOutQtyOfItem(itemId: item.id,
            empId: _requestInventoryOut == null ? GlobalParam.EMPLOYEE_ID : _requestInventoryOut.requesterId );

      }
    });
  }

  Widget _buildListItem(RequestInventoryOutItemView item, int index) {
    var headerStyle = TextStyle();

    return IgnorePointer(
      ignoring: !_isEditing,
      child: Container(
        key: ValueKey(index),
        height: 125,
        margin: EdgeInsets.only(left: 5, right: 5, top: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: ReqinvoutStatusDropdown.getStatusColor(item.status),
                width: 2
            )
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (_list.length > 1 && _isFullControl && _isOwner())
                    InkWell(
                      child: Icon(Icons.close, size: 25, color: Colors.red),
                      onTap: () {
                        if(_list[index].id != null) {
                          SDialog.confirm(L10n.ofValue().reqInventoryOut, L10n.ofValue().delete + ' <b>${_itemCodes[index]}</b>. ' + L10n.ofValue().areYouSure + "?").then((value){
                            if(value == DialogButton.yes) {
                              _deleteReqinvoutItemIds.add(_list[index].id);
                              _itemCodes.removeAt(index);
                              _itemIds.removeAt(index);
                              _itemNames.removeAt(index);
                              _quantityTextControllers.removeAt(index);
                              _limitDateTextControllers.removeAt(index);
                              _limitDates.removeAt(index);
                              _notesTextControllers.removeAt(index);
                              _stockQties.removeAt(index);
                              _waitingOutQties.removeAt(index);
                              _selectedWarehouseDetailsIds.removeAt(index);
                              _list.removeAt(index);
                              _reqinvoutItemStreamController.sink.add(_list);
                            }
                          });
                        } else {
                          _itemCodes.removeAt(index);
                          _itemIds.removeAt(index);
                          _itemNames.removeAt(index);
                          _quantityTextControllers.removeAt(index);
                          _limitDateTextControllers.removeAt(index);
                          _limitDates.removeAt(index);
                          _notesTextControllers.removeAt(index);
                          _stockQties.removeAt(index);
                          _waitingOutQties.removeAt(index);
                          _selectedWarehouseDetailsIds.removeAt(index);
                          _list.removeAt(index);
                          _reqinvoutItemStreamController.sink.add(_list);
                        }
                      },
                    ),
                  SizedBox(height: 10,),
                  RotatedBox(quarterTurns: 3, child: SText('${index + 1}', style: TextStyle(fontSize: 18),)),
                  SizedBox(height: 10,),
                  if (_isFullControl && _isOwner())
                  InkWell(
                    child: Icon(Icons.add, size: 25, color: Colors.blue),
                    onTap: () {
                      _onAddItem(index: index);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Table(
                    border: _tableBorder,
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: SHtml(data:
                                      _itemCodes[index],
                                      defaultTextStyle: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  if (_isFullControl)
                                  InkWell(
                                    child: Icon(Icons.search),
                                    onTap: () {
                                      _showSearchProductDialog(index);
                                    },
                                  ),
                                  WarehouseDetailsDropdown(
                                    list: _subWarehouseList,
                                    selectedId: _selectedWarehouseDetailsIds[index],
                                    onChanged: (value) {
                                      _selectedWarehouseDetailsIds[index] = value;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]
                      ),
                    ],
                  ),
                  Table(
                    border: _tableBorder,
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              height: 22,
                              padding: const EdgeInsets.only(left: 2),
                              child: SHtml(data:
                                _itemNames[index],
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ]
                      ),
                    ],
                  ),
                  Table(
                    border: _tableBorder,
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [

                      ///Label
                      TableRow(
                          children: [
                            TableCell(
                              child:  Container(
                                alignment: Alignment.center,
                                height: 22,
                                child: SText(
                                  L10n.ofValue().quantity,
                                  textAlign: TextAlign.center,
                                  style: headerStyle.merge(TextStyle(color: QuotationUtil.getQtyColor("qty"))),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                alignment: Alignment.center,
                                height: 22,
                                child: SText(
                                  L10n.ofValue().stockQty,
                                  textAlign: TextAlign.center,
                                  style: headerStyle.merge(TextStyle(color: QuotationUtil.getQtyColor("stockQty")))
                                )
                              ),
                            ),
                            TableCell(
                              child: Container(
                                  alignment: Alignment.center,
                                  height: 22,
                                  child: SText(
                                      L10n.ofValue().waitingOut,
                                      textAlign: TextAlign.center,
                                      style: headerStyle.merge(TextStyle(color: QuotationUtil.getQtyColor("waitingOutQty")))
                                  )
                              ),
                            ),
                          ]
                      ),
                      ///Input
                      TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                height: 22,
                                child: STextField(
                                  controller: _quantityTextControllers[index],
                                  style: TextStyle(color: QuotationUtil.getQtyColor("qty")),
                                  textAlign: TextAlign.end,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                height: 22,
                                child: SText(
                                  '${_stockQties[index]}',
                                  style: TextStyle(color: QuotationUtil.getQtyColor("stockQty")),
                                  textAlign: TextAlign.end,

                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(right: 5),
                                height: 22,
                                child: SText(
                                  '${_waitingOutQties[index]}',
                                  style: TextStyle(color: QuotationUtil.getQtyColor("waitingOutQty")),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ),
                          ]
                      ),
                    ],
                  ),
                  Table(
                    border: _tableBorder,
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Row(
                              children: <Widget>[
                                LimitedBox(
                                  maxWidth: 120,
                                  maxHeight: 20,
                                  child: SDateTimePickerFormField(
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red
                                    ),
                                    controller: _limitDateTextControllers[index],
                                    inputType: SInputType.date,
                                    initialValue: _limitDates[index],
                                    format: DateFormat.yMd(),
                                    editable: true,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 5, top: 3),
                                      border: InputBorder.none,
                                      hasFloatingPlaceholder: true,
                                      hintText: L10n.ofValue().limitDate,
                                    ),
                                    onChanged: (dt) {
                                      setState(() {
                                        _limitDates[index] = dt;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Flexible(
                                  child: STextField(
                                    controller: _notesTextControllers[index],
                                    decoration: InputDecoration(
                                      hintText: L10n.ofValue().notes,
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(top: 2, bottom: 2)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
          decoration: STextStyle.appBarDecoration()
      ),
      titleSpacing: -5,
      title: SText(
        L10n.ofValue().reqInventoryOut + _getExtraAppBarTitle(),
        style: TextStyle(fontSize: 16)
      ),
      actions: <Widget>[
        if(_isEditing)
        InkWell(
          child: Icon(_draggable ? Icons.phonelink_lock : Icons.sort),
          onTap: () {
            _draggable = !_draggable;
            setState(() {
            });
          },
        )
      ],
    );
  }

  String _getExtraAppBarTitle() {
    String title = ' - ';
    if (_requestInventoryOut != null) {
      title += L10n.ofValue().update;
    } else {
      title += L10n.ofValue().addNew;
    }

    if (widget.quotation != null)
      title += ' - ' + L10n.ofValue().fromQuotation;

    return title;
  }

  String getBusinessCode(){
    return "inv03";
  }
  bool roleControl(String buttonName){
    int id = 0;
    int creatorId =0 ;
    int status = RequestInventoryOutView.STATUS_NEW;
    int submit = Constant.SUBMIT_0;
    int loginUserId = GlobalParam.USER_ID ;
    int ownerApprove =0;
    if(_requestInventoryOut != null) {
      id = _requestInventoryOut.id;
      creatorId = _requestInventoryOut.createdId != null? _requestInventoryOut.createdId : loginUserId;
      status = _requestInventoryOut.status;
      status = status == null ? RequestInventoryOutView.STATUS_NEW : status;
      submit = _requestInventoryOut.submit != null ? _requestInventoryOut.submit : 0;
      ownerApprove = getApproveLevel();
    }

    bool isApproveLevel1 = _userBusiness.isLevel1;
    bool isApproveLevel2 = _userBusiness.isLevel2;
    bool isApproveLevel3 = _userBusiness.isLevel3;


    if (RequestInventoryOutView.STATUS_NEW == status) {

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

    } else if (RequestInventoryOutView.STATUS_REJECT == _requestInventoryOut.status) {
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
    } else if (RequestInventoryOutView.STATUS_WAITING == status) {


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
         // if(buttonName == "cbSubmit") return true;
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

      if (GlobalParam.EMPLOYEE_ID == _requestInventoryOut.employeeId
          || GlobalParam.EMPLOYEE_ID == _requestInventoryOut.requesterId || loginUserId == creatorId ) {

        if (submit <= (ownerApprove + 1)) {
          if(buttonName == "cbCancelSubmit"){
            return true;
          }
        }
      }
    } else if (RequestInventoryOutView.STATUS_SUBMIT == status) {
      if(buttonName == "cbCancelApprove"){
        if(isApproveLevel1) return true;
      }

    } else if (RequestInventoryOutView.STATUS_STOCKER == status) {
      if(buttonName == "cbCancelApprove"){
        if(isApproveLevel2) return true;
      }
    } else if (RequestInventoryOutView.STATUS_APPROVED == status) {
      if(buttonName == "cbCancelApprove"){
        if(isApproveLevel3) return true;
      }
    } else if (RequestInventoryOutView.STATUS_CANCELED == status) {

    }
    else if (RequestInventoryOutView.STATUS_DONE == status || RequestInventoryOutView.STATUS_UNDONE == status) {

    }
    return false;
  }

  int getApproveLevel() {

    int level = 0;
    if (_requestInventoryOut.isOwnerApproveLevel3 == 1) {
      level = 3;
    } else if (_requestInventoryOut.isOwnerApproveLevel2 == 1) {
      level = 2;
    } else if (_requestInventoryOut.isOwnerApproveLevel1 == 1) {
      level = 1;
    }
    return level;
  }

  bool _validateRequestInventoryOut() {
    ///check status
    if (![ReqinvoutStatusDropdown.STATUS_SUBMIT,
      ReqinvoutStatusDropdown.STATUS_STOCKER,
      ReqinvoutStatusDropdown.STATUS_APPROVED,
      ReqinvoutStatusDropdown.STATUS_DONE,
      ReqinvoutStatusDropdown.STATUS_UNDONE,
    ].contains(_requestInventoryOut.status)) {
      Toast.show(L10n.of(context).reqInventoryOutHasNotBeenApproved, context);
      return false;
    }

    ///check item
   // if(!_checkedItems.any((test) => test !=null)) {
    //  Toast.show(L10n.of(context).youMustSelectAtLessOneItem, context);
    //  return false;
    //}

    return true;
  }
  @override
  void dispose() {
    super.dispose();
    _reqinvoutItemStreamController.close();
    _saveOrUpdateStreamController.close();
  }


}