import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/modules/chat/chat_bloc.dart';
import 'package:mobile/modules/chat/chat_event.dart';
import 'package:mobile/modules/chat/chat_model.dart';
import 'package:mobile/modules/chat/chat_state.dart';
import 'package:mobile/modules/chat/details/chat_details_api.dart';
import 'package:mobile/modules/chat/details/chat_details_bloc.dart';
import 'package:mobile/modules/chat/details/chat_details_ui.dart';
import 'package:mobile/widgets/shtml.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/chat/details/chat_details_web_socket.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/widgets/scircular_progress_indicator.dart';
import 'package:mobile/widgets/stext.dart';


class EmployeeUI extends StatefulWidget {
  final ChatBloc chatBloc;

  EmployeeUI({
    Key key,
    @required this.chatBloc,
  }) : super(key: key);

  @override
  State<EmployeeUI> createState() {
    GlobalParam.employeeUIState = EmployeeUIState();
    return GlobalParam.employeeUIState;
  }
}

class EmployeeUIState extends State<EmployeeUI> {
  ChatBloc get _chatBloc => widget.chatBloc;
  List<ChatHistory> _chatHistoryList;
  ChatDetailsBloc _chatDetailsBloc;
  static ChatHistory _selectedChatHistory;

  @override
  void initState() {
    _chatDetailsBloc = ChatDetailsBloc(chatDetailsAPI: ChatDetailsAPI(), chatDetailsWebSocket: ChatDetailsWebSocket());
    super.initState();
  }


  @override
  void didUpdateWidget(EmployeeUI oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedChatHistory!= null){
      setState(() {
        _selectedChatHistory.unreadMessage = 0;
      });
    }

    if (mounted)
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
      appBar: _buildAppBar(L10n.of(context).employee, 0/*await Util.getNotificationByGroupId(SkyNotification.GROUP_EMPLOYEE)*/),
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
              _selectedChatHistory = chatHistory;
            },
            leading: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: <Widget>[
                FittedBox(
                  child: ClipOval(
                    child: Image.network('${GlobalParam.IMAGE_SERVER_URL}/avartar?id=${chatHistory.userId}',
                      fit: BoxFit.fill,
                      height: 55,
                      width: 55,
                    ),
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
                    height: 17,
                    child: SHtml(data: chatHistory.lastMessage??'')
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
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  Widget _buildAppBar(String text, int numberOfNotifications) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(children: <Widget>[
        IconButton(
          icon: ClipOval(
            child: SvgPicture.asset('assets/message.svg', color: STextStyle.PRIMARY_TEXT_COLOR),
          ),
          onPressed: (){

          },
        ),
        if (text != null)
          SText(text, style: TextStyle(color: Colors.black),),
        SizedBox(
          width: 10,
        ),
        if (numberOfNotifications != null && numberOfNotifications > 0)
          Container(
              padding: EdgeInsets.only(left: 6, top: 3, bottom: 3, right: 6),
              decoration: BoxDecoration(
                  color: STextStyle.HOT_COLOR,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: SText(numberOfNotifications.toString(), style: TextStyle(color: Colors.white, fontSize: GlobalParam.SMALLER_FONT_SIZE))
          )
      ],
      ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset('assets/filter.svg', color: STextStyle.ACTIVE_BOTTOM_BAR_COLOR, semanticsLabel: L10n.of(context).task),
          onPressed: (){

          },
        ),

      ],
    );
  }

  void updateOnlineUserStatus(int userId, String devices) {
    if (!mounted || GlobalParam.onlineUsers == null || _chatHistoryList == null)
      return;

    for (ChatHistory c in _chatHistoryList ) {
      if (c.userId == userId) {
        setState(() {
          c.isOnline = (devices?.length ?? 0) > 0;
          c.devices = devices;
        });
      }
    }
  }

}
