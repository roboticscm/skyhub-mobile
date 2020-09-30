import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/constant.dart';
import 'package:mobile/common/global_function.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/inventory/request_inventory_out/details/reqinvout_details_ui.dart';
import 'package:mobile/modules/inventory/request_inventory_out/request_inventory_out_api.dart';
import 'package:mobile/modules/inventory/request_inventory_out/request_inventory_out_model.dart';
import 'package:mobile/modules/notification/task_approve_submit/task_approve_submit_list_api.dart';
import 'package:mobile/modules/sales/quotation/quotation_api.dart';
import 'package:mobile/modules/sales/quotation/quotation_model.dart';
import 'package:mobile/modules/sales/quotation/quotation_util.dart';
import 'package:mobile/modules/sales/request_po/detail/reqpo_details_ui.dart';
import 'package:mobile/modules/sales/request_po/request_po_api.dart';
import 'package:mobile/modules/sales/request_po/request_po_model.dart';
import 'package:mobile/modules/user_business/user_business_list_api.dart';
import 'package:mobile/modules/user_business/user_business_model.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/widgets/data_widget/generic_status_dropdown.dart';
import 'package:mobile/widgets/particular/approve_button.dart';
import 'package:mobile/widgets/particular/cancel_approve_button.dart';
import 'package:mobile/widgets/particular/cancel_submit_button.dart';
import 'package:mobile/widgets/particular/inventory_out_request_button.dart';
import 'package:mobile/widgets/particular/inventory_out_request_button_add_new.dart';
import 'package:mobile/widgets/particular/order_request_button.dart';
import 'package:mobile/widgets/particular/order_request_button_add_new.dart';
import 'package:mobile/widgets/particular/sclose_button.dart';
import 'package:mobile/widgets/particular/ssave_button.dart';
import 'package:mobile/widgets/particular/submit_button.dart';
import 'package:mobile/widgets/scheckbox.dart';
import 'package:mobile/widgets/scircular_progress_indicator.dart';
import 'package:mobile/widgets/sdialog.dart';
import 'package:mobile/widgets/shtml.dart';
import 'package:mobile/widgets/stext.dart';
import 'package:mobile/widgets/stext_field.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';

class QuotationDetailsUI extends StatefulWidget {
  final QuotationView quotation;
  final QuotationAPI quotationAPI;
  final UserBusiness userBusiness;
  const QuotationDetailsUI({Key key, this.quotation, this.quotationAPI,this.userBusiness}) : super(key: key);
  @override
  _QuotationDetailsUIState createState() => _QuotationDetailsUIState();
}

class _QuotationDetailsUIState extends State<QuotationDetailsUI> {
  QuotationView get _quotation => widget.quotation;
  StreamController<List<QuotationItemView>> _quotationItemStreamController = StreamController.broadcast();
  List<int> _checkedItems = [];
  List<TextEditingController> _unitPriceTextControllers = [];
  List<TextEditingController> _quantityTextControllers = [];
  List<TextEditingController> _deliveredQtyTextControllers = [];
  List<TextEditingController> _remainedQtyTextControllers = [];
  List<TextEditingController> _stockQtyTextControllers = [];
  List<TextEditingController> _totalPriceTextControllers = [];
  List<TextEditingController> _itemCodeTextControllers = [];
  final _numberFormatter = NumberFormat("#,###");

  var _customerNameTextController = TextEditingController();
  var _contentTextController = TextEditingController();
  var _quotationDateTextController = TextEditingController();
  var _refNoTextController = TextEditingController();
  var _tableBorder = TableBorder.all(color: Colors.grey, width: 0.2);
  List<QuotationItemView> _list;
  var _requestInventoryOutAPI = RequestInventoryOutAPI();
  bool editableWidget = false;
  UserBusiness _userBusinessReqInventoryOut;
  UserBusiness get userBusiness => widget.userBusiness;
  UserBusiness userBusinessReqPo;
  @override
  void initState() {
    super.initState();


    _customerNameTextController.text = _quotation.customerName.replaceAll("<mark>", "").replaceAll("</mark>", "");
    _contentTextController.text = _quotation.content;
    _quotationDateTextController.text = Util.getDateStr(_quotation.quotationDate);
    _refNoTextController.text = _quotation.code;
    _loadDataControl();
    _loadData();

  }

  Future<void> _loadDataControl() async {

    _userBusinessReqInventoryOut =
    await UserBusinessListAPI().getUserBusinessWithUserIdAndBusiness(
        userId: GlobalParam.getUserId(), business: "inv03");

    userBusinessReqPo =
    await UserBusinessListAPI().getUserBusinessWithUserIdAndBusiness(
        userId: GlobalParam.getUserId(), business: "pur11");

  }

  void _loadData() async {
    var ret = await widget.quotationAPI.findQuotationItem(quotationId: widget.quotation.id);
    if(ret.item1 != null) {
      _list = ret.item1;
      for(var i = 0 ; i < ret.item1.length; i++) {
        _itemCodeTextControllers.add(TextEditingController());
        _itemCodeTextControllers[i].text ='${ret.item1[i].itemCode??""}';
        _checkedItems.add(null);
        _unitPriceTextControllers.add(TextEditingController());
        _unitPriceTextControllers[i].text = '${ret.item1[i].price != null ? _numberFormatter.format(ret.item1[i].price.toDouble()) : ""}';

        _quantityTextControllers.add(TextEditingController());
        _quantityTextControllers[i].text = '${ret.item1[i].qty??0}';

        _deliveredQtyTextControllers.add(TextEditingController());
        _deliveredQtyTextControllers[i].text = '${ret.item1[i].qtyOut??0}';

        _remainedQtyTextControllers.add(TextEditingController());
        _remainedQtyTextControllers[i].text = '${(ret.item1[i].qty??0) - (ret.item1[i].qtyOut??0)}';

        _stockQtyTextControllers.add(TextEditingController());
        _stockQtyTextControllers[i].text = '${ret.item1[i].stock??0}';

        _totalPriceTextControllers.add(TextEditingController());
        var totalPrice = (ret.item1[i].qty??0)*(ret.item1[i].price??0);
        _totalPriceTextControllers[i].text = '${_numberFormatter.format(totalPrice.toDouble())}';
      }
      _quotationItemStreamController.sink.add(ret.item1);
    } else {
      _quotationItemStreamController.sink.add([]);
      Toast.show(ret.item2, GlobalParam.appContext);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),

      body: _buildBody(),
      bottomNavigationBar: _buildBottom(),
    );
  }

  Widget _buildBottom() {
    var headerStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
    var headerAlign = TextAlign.right;
    return StreamBuilder<Object>(
      stream: _quotationItemStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData)
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
              child: Table(
                columnWidths: {0: FixedColumnWidth(40)},
                border: _tableBorder,
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
                            padding: EdgeInsets.only(right: 4),
                            alignment: Alignment.centerRight,
                            child: SText('${_numberFormatter.format(_sumQty("qty"))}',
                            style: headerStyle.merge(TextStyle(color: QuotationUtil.getQtyColor("qty"))),
                            textAlign: headerAlign,)
                          ),
                        ),
                        TableCell(
                          child: Container(
                            height: 30,
                            padding: EdgeInsets.only(right: 4),
                            alignment: Alignment.centerRight,
                            child: SText('${_numberFormatter.format(_sumQty("deliveredQty"))}',
                              style: headerStyle.merge(TextStyle(color: QuotationUtil.getQtyColor("deliveredQty"))),
                              textAlign: headerAlign,)
                          ),
                        ),
                        TableCell(
                          child: Container(
                              height: 30,
                              padding: EdgeInsets.only(right: 4),
                              alignment: Alignment.centerRight,
                              child: SText('${_numberFormatter.format(_sumQty("remainedQty"))}',
                                style: headerStyle.merge(TextStyle(color: QuotationUtil.getQtyColor("remainedQty"))),
                                textAlign: headerAlign,)
                          ),
                        ),
                        TableCell(
                          child: Container(
                              height: 30,
                              padding: EdgeInsets.only(right: 4),
                              alignment: Alignment.centerRight,
                              child: SText('${_numberFormatter.format(_sumQty("stockQty"))}',
                                style: headerStyle.merge(TextStyle(color: QuotationUtil.getQtyColor("stockQty"))),
                                textAlign: headerAlign,)
                          ),
                        ),
                      ]
                  ),
                ],
              )
            ),

            Container(
              decoration: BoxDecoration(
                color: STextStyle.GRADIENT_COLOR_AlPHA,
                border: Border(bottom: BorderSide(
                  color: Colors.grey
                ))
              ),
              alignment: Alignment.centerRight,
              height: 30,
              width: double.infinity,
              child: SText(
                '${L10n.ofValue().grandTotal}: ${_numberFormatter.format(widget.quotation.grandTotal)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white
                ),
              ),
            ),
            Container(
              height: 55,
              color: STextStyle.GRADIENT_COLOR1,
              child: Row(
                children: <Widget>[
                  //SCloseButton(color: Colors.white,),
                  Spacer(),
                 // if(_isOwner())
                  RequestInventoryOutButton(onTap: () async {
                    if (!_validateRequestInventoryOut())
                      return;

                    if(_userBusinessReqInventoryOut == null) {
                      _userBusinessReqInventoryOut= await UserBusinessListAPI().getUserBusinessWithUserIdAndBusiness(
                          userId: GlobalParam.getUserId(), business: "inv03");
                      if(_userBusinessReqInventoryOut == null)
                        return;

                    }

                    RequestInventoryOutView requestInventoryOut = new  RequestInventoryOutView();
                    var tmprequestInventoryOut = await _requestInventoryOutAPI.findReqInventoryOutByQuotationId(_quotation.id) ;
                    if(tmprequestInventoryOut.item1 != null && tmprequestInventoryOut.item1.length != 0){
                      requestInventoryOut = tmprequestInventoryOut .item1[0] as RequestInventoryOutView;
                    }


                    if(tmprequestInventoryOut.item1 != null && tmprequestInventoryOut.item1.length != 0){
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                        return ReqinvoutDetailsUI(
                            quotation: _quotation,
                            //quotationItemList: _getDataList(),
                            isFullControl: true,
                            requestInventoryOutAPI: _requestInventoryOutAPI,
                            userBusiness: _userBusinessReqInventoryOut,
                            requestInventoryOut: requestInventoryOut ,

                        );
                      }));

                    }
                    else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ReqinvoutDetailsUI(
                                quotation: _quotation,
                                quotationItemList: _getDataList(),
                                isFullControl: true,
                                requestInventoryOutAPI: _requestInventoryOutAPI,
                                userBusiness: _userBusinessReqInventoryOut
                            );
                          }));
                    }
                  },),

                  //if(_isOwner())
                  OrderRequestButton(onTap : () async {
                    //Toast.show(L10n.ofValue().underConstruction, context);
                    if (!_validateRequestInventoryOut())
                      return;

                   if(userBusinessReqPo == null) {
                     userBusinessReqPo = await UserBusinessListAPI().getUserBusinessWithUserIdAndBusiness(
                         userId: GlobalParam.getUserId(), business: "pur11");
                     if(userBusinessReqPo == null)
                     return;

                   }

                    RequestPoAPI requestPoAPI = new RequestPoAPI();
                    RequestPoView reqPo = new RequestPoView();
                     var tmpReqPo = await requestPoAPI.findReqPoByQuotationId(_quotation.id) ;
                    if(tmpReqPo.item1 != null && tmpReqPo.item1.length != 0){
                      reqPo = tmpReqPo.item1[0] as RequestPoView;
                    }

                    if(tmpReqPo.item1 == null || tmpReqPo.item1.length == 0)
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                      return ReqPoDetailsUI(
                             requestPoAPI: requestPoAPI,
                             reqPo: reqPo,
                             userBusiness: userBusinessReqPo,
                             quotation: _quotation,
                             quotationItemList: _getDataList(),
                          //isFullControl: false,
                         );
                    }));
                    else
                     Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                        return ReqPoDetailsUI(
                          requestPoAPI: requestPoAPI,
                          reqPo: reqPo,
                          userBusiness: userBusinessReqPo,
                          quotation: _quotation,
                           createNew: false,
                          //isFullControl: false,
                        );
                      }));

                  },),

                  if(roleControl("cbSubmit",_quotation)== true)
                    SubmitButton(
                        color: Colors.white,
                        onTap: (){
                          // _onSaveOrUpdate(_bindingData());
                          _onSubmit();
                        },
                        onAskMessage:() {
                          return '${L10n.ofValue().submit} <b>${_getConfirmMessage()}</b>. ${L10n.ofValue().areYouSure}?';
                        }
                    ),
                  if(roleControl("cbCancelSubmit",_quotation)== true)
                    CancelSubmitButton(
                        color: Colors.white,
                        onTap: (){
                          _onCancelSubmit();
                        },
                        onAskMessage:() {
                          return '${L10n.ofValue().cancelSubmit} <b>${_getConfirmMessage()}</b>. ${L10n.ofValue().areYouSure}?';
                        }
                    ),
                  ///TODO
                  if(roleControl("cbApprove",_quotation)== true)
                    ApproveButton(
                      color: Colors.white,
                      onTap: (){
                        _onApprove();
                      },
                      onAskMessage: () {
                        return '${L10n.ofValue().approve} <b>${_getConfirmMessage()}</b>. ${L10n.ofValue().areYouSure}?';
                      },
                    ),

                  if(roleControl("cbCancelApprove",_quotation)== true)
                    CancelApproveButton(
                      color: Colors.white,
                      onTap: (){
                        _onCancelApprove();
                      },
                      onAskMessage: () {
                        return '${L10n.ofValue().cancelApprove} <b>${_getConfirmMessage()}</b>. ${L10n.ofValue().areYouSure}?';
                      },
                    ),
                ],
              ),

            ),

          ],
        );
        else
          return Container();
      }
    );
  }

  void _onSubmit() {
    var _taskApproveSubmitListAPI = TaskApproveSubmitListAPI();
    _taskApproveSubmitListAPI
        .doApproveSubmitWithUserIdAndGroupIdAndSourceIdAndTask(
        userId: GlobalParam.USER_ID,
        groupId: 2,
        sourceId: _quotation.id,
        task: 1 ).then((response) {
      //_loadData();
      if(response.status.toString() == "success"){
        int submit = json.decode(response.updateObject)["submit"];
        int status = json.decode(response.updateObject)["status"];

        _quotation.submit = submit;
        _quotation.status = status;

        setState(() {
        });
        if(response.message.length >0)SDialog.alert("",response.message);
      }
      else{
        SDialog.alert("",response.message);
      }

    });
  }

  void _onCancelSubmit() {
    var _taskApproveSubmitListAPI = TaskApproveSubmitListAPI();
    _taskApproveSubmitListAPI
        .doApproveSubmitWithUserIdAndGroupIdAndSourceIdAndTask(
        userId: GlobalParam.USER_ID,
        groupId: 2,
        sourceId: _quotation.id,
        task: 2 ).then((response) {
      //_loadData();
      if(response.status.toString() == "success"){
        int submit = json.decode(response.updateObject)["submit"];
        int status = json.decode(response.updateObject)["status"];
        _quotation.submit = submit;
        _quotation.status = status;
        setState(() {
        });
        if(response.message.length >0)SDialog.alert("",response.message);
      }
      else{
        SDialog.alert("",response.message);
      }

    });
  }

  void _onApprove() {

    var _taskApproveSubmitListAPI = TaskApproveSubmitListAPI();
    _taskApproveSubmitListAPI
        .doApproveSubmitWithUserIdAndGroupIdAndSourceIdAndTask(
        userId: GlobalParam.USER_ID,
        groupId: 2,
        sourceId: _quotation.id,
        task: 3 ).then((response) {

      if(response.status.toString() == "success"){

        int submit = json.decode(response.updateObject)["submit"];
        int status = json.decode(response.updateObject)["status"];
        _quotation.submit = submit;
        _quotation.status = status;

        setState(() {

        });
        if(response.message.length >0)SDialog.alert("",response.message);
      }
      else{
        SDialog.alert("",response.message);
      }

    });


  }
  void _onCancelApprove() {

    var _taskApproveSubmitListAPI = TaskApproveSubmitListAPI();
    _taskApproveSubmitListAPI
        .doApproveSubmitWithUserIdAndGroupIdAndSourceIdAndTask(
        userId: GlobalParam.USER_ID,
        groupId: 2,
        sourceId: _quotation.id,
        task: 4 ).then((response) {

      if(response.status.toString() == "success"){
        int submit = json.decode(response.updateObject)["submit"];
        int status = json.decode(response.updateObject)["status"];

        _quotation.submit = submit;
        _quotation.status = status;
        setState(() {


        });
        if(response.message.length >0)SDialog.alert("",response.message);
      }
      else{
        SDialog.alert("",response.message);
      }

    });


  }

  QuotationView _bindingData() {
    return QuotationView(
      id: _quotation.id,
     /* code : _selectedHoliday != null ? _selectedHoliday.code : null,
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
      branchId: GlobalParam.BRANCH_ID,*/
    );
  }
  String _getConfirmMessage() {
    //return HolidayUtil.getHolidayTypeName(h?.holidayType) + " - " +
     //   Util.getShortDateTimeStr(h.startDate) + " - " + Util.getShortDateTimeStr(h.endDate);
    return   _quotation.code;
  }

  bool _isOwner() {
    return ([_quotation.picId, _quotation.creatorId, _quotation.requesterId].contains(GlobalParam.EMPLOYEE_ID)
        || [_quotation.createdId].contains(GlobalParam.USER_ID));
  }

  bool _validateRequestInventoryOut() {
    ///check status
    if (![GenericStatusDropdown.STATUS_SUBMIT,
      GenericStatusDropdown.STATUS_APPROVED,
      GenericStatusDropdown.STATUS_MANAGER,
      GenericStatusDropdown.STATUS_SOLD,

    ].contains(_quotation.status)) {
      Toast.show(L10n.of(context).quotationHasNotBeenApproved, context);
      return false;
    }

    ///check item
    if(!_checkedItems.any((test) => test !=null)) {
      Toast.show(L10n.of(context).youMustSelectAtLessOneItem, context);
      return false;
    }

    return true;
  }


  List<QuotationItemView> _getDataList() {
    if ((_list?.length??0) == 0)
      return null;

    return List.from(_list.where((test){
      return _checkedItems.contains(test.id);
    }));
  }




  int _sumQty(String type) {
    switch(type){
      case "qty":
        return _quantityTextControllers.isEmpty ? 0 : _quantityTextControllers.map((item) => int.parse(item.text.length > 0 ? item.text : '0'))
          .reduce((x, y) => x + y);
      case "deliveredQty":
        return _deliveredQtyTextControllers.isEmpty ? 0 : _deliveredQtyTextControllers.map((item) => int.parse(item.text.length > 0 ? item.text : '0'))
            .reduce((x, y) => x + y);
      case "remainedQty":
        return _remainedQtyTextControllers.isEmpty ? 0 : _remainedQtyTextControllers.map((item) => int.parse(item.text.length > 0 ? item.text : '0'))
            .reduce((x, y) => x + y);
      case "stockQty":
        return _stockQtyTextControllers.isEmpty ? 0 : _stockQtyTextControllers.map((item) => int.parse(item.text.length > 0 ? item.text : '0'))
            .reduce((x, y) => x + y);
    }

    return 0;
  }

  Widget _buildBody() {
    return StreamBuilder<List<QuotationItemView>>(
      stream: _quotationItemStreamController.stream,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return _buildListView(snapshot.data);
        } else {
          return SCircularProgressIndicator.buildSmallCenter();
        }
      },
    );
  }

  Widget _buildHeaderForm(QuotationView item) {
    return PreferredSize(
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
                border: _tableBorder,
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: SHtml(
                            data: item.code,
                            maxLines: 1,
                            defaultTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      TableCell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GenericStatusDropdown.getStatusIcon(_quotation.status, 20),
                            SText(
                                ' ' + GenericStatusDropdown.getStatusName(_quotation.status),

                            ),
                          ],
                        ),
                      ),
                      TableCell(
                        child: STextField(
                          enabled: editableWidget,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              hintText: L10n.ofValue().createdDate,
                              contentPadding: EdgeInsets.only(top: 2, bottom: 2),
                              border: InputBorder.none
                          ),
                          controller: _quotationDateTextController
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
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: STextField(
                            enabled: editableWidget,
                            decoration: InputDecoration(
                              hintText: L10n.ofValue().customer,
                              contentPadding: EdgeInsets.only(top: 2, bottom: 2),
                              border: InputBorder.none
                            ),
                            controller: _customerNameTextController
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Table(
                border: _tableBorder,
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: STextField(
                            enabled: editableWidget,
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

            ]
        ),
      ),
    );
  }

  Widget _buildListView(List<QuotationItemView> list) {
    return Column(
      children: <Widget>[
        SizedBox(height: 84, child: _buildHeaderForm(widget.quotation)),
        Expanded(
//          child: GridView.count (
//            crossAxisCount: (Util.getScreenWidth()/360).floor(),
//            childAspectRatio: 2.65,
//            children: <Widget>[
//              for(var i = 0; i < list.length; i ++)
//                _buildListItem(list[i], i)
//            ],
//          ),
          child: ListView (
            children: <Widget>[
              for(var i = 0; i < list.length; i ++)
                _buildListItem(list[i], i)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(QuotationItemView item, int index) {
    var headerStyle = TextStyle();

    var groupBgColor;
    var groupStyle = TextStyle(fontSize: 16, color: Colors.black);

    return Container(
      margin: EdgeInsets.only(left: 5, right: 5, top: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.grey,
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
                RotatedBox(quarterTurns: 3, child: SText('${index + 1}')),
                InkWell(
                  onLongPress: (){
                    for(var i = 0; i < _checkedItems.length; i++ )
                      _checkedItems[i] = _checkedItems[i] == null ?  _list[i].id  : null;
                    setState(() {
                    });
                  },
                  child: SCheckbox(
                    useTapTarget: false,
                    value: _checkedItems[index] != null,
                    onChanged: (value) {
                      _checkedItems[index] = value ? _list[index].id : null;
                      setState(() {
                      });
                    },
                  ),
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
                              child: SHtml(data: item.itemCode, maxLines: 1, defaultTextStyle: TextStyle(fontWeight: FontWeight.bold),),
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
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: SHtml(data: item.itemName, maxLines: 1,),
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
                    TableRow(
                      children: [
                        ///Unit price
                        TableCell(
                          child:  Container(
                            padding: EdgeInsets.only(left: 5),
                            child: SText(L10n.ofValue().unitPrice, style: headerStyle,)
                          ),
                        ),
                        TableCell(
                          child: Container(
                            child: STextField(
                              enabled: editableWidget,
                              controller: _unitPriceTextControllers[index],
                              textAlign: TextAlign.end,
                              style: headerStyle,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 5, top: 0, bottom: 0),
                                border: InputBorder.none
                              ),
                              keyboardType: TextInputType.numberWithOptions(),
                            ),
                          ),
                        ),
                      ]
                    ),
                    ///Label
                    TableRow(
                      children: [
                        TableCell(
                          child:  Table(
                            border: _tableBorder,
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Container(
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
                                        L10n.ofValue().deliveredQty,
                                        textAlign: TextAlign.center,
                                        style: headerStyle.merge(TextStyle(color: QuotationUtil.getQtyColor("deliveredQty")))
                                      )
                                    ),
                                  ),
                                ]
                              )
                            ],
                          ),
                        ),
                        TableCell(
                          child:  Table(
                            border: _tableBorder,
                            children: [
                              TableRow(
                                  children: [
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 22,
                                        child: SText(
                                          L10n.ofValue().remainedQty,
                                          textAlign: TextAlign.center,
                                          style: headerStyle.merge(TextStyle(color: QuotationUtil.getQtyColor("remainedQty")))
                                        )
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
                                  ]
                              )
                            ],
                          ),
                        ),
                      ]
                    ),
                    ///Input
                    TableRow(
                      children: [
                        TableCell(
                          child: Table(
                            border: _tableBorder,
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Container(
                                      height: 22,
                                      child: STextField(
                                        enabled: editableWidget,
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
                                      child: STextField(
                                        enabled: false,
                                        controller: _deliveredQtyTextControllers[index],
                                        style: TextStyle(color: QuotationUtil.getQtyColor("deliveredQty")),
                                        textAlign: TextAlign.end,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                                        ),
                                        keyboardType: TextInputType.numberWithOptions(),
                                      ),
                                    ),
                                  ),
                                ]
                              ),
                            ],
                          )
                        ),
                        TableCell(
                            child: Table(
                              border: _tableBorder,
                              children: [
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Container(
                                          height: 22,
                                          child: STextField(
                                            enabled: false,
                                            controller: _remainedQtyTextControllers[index],
                                            textAlign: TextAlign.end,
                                            style: TextStyle(color: QuotationUtil.getQtyColor("remainedQty")),
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
                                          child: STextField(
                                            enabled: false,
                                            controller: _stockQtyTextControllers[index],
                                            style: TextStyle(color: QuotationUtil.getQtyColor("stockQty")),
                                            textAlign: TextAlign.end,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                                            ),
                                            keyboardType: TextInputType.numberWithOptions(),
                                          ),
                                        ),
                                      ),
                                    ]
                                ),
                              ],
                            )
                        ),
                      ]
                    ),

                    ///Total Price
                    TableRow(
                      decoration: BoxDecoration(
                        color: groupBgColor,
                      ),
                      children: [
                        TableCell(
                          child:  Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: SText(L10n.ofValue().totalPrice, style: groupStyle,),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            child: STextField(
                              controller: _totalPriceTextControllers[index],
                              textAlign: TextAlign.end,
                              enabled: false,
                              style: groupStyle,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                              ),
                              keyboardType: TextInputType.numberWithOptions(),
                            ),
                          ),
                        ),
                      ]
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
          decoration: STextStyle.appBarDecoration()
      ),
      titleSpacing: -5,
      title: SText(L10n.ofValue().quotation),

      actions:

      <Widget>[
        //if(_isOwner())
          RequestInventoryOutButtonAddNew(onTap: () async {
            if (!_validateRequestInventoryOut())
              return;

            if(_userBusinessReqInventoryOut == null) {
              _userBusinessReqInventoryOut= await UserBusinessListAPI().getUserBusinessWithUserIdAndBusiness(
                  userId: GlobalParam.getUserId(), business: "inv03");
              if(_userBusinessReqInventoryOut == null)
                return;

            }


              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ReqinvoutDetailsUI(
                        quotation: _quotation,
                        quotationItemList: _getDataList(),
                        isFullControl: true,
                        requestInventoryOutAPI: _requestInventoryOutAPI,
                        userBusiness: _userBusinessReqInventoryOut
                    );
                  }));

          },),

       // if(_isOwner())
          OrderRequestButtonAddNew(onTap : () async {
            //Toast.show(L10n.ofValue().underConstruction, context);
            if (!_validateRequestInventoryOut())
              return;

            if(userBusinessReqPo == null) {
              userBusinessReqPo = await UserBusinessListAPI().getUserBusinessWithUserIdAndBusiness(
                  userId: GlobalParam.getUserId(), business: "pur11");
              if(userBusinessReqPo == null)
                return;

            }

            RequestPoAPI requestPoAPI = new RequestPoAPI();
            RequestPoView reqPo = new RequestPoView();

              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                return ReqPoDetailsUI(
                  requestPoAPI: requestPoAPI,
                  reqPo: reqPo,
                  userBusiness: userBusinessReqPo,
                  quotation: _quotation,
                  quotationItemList: _getDataList(),
                  //isFullControl: false,
                );
              }));


          },),
      ],


    );
  }

  @override
  void dispose() {
    super.dispose();
    _quotationItemStreamController.close();
  }

  String getBusinessCode(){
    return "sle03";
  }
  bool roleControl(String buttonName, QuotationView quotation){
    int id = 0;
    int creatorId =0 ;
    int status = QuotationView.STATUS_NEW;
    int submit = Constant.SUBMIT_0;
    int loginUserId = GlobalParam.USER_ID ;
    int ownerApprove =0;
    if(quotation != null) {
      id = quotation.id;
      creatorId = quotation.createdId != null? quotation.createdId : null;
      status = quotation.status;
      status = status == null ? QuotationView.STATUS_NEW : status;
      submit = quotation.submit != null ? quotation.submit : 0;
      ownerApprove = getApproveLevel(quotation);
    }
    //print(userBusiness.isLevel1);
   //print(userBusiness.isLevel2);
   // print(userBusiness.isLevel3);
    bool isApproveLevel1 = userBusiness.isLevel1;
    bool isApproveLevel2 = userBusiness.isLevel2;
    bool isApproveLevel3 = userBusiness.isLevel3;


    if (QuotationView.STATUS_NEW == status) {

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

    } else if (QuotationView.STATUS_REJECT == quotation.status) {
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
    } else if (QuotationView.STATUS_WAITING == status) {


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


      if ( GlobalParam.EMPLOYEE_ID == quotation.requesterId || loginUserId == creatorId ) {
        if (submit <= (ownerApprove + 1)) {
          if(buttonName == "cbCancelSubmit"){
            return true;
          }
        }
      }
    } else if (QuotationView.STATUS_SUBMIT == status) {
      if(buttonName == "cbCancelApprove"){
        if(isApproveLevel1) return true;
      }

    } else if (QuotationView.STATUS_MANAGER == status) {
      if(buttonName == "cbCancelApprove"){
        if(isApproveLevel2) return true;
      }
    } else if (QuotationView.STATUS_APPROVED == status) {
      if(buttonName == "cbCancelApprove"){
        if(isApproveLevel3) return true;
      }
    } else if (QuotationView.STATUS_CANCEL == status) {

    }
    return false;
  }

  int getApproveLevel(QuotationView quotation) {
    int level = 0;
    if (quotation.isOwnerApproveLevel3 == 1) {
      level = 3;
    } else if (quotation.isOwnerApproveLevel2 == 1) {
      level = 2;
    } else if (quotation.isOwnerApproveLevel1 == 1) {
      level = 1;
    }
    return level;
  }

}