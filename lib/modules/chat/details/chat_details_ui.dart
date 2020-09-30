import 'dart:convert';

import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/global_function.dart';
import 'package:mobile/modules/chat/details/chat_details_api.dart';
import 'package:mobile/widgets/shtml.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/widgets/insert_edit_text_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile/modules/video_call/calling_ui.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/widgets/scircular_progress_indicator.dart';
import 'package:mobile/widgets/stext.dart';
import '../chat_model.dart';
import 'package:mobile/common/sky_websocket.dart';
import 'chat_details_bloc.dart';
import 'chat_details_event.dart';
import 'chat_details_state.dart';

class ChatDetailsUI extends StatefulWidget {
  final String chatterName;
  final int chatterId;
  final String chatterAccount;
  final DateTime lastAccess;
  final bool isOnline;
  final ChatDetailsBloc chatDetailsBloc;

  ChatDetailsUI({
    Key key,
    @required this.chatterName,
    @required this.chatterAccount,
    @required this.chatterId,
    @required this.lastAccess,
    @required this.isOnline,
    @required this.chatDetailsBloc
  }) : super(key: key);

  @override
  State<ChatDetailsUI> createState() => _ChatDetailsUIState();
}

class _ChatDetailsUIState extends State<ChatDetailsUI> with TickerProviderStateMixin {
  String get _chatterName => widget.chatterName;
  String get _chatterAccount => widget.chatterAccount;
  int get _chatterId => widget.chatterId;
  bool get _isOnline => widget.isOnline;
  DateTime get _lastAccess => widget.lastAccess;
  ChatDetailsBloc get _chatDetailsBloc => widget.chatDetailsBloc;
  bool _isRemoteTyping = false;
  int _currentPage = 0;
  List<ChatHistoryDetails> _chatHistoryDetailsList;
  TextEditingController messageTextController = TextEditingController();
  FocusNode messageFocusNode = new FocusNode();
  bool _isSending = false;
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  String _typingString = '..........';
  Animation<int> _characterCount;
  AnimationController _animateController;
  @override
  void initState() {
    SkyWebSocket.addMessageListener(_onChatMessage);
    _loadData();
    messageTextController.addListener(() {
      if (messageTextController.text.trim().length > 0 ) {
        var chatHistoryDetails = ChatHistoryDetails(
          senderId: GlobalParam.USER_ID,
          receiverId: _chatterId,
        );
        _chatDetailsBloc.chatDetailsWebSocket.sendTypingMessageToWebSocketServer(chatHistoryDetails);
      }
    });

    messageFocusNode.addListener((){
      if (!messageFocusNode.hasFocus){
        var chatHistoryDetails = ChatHistoryDetails(
          senderId: GlobalParam.USER_ID,
          receiverId: _chatterId,
        );
        _chatDetailsBloc.chatDetailsWebSocket.sendEndTypingMessageToWebSocketServer(chatHistoryDetails);
      }
    });
    _updateReceiveMessageStatus();
    _requestCameraAndMicPermissions();

    _animateController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _characterCount = new StepTween(begin: 1, end: _typingString.length)
        .animate(CurvedAnimation(parent: _animateController, curve: Curves.easeIn));

    super.initState();
  }


  Future<void> _requestCameraAndMicPermissions() async {
    await PermissionHandler().requestPermissions([PermissionGroup.camera]);
    await PermissionHandler().requestPermissions([PermissionGroup.microphone]);
  }

  void _updateReceiveMessageStatus() async {
    GlobalParam.isActivatedChat = true;
    /// update receive message status to read
    await _chatDetailsBloc.chatDetailsAPI.updateReceiveMessageStatus(GlobalParam.USER_ID, _chatterId, SkyNotification.GROUP_MESSAGE, 2);///2=read
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatDetailsEvent, ChatDetailsState>(
      key: GlobalParam.chatDetailsPageGlobalKey,
      bloc: _chatDetailsBloc,
      builder: (BuildContext context, ChatDetailsState state) {
        if (state is ChatDetailsFailure) {
          _onWidgetDidBuild(() {
            scaffoldKey.currentState?.showSnackBar(
              SnackBar(
                content: SText(state.error),
                backgroundColor: Colors.red,
              ),
            );
          });
        }
        if (state is ChatDetailsLoading)
          _chatHistoryDetailsList = state.chatHistoryDetailsList;

        return state is ChatDetailsLoading ? _buildChatDetails(state) : SCircularProgressIndicator.buildSmallCenter();

      },
    );
  }

  Widget _buildChatDetails(ChatDetailsState state) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: STextStyle.LIST_BACKGROUND_COLOR,
      appBar: _buildAppBar(),
      body: ListView(
        reverse: true,
        children: <Widget>[
          ..._buildChatDetailsList(state)
        ],
      ),
      bottomNavigationBar: _buildInputChat(state),
    );
  }

  Widget _buildInputChat(ChatDetailsState state) {
    return Container(
      decoration: STextStyle.appBarDecoration(),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: 55,
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                focusNode: messageFocusNode,
                maxLines: 1,
                style: TextStyle(color: STextStyle.BACKGROUND_COLOR),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onSubmitted: (value){
                  _onSendMessageButtonPressed();
                },
                controller: messageTextController,
                decoration: InputDecoration(
                    hintText: L10n.of(context).message + '...',
                    prefixIcon: IconButton(
                      icon: Icon(Icons.insert_emoticon, color: STextStyle.BACKGROUND_COLOR),
                      onPressed: () async {
                        String emoji = await _showEmojiDialog(L10n.of(context).selectEmoji);
                        if (!mounted)
                          return;
                        setState(() {
                          if (emoji !=null)
                            messageTextController.text += emoji;
                        });
                      },
                    ),
                    suffixIcon: !_isSending ? IconButton(
                      icon: Icon(Icons.send, color: STextStyle.BACKGROUND_COLOR),
                      //onPressed: state is SendingMessage ? _onSendMessageButtonPressed : null,
                      onPressed: _onSendMessageButtonPressed,
                    ) : SCircularProgressIndicator.buildSmallest(),

                    hintStyle: TextStyle(
                        fontSize: 14,
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
          ],
        ),
      ),
    );
  }

  Future<String> _showEmojiDialog(String label)  {
    var textController = InsertEditTextController();
    return showDialog(
      context: context,
      child: new AlertDialog(
        title: new Text(label),
        content: SizedBox(
          height: 250,
          child: Column(
            children: <Widget>[
              FittedBox(
                child: EmojiPicker(
                  buttonMode: ButtonMode.MATERIAL,
                  onEmojiSelected: (emoji, category) {
                    textController.setTextAndPosition(textController.text + emoji.emoji);
                  },
                ),
              ),
              TextField(controller: textController,),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.pop(context, textController.text),
            child: Text(L10n.of(context).select),
          ),

          new FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(L10n.of(context).close),
          ),
        ],
      ),
    );
  }

  List<Widget>_buildChatDetailsList(ChatDetailsState state){
    List<Widget> list = List<Widget>();
    bool isShowAvatar = false;
    bool isReceiverFirst = false;

    for (var i = 0; i < _chatHistoryDetailsList.length; i++){
      if (_chatHistoryDetailsList[i].senderId != _chatterId) {
        list.add(_buildSenderItem(state, _chatHistoryDetailsList[i]));
        isReceiverFirst = true;
      } else {
        if (i <_chatHistoryDetailsList.length-1 && _chatHistoryDetailsList[i].receiverId != _chatHistoryDetailsList[i+1].receiverId)
          isShowAvatar = true;
        else
          isShowAvatar = false;

        if(i==_chatHistoryDetailsList.length-1 && isReceiverFirst == false) {
          isShowAvatar = true;
        }

        if( i <_chatHistoryDetailsList.length-1 && _chatHistoryDetailsList[i].sendDate?.day != _chatHistoryDetailsList[i+1].sendDate?.day){
          isShowAvatar = true;
        }

        list.add(_buildReceiverItem(_chatHistoryDetailsList[i], isShowAvatar));
      }

      if(_chatHistoryDetailsList[i].sendDate?.day != DateTime.now().day ){
        if (i < _chatHistoryDetailsList.length-1) {
          if(_chatHistoryDetailsList[i].sendDate?.day != _chatHistoryDetailsList[i+1].sendDate?.day){
            list.add(_buildSendDate(_chatHistoryDetailsList[i].sendDate));
          }
        } else {// first history line
          list.add(_buildSendDate(_chatHistoryDetailsList[i].sendDate));
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
  Widget _buildReceiverItem(ChatHistoryDetails chatHistoryDetails, bool showAvatar){
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (showAvatar)
            Row(children: <Widget>[
              ClipOval(
                //child: Image.network('${GlobalParam.IMAGE_SERVER_URL}/avartar?id=${chatHistory.userId}',
                child: FadeInImage.memoryNetwork(
                  placeholder: transparentImage,
                  image: '${GlobalParam.IMAGE_SERVER_URL}/avartar?id=${chatHistoryDetails.senderId}',
                  fit: BoxFit.fill,
                  height: 55,
                  width: 55,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              SText(chatHistoryDetails.name, style: STextStyle.blurTextStyle())
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
            width: chatHistoryDetails.message.trim().length.toDouble()*(GlobalParam.DEFAULT_FONT_SIZE-5)+12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if(chatHistoryDetails.message == L10n.ofValue().typing)
                  _characterCount != null ?
                    AnimatedBuilder(
                      animation: _characterCount,
                      builder: (context, child){
                        String text = _typingString.substring(0, _characterCount.value);
                        return SHtml(data: text);
                      },
                    )
                  : SHtml(data: '.')
                else
                  SHtml(data: chatHistoryDetails.message),
                SizedBox(
                  height: 13,
                ),
                SizedBox(
                  width: 1000,
                  child: SText(Util.getTimeStr(chatHistoryDetails.sendDate), textAlign: TextAlign.end,
                      style: STextStyle.smallerTextStyle().merge(STextStyle.italicTextStyle())
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSenderItem(ChatDetailsState state, ChatHistoryDetails chatHistoryDetails){
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


  Widget _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
          decoration: STextStyle.appBarDecoration()
      ),
      titleSpacing: -5,
      title: Container(
        padding: EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SText(_chatterName, style: STextStyle.biggerTextStyle()),
            SText((_isOnline ?? false) ? L10n.of(context).justAccess : L10n.of(context).lastAccess  + ": " + (_lastAccess == null ? L10n.of(context).longTime : Util.getDateTimeStr(_lastAccess)), style: STextStyle.smallerTextStyle()),
          ],
        ),
      ),
      actions: <Widget>[
        IconButton(
          tooltip: L10n.of(context).voiceCall,
          icon: Icon(Icons.call
          ),
          onPressed: () async {
            _openCallingDialog(false);
          },
        ),
        IconButton(
          tooltip: L10n.of(context).videoCall,
          icon: Icon(Icons.videocam),
          onPressed: () async {
            _openCallingDialog(true);
          },
        ),
        IconButton(
          tooltip: L10n.of(context).more,
          icon: Icon(Icons.more_horiz),
          onPressed: (){

          },
        )
      ],
    );
  }

  void _openCallingDialog(bool isVideoCalling) {
    Navigator.of(context).push(new MaterialPageRoute<String>(
        builder: (BuildContext context) {
          return CallingUI(
            isCallMode: true,
            receiverId: _chatterId,
            receiverName: _chatterName,
            receiverAccount: _chatterAccount,
            isVideoCalling: isVideoCalling,
          );
        },
        fullscreenDialog: true));
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  void _loadData() {
    _chatDetailsBloc.dispatch(TapDetails(
        senderId: GlobalParam.USER_ID,
        receiverId: _chatterId,
        groupId: SkyNotification.GROUP_MESSAGE,
        currentPage: _currentPage,
        pageSize: GlobalParam.PAGE_SIZE
    ));
  }

  void _onSendMessageButtonPressed() async {
    var message = messageTextController.text.trim();
    if (message.length == 0)
      return;

    setState(() {
      _isSending = true;
    });

    var isSuccess = await ChatDetailsAPI.saveMessage(
      senderId: GlobalParam.USER_ID,
      receiverId: _chatterId,
      groupId: SkyNotification.GROUP_MESSAGE,
      message: message,
    );
    var chatHistoryDetails = ChatHistoryDetails(
      message: message,
      senderId: GlobalParam.USER_ID,
      receiverId: _chatterId,
      sendDate: DateTime.now(),
      name: GlobalParam.FULL_NAME,
    );

    setState(() {
      if (isSuccess) {
        _chatDetailsBloc.chatDetailsWebSocket.sendMessageToWebSocketServer(
            chatHistoryDetails);

        if (_isRemoteTyping && _chatHistoryDetailsList.length > 0) {
          _chatHistoryDetailsList.removeAt(0);
        }
        _chatHistoryDetailsList.insert(0, chatHistoryDetails);
        messageTextController.text = '';
        _isSending = false;
      }
    });
    _isRemoteTyping = false;
  }

  void _onChatMessage(msg) async {
    var decodedMessage = json.decode(msg);
    ChatData chatData;
    switch(decodedMessage["action"]){
      case "chat":
        chatData = ChatData.fromJson(decodedMessage["chatData"]);
        if (chatData.fromId != _chatterId) {
          Util.playMessageTone();
          break;
        }
        setState(() {
          var chatHistoryDetails = ChatHistoryDetails(
            message: chatData.msgContent,
            senderId: chatData.fromId,
            receiverId: chatData.toId,
            sendDate: DateTime.now(),
            name: _chatterName
          );

          if (_isRemoteTyping && _chatHistoryDetailsList.length > 0) {
            _chatHistoryDetailsList.removeAt(0);
          }
          _chatHistoryDetailsList.insert(0, chatHistoryDetails);
        });
        _isRemoteTyping = false;
        break;
      case "typing":
        chatData = ChatData.fromJson(decodedMessage["chatData"]);
        if (chatData.fromId != _chatterId) {
          break;
        }

        setState(() {
          var chatHistoryDetails = ChatHistoryDetails(
            message: L10n.of(context).typing,
            senderId: chatData.fromId,
            receiverId: chatData.toId,
            name: _chatterName,
            sendDate: DateTime.now()
          );
          if (!_isRemoteTyping)
            _chatHistoryDetailsList.insert(0, chatHistoryDetails);
        });
        _isRemoteTyping = true;
        _animateController.reset();
        await _animateController.repeat();
        break;
      case "endTyping":
        chatData = ChatData.fromJson(decodedMessage["chatData"]);
        if (chatData.fromId != _chatterId) {
          break;
        }

        setState(() {
          if (_isRemoteTyping)
            _chatHistoryDetailsList.removeAt(0);
        });
        _isRemoteTyping = false;
        break;
      default:
        debugPrint('Unhandle message: ${decodedMessage["action"]}');
        break;
    }
  }

  @override
  void dispose() {
    SkyWebSocket.removeMessageListener(_onChatMessage);
    _animateController.dispose();
    super.dispose();
  }

}

