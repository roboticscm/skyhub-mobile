import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/chat/chat_model.dart';
import 'package:mobile/modules/home/home_item.dart';
import 'package:mobile/style/text_style.dart';
import 'details/message_list_details_stream_ui.dart';
import 'message_list_bloc.dart';
import 'message_list_ui.dart';

class NotificationUI extends StatefulWidget {
  final MessageListBloc messageListBloc;
  NotificationUI({
    Key key,
    this.messageListBloc
  }) : super(key: key);

  @override
  State<NotificationUI> createState() {
    GlobalParam.notificationUIState = NotificationUIState();
    return GlobalParam.notificationUIState;
  }
}

class NotificationUIState extends State<NotificationUI> {
  List<NotificationItem> _notificationItemList = List();
  get _messageListBloc => widget.messageListBloc;
  @override
  void initState() {
    super.initState();
  }

  void _buildNotifyItemList() async {
    if (!mounted) return;

    _notificationItemList.clear();
    _notificationItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_EMPLOYEE,
        name: L10n.of(GlobalParam.appContext).employee,
        assetIcon: 'assets/user.svg',
         totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_EMPLOYEE),
         lastNotify: await Util.getLastNotifyByGroupId(SkyNotification.GROUP_EMPLOYEE)
    ));

    _notificationItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_TRAVELING,
        name: L10n.of(GlobalParam.appContext).traveling,
        assetIcon: 'assets/traveling.svg',
        icon: Icon(FontAwesomeIcons.suitcaseRolling, color: Colors.white, size: 25),
        totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_TRAVELING),
        lastNotify: await Util.getLastNotifyByGroupId(SkyNotification.GROUP_TRAVELING)
    ));

    _notificationItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_QOTATION,
        name: L10n.of(context).quotation,
        assetIcon: 'assets/quotation.svg',
        icon: Icon(FontAwesomeIcons.moneyCheckAlt, color: Colors.white, size: 20),
        totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_QOTATION),
        lastNotify: await Util.getLastNotifyByGroupId(SkyNotification.GROUP_QOTATION)
    ));

    _notificationItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_HOLIDAY,
        name: L10n.of(context).holiday,
        assetIcon: 'assets/holiday.svg',
        icon: Icon(FontAwesomeIcons.umbrella, color: Colors.white, size: 20),
        totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_HOLIDAY),
        lastNotify: await Util.getLastNotifyByGroupId(SkyNotification.GROUP_HOLIDAY)
    ));

    _notificationItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_REQINVENTORYOUT,
        name: L10n.of(context).reqInventoryOut,
        assetIcon: 'assets/req_inventory_out.svg',
        icon: Icon(FontAwesomeIcons.fileExport, color: Colors.white, size: 20),
        totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_REQINVENTORYOUT),
        lastNotify: await Util.getLastNotifyByGroupId(SkyNotification.GROUP_REQINVENTORYOUT)
    ));

    _notificationItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_REQINVENTORYIN,
        name: L10n.of(context).reqInventoryIn,
        assetIcon: 'assets/req_inventory_in.svg',
        icon: Icon(FontAwesomeIcons.fileImport, color: Colors.white, size: 20),
        totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_REQINVENTORYIN),
        lastNotify: await Util.getLastNotifyByGroupId(SkyNotification.GROUP_REQINVENTORYIN)
    ));

    _notificationItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_REQPO,
        name: L10n.of(context).reqPo,
        assetIcon: 'assets/req_po.svg',
        icon: Icon(FontAwesomeIcons.moneyBill, color: Colors.white, size: 20),
        totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_REQPO),
        lastNotify: await Util.getLastNotifyByGroupId(SkyNotification.GROUP_REQPO)
    ));

    _notificationItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_ADVANCE,
        name: L10n.of(context).advance,
        assetIcon: 'assets/advance.svg',
        icon: Icon(FontAwesomeIcons.dollarSign, color: Colors.white, size: 20),
        totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_ADVANCE),
        lastNotify: await Util.getLastNotifyByGroupId(SkyNotification.GROUP_ADVANCE)
    ));

    _notificationItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_REQPAYMENT,
        name: L10n.of(context).reqPayment,
        assetIcon: 'assets/req_payment.svg',
        icon: Icon(FontAwesomeIcons.handHoldingUsd, color: Colors.white, size: 20),
        totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_REQPAYMENT),
        lastNotify: await Util.getLastNotifyByGroupId(SkyNotification.GROUP_REQPAYMENT)
    ));

    _notificationItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_PAYMENT,
        name: L10n.of(context).payment,
        assetIcon: 'assets/payment.svg',
        icon: Icon(FontAwesomeIcons.fileInvoiceDollar, color: Colors.white, size: 20),
        totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_PAYMENT),
        lastNotify: await Util.getLastNotifyByGroupId(SkyNotification.GROUP_PAYMENT)
    ));


    _notificationItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_CONTRACT,
        name: L10n.of(context).contract,
        assetIcon: 'assets/contract.svg',
        icon: Icon(FontAwesomeIcons.handshake, color: Colors.white, size: 20),
        totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_CONTRACT),
        lastNotify: await Util.getLastNotifyByGroupId(SkyNotification.GROUP_CONTRACT)
    ));

    _notificationItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_ACCEPTANCE,
        name: L10n.of(context).acceptance,
        assetIcon: 'assets/acceptance.svg',
        icon: Icon(FontAwesomeIcons.fileSignature, color: Colors.white, size: 20),
        totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_ACCEPTANCE),
        lastNotify: await Util.getLastNotifyByGroupId(SkyNotification.GROUP_ACCEPTANCE)
    ));

    _notificationItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_INSPECTION,
        name: L10n.of(context).inspection,
        assetIcon: 'assets/inspection.svg',
        icon: Icon(FontAwesomeIcons.tasks, color: Colors.white, size: 20),
        totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_INSPECTION),
        lastNotify: await Util.getLastNotifyByGroupId(SkyNotification.GROUP_INSPECTION)
    ));

    _notificationItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_REPAIRREPORT,
        name: L10n.of(context).repairReport,
        assetIcon: 'assets/repair_report.svg',
        icon: Icon(FontAwesomeIcons.tools, color: Colors.white, size: 20),
        totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_REPAIRREPORT),
        lastNotify: await Util.getLastNotifyByGroupId(SkyNotification.GROUP_REPAIRREPORT)
    ));

    _notificationItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_INVENTORYIN,
        name: L10n.of(context).inventoryIn,
        assetIcon: 'assets/inventory_in.svg',
        totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_INVENTORYIN),
        lastNotify: await Util.getLastNotifyByGroupId(SkyNotification.GROUP_INVENTORYIN)
    ));

    _notificationItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_INVENTORYOUT,
        name: L10n.of(context).inventoryOut,
        assetIcon: 'assets/inventory_out.svg',
        totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_INVENTORYOUT),
        lastNotify: await Util.getLastNotifyByGroupId(SkyNotification.GROUP_INVENTORYOUT)
    ));

    _notificationItemList.sort((item1, item2){
      return item2.lastNotify.compareTo(item1.lastNotify);
    });
  }


  void onNotify() async {
    if (!mounted)
      return;
    setState(() {
      _buildNotifyItemList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return _buildListView();
  }

  Widget _buildListView(){
    return GridView.count(
      mainAxisSpacing: 3,
      crossAxisSpacing: 3,
      childAspectRatio: 2,
      crossAxisCount: Util.calcNumOfGridColumn(),
      children: <Widget>[
        for (var item in _notificationItemList)
          _buildListItem(item)
      ],
    );
  }

  Widget _buildListItem(NotificationItem item) {
    return Card(
        child: Center(
          child: InkWell(
            onTap: () {
              GlobalParam.currentGroupId = item.groupId;
              showDetails(item);
            },
            child: FittedBox(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: <Widget>[
                            Container(
                              width: 55,
                              height: 55,
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.only(top: 5, right: 5),
                              child: item.icon ?? SvgPicture.asset(
                                  item.assetIcon, color: STextStyle.LIGHT_TEXT_COLOR),
                              decoration: BoxDecoration(
                                  color: STextStyle.GRADIENT_COLOR1,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 2),
                              padding: EdgeInsets.only(left: 3, top: 0, right: 3, bottom: 0),
                              decoration: BoxDecoration(
                                  color: STextStyle.NOTIFICATION_BACKGROUND_COLOR,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: ((item.totalNotify ?? 0) <= 0) ? FittedBox() : Text('${item.totalNotify}', style: TextStyle(color: Colors.white, fontSize: GlobalParam.SMALLER_FONT_SIZE),),
                            )
                          ],
                        )
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 4),
                        child: Text(item.name, style: STextStyle.biggerTextStyle(),)
                    ),
                  ]),
            ),
          ),
        )
    );
  }

  void showDetails(NotificationItem item) {
   /* Navigator.push(context,
      MaterialPageRoute(builder: (context) =>
          MessageListStreamUI(
            messageListBloc: _messageListBloc,
            groupId: item.groupId,
            title: item.name,
            totalNotify: item.totalNotify,
            assetIcon: item.assetIcon,
            icon: item.icon
          )
      ),
    ).then((_){
      _buildNotifyItemList();
    });*/
    GlobalParam.currentGroupId = item.groupId;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          MessageListDetailsStreamUI(
            //messageListDetailsBloc: _messageListDetailsBloc,
            groupId: item.groupId,
            //senderName: message.name,
            approveOnly: true,
            senderId: GlobalParam.getUserId(),
            //senderAccount: message.account,
            //lastAccess: message.lastAccess,
            //isOnline: message.isOnline,
          )
      ),
    ).then((onValue) async{
      GlobalParam.isActivatedChat = false;
      if (GlobalParam.currentGroupId == SkyNotification.GROUP_EMPLOYEE)
        //await _messageListDetailsBloc.messageListDetailsAPI.updateReceiveMessageStatus (GlobalParam.USER_ID, message.userId, SkyNotification.GROUP_EMPLOYEE, 2);///2=read
      onNotify();
    });

  }

}
