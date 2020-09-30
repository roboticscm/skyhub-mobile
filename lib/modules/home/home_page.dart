import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/common/api_util.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/global_function.dart';
import 'package:mobile/common/native_code.dart';
import 'package:mobile/common/sky_websocket.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/main.dart';
import 'package:mobile/modules/calendar/calendar_ui.dart';
import 'package:mobile/modules/calendar/search/calendar_search_ui.dart';
import 'package:mobile/modules/chat/chat_api.dart';
import 'package:mobile/modules/chat/chat_bloc.dart';
import 'package:mobile/modules/chat/chat_model.dart';
import 'package:mobile/modules/chat/chat_ui.dart';
import 'package:mobile/modules/chat/search/chat_search_ui.dart';
import 'package:mobile/modules/home/search/home_page_search_ui.dart';
import 'package:mobile/modules/inventory/inventory_ui.dart';
import 'package:mobile/modules/inventory/search/inventory_search_ui.dart';
import 'package:mobile/modules/notification/message_list_api.dart';
import 'package:mobile/modules/notification/message_list_bloc.dart';
import 'package:mobile/modules/notification/notification_ui.dart';
import 'package:mobile/modules/notification/search/notification_search_ui.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/system/authentication/authentication.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:connectivity/connectivity.dart';
import 'package:mobile/system/menu/menu_api.dart';
import 'package:mobile/system/menu/menu_bloc.dart';
import 'package:mobile/system/menu/menu_ui.dart';
import 'package:mobile/system/menu/sub/sub_menu_api.dart';
import 'package:mobile/system/menu/sub/sub_menu_bloc.dart';
import 'package:mobile/system/menu/sub/sub_menu_ui.dart';
import 'package:mobile/widgets/sraised_button.dart';
import 'package:mobile/widgets/stext.dart';

import 'settings_ui.dart';

class HomePage extends StatefulWidget {
  static HomePageState homePageState;
  @override
  State<StatefulWidget> createState() {
    homePageState = HomePageState();
    GlobalParam.homePageState = homePageState;
    return GlobalParam.homePageState;
  }
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin, WidgetsBindingObserver {
  static const int HOME_TAB_INDEX = 0;
  static const int NOTIFICATION_TAB_INDEX = 1;
  static const int CALENDAR_TAB_INDEX = 2;
  static const int MESSAGE_TAB_INDEX = 3;
  static const int INVENTORY_TAB_INDEX = 4;

  TabController _tabController;
  ChatBloc _chatBloc;
  MenuBloc _menuBloc;
  SubMenuBloc _subMenuBloc;

  MessageListBloc _messageListBloc;
  static int _totalNotify = 0;
  bool previousActivatedChat = GlobalParam.isActivatedChat;

  String _connectionStatus = 'Unknown';
  ConnectivityResult _connectionResult = ConnectivityResult.none;
  bool _isConnectedToMessageServer = false;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  int _totalBottomNotify;
  int _totalMessageNotify;
  int _totalCalendarNotify = 0;
  static const int MENU_INDEX = 0;
  static const int SUB_MENU_INDEX = 1;
  int selectedMenuIndex = MENU_INDEX;
  StreamController<int> _calendarNotifyStreamController = StreamController();
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    _chatBloc = ChatBloc(chatAPI: ChatAPI());
    _menuBloc = MenuBloc (menuAPI: MenuAPI());
    _subMenuBloc = SubMenuBloc (subMenuAPI: SubMenuAPI());
    _messageListBloc = MessageListBloc(messageListAPI: MessageListAPI(), chatAPI: ChatAPI());

    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener((){
      if (!_tabController.indexIsChanging) {
        if (_tabController.index == HOME_TAB_INDEX ) {
          GlobalParam.homePageState.selectedMenuIndex = HomePageState.MENU_INDEX;
        }
        onNotify(null);
      }
    });
    onNotify(null);
  }

  void changeStackIndex(int index, int menuId) {
    if (menuId != null)
      SubMenuUI.subMenuUIState.loadData(menuId);
    setState(() {
      selectedMenuIndex = index;
    });
  }

  void updateConnectedMessageServerStatus(bool isConnected) {
    if (!mounted) return;

    setState(() {
      _isConnectedToMessageServer = isConnected;
    });
  }

  Future<void> taskIconReload() async{
    if (!mounted)
      return;
    GlobalParam.notify = await _chatBloc.chatAPI.findNotifyCountByUserId(userId: GlobalParam.USER_ID);

    switch(_tabController.index) {
      case NOTIFICATION_TAB_INDEX:
        GlobalParam.notificationUIState.onNotify();
        break;
     }

    var totalNotify = await Util.getTotalNotify(GlobalParam.notify) + _totalCalendarNotify;
    var totalBottomNotify = await Util.getTotalBottomNotify(GlobalParam.notify);
    var totalMessageNotify = await Util.getNotificationByGroupId(SkyNotification.GROUP_MESSAGE);
    setState(() {
      _totalNotify = totalNotify;
      _totalBottomNotify = totalBottomNotify;
      _totalMessageNotify = totalMessageNotify;
    });

   // if (GlobalParam.isAppInBackground){
     //AppState.showNotification(_totalNotify);
      try{
        Util.updateBadgerNotification(_totalNotify);
      }catch(e){
        debugPrint(e.toString());
      }
    //}
 }
  Future<void> onNotify(int groupId) async {
    if (!mounted)
      return;
    GlobalParam.notify = await _chatBloc.chatAPI.findNotifyCountByUserId(userId: GlobalParam.USER_ID);

  //  if (groupId != null) {
   //   GlobalParam.messageListUIState?.onNotify();
    //}

    switch(_tabController.index) {
      case NOTIFICATION_TAB_INDEX:
        GlobalParam.notificationUIState.onNotify();
        break;
      case MESSAGE_TAB_INDEX:
        GlobalParam.chatUIState.onNotify();
        break;
    }

    var totalNotify = await Util.getTotalNotify(GlobalParam.notify) + _totalCalendarNotify;
    var totalBottomNotify = await Util.getTotalBottomNotify(GlobalParam.notify);
    var totalMessageNotify = await Util.getNotificationByGroupId(SkyNotification.GROUP_MESSAGE);
    setState(() {
      _totalNotify = totalNotify;
      _totalBottomNotify = totalBottomNotify;
      _totalMessageNotify = totalMessageNotify;
    });

    if (GlobalParam.isAppInBackground){
      AppState.showNotification(_totalNotify);
      try{
        Util.updateBadgerNotification(_totalNotify);
      }catch(e){
        debugPrint(e.toString());
      }
   }
  }

  int getSelectedTabIndex() {
    return _tabController.index;
  }

  void setSelectedTabIndex(int index) {
    _tabController.index = index;
    setState(() {
    });
  }

  void calendarNotify(int count) async {
    _totalNotify = await Util.getTotalNotify(GlobalParam.notify) + count;
    _calendarNotifyStreamController.sink.add(count);
    _totalCalendarNotify = count;
  }
  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);

    return WillPopScope(
      onWillPop: () {
        if (Platform.isAndroid) {
          if (Navigator.of(context).canPop()) {
            return Future.value(true);
          } else {
            GlobalParam.isActivatedChat = false;
            NativeCall.sendAppToBackground();
            return Future.value(false);
          }
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(authenticationBloc),
        drawer: _buildDrawer(authenticationBloc),
        body: TabBarView(
          children: <Widget>[
            IndexedStack(
              index: selectedMenuIndex,
              children: <Widget>[
                MenuUI(menuBloc: _menuBloc,),
                SubMenuUI(subMenuBloc: _subMenuBloc),
              ],
            ),
            NotificationUI(messageListBloc: _messageListBloc, ),
            CalendarUI(),
            ChatUI(chatBloc: _chatBloc,),
            InventoryUI(),
          ],
          controller: _tabController,
        ),

        bottomNavigationBar: Material(
          color: STextStyle.TASK_BAR_COLOR,
          child: TabBar(
            onTap: (index) {

            },
            labelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: GlobalParam.DEFAULT_FONT_SIZE, color: Colors.white70),
            unselectedLabelStyle: TextStyle(fontSize: GlobalParam.SMALLER_FONT_SIZE),
            labelPadding: EdgeInsets.all(0),
            tabs: [
              _buildBottomTabItemIcon(Icons.home, L10n.of(context).home, 0),
              _buildBottomTabItem('assets/notification.svg', L10n.of(context).notification, _totalBottomNotify),
              _buildBottomTabItemWithStreamBuilder('assets/calendar.svg', L10n.of(context).calendar),
              _buildBottomTabItem('assets/message.svg', L10n.of(context).message, _totalMessageNotify),
              _buildBottomTabItem('assets/inventory.svg', L10n.of(context).inventory, 0),

          ],
          controller: _tabController,
          )
        ),
      ),
    );
  }


  Widget _buildBottomTabItemIcon(IconData iconData, text, int numOfNotification) {
    return Container(
        margin: EdgeInsets.only(top: 5, right: 5),
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Tab(icon: Icon(iconData, size: 32, color: STextStyle.BOTTOM_BAR_COLOR), text: text),
            Container(
              margin: EdgeInsets.only(left: 20),
              padding: EdgeInsets.only(left: 3, top: 0, right: 3, bottom: 0),
              decoration: BoxDecoration(
                  color: STextStyle.NOTIFICATION_BACKGROUND_COLOR,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: ((numOfNotification ?? 0) <= 0) ? FittedBox() : Text(numOfNotification.toString(), style: TextStyle(color: Colors.white, fontSize: GlobalParam.SMALLER_FONT_SIZE),),
            )
          ],
        ));
  }

  Widget _buildBottomTabItem(assetsImage, text, int numOfNotification) {
    return Container(
        margin: EdgeInsets.only(top: 5, right: 5),
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Tab(icon: SvgPicture.asset(assetsImage, color: STextStyle.BOTTOM_BAR_COLOR, width: 30,), text: text),
            Container(
              margin: EdgeInsets.only(left: 20),
              padding: EdgeInsets.only(left: 3, top: 0, right: 3, bottom: 0),
              decoration: BoxDecoration(
                  color: STextStyle.NOTIFICATION_BACKGROUND_COLOR,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: ((numOfNotification ?? 0) <= 0) ? FittedBox() : Text(numOfNotification.toString(), style: TextStyle(color: Colors.white, fontSize: GlobalParam.SMALLER_FONT_SIZE),),
            )
          ],
        ));
  }

  Widget _buildBottomTabItemWithStreamBuilder(assetsImage, text) {
    return Container(
      margin: EdgeInsets.only(top: 5, right: 5),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Tab(icon: SvgPicture.asset(assetsImage, color: STextStyle.BOTTOM_BAR_COLOR, width: 30,), text: text),
          StreamBuilder<int>(
            stream: _calendarNotifyStreamController.stream,
            builder: (context, snapshot) {
              if(snapshot.hasData && (snapshot.data??0) > 0)
                return Container(
                  margin: EdgeInsets.only(left: 20),
                  padding: EdgeInsets.only(left: 3, top: 0, right: 3, bottom: 0),
                  decoration: BoxDecoration(
                    color: STextStyle.NOTIFICATION_BACKGROUND_COLOR,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(snapshot.data?.toString(), style: TextStyle(color: Colors.white, fontSize: GlobalParam.SMALLER_FONT_SIZE),),
                );
              else
                return FittedBox();
            }
          )
        ],
      ));
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    _connectivitySubscription.cancel();
    _calendarNotifyStreamController.close();
    super.dispose();
  }

  Widget _buildAppBar(AuthenticationBloc authenticationBloc) {
    return AppBar(
      titleSpacing: -5,
      title: TextField(
        onTap: (){
          _showSearchPage();
        },
        textAlign: TextAlign.center,
        style: TextStyle(color: STextStyle.BACKGROUND_COLOR),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(Icons.search, color: STextStyle.BACKGROUND_COLOR),
            onPressed: (){

            },
          ),
          hintText: L10n.of(context).search + '...',
//          prefixIcon: IconButton(
//            icon: Icon(Icons.menu, color: STextStyle.BACKGROUND_COLOR),
//            onPressed: (){
//            },
//          ),
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
      flexibleSpace: Container(
          decoration: STextStyle.appBarDecoration()
      ),
      actions: <Widget>[
        SizedBox(
          width: 5,
        ),
        Stack(
          alignment: AlignmentDirectional.topEnd,
          children: <Widget>[
            FittedBox(
              child: IconButton(
                iconSize: 60,
                icon: ClipOval(
                  child: FadeInImage.memoryNetwork(
                    placeholder: transparentImage,
                    image: '${GlobalParam.IMAGE_SERVER_URL}/avartar?id=${GlobalParam.USER_ID}',
                    fit: BoxFit.fill,
                    height: 60,
                    width: 60,
                  ),
                ),
                onPressed: (){
                  _showConnectivityStatus();
                },
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 2, right: 4),
              padding: EdgeInsets.only(left: 3 , top: 0, right: 3, bottom: 0),
              decoration: BoxDecoration(
                  color: STextStyle.NOTIFICATION_BACKGROUND_COLOR,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: ((_totalNotify ?? 0) <= 0) ? FittedBox() : Text('$_totalNotify', style: TextStyle(color: Colors.white, fontSize: GlobalParam.SMALLER_FONT_SIZE-1),),
            ),
            Container(
              width: 16,
              height: 16,
              margin: EdgeInsets.only(top: 35, right: 35),
              decoration: BoxDecoration(
                  color: (_connectionResult == ConnectivityResult.none ) ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(8)
              ),
            ),
            Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.only(top: 39, right: 39),
              decoration: BoxDecoration(
                  color: (_isConnectedToMessageServer ) ? Colors.green : Colors.blueGrey,
                  borderRadius: BorderRadius.circular(4)
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildDrawer(AuthenticationBloc authenticationBloc) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: IconButton(icon: Image.asset('assets/logo.png',), onPressed: (){

            }),
            decoration: BoxDecoration(
              color: STextStyle.GRADIENT_COLOR1,
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: SText(L10n.of(context).settings),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context){
                    return SettingsUI();
                }).then((value){

                });
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(L10n.of(context).logout),
            onTap: () {
              logout();
            },
          ),
        ],
      ),
    );
  }

  void logout() {
    final AuthenticationBloc authenticationBloc =
    BlocProvider.of<AuthenticationBloc>(context);
    authenticationBloc.dispatch(LoggedOut());
    Navigator.pop(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ApiUtil.updateLastAccessByUserId(GlobalParam.USER_ID);
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.paused:
        GlobalParam.isActivatedChat = false;
        GlobalParam.isAppInBackground = true;
        break;
      case AppLifecycleState.resumed:
        GlobalParam.isAppInBackground = false;
        onNotify(GlobalParam.currentGroupId);
        if (previousActivatedChat)
          GlobalParam.isActivatedChat = true;
        onNotify(GlobalParam.currentGroupId);
        break;
      case AppLifecycleState.inactive:
        GlobalParam.isActivatedChat = false;
        GlobalParam.isAppInBackground = true;
        break;
      case AppLifecycleState.detached:
        GlobalParam.isAppInBackground = true;
        break;
    }
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      print(e.toString());
    }

    if (!mounted) {
      return;
    }

   // if (Platform.isIOS)
      _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        String wifiName, wifiBSSID, wifiIP;

        try {
          wifiName = await _connectivity.getWifiName();
        } catch (e) {
          print(e.toString());
          wifiName = "Failed to get Wifi Name";
        }

        try {
          wifiBSSID = await _connectivity.getWifiBSSID();
        } catch (e) {
          print(e.toString());
          wifiBSSID = "Failed to get Wifi BSSID";
        }

        try {
          wifiIP = await _connectivity.getWifiIP();
        } catch (e) {
          print(e.toString());
          wifiIP = "Failed to get Wifi IP";
        }

        setState(() {
          _connectionResult = result;
          _connectionStatus = '$result\n'
              'Wifi Name: $wifiName\n'
              'Wifi BSSID: $wifiBSSID\n'
              'Wifi IP: $wifiIP\n';
        });
        SkyWebSocket.reconnect();
        break;
      case ConnectivityResult.mobile:
        setState((){
          _connectionResult = result;
          _connectionStatus = result.toString();
        });
        SkyWebSocket.reconnect();
        break;
      case ConnectivityResult.none:
        setState((){
          _connectionResult = result;
          _connectionStatus = result.toString();
        });
//        SkyWebSocket.close();
//        SkyWebSocket.reset();
//        GlobalParam.webSocketTimer?.cancel();
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  void _showConnectivityStatus() {
    showDialog(
      context: context,
      child: new AlertDialog(
        title: new SText(L10n.of(context).connectionStatus),
        content: Container(
          height: 200,
          child: Column(
            children: <Widget>[
              Text(_connectionResult == ConnectivityResult.none ? L10n.of(context).noConnectionAvailable : _connectionStatus),
              SRaisedButton(
                onPressed: () {
                  SkyWebSocket.reconnect();
                },
                child: Text(L10n.of(context).connectToMessageServer),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(L10n.of(context).close),
          ),
        ],
      ),
    );
  }
  void _showSearchPage() {
    Widget searchTarget;
    switch (_tabController.index) {
      case HOME_TAB_INDEX:
        searchTarget = HomePageSearchUI();
        break;
      case NOTIFICATION_TAB_INDEX:
        searchTarget = NotificationSearchUI();
        break;
      case CALENDAR_TAB_INDEX:
        searchTarget = CalendarSearchUI();
        break;
      case MESSAGE_TAB_INDEX:
        searchTarget = ChatSearchUI();
        break;
      case INVENTORY_TAB_INDEX:
        searchTarget = InventorySearchUI();
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
      searchTarget
      ),
    ).then((_) {
    });
  }
}

