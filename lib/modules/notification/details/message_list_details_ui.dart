import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kernel/text/serializer_combinators.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/modules/chat/chat_model.dart';
import 'package:mobile/widgets/shtml.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/video_call/calling_ui.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/widgets/scircular_progress_indicator.dart';
import 'package:mobile/widgets/stext.dart';
import 'message_list_details_bloc.dart';
import 'message_list_details_event.dart';
import 'message_list_details_state.dart';

class MessageListDetailsUI extends StatefulWidget {
  final String senderName;
  final int senderId;
  final String senderAccount;
  final DateTime lastAccess;
  final bool isOnline;
  final int groupId;
  final MessageListDetailsBloc messageListDetailsBloc;

  MessageListDetailsUI({
    Key key,
    @required this.senderName,
    @required this.senderAccount,
    @required this.senderId,
    @required this.lastAccess,
    @required this.isOnline,
    @required this.groupId,
    @required this.messageListDetailsBloc
  }) : super(key: key);

  @override
  State<MessageListDetailsUI> createState() => _MessageListDetailsUIState();
}

class _MessageListDetailsUIState extends State<MessageListDetailsUI> {
  String get _senderName => widget.senderName;
  String get _senderAccount => widget.senderAccount;
  int get _senderId => widget.senderId;
  int get _groupId => widget.groupId;
  bool get _isOnline => widget.isOnline;
  DateTime get _lastAccess => widget.lastAccess;
  MessageListDetailsBloc get _messageListDetailsBloc => widget.messageListDetailsBloc;
  List<ChatHistoryDetails> _messageDetailsList;
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _updateReceiveMessageStatus();
    super.initState();
    _init();
  }

  void _init() {
    _messageListDetailsBloc.dispatch(OnTapMessageListDetails(
        senderId: GlobalParam.USER_ID,
        receiverId: _senderId,
        groupId: _groupId,
        currentPage: 0,
        pageSize: GlobalParam.PAGE_SIZE
    ));
  }

  void _updateReceiveMessageStatus() async {
    GlobalParam.isActivatedChat = true;
    /// update receive message status to read
    //await _messageListDetailsBloc.messageListDetailsAPI.updateReceiveMessageTask(GlobalParam.USER_ID, _senderId, _groupId, 2);///2=read
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageListDetailsEvent, MessageListDetailsState>(
      key: GlobalParam.messageListDetailsPageGlobalKey,
      bloc: _messageListDetailsBloc,
      builder: (BuildContext context, MessageListDetailsState state) {
        if (state is MessageListDetailsFailure) {
          _onWidgetDidBuild(() {
            scaffoldKey.currentState?.showSnackBar(
              SnackBar(
                content: SText(state.error),
                backgroundColor: Colors.red,
              ),
            );
          });
        }
        if (state is MessageListDetailsLoading)
          _messageDetailsList = state.messageDetailsList;

        return state is MessageListDetailsLoading ? _buildMessageListDetails(state) : SCircularProgressIndicator.buildSmallCenter();

      },
    );
  }

  Widget _buildMessageListDetails(MessageListDetailsState state) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: STextStyle.LIST_BACKGROUND_COLOR,
      appBar: _buildAppBar(),
      body: ListView(
        reverse: true,
        children: <Widget>[
          ..._buildMessageListDetailsList(state)
        ],
      ),
    );
  }

  List<Widget>_buildMessageListDetailsList(MessageListDetailsState state){
    List<Widget> list = List<Widget>();
    bool isShowAvatar = false;
    bool isReceiverFirst = false;

    for (var i = 0; i < _messageDetailsList.length; i++){
      if (_messageDetailsList[i].senderId != _senderId) {
        list.add(_buildSenderItem(state, _messageDetailsList[i]));
        isReceiverFirst = true;
      } else {
        if (i <_messageDetailsList.length-1 && _messageDetailsList[i].receiverId != _messageDetailsList[i+1].receiverId)
          isShowAvatar = true;
        else
          isShowAvatar = false;

        if(i==_messageDetailsList.length-1 && isReceiverFirst == false) {
          isShowAvatar = true;
        }

        if( i <_messageDetailsList.length-1 && _messageDetailsList[i].sendDate?.day != _messageDetailsList[i+1].sendDate?.day){
          isShowAvatar = true;
        }

        list.add(_buildReceiverItem(_messageDetailsList[i], isShowAvatar));
      }

      if(_messageDetailsList[i].sendDate?.day != DateTime.now().day ){
        if (i < _messageDetailsList.length-1) {
          if(_messageDetailsList[i].sendDate?.day != _messageDetailsList[i+1].sendDate?.day){
            list.add(_buildSendDate(_messageDetailsList[i].sendDate));
          }
        } else {// first history line
          list.add(_buildSendDate(_messageDetailsList[i].sendDate));
        }
      }
    }
    return list;
  }

  Widget _buildSendDate(DateTime dateTime){
    return Container(
      child: Column(
        children: <Widget>[
          Divider(),
          SText(Util.getDateStr(dateTime), textAlign: TextAlign.center, style: STextStyle.blurTextStyle()),
        ],
      ),
    );
  }
  Widget _buildReceiverItem(ChatHistoryDetails messageListDetails, bool showAvatar){
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (showAvatar)
            Row(children: <Widget>[
              ClipOval(
                child: Image.network('${GlobalParam.IMAGE_SERVER_URL}/avartar?id=${messageListDetails.senderId}',
                  fit: BoxFit.fill,
                  width: 40,
                  height: 40,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              SText(messageListDetails.name, style: STextStyle.blurTextStyle())
            ],
            ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: STextStyle.RECEIVER_BACKGROUND_COLOR,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width*0.8,
                minWidth: 5*(GlobalParam.DEFAULT_FONT_SIZE-5)+12
            ),
            width: messageListDetails.message.trim().length.toDouble()*(GlobalParam.DEFAULT_FONT_SIZE-5)+12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SHtml(data: messageListDetails.message),
                SizedBox(
                  height: 13,
                ),
                SizedBox(
                  width: 1000,
                  child: SText(Util.getTimeStr(messageListDetails.sendDate), textAlign: TextAlign.end,
                      style: STextStyle.smallerTextStyle().merge(STextStyle.italicTextStyle())
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      trailing: _groupId == SkyNotification.GROUP_EMPLOYEE ? FittedBox() : _buildTrailing(messageListDetails),
    );
  }

  Widget _buildSenderItem(MessageListDetailsState state, ChatHistoryDetails chatHistoryDetails){
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
                maxWidth: MediaQuery.of(context).size.width*0.8,
                minWidth: 5*(GlobalParam.DEFAULT_FONT_SIZE-5)+10
            ),
            width: chatHistoryDetails.message.trim().length.toDouble()*(GlobalParam.DEFAULT_FONT_SIZE-5)+10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SHtml(data: '${chatHistoryDetails.message}', customTextAlign: (e) => TextAlign.end,),
                SText(Util.getTimeStr(chatHistoryDetails.sendDate),
                    style: STextStyle.smallerTextStyle().merge(STextStyle.italicTextStyle())
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrailing(ChatHistoryDetails item) {
    return PopupMenuButton<Tuple2<int, int>>(
      onSelected: (value) {

        _messageListDetailsBloc.dispatch(OnTapSubmitApproveDeny(
            userId: GlobalParam.getUserId(),
            groupId: _groupId,
            currentPage: 0,
            pageSize: GlobalParam.PAGE_SIZE,
            task : value.first,
            sourceId : value.second
        ));
      },
      icon: Icon(Icons.arrow_drop_down, color: [ChatHistoryDetails.TASK_CANCEL_APPROVE, ChatHistoryDetails.TASK_SUBMIT].contains(item.task)  ? STextStyle.HOT_COLOR: Colors.green, size: 40,),
      itemBuilder: [ChatHistory.TASK_CANCEL_APPROVE, ChatHistory.TASK_SUBMIT].contains(item.task) ? (context) => [
        PopupMenuItem< Tuple2<int, int>>(
          value: new Tuple2(ChatHistoryDetails.TASK_APPROVE,item.sourceId),
          child: SText(L10n.of(context).approve),

        ),
        PopupMenuItem<Tuple2<int, int>>(
          value: new Tuple2(ChatHistoryDetails.TASK_SUBMIT,item.sourceId),
          child: SText(L10n.of(context).submit),

        ),
        PopupMenuItem<Tuple2<int, int>>(
          value: new Tuple2(ChatHistoryDetails.TASK_DENY,item.sourceId),
          child: SText(L10n.of(context).deny),
        ),
      ] : (context) => [
        PopupMenuItem<Tuple2<int, int>>(
          value: new Tuple2(ChatHistoryDetails.TASK_CANCEL_APPROVE,item.sourceId),
          child: SText(L10n.of(context).cancelApprove),
        ),
        PopupMenuItem<Tuple2<int, int>>(
          value: new Tuple2(ChatHistoryDetails.TASK_CANCEL_SUBMIT,item.sourceId),
          child: SText(L10n.of(context).cancelSubmit),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
          decoration: STextStyle.appBarDecoration()
      ),
      titleSpacing: -5,
      title: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SText(_senderName, style: STextStyle.biggerTextStyle()),
                SText((_isOnline ?? false) ? L10n.of(context).justAccess : L10n.of(context).lastAccess  + ": " + (_lastAccess == null ? L10n.of(context).longTime : Util.getDateTimeStr(_lastAccess)), style: STextStyle.smallerTextStyle()),
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
                  contentPadding: EdgeInsets.all(0),
                  fillColor: STextStyle.GRADIENT_COLOR_AlPHA
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      actions: <Widget>[

      ],
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

}

