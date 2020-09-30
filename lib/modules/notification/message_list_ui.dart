import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kernel/text/serializer_combinators.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/global_function.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/chat/chat_model.dart';
import 'package:mobile/modules/notification/details/message_list_details_stream_ui.dart';
import 'package:mobile/widgets/shtml.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/widgets/scircular_progress_indicator.dart';
import 'package:mobile/widgets/stext.dart';
import 'details/message_list_details_bloc.dart';
import 'message_list_api.dart';
import 'message_list_bloc.dart';
import 'package:mobile/common/sky_websocket.dart';


class MessageListStreamUI extends StatefulWidget {
  final MessageListBloc messageListBloc;
  final int groupId;
  final int totalNotify;
  final String title;
  final String assetIcon;
  final Icon icon;
  MessageListStreamUI({
    Key key,
    this.icon,
    @required this.messageListBloc,
    @required this.groupId,
    @required this.title,
    @required this.assetIcon,
    @required this.totalNotify,
  }) : super(key: key);

  @override
  State<MessageListStreamUI> createState() {
    //GlobalParam.messageListUIState = MessageListUIState();
    //return GlobalParam.messageListUIState;
    return MessageListUIState();
  }
}

class MessageListUIState extends State<MessageListStreamUI> {
  MessageListBloc get _messageListBloc => widget.messageListBloc;

  int get _groupId => widget.groupId;
  int get __totalNotify => widget.totalNotify;
  int _totalNotify;
  Icon get _icon => widget.icon;
  String get _title => widget.title;
  String get _assetIcon => widget.assetIcon;
  List<ChatHistory> _messageListHistoryList;
  MessageListDetailsBloc _messageListDetailsBloc;
  var  _messageListsStreamController = StreamController<List<ChatHistory>>();
  @override
  void initState() {
    super.initState();
    _totalNotify = __totalNotify;
   // _messageListDetailsBloc = MessageLisvar addMessageListener = tDetailsBloc(messageListDetailsAPI: MessageListDetailsAPI());

    _loadData();
    SkyWebSocket.addMessageListener(_onWebSocketMessage);
  }

  void _loadData() async {

    /*if(GlobalParam.currentGroupId == SkyNotification.GROUP_EMPLOYEE) {
      _messageListBloc.dispatch(OnTapEmployeeList(
          userId: GlobalParam.USER_ID,
          groupId: _groupId,
          currentPage: 0,
          pageSize: GlobalParam.PAGE_SIZE
      ));
    } else {
      _messageListBloc.dispatch(OnTapMessageList(
          userId: GlobalParam.USER_ID,
          groupId: _groupId,
          currentPage: 0,
          pageSize: GlobalParam.PAGE_SIZE
      ));
    }*/
    var api = MessageListAPI ();
    var data = await api.findMessageWithTaskByUserId(userId: GlobalParam.getUserId(),groupId: widget.groupId,currentPage: 0,pageSize: 1000);
    _messageListsStreamController.sink.add(data);
  }

  void onNotify() async {
    if(!mounted)
      return;

    await GlobalParam.homePageState.onNotify(null);
    var totalNotify = await Util.getNotificationByGroupId(_groupId);
    setState(() {
      _totalNotify = totalNotify;
    });
    _loadData();
  }


  @override
  Widget build(BuildContext context) {
    /*
    return BlocBuilder<MessageListEvent, MessageListState>(
      bloc: _messageListBloc,
      builder: (BuildContext context, MessageListState state) {
        if (state is MessageListFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: SText(state.error),
                backgroundColor: Colors.red,
              ),
            );
          });
        }
        if (state is MessageListLoading) {
          _messageListHistoryList = state.messageList;
        }
        return state is MessageListLoading ? _buildRecentMessageListList() : SCircularProgressIndicator.buildSmallCenter();
      },
    );*/
    return StreamBuilder<List<ChatHistory>>(
      stream:  _messageListsStreamController.stream,
      builder: (BuildContext context, snapshot) {

        if(snapshot.hasData) {
          return _buildRecentMessageListList(snapshot.data);
        } else {
          return SCircularProgressIndicator.buildSmallCenter();
        }
      },
    );
  }

  Widget _buildRecentMessageListList(List<ChatHistory> items) {
    return Scaffold(
      backgroundColor: STextStyle.BACKGROUND_COLOR,
      appBar: _buildAppBar(_title, _assetIcon, _totalNotify),
      body: ListView (
        padding: EdgeInsets.zero,
        children: [
          for (var item in items)
            _buildItem(item),
        ],
      ),
    );
  }

  Widget _buildItem(ChatHistory item) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: (){
            _onTapMessageList(item);
          },
          leading: Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: <Widget>[
              FittedBox(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    SCircularProgressIndicator.buildSmallCenter(),
                    ClipOval(
                      child: FadeInImage.memoryNetwork(
                        placeholder: transparentImage,
                        image: '${GlobalParam.IMAGE_SERVER_URL}/avartar?id=${item.userId}',
                        fit: BoxFit.fill,
                        height: 55,
                        width: 55,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.only(bottom: 4, right: 4),
                decoration: BoxDecoration(
                  color: (item.isOnline ?? false) ? Colors.green : Colors.blueGrey,
                  borderRadius: BorderRadius.circular(4)
                ),
              ),
            ],
          ),
          title: SText(item.name??''),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //SText(messageList.jobTitle??'', style: STextStyle.blurTextStyle()),
              SizedBox(height: 5),
              SizedBox(
                child: SHtml(data: item.lastMessage??'', maxLines: 1,)
              ),
              SizedBox(
                  height: 5
              ),
              SizedBox(width: 1000, child: SText(Util.getEasyReadingDateTime(DateTime.now(), item.sendDate)??'', textAlign: TextAlign.end, style: STextStyle.smallerTextStyle())),
            ],
          ),

          trailing:_buildTrailing(item),
        ),
        Row(
        children: <Widget>[
          if ((item.devices?.length ?? 0) <= 0)
            Container(alignment: AlignmentDirectional.center, width: 70, child: SText(Util.getDateTimeWithoutYearStr(item.lastAccess),style: TextStyle(fontSize: 10)))
          else
            Container(width: 70, child: _buildOnlineDevices(item.devices)),
//          Flexible(
//              child: SText(Util.getEasyReadingDateTime(DateTime.now(), messageList.sendDate)??'',style: STextStyle.smallerTextStyle())
//            )
          ],
        ),
        Divider(
          indent: 10,
        )
      ],
    );
  }

  Widget _buildTrailing(ChatHistory item) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: <Widget>[
        _buildUnreadMessage(item),

      ],
    );
  }

  Widget _buildOnlineDevices(String devices) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (devices?.contains("Mobile") ?? false)
          Icon( Icons.smartphone, size: 20),
        if (devices?.contains("Web") ?? false )
          Icon( Icons.web, size: 20),
      ],
    );
  }
  Widget _buildUnreadMessage(ChatHistory item) {
    return (item.unreadMessage ?? 0) > 0 ?
    Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red
      ),
      child: Center(
          child: SText(
            item.unreadMessage.toString(),
            style: TextStyle(
                color: Colors.white
            ),
          )
      ),
    ) : FittedBox();
  }
  void _onTapMessageList(ChatHistory message) async{
    GlobalParam.currentGroupId = _groupId;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          MessageListDetailsStreamUI(
            //messageListDetailsBloc: _messageListDetailsBloc,
            groupId: _groupId,
            //senderName: message.name,
            senderId: message.userId,
            //senderAccount: message.account,
            //lastAccess: message.lastAccess,
            //isOnline: message.isOnline,
          )
      ),
    ).then((onValue) async{
      GlobalParam.isActivatedChat = false;
      if (GlobalParam.currentGroupId == SkyNotification.GROUP_EMPLOYEE)
        await _messageListDetailsBloc.messageListDetailsAPI.updateReceiveMessageStatus (GlobalParam.USER_ID, message.userId, SkyNotification.GROUP_EMPLOYEE, 2);///2=read
      onNotify();
    });
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  Widget _buildAppBar(String title, String assetIcon, int numberOfNotifications) {
    return AppBar(
      flexibleSpace: Container(
          decoration: STextStyle.appBarDecoration()
      ),
      titleSpacing: -10,
      backgroundColor: Colors.white,
      title: Row(children: <Widget>[
        Stack(
          alignment: AlignmentDirectional.topEnd,
          children: <Widget>[
            IconButton(
              icon: _icon ?? SvgPicture.asset(assetIcon, color: STextStyle.LIGHT_TEXT_COLOR),
              onPressed: (){

              },
            ),
            if (numberOfNotifications != null && numberOfNotifications > 0)
              Container(
                  padding: EdgeInsets.only(left: 4, top: 2, bottom: 2, right: 4),
                  decoration: BoxDecoration(
                      color: STextStyle.HOT_COLOR,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: SText(numberOfNotifications.toString(), style: TextStyle(color: Colors.white, fontSize: GlobalParam.SMALLER_FONT_SIZE))
              )

          ],
        ),
//        if (title != null)
//          SText(title, style: TextStyle(color: Colors.black),),
        SizedBox(
          width: 10,
        )
        ,
        Flexible(
          child: TextField(
            textAlign: TextAlign.center,
            style: TextStyle(color: STextStyle.BACKGROUND_COLOR),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: STextStyle.BACKGROUND_COLOR),
                  onPressed: (){

                  },
                ),
                hintText: 'Search...',
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
        )
        ,
        SizedBox(
          width: 20,
        ),

      ],
      ),
//      actions: <Widget>[
//        IconButton(
//          icon: SvgPicture.asset('assets/filter.svg', color: STextStyle.ACTIVE_BOTTOM_BAR_COLOR, semanticsLabel: L10n.of(context).task),
//          onPressed: (){
//
//          },
//        ),
//
//      ],
    );
  }

  void updateOnlineUserStatus(int userId, String devices) {
    if (!mounted || GlobalParam.onlineUsers == null || _messageListHistoryList == null)
      return;

    for (ChatHistory c in _messageListHistoryList ) {
      if (c.userId == userId) {
        setState(() {
          c.isOnline = (devices?.length ?? 0) > 0;
          c.devices = devices;
        });
      }
    }
  }
  Future<void> _onWebSocketMessage(String msg) async {
    await _loadData();
  }
  @override
  void dispose() {
    super.dispose();
    _messageListsStreamController.close();
    SkyWebSocket.removeMessageListener(_onWebSocketMessage);

  }

}
