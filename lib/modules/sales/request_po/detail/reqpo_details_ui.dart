import 'dart:async';
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/constant.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/chat/chat_model.dart';
import 'package:mobile/modules/inventory/inventory_model.dart';
import 'package:mobile/modules/inventory/request_inventory_out/request_inventory_out_model.dart';
import 'package:mobile/modules/inventory/search/inventory_search_ui.dart';
import 'package:mobile/modules/notification/task_approve_submit/task_approve_submit_list_api.dart';
import 'package:mobile/modules/sales/quotation/quotation_model.dart';
import 'package:mobile/modules/sales/quotation/quotation_util.dart';
import 'package:mobile/modules/user_business/user_business_model.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/widgets/data_widget/reqpo_status_dropdown.dart';
import 'package:mobile/widgets/particular/approve_button.dart';
import 'package:mobile/widgets/particular/cancel_approve_button.dart';
import 'package:mobile/widgets/particular/cancel_submit_button.dart';
import 'package:mobile/widgets/particular/sedit_button.dart';
import 'package:mobile/widgets/particular/ssave_button.dart';
import 'package:mobile/widgets/particular/submit_button.dart';
import 'package:mobile/widgets/sdatetime_picker_formfield.dart';
import 'package:mobile/widgets/sdialog.dart';
import 'package:mobile/widgets/stext.dart';
import 'package:mobile/widgets/stext_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';
import 'package:mobile/widgets/data_widget/reqinvout_status_dropdown.dart';
import 'package:validators/validators.dart';
import '../request_po_api.dart';
import '../request_po_model.dart';

class ReqPoDetailsUI extends StatefulWidget {
  RequestPoAPI requestPoAPI;
  RequestPoView reqPo;
  bool createNew;
  bool isFullControl;
  UserBusiness userBusiness;
  List<QuotationItemView> quotationItemList;
  QuotationView quotation;
  RequestInventoryOutView requestInventoryOut;
  List<RequestInventoryOutItemView> requestInventoryOutItemList;

  ReqPoDetailsUI({
    Key key,
    this.createNew,
    this.requestPoAPI,
    this.reqPo,
    this.quotationItemList,
    this.quotation,
    this.userBusiness,
    this.requestInventoryOut,
    this.requestInventoryOutItemList,
    this.isFullControl = true,
  }) : super(key: key);
  @override
  _ReqPoDetailsUIState createState() => _ReqPoDetailsUIState();
}

class _ReqPoDetailsUIState extends State<ReqPoDetailsUI> {
  bool _isEditing = false;

  StreamController<List<RequestPoItemView>> requestPoItemStreamController =
  StreamController.broadcast();
  StreamController<bool> _saveOrUpdateStreamController =
  StreamController.broadcast();

   List<RequestPoItemView> _list;
  List<RequestPoItemView> _deletedList = new List<RequestPoItemView>();

  List<TextEditingController> itemCodeOrderList =
  new List<TextEditingController>();
  List<TextEditingController> itemCodeList = new List<TextEditingController>();
  List<TextEditingController> itemNameList = new List<TextEditingController>();
  List<TextEditingController> itemNameOriginList =
  new List<TextEditingController>();
  List<TextEditingController> brandList = new List<TextEditingController>();
  List<TextEditingController> quantityList = new List<TextEditingController>();
  List<TextEditingController> unitList = new List<TextEditingController>();
  List<TextEditingController> stockList = new List<TextEditingController>();
  List<TextEditingController> publishCustomerList =
  new List<TextEditingController>();
  List<TextEditingController> statusList = new List<TextEditingController>();
  List<TextEditingController> inventoryInCodeList =
  new List<TextEditingController>();
  List<TextEditingController> quotationCodeList =
  new List<TextEditingController>();
  List<TextEditingController> poCodeList = new List<TextEditingController>();
  List<TextEditingController> reqInventoryOutCodeList =
  new List<TextEditingController>();
  List<TextEditingController> notesList = new List<TextEditingController>();
  List<TextEditingController> contractCodeList =
  new List<TextEditingController>();

  TextEditingController notesController = new TextEditingController();
  TextEditingController reqPoCodeController = new TextEditingController();
  TextEditingController createdDateController = new TextEditingController();

  var _contentTextController = TextEditingController();
  var _tableBorder = TableBorder.all(color: Colors.grey, width: 0.2);

  bool _draggable = false;


  bool get _isFullControl => widget.isFullControl;
  UserBusiness userBusiness;
  AutoCompleteTextField autoComplete = new AutoCompleteTextField<String>();
  SharedPreferences prefs;
  static RequestPoView   reqPo ;
  bool needSave = false;

  var _requestDate = '';
  var _requester = '';
  var _approver = '';
  var _approveDate = '';

  @override
  void initState() {
    super.initState();
    userBusiness = widget.userBusiness;
    reqPo = null;
    reqPo = widget.reqPo;
    if(_list != null){
      _list.clear();
      _list = null;
    }
    _init();
  }

  void _showSearchDialog(int index , String searchType) {

    if(_isOwner() && (reqPo == null || reqPo.id == null|| reqPo.status == RequestPoView.STATUS_REJECT||  reqPo.status == RequestPoView.STATUS_NEW))
      showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return InventorySearchUI(
          showDetails: false,
          searchReqPoItem:true,
          searchType: searchType,
        );
      },
    ).then((value)  {


      if (value != null) {
        needSave = true;
        var item = value as ReqPoItemSearchResult;
        if(searchType == "itemcode") {

          _list[index].item_code = item.code;
          _list[index].item_name = item.name;
          _list[index].item_code_order = item.codeOrder;
          _list[index].brand = item.brandName;
          _list[index].unit_id = item.unitId;
          _list[index].unitName = item.unitName;
          _list[index].item_name_origin = item.nameOrigin;
          _list[index].item_code_origin = item.codeOrigin;
          _list[index].qty = 1.0;
          _list[index].item_id = item.id;

          itemCodeOrderList[index].text = item.codeOrder;
          itemCodeList[index].text = item.code;
          itemNameList[index].text = item.name;
          itemNameOriginList[index].text = item.nameOrigin;
          brandList[index].text = item.brandName;
          unitList[index].text = item.unitName;
          quantityList[index].text = "1.0";
        }
        else if (searchType == "quotation"){
          _list[index].quotation_id = item.searchId;
          _list[index].quotation_code = item.searchCode;
          quotationCodeList[index].text = item.searchCode;
        }
        else if (searchType == "contract"){
          _list[index].contract_id = item.searchId;
          _list[index].contract_code = item.searchCode;
          contractCodeList[index].text = item.searchCode;
        }
        else if (searchType == "reqinventoryout"){
          _list[index].req_inventory_out_id = item.searchId;
          _list[index].req_inventory_out_code = item.searchCode;
           reqInventoryOutCodeList[index].text= item.searchCode;
        }
        else if (searchType == "customer"){
          _list[index].customer_id = item.searchId;
          _list[index].customer_name = item.searchName;
           publishCustomerList[index].text= item.searchCode;
        }
        else if (searchType == "brand"){
          _list[index].brand = item.searchName;
           brandList[index].text= item.searchName;
        }
        else if (searchType == "unit"){
          _list[index].unit_id = item.searchId;
          unitList[index].text= item.searchName;
        }
        else if (searchType == "itemnameorigin"){
          _list[index].item_name_origin = item.searchName;
          itemNameOriginList[index].text= item.searchName;
        }
        else if (searchType == "itemordercode"){

          _list[index].item_code_order = item.searchCode;
           itemCodeOrderList[index].text= item.searchCode;

        }

        setState(() {

        });
      }
    });
  }

  Future<void> _init() async {
    _list = [];
    if (widget.quotationItemList != null) {
      for (int i = 0; i < widget.quotationItemList.length; i++) {
        fromQuotationToRePo(widget.quotationItemList[i]);
      }
    }
    if (widget.requestInventoryOutItemList != null) {
      for (int i = 0; i < widget.requestInventoryOutItemList.length; i++) {
        fromReqInventoryOutToRePo(widget.requestInventoryOutItemList[i]);
      }
    }
    await _loadData();
  }

  bool _isOwner() {
    if (reqPo != null) {
      return ([reqPo.requesterId].contains(GlobalParam.EMPLOYEE_ID) ||
          [reqPo.createdId].contains(GlobalParam.USER_ID)|| reqPo.id == null);
    } else
      return true;
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

  void fromQuotationToRePo(QuotationItemView srcItem) {
    RequestPoItemView item = new RequestPoItemView(
        item_id: srcItem.itemId,
        item_code: srcItem.itemCodeOrigin,
        item_name: srcItem.itemNameOrigin,
        item_code_origin: srcItem.itemCodeOrigin,
        item_name_origin: srcItem.itemNameOrigin,
        item_code_order: srcItem.itemCodeOrder,
        brand: srcItem.brand,
        unit_id: srcItem.unitId,
        unitName: srcItem.unitName,
        qty: srcItem.qty.toDouble(),
        customer_id: widget.quotation.customerId,
        customer_name: widget.quotation.customerName,
        quotation_id: widget.quotation.id,
        quotation_code: widget.quotation.code,
        quotation_item_id: srcItem.id);
    reqPo.quotationId = widget.quotation.id;
    reqPo.fromBusinessCode = "sle03";
    reqPo.fromBusinessId = widget.quotation.id;
    _list.add(item);
  }

  void fromReqInventoryOutToRePo(RequestInventoryOutItemView srcItem) {
    RequestPoItemView item = new RequestPoItemView(
        item_id: srcItem.itemId,
        item_code: srcItem.itemCode,
        item_name: srcItem.itemName,
        item_code_origin: srcItem.itemCodeOrigin,
        item_name_origin: srcItem.itemNameOrigin,
        brand: srcItem.brand,
        unit_id: srcItem.unitId,
        unitName: srcItem.unitName,
        qty: srcItem.qty.toDouble(),
        customer_id: widget.requestInventoryOut.partnerId,
        customer_name: widget.requestInventoryOut.partnerName.replaceAll("<mark>", "").replaceAll("<\/mark>", ""),
        quotation_id: widget.requestInventoryOut.quotationId,
        //quotation_code: widget.requestInventoryOut.quotationId.code,
        req_inventory_out_code: widget.requestInventoryOut.code,
        req_inventory_out_id: widget.requestInventoryOut.id
    );

    reqPo.fromBusinessCode = "inv03";
    reqPo.fromBusinessId = widget.requestInventoryOut.id;
    _list.add(item);
  }

  Future<void> _loadData() async {
    if (widget.createNew == false) {
      var ret = await widget.requestPoAPI.findRequestPoItem(reqPoId: reqPo.id);
      if (ret.item1 != null) {
        _list = ret.item1;
        _buildDataList();
        requestPoItemStreamController.sink.add(_list);
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_list.length == 0) _list.add(new RequestPoItemView());
        _buildDataList();
        requestPoItemStreamController.sink.add(_list);
      });
    }
  }


  void _buildDataList() {
    itemCodeOrderList.clear();
    itemCodeList.clear();
    itemNameList.clear();
    itemNameOriginList.clear();
    brandList.clear();
    quantityList.clear();
    unitList.clear();
    stockList.clear();
    publishCustomerList.clear();
    statusList.clear();
    quotationCodeList.clear();
    inventoryInCodeList.clear();
    poCodeList.clear();
    reqInventoryOutCodeList.clear();
    notesList.clear();
    contractCodeList.clear();

    for (var i = 0; i < _list.length; i++) {
      itemCodeOrderList.add(
          new TextEditingController(text: '${_list[i].item_code_order ?? ""}'));
      itemCodeList
          .add(new TextEditingController(text: '${_list[i].item_code ?? ""}'));
      itemNameList
          .add(new TextEditingController(text: '${_list[i].item_name ?? ""}'));
      itemNameOriginList.add(new TextEditingController(
          text: '${_list[i].item_name_origin ?? ""}'));
      brandList.add(new TextEditingController(text: '${_list[i].brand ?? ""}'));
      quantityList
          .add(new TextEditingController(text: '${_list[i].qty ?? ""}'));
      unitList.add(new TextEditingController(text: '${_list[i].unitName ?? ""}'));
      stockList.add(new TextEditingController(text: '${""}'));
      publishCustomerList.add(
          new TextEditingController(text: '${_list[i].customer_name ?? ""}'));
      statusList.add(new TextEditingController(
          text: ReqPoStatusDropdown.getStatusName(_list[i].status ?? 1)));
      quotationCodeList.add(
          new TextEditingController(text: '${_list[i].quotation_code ?? ""}'));
      inventoryInCodeList.add(new TextEditingController(text: '${""}'));
      poCodeList.add(new TextEditingController(text: '${""}'));
      reqInventoryOutCodeList.add(new TextEditingController(
          text: '${_list[i].req_inventory_out_code ?? ""}'));
      notesList.add(new TextEditingController(text: '${_list[i].notes ?? ""}'));
      contractCodeList.add(
          new TextEditingController(text: '${_list[i].contract_code ?? ""}'));
    }
  }

  void viewExistReqPo() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: _buildBottom());
  }

  void _onAddItem({int index}) {
    if (_list[_list.length - 1].item_code == null) {
      return;
    }
   // WidgetsBinding.instance.addPostFrameCallback((_) {
      _list.add(new RequestPoItemView());
      _buildDataList();
       requestPoItemStreamController.sink.add(_list);
    //});
   // setState(() {});
  }

  void _onRemoveItem({int index}) {
    if (_list[index].id != null) {
      _list[index].deleted = 1;
      _deletedList.add(_list[index]);
      _list.removeAt(index);
    } else {
      _list.removeAt(index);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_list.length == 0) {
        _list.add(new RequestPoItemView());
      }
      _buildDataList();
      requestPoItemStreamController.sink.add(_list);
    });
    setState(() {});
  }

  RequestPoView _bindingData() {
    String content = _contentTextController.text.trim().replaceAll(" ", "");
    String notes = notesController.text.trim().replaceAll(" ", "");
    double sumQty = 0;
    for (int i = 0; i < _list.length; i++) {
      if (_list[i].item_code != null && (isNumeric(quantityList[i].text) || isFloat(quantityList[i].text))) {
        sumQty += double.parse(quantityList[i].text);
      }
    }

    return RequestPoView(
      id: reqPo.id,
      code: reqPo.code ,
      requestType: reqPo.requestType,
      content: content,
      requesterId: reqPo.requesterId,
      requestDate: reqPo.requestDate,
      approverId1: reqPo.approverId1,
      approvalDate1: reqPo.approvalDate1,
      approverId2: reqPo.approverId2,
      approvalDate2: reqPo.approvalDate2,
      approverId3: reqPo.approverId3,
      approvalDate3: reqPo.approvalDate3,
      supplierId: reqPo.supplierId,
      brand: reqPo.brand,
      stage: reqPo.stage == null ? 10 : reqPo.stage,
      quotationId: reqPo.quotationId,
      contractId: reqPo.contractId,
      reqInventoryOutId: reqPo.reqInventoryOutId,
      fromBusinessCode: reqPo.fromBusinessCode,
      fromBusinessId: reqPo.fromBusinessId,
      reportCode: reqPo.reportCode,
      notes: reqPo.notes = notes,
      status:
      reqPo.status == null ? ReqPoStatusDropdown.STATUS_NEW : reqPo.status,
      companyId: 1,
      branchId: 101,
      deleted: reqPo.deleted == null ? 0 : reqPo.deleted,
      deletedId: reqPo.deletedId,
      deletedDate: reqPo.deletedDate,
      createdId:
      reqPo.createdId == null ? GlobalParam.USER_ID : reqPo.createdId,
      createdDate:
      reqPo.createdDate == null ? DateTime.now() :reqPo.createdDate,
      updatedId:
      reqPo.updatedId == null ? GlobalParam.USER_ID : reqPo.updatedId,
      updatedDate:
      reqPo.updatedDate == null ? DateTime.now() : reqPo.updatedDate,
      version: reqPo.version,
      creatorId:
      reqPo.creatorId == null ? GlobalParam.EMPLOYEE_ID :reqPo.creatorId,
      creationDate:
      reqPo.createdDate == null ? DateTime.now() : reqPo.createdDate,
      sumQty: sumQty,
      submit: reqPo.submit,
      submitId0: reqPo.submitId0,
      submitId1: reqPo.submitId1,
      submitId2: reqPo.submitId2,
      submitId3: reqPo.submitId3,
      submitName0: reqPo.submitName0,
      submitName1: reqPo.submitName1,
      submitName2: reqPo.submitName2,
      submitName3: reqPo.submitName3,
    );
  }

  Widget _buildBottom() {
    return StreamBuilder<Object>(
        stream: requestPoItemStreamController.stream,
        builder: (context, snapshot) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: STextStyle.GRADIENT_COLOR1, width: 1))),
                alignment: Alignment.centerRight,
                height: 30,
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Table(
                        defaultVerticalAlignment:
                        TableCellVerticalAlignment.middle,
                        columnWidths: {0: FixedColumnWidth(40)},
                        border: _tableBorder,
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                child: SizedBox(
                                  width: 40,
                                  child: Text(
                                    '\u03A3',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
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

                    if( _isOwner() && (reqPo == null || reqPo.id == null|| reqPo.status == RequestPoView.STATUS_REJECT||  reqPo.status == RequestPoView.STATUS_NEW))
                      SSaveButton(
                        progressStream: _saveOrUpdateStreamController.stream,
                        isSaveMode: reqPo != null ? false : true,
                        color: Colors.white,
                        onTap: () {
                          if(_validateInput())
                            _onSaveOrUpdate(_bindingData());
                          //saveOrUpDate();
                        },
                      ),
                    Spacer(),
                    if (roleControl("cbSubmit") == true)
                      SubmitButton(
                        onTap: () {
                          if(validateAlreadySave())
                          _onSubmit();
                               else
                               Toast.show(
                                L10n.ofValue().save + " " + L10n.ofValue().isInvalid,
                              context);
                        },

                        color: Colors.white,
                        onAskMessage: () {
                          return '${L10n.ofValue().submit} <b>${reqPo.code}</b>. ${L10n.ofValue().areYouSure}?';
                        },
                      ),
                    if (roleControl("cbCancelSubmit") == true)
                      CancelSubmitButton(
                        onTap: () {
                          _onCancelSubmit();
                        },
                        color: Colors.white,
                        onAskMessage: () {
                          return '${L10n.ofValue().submit} <b>${reqPo.code}</b>. ${L10n.ofValue().areYouSure}?';
                        },
                      ),
                    if (roleControl("cbApprove") == true)
                      ApproveButton(
                        onTap: () {
                          if(validateAlreadySave())
                          _onApprove();
                          else
                            Toast.show(
                                L10n.ofValue().save + " " + L10n.ofValue().isInvalid,
                                context);
                        },
                        color: Colors.white,
                        onAskMessage: () {
                          return '${L10n.ofValue().approve} <b>${reqPo.code}</b>. ${L10n.ofValue().areYouSure}?';
                        },
                      ),
                    if (roleControl("cbCancelApprove") == true)
                      CancelApproveButton(
                        onTap: () {
                          _onCancelApprove();
                        },
                        color: Colors.white,
                        onAskMessage: () {
                          return '${L10n.ofValue().approve} <b>${reqPo.code}</b>. ${L10n.ofValue().areYouSure}?';
                        },
                      ),
                  ],
                ),
              ),
            ],
          );
        });
  }



  void _onSubmit() {
    var _taskApproveSubmitListAPI = TaskApproveSubmitListAPI();
    _taskApproveSubmitListAPI
        .doApproveSubmitWithUserIdAndGroupIdAndSourceIdAndTask(
        userId: GlobalParam.USER_ID,
        groupId: ChatHistory.GROUP_REQPO,
        sourceId: reqPo.id,
        task: 1)
        .then((response) {
      //_loadData();
      if (response.status.toString() == "success") {
        int submit = json.decode(response.updateObject)["submit"];
        int status = json.decode(response.updateObject)["status"];
        String requesterName =
        json.decode(response.updateObject)["requesterName"];
        String requestDate = json.decode(response.updateObject)["requestDate"];
        reqPo.submit = submit;
        reqPo.status = status;
        for (int i = 0; i < statusList.length; i++) {
          statusList[i].text = ReqPoStatusDropdown.getStatusName(status);
          _list[i].status = status ;
        }

        reqPo.requesterName = requesterName;
        reqPo.requestDate = DateTime.parse(requestDate);
        setState(() {});
        if(response.message.length >0)SDialog.alert("",response.message);
      } else {
        SDialog.alert("", response.message);
      }
    });
  }

  void _onCancelSubmit() {
    var _taskApproveSubmitListAPI = TaskApproveSubmitListAPI();
    _taskApproveSubmitListAPI
        .doApproveSubmitWithUserIdAndGroupIdAndSourceIdAndTask(
        userId: GlobalParam.USER_ID,
        groupId: ChatHistory.GROUP_REQPO,
        sourceId: reqPo.id,
        task: 2)
        .then((response) {

      if (response.status.toString() == "success") {
        int submit = json.decode(response.updateObject)["submit"];
        int status = json.decode(response.updateObject)["status"];
        reqPo.submit = submit;
        reqPo.status = status;
        for (int i = 0; i < statusList.length; i++) {
          statusList[i].text = ReqPoStatusDropdown.getStatusName(status);
          _list[i].status = status ;
        }
        reqPo.requesterName = null;
        reqPo.requestDate = null;
        setState(() {});
        if(response.message.length >0)SDialog.alert("",response.message);
      } else {
        SDialog.alert("", response.message);
      }
    });
  }

  void _onApprove() {
    var _taskApproveSubmitListAPI = TaskApproveSubmitListAPI();
    _taskApproveSubmitListAPI
        .doApproveSubmitWithUserIdAndGroupIdAndSourceIdAndTask(
        userId: GlobalParam.USER_ID,
        groupId: ChatHistory.GROUP_REQPO,
        sourceId: reqPo.id,
        task: 3)
        .then((response) {
      if (response.status.toString() == "success") {
        int submit = json.decode(response.updateObject)["submit"];
        int status = json.decode(response.updateObject)["status"];
        String approverName = json.decode(response.updateObject)["approveName"];
        String approvedDate =
        json.decode(response.updateObject)["approvedDate"];
        reqPo.submit = submit;
        reqPo.status = status;
        for (int i = 0; i < statusList.length; i++) {
          statusList[i].text = ReqPoStatusDropdown.getStatusName(status);
          _list[i].status = status ;
        }
        if (status == RequestPoView.STATUS_SUBMIT) {
          reqPo.approverName1 = approverName;
          reqPo.approvalDate1 = DateTime.parse(approvedDate);
        }
        if (status == RequestPoView.STATUS_PUR) {
          reqPo.approverName2 = approverName;
          reqPo.approvalDate2 = DateTime.parse(approvedDate);
        }

        if (status == RequestPoView.STATUS_APPROVED) {
          reqPo.approverName3 = approverName;
          reqPo.approvalDate3 = DateTime.parse(approvedDate);
        }
        setState(() {});
        if(response.message.length >0)SDialog.alert("",response.message);
      } else {
        SDialog.alert("", response.message);
      }
    });
  }

  void _onCancelApprove() {
    var _taskApproveSubmitListAPI = TaskApproveSubmitListAPI();
    _taskApproveSubmitListAPI
        .doApproveSubmitWithUserIdAndGroupIdAndSourceIdAndTask(
        userId: GlobalParam.USER_ID,
        groupId: ChatHistory.GROUP_REQPO,
        sourceId: reqPo.id,
        task: 4)
        .then((response) {
      if (response.status.toString() == "success") {
        int submit = json.decode(response.updateObject)["submit"];
        int status = json.decode(response.updateObject)["status"];
        reqPo.submit = submit;
        reqPo.status = status;
        for (int i = 0; i < statusList.length; i++) {
          statusList[i].text = ReqPoStatusDropdown.getStatusName(status);
          _list[i].status = status ;
        }
        reqPo.approverName1 = null;
        reqPo.approvalDate1 = null;
        reqPo.approverName2 = null;
        reqPo.approvalDate2 = null;
        reqPo.approverName3 = null;
        reqPo.approvalDate3 = null;
        setState(() {});
        if(response.message.length >0)SDialog.alert("",response.message);
      } else {
        SDialog.alert("", response.message);
      }
    });
  }



  void _onSaveOrUpdate(RequestPoView reqP) async {
    bool validate =  await _validateInput();
    if (!validate ) return;

    _saveOrUpdateStreamController.sink.add(true);
    widget.requestPoAPI.saveOrUpdate(reqP).then((value) async {
      if (value.item1 == null) {
        Toast.show(value.item2, context);
      } else {

        reqPo = value.item1;
        reqPo.id =  value.item1.id;
        reqPo.fromBusinessCode =value.item1.fromBusinessCode;
        reqPo.fromBusinessId =value.item1.fromBusinessId;
        _onSaveOrUpdateItem(_bindingDataList(value.item1.id));
        _saveOrUpdateStreamController.sink.add(false);
        setState(() {});
      }
    });
  }
  bool validateAlreadySave(){
    for(int i = 0 ; i < _list.length; i ++){
      if(_list[i].id == null ){
        return false;
      }
    }

    if(_deletedList.length  >0   ){
      return false;
    }
    if(needSave == true) return false;

    return true;
  }

  void _onSaveOrUpdateItem(List<RequestPoItemView> list) async {

    await widget.requestPoAPI.saveOrUpdateItem(list).then((value) async {
      if (value.item1 == null) {
        Toast.show(value.item2, context);
      } else {

         widget.createNew = false;
         await _loadData();
         _deletedList.clear();
        _saveOrUpdateStreamController.sink.add(false);
        needSave = false;
        setState(() {});
      }
    });
  }

  List<RequestPoItemView> _bindingDataList(int Id) {
    print("code order");
    print( _list[0].item_code_order);
    var emptyItemIndex = -1;
    for (var i = 0; i < _list.length; i++) {
      if (_list[i].item_code != null) {
        _list[i].req_po_id ??= Id;
        _list[i].sort ??= i + 1;
        _list[i].status = 1;//??= ReqPoStatusDropdown.STATUS_NEW;
        _list[i].created_id ??= GlobalParam.USER_ID;
        _list[i].created_date ??= DateTime.now();
        _list[i].updated_id = GlobalParam.USER_ID;
        _list[i].updated_date = DateTime.now();
        _list[i].version = _list[i].version ?? 0 + 1;
        _list[i].deleted = 0;
        double quantity;
        if (isNumeric(quantityList[i].text) || isFloat(quantityList[i].text)) {
          quantity =  double.parse(quantityList[i].text);
        }

        _list[i].qty = quantity > 0 ? quantity : _list[i].qty;
        _list[i].notes = notesList[i].text;
        print( _list[i].req_po_id);
      }
      if (_list[i].item_code == null) {
        emptyItemIndex = i;
      }
    }
    for (var i = 0; i < _deletedList.length; i++) {
      _deletedList[i].deleted_id = GlobalParam.USER_ID;
      _deletedList[i].deleted_date ??= DateTime.now();
      _deletedList[i].updated_id = GlobalParam.USER_ID;
      _deletedList[i].updated_date = DateTime.now();
      _deletedList[i].version = _deletedList[i].version + 1;
    }
    List<RequestPoItemView> updatedRepoItem = new List<RequestPoItemView>();
    if (emptyItemIndex != -1) {
      _list.removeAt(emptyItemIndex);
    }

    updatedRepoItem.addAll(_list);
    if (_deletedList.length > 0) updatedRepoItem.addAll(_deletedList);
    return updatedRepoItem;
  }

  bool _validateInput() {
    if (_contentTextController.text == "") {
      Toast.show(
          L10n.ofValue().pur11TableContent + " " + L10n.ofValue().isInvalid,
          context);
      return false;
    }

    for( int i = 0 ; i <_list.length ; i ++) {
      if (_list[i].item_code == null) {
        Toast.show(
            L10n
                .ofValue()
                .pur11TableItemcode + " " + L10n
                .ofValue()
                .isInvalid,
            context);
        return false;
      }
      print (quantityList[i].text.isEmpty);
      if(quantityList[i].text == null || quantityList[i].text.isEmpty ){
        Toast.show(
            L10n
                .ofValue()
                .pur11TableQuantity+ " " + L10n
                .ofValue()
                .isInvalid,
            context);
        return false;
      }

      if(brandList[i].text == null || brandList[i].text.isEmpty ){
        Toast.show(
            L10n
                .ofValue()
                .pur11TableBrand+ " " + L10n
                .ofValue()
                .isInvalid,
            context);
        return false;
      }
      if(unitList[i].text == null || unitList[i].text.isEmpty || _list[i].unit_id == null ){
        Toast.show(
            L10n
                .ofValue()
                .pur11TableUnit+ " " + L10n
                .ofValue()
                .isInvalid,
            context);
        return false;
      }
      if(!isNumeric(quantityList[i].text) && !isFloat(quantityList[i].text)){
        Toast.show(
            L10n
                .ofValue()
                .pur11TableQuantity+ " " + L10n
                .ofValue()
                .isInvalid,
            context);
        return false;

      }
    }
    return true;
  }

  int _getCreatorId() {
    if (reqPo != null) return reqPo.requesterId;

    if (reqPo != null) return reqPo.creatorId;

    return null;
  }

  Widget _buildBody() {
    return StreamBuilder<List<RequestPoItemView>>(
      stream: requestPoItemStreamController.stream,
      builder: (context, snapshot) {
        return _buildListView(snapshot.data);
      },
    );
  }

  Widget _buildHeaderForm(RequestPoView item) {
    var status =
    (reqPo.status != null ? reqPo.status : ReqPoStatusDropdown.STATUS_NEW);
    reqPoCodeController.text = reqPo.code;
    _contentTextController.text = reqPo.content;
    if (reqPo.notes != null) {
      notesController.text = reqPo.notes;
    }
    var formatter = new DateFormat('dd-MM-yyyy');
    if (reqPo.createdDate != null) {
      createdDateController.text = formatter.format(reqPo.createdDate);
    }

    _requester = reqPo.requesterName;

    if (reqPo.requestDate != null) {
      _requestDate = formatter.format(reqPo.requestDate);
    } else {
      _requestDate = '';

    }
    if (reqPo.approverName1 != null) {
      _approver = reqPo.approverName1;
      _approveDate = formatter.format(reqPo.approvalDate1);
    } else if (reqPo.approverName2 != null) {
      _approver = reqPo.approverName2;
      _approveDate = formatter.format(reqPo.approvalDate2);
    } else if (reqPo.approverName3 != null) {
      _approver = reqPo.approverName3;
      _approveDate = formatter.format(reqPo.approvalDate3);
    }

    var headerStyle = TextStyle(fontSize: 16);
    const COL1_WIDTH = 5.5;
    const COL2_WIDTH = 14.5;
    const COL23_WIDTH = 9.5;
    const COL33_WIDTH = 5;

    return IgnorePointer(
      //ignoring: !_isEditing,
      ignoring: false,
      child: PreferredSize(
        key: ValueKey(-1),
        child: Container(
          margin: EdgeInsets.only(left: 5, right: 5, top: 5),
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 0, 0, 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: STextStyle.GRADIENT_COLOR1, width: 2)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
            Table(
              columnWidths: {
                0: FractionColumnWidth((COL1_WIDTH +1)/ 20),
                1: FractionColumnWidth((COL23_WIDTH -1)/ 20),
                2: FractionColumnWidth(COL33_WIDTH / 20)
              },
              children: [
                TableRow(children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: STextField(
                        decoration: InputDecoration(
                            hintText: L10n.ofValue().refNo,
                            contentPadding: EdgeInsets.only(top: 2, bottom: 2),
                            border: InputBorder.none),
                        controller: reqPoCodeController,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ReqPoStatusDropdown.getStatusIcon(status, 20),
                        SText(
                          ' ' + ReqPoStatusDropdown.getStatusName(status),
                          style: headerStyle,
                        ),
                      ],
                    ),
                  ),
                  TableCell(
                    child: LimitedBox(
                      maxHeight: 20,
                      child: SDateTimePickerFormField(
                        style: headerStyle,
                        textAlign: TextAlign.right,
                        controller: createdDateController,
                        inputType: SInputType.date,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 5, top: 3),
                            border: InputBorder.none,
                            hasFloatingPlaceholder: true),
                      ),
                    ),
                  ),
                ]),
              ],
            ),

            Table(
              // border: _tableBorder,
              columnWidths: {
                0: FractionColumnWidth(COL1_WIDTH / 20),
                1: FractionColumnWidth(COL2_WIDTH / 20)
              },
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(top: 2, bottom: 2, left: 5),
                        child: SText(
                          L10n.ofValue().content,
                          style: headerStyle,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: TextField(
                            maxLines: 1,
                            style: headerStyle,
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.only(top: 2, bottom: 2, left: 5),
                            ),
                            keyboardType: TextInputType.multiline,
                            controller: _contentTextController),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            //if(reqPo.requesterName != null )
            Table(
              //border: _tableBorder,
              columnWidths: {
                0: FractionColumnWidth(COL1_WIDTH / 20),
                1: FractionColumnWidth(COL23_WIDTH / 20),
                2: FractionColumnWidth(COL33_WIDTH / 20)
              },
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(top: 2, bottom: 2, left: 5),
                        child: SText(
                          L10n.ofValue().pur11LabelRequester,
                          style: headerStyle,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: SText(
                          _requester ?? '',
                          style: headerStyle
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: SText(
                          _requestDate ?? '',
                          style: headerStyle,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Table(
              //border: _tableBorder,
              columnWidths: {
                0: FractionColumnWidth(COL1_WIDTH / 20),
                1: FractionColumnWidth(COL2_WIDTH / 20)
              },
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(top: 2, bottom: 2, left: 5),
                        child: SText(
                          L10n.ofValue().notes ,
                          style: headerStyle,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: STextField(
                          style: headerStyle,
                          controller: notesController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            //hintText: L10n.ofValue().notes,
                            contentPadding: EdgeInsets.only(top: 2, bottom: 2),

                            // filled: true,
                            // fillColor:Color.fromRGBO(255, 0, 0, 0.05),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),


            //if(reqPo.approverName1 != null  || reqPo.approverName2 != null || reqPo.approverName3 != null)
            Table(
              //border: _tableBorder,
              columnWidths: {
                0: FractionColumnWidth(COL1_WIDTH / 20),
                1: FractionColumnWidth(COL23_WIDTH / 20),
                2: FractionColumnWidth(COL33_WIDTH / 20)
              },
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(top: 2, bottom: 2, left: 5),
                        child: SText(
                          L10n.ofValue().pur11LabelApprover,
                          style: headerStyle,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: SText(
                          _approver ?? '',
                          style: headerStyle,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: SText(
                          _approveDate ?? '',
                          style: headerStyle,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildListView(List<RequestPoItemView> list) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _draggable
              ? ReorderableListView(
            onReorder: _onReorder,
            children: <Widget>[
              _buildHeaderForm(reqPo),
              for (var i = 0; i < (list?.length ?? 0); i++)
                _buildListItem(list[i], i)
            ],
          )
              : ListView(
            children: <Widget>[
              _buildHeaderForm(reqPo),
              for (var i = 0; i < (list?.length ?? 0); i++)
                _buildListItem(list[i], i)
            ],
          ),
        ),
      ],
    );
  }

  _onReorder(int oldIndex, int newIndex) {
    /* print('$oldIndex  $newIndex');
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

    requestPoItemStreamController.add(_list);
    */
  }
/*
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
        _waitingOutQties[index] = await widget.requestPoAPI.findOtherWaitingOutQtyOfItem(itemId: item.id,
            empId: reqPo == null ? GlobalParam.EMPLOYEE_ID : reqPo.requesterId );

      }
    });
  }*/

  Widget _buildListItem(RequestPoItemView item, int index) {
    var headerStyle = TextStyle(fontSize: 14);

    return IgnorePointer(
      //ignoring: !_isEditing,
      ignoring: false,
      child: Container(
        key: ValueKey(index),
        // height: 125,
        margin: EdgeInsets.only(left: 5, right: 5, top: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: ReqinvoutStatusDropdown.getStatusColor(item.status),
                width: 2)),
        child: Row(
          children: <Widget>[
            Container(
              width: 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //if (_list.length > 1 && _isFullControl && _isOwner())
                  InkWell(
                    child: Icon(Icons.close, size: 25, color: Colors.red)  ,
                    onTap: () {
                      if((reqPo.status == ReqPoStatusDropdown.STATUS_NEW || reqPo.status == ReqPoStatusDropdown.STATUS_REJECT || reqPo.id == null ) && _isOwner() )
                        _onRemoveItem(index: index);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RotatedBox(
                      quarterTurns: 3,
                      child: SText(
                        '${index + 1}',
                        style: TextStyle(fontSize: 18),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  //if (_isFullControl && _isOwner())
                  InkWell(
                    child: Icon(Icons.add, size: 25, color: Colors.blue),
                    onTap: () {
                      if((reqPo.status == ReqPoStatusDropdown.STATUS_NEW || reqPo.status == ReqPoStatusDropdown.STATUS_REJECT || reqPo.id == null ) && _isOwner() )
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
                    columnWidths: {
                      0: FractionColumnWidth(3 / 10),
                      1: FractionColumnWidth(7 / 10)
                    },
                    border: _tableBorder,
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [
                        TableCell(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 22,
                            child: SText(
                              L10n.ofValue().pur11TableItemcode,
                              textAlign: TextAlign.center,
                              style: headerStyle.merge(TextStyle(
                                  color: QuotationUtil.getQtyColor("qty"))),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            //height: 22

                            child: STextField(
                              style: headerStyle,
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.only(top: 2, bottom: 2),
                                  border: InputBorder.none),
                              onTap: () {
                                _showSearchDialog(index,"itemcode");
                                //print(index);
                              },
                              controller: itemCodeList[index],
                              keyboardType: TextInputType.multiline,
                              maxLines: null
                            ),
                          ),
                        ),
                      ]),

                      ///Label
                      TableRow(children: [
                        TableCell(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 22,
                            child: SText(
                              L10n.ofValue().pur11TableItemcodeorder,
                              textAlign: TextAlign.center,
                              style: headerStyle.merge(TextStyle(
                                  color: QuotationUtil.getQtyColor("qty"))),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            // height: 22,
                            child: STextField(
                              style: headerStyle,
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.only(top: 2, bottom: 2),
                                  border: InputBorder.none),
                              onTap: () {
                                _showSearchDialog(index,"itemordercode");
                                //print(index);
                              },

                              controller: itemCodeOrderList[index],
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
//                              style: TextStyle(
//                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ]),

                      TableRow(children: [
                        TableCell(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 22,
                            child: SText(
                              L10n.ofValue().pur11TableItemname,
                              textAlign: TextAlign.center,
                              style: headerStyle.merge(TextStyle(
                                  color: QuotationUtil.getQtyColor("qty"))),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            // height: 22,
                            child: STextField(
                              style: headerStyle,
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.only(top: 2, bottom: 2),
                                  border: InputBorder.none),
                              controller: itemNameList[index],
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              //maxLines: 10,
//                              style: TextStyle(
//                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ]),

                      TableRow(children: [
                        TableCell(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 22,
                            child: SText(
                              L10n.ofValue().pur11TableItemnameorigin,
                              textAlign: TextAlign.center,
                              style: headerStyle.merge(TextStyle(
                                  color: QuotationUtil.getQtyColor("qty"))),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            //height: 22,
                            child: STextField(
                              style: headerStyle,
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.only(top: 2, bottom: 2),
                                  border: InputBorder.none),
                              onTap: () {
                                _showSearchDialog(index,"itemnameorigin");
                                //print(index);
                              },
                              controller: itemNameOriginList[index],
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
//                              style: TextStyle(
//                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ]),

                      TableRow(children: [
                        TableCell(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 22,
                            child: SText(
                              L10n.ofValue().pur11TableBrand,
                              textAlign: TextAlign.center,
                              style: headerStyle.merge(TextStyle(
                                  color: QuotationUtil.getQtyColor("qty"))),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            //height: 22,
                            child: STextField(
                              style: headerStyle,
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.only(top: 2, bottom: 2),
                                  border: InputBorder.none),
                              onTap: () {
                                _showSearchDialog(index,"brand");
                                //print(index);
                              },
                              controller: brandList[index],
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
//                              style: TextStyle(
//                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ]),

                      TableRow(children: [
                        TableCell(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 22,
                            child: SText(
                              L10n.ofValue().pur11TableQuantity,
                              textAlign: TextAlign.center,
                              style: headerStyle.merge(TextStyle(
                                  color: QuotationUtil.getQtyColor("qty"))),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            //height: 22,
                            child: STextField(
                              style: headerStyle,
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.only(top: 2, bottom: 2),
                                  border: InputBorder.none),
                              controller: quantityList[index],
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
//                              style: TextStyle(
//                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ]),

                      TableRow(children: [
                        TableCell(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 22,
                            child: SText(
                              L10n.ofValue().pur11TableUnit,
                              textAlign: TextAlign.center,
                              style: headerStyle.merge(TextStyle(
                                  color: QuotationUtil.getQtyColor("qty"))),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            //height: 22,
                            child: STextField(
                              style: headerStyle,
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.only(top: 2, bottom: 2),
                                  border: InputBorder.none),
                              onTap: () {
                                _showSearchDialog(index,"unit");
                                //print(index);
                              },
                              controller: unitList[index],
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
//                              style: TextStyle(
//                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ]),

                      TableRow(children: [
                        TableCell(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 22,
                            child: SText(
                              L10n.ofValue().pur11TableStock,
                              textAlign: TextAlign.center,
                              style: headerStyle.merge(TextStyle(
                                  color: QuotationUtil.getQtyColor("qty"))),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            // height: 22,
                            child: STextField(
                              style: headerStyle,
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.only(top: 2, bottom: 2),
                                  border: InputBorder.none),
                              controller: stockList[index],
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
//                              style: TextStyle(
//                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ]),

                      TableRow(children: [
                        TableCell(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            // height: ,
                            child: SText(
                              L10n.ofValue().pur11TablePublishCustomer,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                              style: headerStyle.merge(TextStyle(
                                  color: QuotationUtil.getQtyColor("qty"))),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            // height: 22,
                            child: STextField(
                              style: headerStyle,
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.only(top: 2, bottom: 2),
                                  border: InputBorder.none),
                              onTap: () {
                                _showSearchDialog(index,"customer");
                                //print(index);
                              },
                              controller: publishCustomerList[index],
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
//                              style: TextStyle(
//                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ]),

                      TableRow(children: [
                        TableCell(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 22,
                            child: SText(
                              L10n.ofValue().pur11TableStatus,
                              textAlign: TextAlign.center,
                              style: headerStyle.merge(TextStyle(
                                  color: QuotationUtil.getQtyColor("qty"))),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            //height: 22,
                            child: STextField(
                              style: headerStyle,
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.only(top: 2, bottom: 2),
                                  border: InputBorder.none),
                              controller: statusList[index],
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
//                              style: TextStyle(
//                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 22,
                            child: SText(
                              L10n.ofValue().pur11TableInventoryincode,
                              textAlign: TextAlign.center,
                              style: headerStyle.merge(TextStyle(
                                  color: QuotationUtil.getQtyColor("qty"))),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            //height: 22,
                            child: STextField(
                              style: headerStyle,
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.only(top: 2, bottom: 2),
                                  border: InputBorder.none),
                              // controller: inventoryInCodeList[index],
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
//                              style: TextStyle(
//                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ]),

                      TableRow(children: [

                        TableCell(

                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 22,
                            child: SText(
                              L10n.ofValue().pur11TableQuotationcode,
                              textAlign: TextAlign.center,
                              style: headerStyle.merge(TextStyle(
                                  color: QuotationUtil.getQtyColor("qty"))),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            // height: 22,
                            child: STextField(
                              style: headerStyle,
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.only(top: 2, bottom: 2),
                                  border: InputBorder.none),
                              onTap: () {
                                _showSearchDialog(index,"quotation");
                                //print(index);
                              },
                              controller: quotationCodeList[index],
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
//                              style: TextStyle(
//                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ]),

                      TableRow(children: [
                        TableCell(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 22,
                            child: SText(
                              L10n.ofValue().pur11TablePoCode,
                              textAlign: TextAlign.center,
                              style: headerStyle.merge(TextStyle(
                                  color: QuotationUtil.getQtyColor("qty"))),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            // height: 22,
                            child: STextField(
                              style: headerStyle,
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.only(top: 2, bottom: 2),
                                  border: InputBorder.none),
                              controller: poCodeList[index],
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
//                              style: TextStyle(
//                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ]),

                      TableRow(children: [
                        TableCell(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 22,
                            child: SText(
                              L10n.ofValue().pur11TableContractcode,
                              textAlign: TextAlign.center,
//                              style: headerStyle.merge(TextStyle(
//                                  color: QuotationUtil.getQtyColor("qty"))),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            // height: 22,
                            child: STextField(
                              style: headerStyle,
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.only(top: 2, bottom: 2),
                                  border: InputBorder.none),

                              onTap: () {
                                _showSearchDialog(index,"contract");
                                //print(index);
                              },
                              controller: contractCodeList[index],
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
//                              style: TextStyle(
//                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 22,
                            child: SText(
                              L10n.ofValue().pur11TableReqInventoryoutcode,
                              textAlign: TextAlign.center,
                              style: headerStyle.merge(TextStyle(
                                  color: QuotationUtil.getQtyColor("qty"))),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            //height: 22,
                            child: STextField(
                              style: headerStyle,
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.only(top: 2, bottom: 2),
                                  border: InputBorder.none),
                              onTap: () {
                                _showSearchDialog(index,"reqinventoryout");
                                //print(index);
                              },
                              controller: reqInventoryOutCodeList[index],
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
//                              style: TextStyle(
//                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ]),

                      TableRow(children: [
                        TableCell(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 22,
                            child: SText(
                              L10n.ofValue().pur11TableNotes,
                              textAlign: TextAlign.center,
                              style: headerStyle.merge(TextStyle(
                                  color: QuotationUtil.getQtyColor("qty"))),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            //height: 22,
                            child: STextField(
                              style: headerStyle,
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.only(top: 2, bottom: 2),
                                  border: InputBorder.none),
                              controller: notesList[index],
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
//                              style: TextStyle(
//                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ]),

                      ///Input
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
      flexibleSpace: Container(decoration: STextStyle.appBarDecoration()),
      titleSpacing: -5,
      title: SText(L10n.ofValue().reqPo + _getExtraAppBarTitle(),
          style: TextStyle(fontSize: 16)),
      actions: <Widget>[
        if (_isEditing)
          InkWell(
            child: Icon(_draggable ? Icons.phonelink_lock : Icons.sort),
            onTap: () {
              _draggable = !_draggable;
              setState(() {});
            },
          )
      ],
    );
  }

  String _getExtraAppBarTitle() {
    String title = ' - ';
    if (reqPo != null) {
      title += L10n.ofValue().update;
    } else {
      title += L10n.ofValue().addNew;
    }

    // if (reqPo != null)
    //  title += ' - ' + L10n.ofValue().fromQuotation;

    return title;
  }

  String getBusinessCode() {
    return "pur11";
  }

  bool roleControl(String buttonName) {
    int id = 0;
    int creatorId = 0;
    int status = RequestPoView.STATUS_NEW;
    int submit = Constant.SUBMIT_0;
    int loginUserId = GlobalParam.USER_ID;
    int ownerApprove = 0;
    if (reqPo != null) {
      id = reqPo.id;
      creatorId = reqPo.createdId != null ? reqPo.createdId : null;
      status = reqPo.status;
      status = status == null ? RequestPoView.STATUS_NEW : status;
      submit = reqPo.submit != null ? reqPo.submit : 0;
      ownerApprove = getApproveLevel();
    }
    if (reqPo.id == null) {
      return false;
    }

    bool isApproveLevel1 = userBusiness.isLevel1;
    bool isApproveLevel2 = userBusiness.isLevel2;
    bool isApproveLevel3 = userBusiness.isLevel3;

    if (RequestPoView.STATUS_NEW == status) {
      if (buttonName == "cbApprove") {
        if (isApproveLevel1 || isApproveLevel2 || isApproveLevel3) {
          return true;
        }
      }
      if (buttonName == "cbSubmit") {
        if (!isApproveLevel3) {
          return true;
        }
      }
    } else if (RequestPoView.STATUS_REJECT == reqPo.status) {
      if (buttonName == "cbApprove") {
        if (isApproveLevel1 || isApproveLevel2 || isApproveLevel3) {
          return true;
        }
      }
      if (buttonName == "cbSubmit") {
        if (!isApproveLevel3) {
          return true;
        }
      }
    } else if (RequestPoView.STATUS_WAITING == status) {
      if (Constant.SUBMIT_3 == submit) {
        if (isApproveLevel3) {
          if (buttonName == "cbApprove") return true;
        } else if (isApproveLevel2) {
          if (buttonName == "cbCancelSubmit") return true;
        } else if (isApproveLevel1) {}
      } else if (Constant.SUBMIT_2 == submit) {
        if (isApproveLevel3) {
          if (buttonName == "cbApprove") return true;
        } else if (isApproveLevel2) {
          if (buttonName == "cbSubmit") return true;
          if (buttonName == "cbApprove") return true;
        } else if (isApproveLevel1) {
          if (buttonName == "cbCancelSubmit") return true;
        }
      } else if (Constant.SUBMIT_1 == submit) {
        if (isApproveLevel3) {
          // if(buttonName == "cbSubmit") return true;
          if (buttonName == "cbApprove") return true;
        } else if (isApproveLevel2) {
          if (buttonName == "cbSubmit") return true;
          if (buttonName == "cbApprove") return true;
        } else if (isApproveLevel1) {
          if (buttonName == "cbSubmit") return true;
          if (buttonName == "cbApprove") return true;
        }
      } else if (Constant.SUBMIT_0 == submit) {
        if (isApproveLevel3) {
          //if(buttonName == "cbSubmit") return true;
          if (buttonName == "cbApprove") return true;
        } else if (isApproveLevel2) {
          if (buttonName == "cbSubmit") return true;
          if (buttonName == "cbApprove") return true;
        } else if (isApproveLevel1) {
          if (buttonName == "cbSubmit") return true;
          if (buttonName == "cbApprove") return true;
        }
      }

      if (GlobalParam.EMPLOYEE_ID == reqPo.requesterId ||
          loginUserId == creatorId) {
        if (submit <= (ownerApprove + 1)) {
          if (buttonName == "cbCancelSubmit") {
            return true;
          }
        }
      }
    } else if (RequestPoView.STATUS_SUBMIT == status) {
      if (buttonName == "cbCancelApprove") {
        if (isApproveLevel1) return true;
      }
    } else if (RequestPoView.STATUS_PUR == status) {
      if (buttonName == "cbCancelApprove") {
        if (isApproveLevel2) return true;
      }
    } else if (RequestPoView.STATUS_APPROVED == status) {
      if (buttonName == "cbCancelApprove") {
        if (isApproveLevel3) return true;
      }
    } else if (RequestPoView.STATUS_CANCELED == status) {}
    // else if (RequestPoView.STATUS_DONE == status || RequestPoView.STATUS_UNDONE == status) {

    //}
    return false;
  }

  int getApproveLevel() {
    int level = 0;
    if (reqPo.isOwnerApproveLevel3 == 1) {
      level = 3;
    } else if (reqPo.isOwnerApproveLevel2 == 1) {
      level = 2;
    } else if (reqPo.isOwnerApproveLevel1 == 1) {
      level = 1;
    }
    return level;
  }
  Widget buildAddRemoveRowIcon(String iconType){
    if((reqPo.status == ReqPoStatusDropdown.STATUS_NEW || reqPo.status == ReqPoStatusDropdown.STATUS_REJECT || reqPo.id == null ) && _isOwner() ) {
      if(iconType == "addIcon")
        return Icon(Icons.add, size: 25, color: Colors.blue);
      else
        return Icon(Icons.close, size: 25, color: Colors.red);
    }
    else
      return null;
  }

  @override
  void dispose() {
    super.dispose();

    requestPoItemStreamController.close();
    _saveOrUpdateStreamController.close();
  }
}
