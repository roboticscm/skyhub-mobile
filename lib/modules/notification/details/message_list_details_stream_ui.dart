import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kernel/text/serializer_combinators.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/convertor.dart';
import 'package:mobile/common/global_function.dart';
import 'package:mobile/common/sky_websocket.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/chat/chat_model.dart';
import 'package:mobile/modules/inventory/request_inventory_out/details/reqinvout_details_ui.dart';
import 'package:mobile/modules/inventory/request_inventory_out/request_inventory_out_api.dart';
import 'package:mobile/modules/inventory/request_inventory_out/request_inventory_out_model.dart';
import 'package:mobile/modules/notification/details/message_list_details_api.dart';
import 'package:mobile/modules/notification/details/message_list_details_bloc.dart';
import 'package:mobile/modules/notification/task_approve_submit/task_approve_submit_list_api.dart';
import 'package:mobile/modules/office/holiday/details/holiday_details_ui.dart';
import 'package:mobile/modules/office/holiday/holiday_api.dart';
import 'package:mobile/modules/office/holiday/holiday_model.dart';
import 'package:mobile/modules/sales/quotation/details/quotation_details_ui.dart';
import 'package:mobile/modules/sales/quotation/quotation_api.dart';
import 'package:mobile/modules/sales/quotation/quotation_model.dart';
import 'package:mobile/modules/sales/request_po/detail/reqpo_details_ui.dart';
import 'package:mobile/modules/sales/request_po/request_po_api.dart';
import 'package:mobile/modules/sales/request_po/request_po_model.dart';
import 'package:mobile/modules/sales/request_po/request_po_ui.dart';
import 'package:mobile/modules/user_business/user_business_list_api.dart';
import 'package:mobile/modules/user_business/user_business_model.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/widgets/scircular_progress_indicator.dart';
import 'package:mobile/widgets/sdialog.dart';
import 'package:mobile/widgets/shtml.dart';
import 'package:mobile/widgets/stext.dart';

class MessageListDetailsStreamUI extends StatefulWidget {
  //final String senderName;
  final int senderId;
  //final String senderAccount;
  //final DateTime lastAccess;
  //final bool isOnline;
  final approveOnly;
  final int groupId;
  //final MessageListDetailsBloc messageListDetailsBloc;

  MessageListDetailsStreamUI({
    Key key,
    //@required this.senderName,
    //@required this.senderAccount,
    @required this.senderId,
    //@required this.lastAccess,
    //@required this.isOnline,
    @required this.approveOnly,
    @required this.groupId,
    // @required this.messageListDetailsBloc,
  }) : super(key: key);

  @override
  _MessageListDetailsStreamUIState createState() =>
      _MessageListDetailsStreamUIState();
}

class _MessageListDetailsStreamUIState
    extends State<MessageListDetailsStreamUI> {
  var _messageDetailsStreamController =
      StreamController<List<ChatHistoryDetails>>();
  var _userBusinessListAPI = UserBusinessListAPI();
  bool notLoadWebsocket = false;
  UserBusiness userBusiness;
  HashMap chatGroupBusinessCode = new HashMap<int, String>();
  HashMap chatGroupBusinessName = new HashMap<int, String>();
  HashMap chatGroupTaskName = new HashMap<int, String>();
  TextEditingController _searchChar = TextEditingController();
  List<ChatHistoryDetails> data;
  @override
  void initState() {
    super.initState();
    chatGroupBusinessCode.putIfAbsent(ChatHistory.GROUP_HOLIDAY, () => 'hrm41');
    chatGroupBusinessCode.putIfAbsent(ChatHistory.GROUP_ADVANCE, () => 'acc31');
    chatGroupBusinessCode.putIfAbsent(
        ChatHistory.GROUP_QUOTATION, () => 'sle03');
    chatGroupBusinessCode.putIfAbsent(
        ChatHistory.GROUP_REQINVENTORYOUT, () => 'inv03');
    chatGroupBusinessCode.putIfAbsent(
        ChatHistory.GROUP_TRAVELING, () => 'hrm42');

    chatGroupBusinessCode.putIfAbsent(
        ChatHistory.GROUP_CONTRACT, () => 'sle11');
    chatGroupBusinessCode.putIfAbsent(
        ChatHistory.GROUP_ACCEPTANCE, () => 'sle13');

    chatGroupBusinessCode.putIfAbsent(
        ChatHistory.GROUP_EMPLOYEE, () => 'hrm01');
    chatGroupBusinessCode.putIfAbsent(
        ChatHistory.GROUP_REQINVENTORYIN, () => 'inv01');
    chatGroupBusinessCode.putIfAbsent(
        ChatHistory.GROUP_REQPAYMENT, () => 'acc41');
    chatGroupBusinessCode.putIfAbsent(ChatHistory.GROUP_PAYMENT, () => 'acc22');
    chatGroupBusinessCode.putIfAbsent(ChatHistory.GROUP_REQPO, () => 'pur11');
    chatGroupBusinessCode.putIfAbsent(
        ChatHistory.GROUP_INVENTORYOUT, () => 'inv04');
    chatGroupBusinessCode.putIfAbsent(
        ChatHistory.GROUP_INVENTORYIN, () => 'inv02');
    chatGroupBusinessCode.putIfAbsent(
        ChatHistory.GROUP_INSPECTION, () => 'svc13');
    chatGroupBusinessCode.putIfAbsent(
        ChatHistory.GROUP_REPAIRREPORT, () => 'svc15');
    chatGroupBusinessCode.putIfAbsent(ChatHistory.GROUP_PO, () => 'pur13');

    chatGroupBusinessName.putIfAbsent(
        ChatHistory.GROUP_HOLIDAY, () => L10n.ofValue().holiday);
    chatGroupBusinessName.putIfAbsent(
        ChatHistory.GROUP_ADVANCE, () => L10n.ofValue().advance);
    chatGroupBusinessName.putIfAbsent(
        ChatHistory.GROUP_QUOTATION, () => L10n.ofValue().quotation);
    chatGroupBusinessName.putIfAbsent(ChatHistory.GROUP_REQINVENTORYOUT,
        () => L10n.ofValue().reqInventoryOut);
    chatGroupBusinessName.putIfAbsent(
        ChatHistory.GROUP_TRAVELING, () => L10n.ofValue().traveling);
    chatGroupBusinessName.putIfAbsent(
        ChatHistory.GROUP_EMPLOYEE, () => L10n.ofValue().employee);

    chatGroupBusinessName.putIfAbsent(
        ChatHistory.GROUP_CONTRACT, () => L10n.ofValue().contract);
    chatGroupBusinessName.putIfAbsent(
        ChatHistory.GROUP_ACCEPTANCE, () => L10n.ofValue().acceptance);

    chatGroupBusinessName.putIfAbsent(
        ChatHistory.GROUP_REQINVENTORYIN, () => L10n.ofValue().reqInventoryIn);
    chatGroupBusinessName.putIfAbsent(
        ChatHistory.GROUP_REQPAYMENT, () => L10n.ofValue().reqPayment);
    chatGroupBusinessName.putIfAbsent(
        ChatHistory.GROUP_PAYMENT, () => L10n.ofValue().payment);
    chatGroupBusinessName.putIfAbsent(
        ChatHistory.GROUP_REQPO, () => L10n.ofValue().reqPo);
    chatGroupBusinessName.putIfAbsent(
        ChatHistory.GROUP_INVENTORYOUT, () => L10n.ofValue().inventoryOut);
    chatGroupBusinessName.putIfAbsent(
        ChatHistory.GROUP_INVENTORYIN, () => L10n.ofValue().inventoryIn);
    chatGroupBusinessName.putIfAbsent(
        ChatHistory.GROUP_INSPECTION, () => L10n.ofValue().inspection);
    chatGroupBusinessName.putIfAbsent(
        ChatHistory.GROUP_REPAIRREPORT, () => L10n.ofValue().repairReport);
    chatGroupBusinessName.putIfAbsent(
        ChatHistory.GROUP_PO, () => L10n.ofValue().po);

    chatGroupTaskName.putIfAbsent(
        ChatHistoryDetails.TASK_SUBMIT, () => L10n.ofValue().submit);
    chatGroupTaskName.putIfAbsent(ChatHistoryDetails.TASK_CANCEL_SUBMIT,
        () => L10n.ofValue().cancelSubmit);
    chatGroupTaskName.putIfAbsent(
        ChatHistoryDetails.TASK_APPROVE, () => L10n.ofValue().approve);
    chatGroupTaskName.putIfAbsent(ChatHistoryDetails.TASK_CANCEL_APPROVE,
        () => L10n.ofValue().cancelApprove);
    chatGroupTaskName.putIfAbsent(
        ChatHistoryDetails.TASK_REJECT, () => L10n.ofValue().rejectStatus);
    _loadData();
    SkyWebSocket.addMessageListener(_onWebSocketMessage);
  }

  Future<void> _onWebSocketMessage(String msg) async {
    if (notLoadWebsocket == true) return;
    if (mounted == false) return;
    var decodedMessage = json.decode(msg);
    String groupId = decodedMessage["groupId"].toString();
    int groupIdInt = -1;
    try {
      groupIdInt = int.parse(groupId);
    } catch (e) {}
    if (groupIdInt == -1) return;
    if (groupIdInt == GlobalParam.currentGroupId) {
      await _loadData();
    }
  }

  Future<void> _loadData() async {
    var api = MessageListDetailsAPI();
    _userBusinessListAPI
        .getUserBusinessWithUserIdAndBusiness(
            userId: GlobalParam.getUserId(),
            business: chatGroupBusinessCode[widget.groupId])
        .then((onValue) async {
      userBusiness = onValue;
      if (widget.approveOnly == true) {
        var business = chatGroupBusinessCode[widget.groupId];
        data = await api.findMessageDetailsByUserIdAndApproveOnly(
            senderId: GlobalParam.getUserId(),
            receiverId: widget.senderId,
            groupId: widget.groupId,
            business: business,
            currentPage: 0,
            pageSize: 1000);
      } else {
        data = await api.findMessageDetailsByUserId(
            senderId: GlobalParam.getUserId(),
            receiverId: widget.senderId,
            groupId: widget.groupId,
            currentPage: 0,
            pageSize: 1000);
      }
      _messageDetailsStreamController.sink.add(data);
    });


  }

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI() {
    return StreamBuilder<List<ChatHistoryDetails>>(
      stream: _messageDetailsStreamController.stream,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return _buildMessageListDetails(snapshot.data);
        } else {
          return SCircularProgressIndicator.buildSmallCenter();
        }
      },
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(decoration: STextStyle.appBarDecoration()),
      titleSpacing: -5,
      title: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 18),
            // alignment: WrapAlignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SText(chatGroupBusinessName[widget.groupId],
                    style: STextStyle.biggerTextStyle()),
                //SText((widget.isOnline ?? false) ? L10n.of(context).justAccess : L10n.of(context).lastAccess  + ": " + (widget.lastAccess == null ? L10n.of(context).longTime : Util.getDateTimeStr(widget.lastAccess)), style: STextStyle.smallerTextStyle()),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: TextField(
              textAlign: TextAlign.center,
              style: TextStyle(color: STextStyle.BACKGROUND_COLOR),
              keyboardType: TextInputType.text,
              controller: _searchChar,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon:
                        Icon(Icons.search, color: STextStyle.BACKGROUND_COLOR),
                    onPressed: () async {
                      var api = MessageListDetailsAPI();
                       data =
                          await api.findMessageDetailsByUserIdAndSearchChar(
                              searchChar: _searchChar.text,
                              receiverId: GlobalParam.getUserId(),
                              groupId: widget.groupId,
                              currentPage: 0,
                              pageSize: 1000);
                      _messageDetailsStreamController.sink.add(data);
                      // print(_searchChar.value.toString());
                      setState(() {});
                    },
                  ),
                  hintText: 'Search...',
                  prefixIcon: IconButton(
                    icon: Icon(Icons.menu, color: STextStyle.BACKGROUND_COLOR),
                    onPressed: () {},
                  ),
                  hintStyle: TextStyle(
                      fontSize: 16, color: STextStyle.BACKGROUND_COLOR),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.all(0),
                  fillColor: STextStyle.GRADIENT_COLOR_AlPHA),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      actions: <Widget>[],
    );
  }

  Widget _buildMessageListDetails(List<ChatHistoryDetails> list) {
    return Scaffold(
      backgroundColor: STextStyle.LIST_BACKGROUND_COLOR,
      appBar: _buildAppBar(),
      body: ListView(
        reverse: true,
        children: <Widget>[..._buildMessageListDetailsList(list)],
      ),
    );
  }

  List<Widget> _buildMessageListDetailsList(
      List<ChatHistoryDetails> messageDetailsList) {
    List<Widget> list = List<Widget>();
    for (var i = 0; i < messageDetailsList.length; i++) {
      list.add(_buildReceiverItem(messageDetailsList[i], true));
    }

    return list;
  }

  Widget _buildSendDate(DateTime dateTime) {
    return Container(
      child: Column(
        children: <Widget>[
          Divider(),
          SText(Util.getDateStr(dateTime),
              textAlign: TextAlign.center, style: STextStyle.blurTextStyle()),
        ],
      ),
    );
  }

  Widget _buildReceiverItem(
      ChatHistoryDetails messageListDetails, bool showAvatar) {
    return ListTile(
      onTap: () {
        if (widget.groupId == ChatHistory.GROUP_HOLIDAY) {
          _goHolidayDetail(messageListDetails.sourceId);
        } else if (widget.groupId == ChatHistory.GROUP_REQINVENTORYOUT) {
          _goReqInventoryOut(messageListDetails.sourceId);
        } else if (widget.groupId == ChatHistory.GROUP_QUOTATION) {
          _goQuotation(messageListDetails.sourceId);
        } else if (widget.groupId == ChatHistory.GROUP_REQPO) {
          _goReqPo(messageListDetails.sourceId);
        }
      },
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (showAvatar)
            Row(
              children: <Widget>[
                ClipOval(
                  child: Image.network(
                    '${GlobalParam.IMAGE_SERVER_URL}/avartar?id=${messageListDetails.senderId}',
                    fit: BoxFit.fill,
                    width: 40,
                    height: 40,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                // if (messageListDetails.name != null)
                SText(messageListDetails.name ?? 'xxxxxxxxx',
                    style: STextStyle.blurTextStyle())
                // else
                //   SText('xxxxxxxxxxxxxxxx', style: STextStyle.blurTextStyle().merge(TextStyle(color: Colors.red)))
              ],
            ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: STextStyle.RECEIVER_BACKGROUND_COLOR,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
                minWidth: 5 * (GlobalParam.DEFAULT_FONT_SIZE - 5) + 12),
            width: messageListDetails.message.trim().length.toDouble() *
                    (GlobalParam.DEFAULT_FONT_SIZE - 5) +
                12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SHtml(data: messageListDetails.message),
                SizedBox(
                  height: 13,
                ),
                SizedBox(
                  width: 1000,
                  child: SText(Util.getTimeStr(messageListDetails.sendDate),
                      textAlign: TextAlign.end,
                      style: STextStyle.smallerTextStyle()
                          .merge(STextStyle.italicTextStyle())),
                ),
              ],
            ),
          ),
        ],
      ),
      trailing: widget.groupId == SkyNotification.GROUP_EMPLOYEE
          ? FittedBox()
          : _buildTrailing(messageListDetails),
    );
  }

  Widget _buildSenderItem(ChatHistoryDetails chatHistoryDetails) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: STextStyle.SENDER_BACKGROUND_COLOR,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
                minWidth: 5 * (GlobalParam.DEFAULT_FONT_SIZE - 5) + 10),
            width: chatHistoryDetails.message.trim().length.toDouble() *
                    (GlobalParam.DEFAULT_FONT_SIZE - 5) +
                10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SHtml(
                  data: '${chatHistoryDetails.message}',
                  customTextAlign: (e) => TextAlign.end,
                ),
                SText(Util.getTimeStr(chatHistoryDetails.sendDate),
                    style: STextStyle.smallerTextStyle()
                        .merge(STextStyle.italicTextStyle())),
              ],
            ),
          ),
        ],
      ),
      //trailing: widget.groupId == SkyNotification.GROUP_EMPLOYEE ? FittedBox() : _buildTrailing(chatHistoryDetails),
    );
  }

  Widget _buildTrailing(ChatHistoryDetails item) {
    return _buildPopup(item);
  }

  void _goReqInventoryOut(int sourceId) async {
    RequestInventoryOutAPI _requestInventoryOutAPI =
        new RequestInventoryOutAPI();
    RequestInventoryOutView _requestInventoryOut;
    var tmpRequestInventoryOutView =
        await _requestInventoryOutAPI.findReqInventoryOutById(sourceId);
    if (tmpRequestInventoryOutView.item1 != null && tmpRequestInventoryOutView.item1.length != 0 ) {
      _requestInventoryOut = tmpRequestInventoryOutView.item1[0] as RequestInventoryOutView;
    }
    else {
      return;
    }

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return ReqinvoutDetailsUI(
        requestInventoryOut: _requestInventoryOut,
        requestInventoryOutAPI: _requestInventoryOutAPI,
        userBusiness: userBusiness,
      );
    })).then((value) {});
  }

  void _goQuotation(int sourceId) async {
    QuotationAPI quotationAPI = new QuotationAPI();
    QuotationView quotation;
    var tmpQuotation = await quotationAPI.findQuotationById(sourceId);
    log2(tmpQuotation);
    if (tmpQuotation.item1 != null &&tmpQuotation.item1.length !=0 ) {
      quotation = tmpQuotation.item1[0] as QuotationView;
      // log2(quotation);
    }
    else{
      return;
    }

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return QuotationDetailsUI(
        quotationAPI: quotationAPI,
        quotation: quotation,
        userBusiness: userBusiness,
      );
    })).then((value) {});
  }

  void _goReqPo(int sourceId) async {
    RequestPoAPI requestPoAPI = new RequestPoAPI();
    RequestPoView requestPo;
    var tmpRequestPo = await requestPoAPI.findReqPoById(sourceId);


    if (tmpRequestPo.item1 != null && tmpRequestPo.item1.length !=0 ) {
      requestPo = tmpRequestPo.item1[0] as RequestPoView;
      //log2(quotation);
    }
    else {
      return;
    }

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return ReqPoDetailsUI(
        requestPoAPI: requestPoAPI,
        reqPo: requestPo,
        createNew: false,
        userBusiness: userBusiness,
      );
    })).then((value) {});
  }

  void _goHolidayDetail(int sourceId) async {
    HolidayAPI holidayAPI = new HolidayAPI();
    HolidayView holiday;
    HolidayParam holidayParam;
    var qHolidayParam = await holidayAPI.findHolidayParamByEmpId(
        empId: GlobalParam.EMPLOYEE_ID);
    if (qHolidayParam.item1 != null  ) {
      holidayParam = qHolidayParam.item1;
    } else {
      return;
    }
    var qHoliday = await holidayAPI.findHolidayById(id: sourceId);
    if (qHoliday != null) {
      holiday = qHoliday.item1;
    } else {
      return;
    }
    //QuotationView quotation;
    //List<QuotationItemView> quotationItemList;
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return HolidayDetailsUI(
        selectedHoliday: holiday,
        holidayAPI: holidayAPI,
        holidayParam: holidayParam,
        userBusiness: userBusiness,
      );
    })).then((value) {});
  }

  Widget _buildPopup(ChatHistoryDetails item) {
    // if(item.task == ChatHistoryDetails.TASK_FINISH){
    if (ExistButtonApproveSubmit(item) == false) {
      return null;
    } else {
      return PopupMenuButton<Tuple2<int, int>>(
        onSelected: (value) {
          int indexFirstColon = item.message.indexOf(":");
          String message = item.message.substring(indexFirstColon + 1);

          SDialog.confirm(this.chatGroupTaskName[value.first], message)
              .then((onValue) {
            if (onValue == DialogButton.yes) {
              notLoadWebsocket = true;
              var _taskApproveSubmitListAPI = TaskApproveSubmitListAPI();
              _taskApproveSubmitListAPI
                  .doApproveSubmitWithUserIdAndGroupIdAndSourceIdAndTask(
                      userId: GlobalParam.USER_ID,
                      groupId: widget.groupId,
                      sourceId: item.sourceId,
                      task: value.first)
                  .then((response) {
                if (response.status.toString() == "success") {
                  print("updateing object");
                  print(response.updateObject);
                  ChatHistoryDetails chatHistoryDetails =
                      new ChatHistoryDetails();
                  chatHistoryDetails.id =
                      json.decode(response.updateObject)["id"];
                  chatHistoryDetails.message =
                      json.decode(response.updateObject)["content"];
                  chatHistoryDetails.senderId =
                      json.decode(response.updateObject)["senderId"];
                  chatHistoryDetails.task =
                      json.decode(response.updateObject)["task"];
                  chatHistoryDetails.sendDate = CustomDateTimeConverter()
                      .fromJson(json.decode(response.updateObject)["sendDate"]);
                  chatHistoryDetails.status =
                      json.decode(response.updateObject)["statusChatReceiver"];
                  chatHistoryDetails.receiverId =
                      json.decode(response.updateObject)["receiverId"];
                  chatHistoryDetails.sourceId =
                      json.decode(response.updateObject)["sourceId"];
                  chatHistoryDetails.name =
                      json.decode(response.updateObject)["name"];
                  for (ChatHistoryDetails c in data) {
                    if (c.id == item.id) {
                        c.task = ChatHistoryDetails.TASK_FINISH;
                    }
                  }

                  data.insert(0, chatHistoryDetails);
                  setState(() {});

                  notLoadWebsocket = false;
                  if(response.message.length >0)SDialog.alert(this.chatGroupTaskName[value.first],response.message);
                } else {
                  SDialog.alert(
                      this.chatGroupTaskName[value.first], response.message);
                  notLoadWebsocket = false;
                }
              });
            }
          });
        },
       icon:  buildIconApproveAndSubmit(item),
        itemBuilder: (context) => buildContextPopupMenu(item),
      );
    }
  }

  Widget buildIconApproveAndSubmit(ChatHistoryDetails item){
    if(item.task ==  ChatHistoryDetails.TASK_SUBMIT || item.task == ChatHistoryDetails.TASK_CANCEL_APPROVE )
      return Icon(
        Icons.arrow_drop_down,
        color: STextStyle.HOT_COLOR,
        size: 40,
      );
    else if(item.task == ChatHistoryDetails.TASK_CANCEL_SUBMIT) {
      if(userBusiness.isLevel1 || userBusiness.isLevel2 || userBusiness.isLevel3)
      return Icon(
        Icons.arrow_drop_down,
        color: STextStyle.HOT_COLOR,
        size: 40,
      );
      else
        return Icon(
          Icons.arrow_drop_down,
          color: Colors.green,
          size: 40,
        );
    }
    else {
      return Icon(
        Icons.arrow_drop_down,
        color: Colors.green,
        size: 40,
      );
    }
  }
  List<PopupMenuItem<Tuple2<int, int>>> buildContextPopupMenu(
      ChatHistoryDetails item) {

    if (item.task == ChatHistoryDetails.TASK_SUBMIT) {
      if (item.senderId != GlobalParam.getUserId()) {
        return [
          PopupMenuItem<Tuple2<int, int>>(
            value: new Tuple2(ChatHistoryDetails.TASK_SUBMIT, item.sourceId),
            child: SText(L10n.of(context).submit),
          ),
          PopupMenuItem<Tuple2<int, int>>(
            value: new Tuple2(ChatHistoryDetails.TASK_APPROVE, item.sourceId),
            child: SText(L10n.of(context).approve),
          ),
          PopupMenuItem<Tuple2<int, int>>(
            value: new Tuple2(ChatHistoryDetails.TASK_REJECT, item.sourceId),
            child: SText(L10n.of(context).rejectStatus),
          ),
        ];
      } else {
        return [
          PopupMenuItem<Tuple2<int, int>>(
            value: new Tuple2(
                ChatHistoryDetails.TASK_CANCEL_SUBMIT, item.sourceId),
            child: SText(L10n.of(context).cancelSubmit),
          ),
        ];
      }
    }
    if (item.task == ChatHistoryDetails.TASK_ME_SUBMIT) {
      return [
        PopupMenuItem<Tuple2<int, int>>(
          value:
              new Tuple2(ChatHistoryDetails.TASK_CANCEL_SUBMIT, item.sourceId),
          child: SText(L10n.of(context).cancelSubmit),
        ),
      ];
    } else if (item.task == ChatHistoryDetails.TASK_CANCEL_SUBMIT) {
      if (item.senderId == GlobalParam.getUserId()) {
        if (userBusiness.isLevel1 ||
            userBusiness.isLevel2 ||
            userBusiness.isLevel3) {
          return [
            PopupMenuItem<Tuple2<int, int>>(
              value: new Tuple2(ChatHistoryDetails.TASK_SUBMIT, item.sourceId),
              child: SText(L10n.of(context).submit),
            ),
            PopupMenuItem<Tuple2<int, int>>(
              value: new Tuple2(ChatHistoryDetails.TASK_APPROVE, item.sourceId),
              child: SText(L10n.of(context).approve),
            ),
            PopupMenuItem<Tuple2<int, int>>(
              value: new Tuple2(ChatHistoryDetails.TASK_REJECT, item.sourceId),
              child: SText(L10n.of(context).rejectStatus),
            ),
          ];
        } else {
          return [
            PopupMenuItem<Tuple2<int, int>>(
              value: new Tuple2(ChatHistoryDetails.TASK_SUBMIT, item.sourceId),
              child: SText(L10n.of(context).submit),
            )
          ];
        }
      } else {
        return null;
      }
    } else if (item.task == ChatHistoryDetails.TASK_APPROVE) {
      // if(item.senderId == GlobalParam.getUserId()) {
      return [
        PopupMenuItem<Tuple2<int, int>>(
          value:
              new Tuple2(ChatHistoryDetails.TASK_CANCEL_APPROVE, item.sourceId),
          child: SText(L10n.of(context).cancelApprove),
        ),
      ];
      //}
      //else{
      // return null;
      //}
    } else if (item.task == ChatHistoryDetails.TASK_CANCEL_APPROVE) {
      if (item.senderId == GlobalParam.getUserId()) {
        return [
          PopupMenuItem<Tuple2<int, int>>(
            value: new Tuple2(ChatHistoryDetails.TASK_SUBMIT, item.sourceId),
            child: SText(L10n.of(context).submit),
          ),
          PopupMenuItem<Tuple2<int, int>>(
            value: new Tuple2(ChatHistoryDetails.TASK_APPROVE, item.sourceId),
            child: SText(L10n.of(context).approve),
          ),
          PopupMenuItem<Tuple2<int, int>>(
            value: new Tuple2(ChatHistoryDetails.TASK_REJECT, item.sourceId),
            child: SText(L10n.of(context).rejectStatus),
          ),
        ];
      } else {
        return null;
      }
    } else if (item.task == ChatHistoryDetails.TASK_REJECT) {
      if (item.senderId == GlobalParam.getUserId()) {
        return null;
      } else {
        return [
          PopupMenuItem<Tuple2<int, int>>(
            value: new Tuple2(ChatHistoryDetails.TASK_SUBMIT, item.sourceId),
            child: SText(L10n.of(context).submit),
          ),
        ];
      }
    } else {
      return null;
    }
  }

  bool ExistButtonApproveSubmit(ChatHistoryDetails item) {
    if (item.task == ChatHistoryDetails.TASK_SUBMIT) {
      if (item.senderId != GlobalParam.getUserId()) {
        return true;
      }
    }
    if (item.task == ChatHistoryDetails.TASK_ME_SUBMIT) {
      return true;
    } else if (item.task == ChatHistoryDetails.TASK_CANCEL_SUBMIT) {
      if (item.senderId == GlobalParam.getUserId()) {
        return true;
      } else {
        return false;
      }
    } else if (item.task == ChatHistoryDetails.TASK_APPROVE) {
      return true;
    } else if (item.task == ChatHistoryDetails.TASK_CANCEL_APPROVE) {
      if (item.senderId == GlobalParam.getUserId()) {
        return true;
      } else {
        return false;
      }
    } else if (item.task == ChatHistoryDetails.TASK_REJECT) {
      if (item.senderId == GlobalParam.getUserId()) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageDetailsStreamController.close();
    SkyWebSocket.removeMessageListener(_onWebSocketMessage);
  }
}
