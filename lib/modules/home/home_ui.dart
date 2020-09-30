import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/chat/chat_bloc.dart';
import 'package:mobile/modules/chat/chat_model.dart';
import 'package:mobile/modules/chat/chat_ui.dart';
import 'package:mobile/modules/notification/message_list_bloc.dart';
import 'package:mobile/modules/notification/message_list_ui.dart';
import 'package:mobile/style/text_style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home_item.dart';
import 'home_page.dart';

class HomeUI extends StatefulWidget {
  final MessageListBloc messageListBloc;
  final ChatBloc chatBloc;
  HomeUI({
    this.messageListBloc,
    this.chatBloc,
    Key key,
  }) : super(key: key);

  @override
  State<HomeUI> createState() {
    GlobalParam.homeUIState = HomeUIState();
    return GlobalParam.homeUIState;
  }
}

class HomeUIState extends State<HomeUI> {
  List<NotificationItem> _homeItemList = List();
  get _messageListBloc => widget.messageListBloc;
  get _chatBloc => widget.chatBloc;
   @override
  void initState() {
    super.initState();
    _buildHomeItemList();
  }

  void _buildHomeItemList() async {
    _homeItemList.clear();
    _homeItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_EMPLOYEE,
        name: L10n.of(GlobalParam.appContext).employee,
        assetIcon: 'assets/user.svg',
        totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_EMPLOYEE)
    ));

    _homeItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_TRAVELING,
        name: L10n.of(context).traveling,
        icon: Icon(FontAwesomeIcons.suitcase, color: Colors.white, size: 25),
        assetIcon: 'assets/traveling.svg',
        totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_TRAVELING)
    ));

    _homeItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_QOTATION,
        name: L10n.of(context).quotation,
        assetIcon: 'assets/quotation.svg',
        icon: Icon(FontAwesomeIcons.moneyCheckAlt, color: Colors.white, size: 25,),
        totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_QOTATION)
    ));

    _homeItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_HOLIDAY,
        name: L10n.of(context).holiday,
        assetIcon: 'assets/holiday.svg',
        icon: Icon(FontAwesomeIcons.umbrella, color: Colors.white, size: 25),
        totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_HOLIDAY)
    ));

    _homeItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_REQINVENTORYOUT,
        name: L10n.of(context).reqInventoryOut,
        assetIcon: 'assets/req_inventory_out.svg',
        icon: Icon(FontAwesomeIcons.fileExport, color: Colors.white, size: 25),
        totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_REQINVENTORYOUT)
    ));

    _homeItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_REQINVENTORYIN,
        name: L10n.of(context).reqInventoryIn,
        assetIcon: 'assets/req_inventory_in.svg',
        icon: Icon(FontAwesomeIcons.fileImport, color: Colors.white, size: 25),
        totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_REQINVENTORYIN)
    ));

    _homeItemList.add(NotificationItem(
        groupId: SkyNotification.GROUP_REQPO,
        name: L10n.of(context).reqPo,
        assetIcon: 'assets/req_po.svg',
        icon: Icon(FontAwesomeIcons.moneyBill, color: Colors.white, size: 25),
        totalNotify: await Util.getNotificationByGroupId(SkyNotification.GROUP_REQPO)
    ));
  }

  void onNotify() async {
    if(!mounted)
      return;
    setState(() {
      _buildHomeItemList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildGrid();
  }

  Widget _buildGrid() {
    return GridView.count(
      mainAxisSpacing: 3,
      crossAxisSpacing: 3,
      childAspectRatio: 2,
      crossAxisCount: Util.calcNumOfGridColumn(),
      children: <Widget>[
        for (NotificationItem item in _homeItemList)
          _buildGridItem(item)
      ],
    );
  }

  Widget _buildGridItem(NotificationItem item) {
    return Card(
      child: Center(
        child: InkWell(
          onTap: () {
            if (item.groupId == SkyNotification.GROUP_MESSAGE)
              _showChat();
            else
              _showDetails(item);
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
                        child: item.icon ?? SvgPicture.asset(item.assetIcon, color: STextStyle.LIGHT_TEXT_COLOR),
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

  void _showDetails(NotificationItem item) {
    Navigator.push(
      context,
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
    ).then((_) {
      onNotify();
    });
  }

  void _showChat() {
    GlobalParam.currentGroupId = SkyNotification.GROUP_MESSAGE;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
        ChatUI(
          chatBloc: _chatBloc,
        )
      ),
    ).then((_) {
      onNotify();
    });
  }
}
