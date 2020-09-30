import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/global_function.dart';
import 'package:mobile/widgets/shtml.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/modules/chat/details/chat_details_web_socket.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/widgets/scircular_progress_indicator.dart';
import 'package:mobile/widgets/stext.dart';

import 'chat_bloc.dart';
import 'chat_event.dart';
import 'chat_model.dart';
import 'chat_state.dart';

import 'details/chat_details_api.dart';
import 'details/chat_details_bloc.dart';
import 'details/chat_details_ui.dart';

class ChatUI extends StatefulWidget {
  final ChatBloc chatBloc;

  ChatUI({
    Key key,
    @required this.chatBloc,
  }) : super(key: key);

  @override
  State<ChatUI> createState() {
    GlobalParam.chatUIState = ChatUIState();
    return GlobalParam.chatUIState;
  }
}

class ChatUIState extends State<ChatUI> {
  ChatBloc get _chatBloc => widget.chatBloc;
  List<ChatHistory> _chatHistoryList;
  ChatDetailsBloc _chatDetailsBloc;
  int _totalMessageNotify = 0;
  @override
  void initState() {
    _chatDetailsBloc = ChatDetailsBloc(chatDetailsAPI: ChatDetailsAPI(), chatDetailsWebSocket: ChatDetailsWebSocket());
    super.initState();
    //onNotify();
  }

  void _loadData() {
    _chatBloc.dispatch(ScrollList(
      userId: GlobalParam.USER_ID,
      groupId: SkyNotification.GROUP_MESSAGE,
      currentPage: 0,
      pageSize: GlobalParam.PAGE_SIZE
    ));
  }

  @override
  void didUpdateWidget(ChatUI oldWidget) {
    super.didUpdateWidget(oldWidget);
    Util.updateBadgerNotification(0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatEvent, ChatState>(
      bloc: _chatBloc,
      builder: (BuildContext context, ChatState state) {
        if (state is ChatFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: SText(state.error),
                backgroundColor: Colors.red,
              ),
            );
          });
        }
        if (state is ChatLoading) {
          _chatHistoryList = state.chatHistoryList;
        }
        return state is ChatLoading ? _buildRecentChatList() : SCircularProgressIndicator.buildSmallCenter();
      },
    );
  }

  Widget _buildRecentChatList() {
    return Scaffold(

      backgroundColor: STextStyle.BACKGROUND_COLOR,
      ///appBar: _buildAppBar(L10n.of(context).message, 'assets/message.svg', _totalMessageNotify),
      body: ListView (
        padding: EdgeInsets.zero,
        children: [
          for (var item in _chatHistoryList)
            _buildItem(item),
        ],
      ),
    );
  }

  Widget _buildItem(ChatHistory chatHistory) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: (){
            _onTapChatContact(chatHistory);
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
                          image: '${GlobalParam.IMAGE_SERVER_URL}/avartar?id=${chatHistory.userId}',
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
                  color: (chatHistory.isOnline ?? false) ? Colors.green : Colors.blueGrey,
                  borderRadius: BorderRadius.circular(4)
                ),
              ),
            ],
          ),
          title: SText(chatHistory.name??''),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SText(chatHistory.jobTitle??'', style: STextStyle.blurTextStyle()),
              SizedBox(height: 5),
              SizedBox(
                //height: 25,
                child: SHtml(data: chatHistory.lastMessage??'', maxLines: 1,)
              ),
            ],
          ),
          trailing: Column(
            children: <Widget>[
              _buildUnreadMessage(chatHistory),
              SText(Util.getEasyReadingDateTime(DateTime.now(), chatHistory.sendDate)??'',style: STextStyle.smallerTextStyle())
            ],
          )
        ),
        Row(
        children: <Widget>[
          if ((chatHistory.devices?.length ?? 0) <= 0)
            Container(alignment: AlignmentDirectional.center, width: 70, child: SText(Util.getDateTimeWithoutYearStr(chatHistory.lastAccess),style: TextStyle(fontSize: 10)))
          else
            Container(width: 70, child: _buildOnlineDevices(chatHistory.devices)),
//          Flexible(
//              child: SText(Util.getEasyReadingDateTime(DateTime.now(), chatHistory.sendDate)??'',style: STextStyle.smallerTextStyle())
//            )
          ],
        ),
        Divider(
          indent: 10,
        )
      ],
    );
  }

  Future<void> onNotify() async {
    var totalMessageNotify = await Util.getNotificationByGroupId(SkyNotification.GROUP_MESSAGE);
    if (mounted){
      setState(() {
        _totalMessageNotify = totalMessageNotify;
      });
    }
    _loadData();
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
  Widget _buildUnreadMessage(ChatHistory chatHistory) {
    return Stack(
      children: <Widget>[
        (chatHistory.unreadMessage ?? 0) > 0 ?
        SizedBox(
          width: 20,
          height: 20,
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red
            ),
            child: Center(
                child: SText(
                  chatHistory.unreadMessage.toString(),
                  style: TextStyle(
                      color: Colors.white
                  ),
                )
            ),
          ),
        ) : Container(child: Text(''))
      ],
    );
  }

  void _onTapChatContact(ChatHistory chatHistory){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
        ChatDetailsUI(
          chatDetailsBloc: _chatDetailsBloc,
          chatterName: chatHistory.name,
          chatterId: chatHistory.userId,
          chatterAccount: chatHistory.account,
          lastAccess: chatHistory.lastAccess,
          isOnline: chatHistory.isOnline,
        )
      ),
    ).then((onValue) async{
      GlobalParam.isActivatedChat = false;
      await _chatDetailsBloc.chatDetailsAPI.updateReceiveMessageStatus(GlobalParam.USER_ID, chatHistory.userId, SkyNotification.GROUP_MESSAGE, 2);///2=read
      await GlobalParam.homePageState?.onNotify(SkyNotification.GROUP_MESSAGE);
    });
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  void updateOnlineUserStatus(int userId, String devices) {
    if (!mounted || _chatHistoryList == null)
      return;

    for (ChatHistory c in _chatHistoryList ) {
      if (c.userId == userId) {
        c.isOnline = (devices?.length ?? 0) > 0;
        c.devices = devices;
      }
    }

    setState(() {
    });
  }

  void updateOnlineUsersStatus() {
    if (!mounted || GlobalParam.onlineUsers == null || _chatHistoryList == null)
      return;

    for (ChatHistory c in _chatHistoryList ) {
      if (GlobalParam.onlineUsers.length == 0) {
        c.devices = null;
        c.isOnline = false;
      } else if (GlobalParam.onlineUsers.containsKey(c.userId.toString())) {
        c.devices = GlobalParam.onlineUsers[c.userId.toString()];
        c.isOnline = (c.devices?.length??0) > 0;
      }
    }

    setState(() {
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
              icon: SvgPicture.asset(assetIcon, color: STextStyle.LIGHT_TEXT_COLOR),
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
}
