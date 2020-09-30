import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_webrtc/media_stream.dart';
import 'package:flutter_webrtc/media_stream_track.dart';
import 'package:flutter_webrtc/rtc_ice_candidate.dart';
import 'package:flutter_webrtc/rtc_peerconnection.dart';
import 'package:flutter_webrtc/rtc_peerconnection_factory.dart';
import 'package:flutter_webrtc/rtc_session_description.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/global_function.dart';
import 'package:mobile/common/native_code.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/modules/calendar/scalendar.dart';
import 'package:mobile/modules/chat/chat_model.dart';
import 'package:mobile/modules/home/home_page.dart';
import 'package:mobile/modules/notification/details/message_list_details_stream_ui.dart';
import 'package:mobile/modules/video_call/calling_ui.dart';
import 'package:mobile/modules/video_call/webrtc_util.dart';
import 'package:mobile/widgets/shtml.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screen/screen.dart';
import 'package:web_socket_channel/io.dart';
import 'package:toast/toast.dart';
import 'package:flutter_incall_manager/incall.dart';
import 'package:mobile/main.dart';

import 'package:http/http.dart' as http;
typedef void OtherEventCallback(dynamic event);
typedef void StreamStateCallback(MediaStream stream);

class SkyWebSocket {
  static IOWebSocketChannel _channel;
  static WebSocket _webSocket;
  static ObserverList<Function> _messageListeners = new ObserverList<Function>();
  static ObserverList<Function> _doneListeners = new ObserverList<Function>();
  static ObserverList<Function> _errorListeners = new ObserverList<Function>();
  static MediaStream _localStream;
  static List<MediaStream> _remoteStreams;
  static int _selfId;
  static int _peerId;
  static String _peerName;
  static String _peerAccount;
  static var _peerConnections = new Map<String, RTCPeerConnection>();
  static StreamStateCallback onAddRemoteStream;
  static StreamStateCallback onRemoveRemoteStream;
  static StreamStateCallback onLocalStream;
  static bool isConnected = false;
  static int channelId = 0;

  static Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
    ]
  };

  static final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ],
  };

  static final Map<String, dynamic> _constraints = {
    'mandatory': {
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': true,
    },
    'optional': [],
  };

  ///1. Connect to Web socket server
  static Future<bool> connect ()async {
    if (GlobalParam.TOKEN == null) {
      isConnected = false;
      GlobalParam.homePageState?.updateConnectedMessageServerStatus(isConnected);
      return false;
    }try{
      //reset connection
      await close();
      await reset();
      log(GlobalParam.CHAT_SERVER_URL);
      _webSocket = await WebSocket.connect(GlobalParam.CHAT_SERVER_URL)
        .timeout(Duration(seconds: GlobalParam.CONNECTION_TIMEOUT));
      _channel = IOWebSocketChannel(_webSocket);
      _channel.stream.listen(_onMessageFromServer, onDone: _onSocketDone, onError: _onSocketError);
      addMessageListener(_onSignalMessage);
      isConnected = true;
      GlobalParam.homePageState?.updateConnectedMessageServerStatus(isConnected);
      return true;
    }catch(e){
      log(e.toString());
      isConnected = false;
      GlobalParam.homePageState?.updateConnectedMessageServerStatus(isConnected);
      return false;
    }
  }



  ///2. join to server with id and other info
  static Future<void> join() async {
    send(json.encode({
      "action": "join",
      "data": UserMetaData(
        userId: GlobalParam.USER_ID,
        name: GlobalParam.FULL_NAME,
        account: GlobalParam.USER_NAME,
        device: "Mobile",
        deviceInfo: await Util.getDeviceInfo(),
        screenWidth: Util.getScreenWidth(),
        screenHeight: Util.getScreenHeight(),
      )}));
    _selfId = GlobalParam.USER_ID;
  }

  ///3. init calling info
  static void initCall({@required int peerId, @required String peerName, @required String peerAccount}) {
    _peerId = peerId;
    _peerName = peerName;
    _peerAccount = peerAccount;
  }

  /// user don't want to answer the call
  static void hangup(String peerSessionId) {
    send(json.encode({
      "action": "hangup",
      "data": UserMetaData(receiverId: _peerId, sessionId: peerSessionId)
    }));
  }

  static void _keepAlive() {
    send(json.encode({"action": "keepAlive"}));
  }

  static Future<void> forceConnect ()async {
    try {
      await connect();
      await join();
    }catch(e){
      print(e);
    }

    Timer(Duration(seconds: 1),(){
      GlobalParam.homePageState.updateConnectedMessageServerStatus(isConnected);
    });
  }

  static Future<void> reconnect ()async {
    print('reconnect..............');
    if (GlobalParam.TOKEN == null)
      return;

    await SCalendar.checkNotify();
    if (!isConnected) {
      try {
        await connect();
        await join();
      }catch(e){
        print(e);
      }
    } else {
      GlobalParam.homePageState.updateConnectedMessageServerStatus(isConnected);
      _keepAlive();
    }
  }

  static void openPopup(isVideoCall) {
    send(json.encode({
      "action": "openPopup",
      "data": UserMetaData(userId: _selfId, receiverId: _peerId, name: _peerName, account: _peerAccount, videoMediaCall: isVideoCall)
    }));
  }

  static Future<void> invite(String peerSessionId, bool isVideoCalling) async {
    _createPeerConnection(peerSessionId, isVideoCalling).then((pc) {
      _peerConnections[peerSessionId] = pc;
      _createOffer(isVideoCalling, peerSessionId, pc);
    });
  }

  static void acceptCall(sessionId, userId, receiverId, bool isVideoCalling) {
    send(json.encode({
      "action": "acceptCall",
      "data": UserMetaData(sessionId: sessionId, userId: userId, receiverId: receiverId, videoMediaCall: isVideoCalling)
    }));
  }

  static _createOffer(bool isVideoCalling, String peerSessionId, RTCPeerConnection pc) async {
    try {
      RTCSessionDescription s = await pc.createOffer(_constraints);
      pc.setLocalDescription(s);

      send(json.encode({
        "action": "webRtcOffer",
        "data": UserMetaData(
            videoMediaCall: isVideoCalling,
            sessionId: peerSessionId,
            candidateDescription: CandidateDescription(sdp: s.sdp, type: s.type)
        )
      }));
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<RTCPeerConnection> _createPeerConnection(String peerSessionId, bool isVideoCalling) async {
    _localStream = await WebRtcUtil.openLocalStream (isVideoCalling);

    if (onLocalStream != null) {
      onLocalStream(_localStream);
    }

    RTCPeerConnection pc = await createPeerConnection(_iceServers, _config);
    pc.addStream(_localStream);
    pc.onIceCandidate = (candidate) {
      send(json.encode({
        "action": "candidate",
        "data": UserMetaData(
          candidate: Candidate(candidate: candidate.candidate, sdpMid: candidate.sdpMid, sdpMLineIndex: candidate.sdpMlineIndex),
          sessionId: peerSessionId,
        )}
      ));
    };

    pc.onIceConnectionState = (state) {

    };

    pc.onAddStream = (stream) {
      if (onAddRemoteStream != null)
        onAddRemoteStream(stream);
    };

    pc.onRemoveStream = (stream) {
      if (onRemoveRemoteStream != null)
        onRemoveRemoteStream(stream);

      _remoteStreams.removeWhere((it) {
        return (it.id == stream.id);
      });
    };

    return pc;
  }

  static _createAnswer(String peerSessionId, RTCPeerConnection pc) async {
    try {
      RTCSessionDescription s = await pc.createAnswer( _constraints);
      pc.setLocalDescription(s);
      send(json.encode({
        "action": "webRtcAnswer",
        "data": UserMetaData(
          sessionId: peerSessionId,
          candidateDescription: CandidateDescription(sdp: s.sdp, type: s.type)
        )
      }));

    } catch (e) {
      print(e.toString());
    }
  }

  static void _onSignalMessage(msg) async {
    var decodedMessage = json.decode(msg);
    UserMetaData data;
    log2('-------------------------------------------------' + decodedMessage["action"]);
    switch(decodedMessage["action"]){
      case 'connect':
        break;
      case 'newUser':
        if (decodedMessage["data"] != null) {
          data = UserMetaData.fromJson(decodedMessage["data"]);

          if((data.device?.length ?? 0) > 0) {
            GlobalParam.onlineUsers ??= Map<dynamic, dynamic>();
            GlobalParam.onlineUsers[data.userId.toString()] = data.device;
            print("user id: ${data.userId} device: ${data.device}");

            switch (HomePage.homePageState.getSelectedTabIndex()) {
              case HomePageState.MESSAGE_TAB_INDEX:
                GlobalParam.chatUIState.updateOnlineUserStatus(data.userId, data.device);
                break;
              case HomePageState.NOTIFICATION_TAB_INDEX:
                GlobalParam.messageListUIState.updateOnlineUserStatus(data.userId, data.device);
                break;
            }
          }
        }
        break;
      case 'leave':
        print('leave....');
        print(decodedMessage["data"]);
        if (decodedMessage["data"] != null) {
          data = UserMetaData.fromJson(decodedMessage["data"]);
          GlobalParam.onlineUsers ??= Map<dynamic, dynamic>();
          GlobalParam.onlineUsers[data.userId.toString()] = data.device;
          switch (HomePage.homePageState.getSelectedTabIndex()) {
            case HomePageState.MESSAGE_TAB_INDEX:
              GlobalParam.chatUIState.updateOnlineUserStatus(data.userId, data.device);
              break;
            case HomePageState.NOTIFICATION_TAB_INDEX:
              GlobalParam.messageListUIState.updateOnlineUserStatus(data.userId, data.device);
              break;
          }
        }
        break;
      case "keepAlive":
      case "usersList":
        GlobalParam.homePageState?.updateConnectedMessageServerStatus(true);
        if (decodedMessage["data"] != null) {
          data = UserMetaData.fromJson(decodedMessage["data"]);
          log2('online: ');
          log2(data.onlineUsers);
          GlobalParam.onlineUsers = data.onlineUsers;
          switch (HomePage.homePageState?.getSelectedTabIndex()) {
            case HomePageState.MESSAGE_TAB_INDEX:
              GlobalParam.chatUIState?.updateOnlineUsersStatus();
              break;
            case HomePageState.NOTIFICATION_TAB_INDEX:
              //GlobalParam.messageListUIState.updateOnlineUserStatus(data.userId, data.device);
              break;
          }

        }
        break;
      case 'webRtcOffer':
        if (decodedMessage["data"] != null) {
          data = UserMetaData.fromJson(decodedMessage["data"]);
          var peerSessionId = data.sessionId;
          var description = data.candidateDescription;
          _createPeerConnection(peerSessionId, data.videoMediaCall).then((pc) async {
            _peerConnections[peerSessionId] = pc;
            await pc.setRemoteDescription(new RTCSessionDescription(description.sdp, description.type));
            _createAnswer(peerSessionId, pc);
          });
        }
        break;
      case 'webRtcAnswer':
        if (decodedMessage["data"] != null) {
          data = UserMetaData.fromJson(decodedMessage["data"]);
          var peerSessionId = data.sessionId;
          var description = data.candidateDescription;
          var pc = _peerConnections[peerSessionId];
          if (pc != null) {
            pc.setRemoteDescription(new RTCSessionDescription(description.sdp, description.type));
          }
        }
        break;
      case 'candidate':
        if (decodedMessage["data"]!=null) {
          data = UserMetaData.fromJson(decodedMessage["data"]);
          var pc = _peerConnections[data.sessionId];
          if (pc != null && data.candidate!=null) {
            RTCIceCandidate candidate = new RTCIceCandidate(
                data.candidate.candidate,
                data.candidate.sdpMid,
                data.candidate.sdpMLineIndex);
            pc.addCandidate(candidate);
          }
        }
        break;
      case "acceptCall":
        if (decodedMessage["data"] != null) {
          data = UserMetaData.fromJson(decodedMessage["data"]);
          invite(data.sessionId, data.videoMediaCall);
          CallingUIState.stopInCallTone();
          GlobalParam.callingUIState?.acceptCall();
        }
        break;
      case "callAcceptedByOther":
        GlobalParam.callingUIState?.callAcceptedByOther();
        break;
      case "openPopup":
        if (decodedMessage["data"] != null) {
          data = UserMetaData.fromJson(decodedMessage["data"]);
          //_turnOnScreen();
          //_openCallDialog(data.sessionId, false, data.videoMediaCall, data.userId, data.name??'', data.account??'');
        }
        break;
      case "hangup":
        _closeCallingDialog ("Todo: User Hangup");
        break;
      case "noAnswer":
        _closeCallingDialog ("Todo: No Anser");
        break;
      case "remoteHangup":
        _closeCallingDialog ("Todo: Remote User Hangup");
        break;
      case "chat":
       //_turnOnScreen();
        await NativeCall.turnOnScreen();
        GlobalParam.homePageState?.onNotify(GlobalParam.currentGroupId);

        ///background chat
        if (!GlobalParam.isActivatedChat) {
          ///TODO notification
         Util.playMessageTone();
        }
        await NativeCall.turnOffScreen();
        break;
      case "notification":
//        _turnOnScreen();
        await NativeCall.turnOnScreen();
        //Util.playMessageTone();
       // GlobalParam.homePageState?.onNotify(GlobalParam.currentGroupId);
        String content = decodedMessage["value"].replaceAll(RegExp("/"), "");
        content = content.replaceAll("<br>", " ");
        content = content.replaceAll("<b>", "");
        _showBigPictureNotification(decodedMessage["title"],content,decodedMessage["senderId"],decodedMessage["groupId"]);
        await NativeCall.turnOffScreen();

       // GlobalParam.homePageState?.onNotify(GlobalParam.currentGroupId);
        break;
      case "taskIconReload":
        GlobalParam.homePageState?.taskIconReload();

        break;
      default:
        log('Unhandle message: ${decodedMessage["action"]}');
        break;
    }
  }

  static Future<String> _downloadAndSaveImage(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static Future<void> _showBigPictureNotification(String title,String content, String senderId,String groupId) async {


    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/logo');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);

    var largeIconPath = await _downloadAndSaveImage(
        '${GlobalParam.IMAGE_SERVER_URL}/avartar?id='+senderId+'', 'largeIcon');

    var bigPictureStyleInformation = BigPictureStyleInformation(
        largeIconPath, BitmapSource.FilePath,
        hideExpandedLargeIcon: true,
      );

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "skyhub",'skyhub','skyhub notify',
        priority: Priority.High,
        largeIcon: largeIconPath,
        largeIconBitmapSource: BitmapSource.FilePath,
        style: AndroidNotificationStyle.Default,
        styleInformation: bigPictureStyleInformation);
    var platformChannelSpecifics =
    NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        channelId++, title, content, platformChannelSpecifics,payload: groupId);


  }
  static Future onSelectNotification(String groupId) async {

    GlobalParam.currentGroupId = int.parse(groupId);
    Navigator.push(
      GlobalParam.appContext,
      MaterialPageRoute(builder: (context) =>
          MessageListDetailsStreamUI(
            //messageListDetailsBloc: _messageListDetailsBloc,
            groupId: int.parse(groupId),
            approveOnly: true,
            senderId: GlobalParam.getUserId(),
            //senderAccount: message.account,
            //lastAccess: message.lastAccess,
            //isOnline: message.isOnline,
          )
      ),
    );
  }

  static void _turnOnScreen() async {
   // GlobalParam.inCall ??= IncallManager();
   // await GlobalParam.inCall.checkRecordPermission();
   // await GlobalParam.inCall.requestRecordPermission();
   // await GlobalParam.inCall?.start({'media':'audio', 'auto': true, 'ringback': ''});
    //await GlobalParam.inCall.turnScreenOn();
   // Screen.setBrightness(0.5);
    //await Screen.keepOn(true);
    await NativeCall.turnOnScreen();
   // await NativeCall.showMainActivity();
  }

  static void _closeCallingDialog(String result) {
    if (GlobalParam.callingUIState != null) {
      GlobalParam.callingUIState.onClose(false);
      Toast.show(result, GlobalParam.appContext, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    }
  }

  static _openCallDialog(String sessionId, bool isCallMode, bool isVideoCalling, int callerId, String name, String account) {
    return Navigator.of(GlobalParam.appContext).push(MaterialPageRoute<String>(
        builder: (BuildContext context) {
          return CallingUI(
            sessionId:sessionId,
            isCallMode: isCallMode,
            receiverName: name,
            receiverAccount: account,
            receiverId: callerId,
            isVideoCalling: isVideoCalling,
          );
        },
        fullscreenDialog: true));
  }

  static Future<void> close() async {
    if (_localStream != null) {
      _localStream.dispose();
      _localStream = null;
    }
    _peerConnections.forEach((key, pc) {
      pc.close();
    });
  }

  static Future<void> reset() async {
    isConnected = false;
    GlobalParam.homePageState?.updateConnectedMessageServerStatus(isConnected);
    removeMessageListener(_onSignalMessage);
    _messageListeners.forEach((function){
      _messageListeners.remove(function);
    });

    if(_channel!=null && _channel.sink!=null)
      await _channel.sink.close();
    if(_webSocket!=null)
      await _webSocket.close();
  }

  static void remoteNoAnswer(int callerId) {
    send(json.encode({
      "action": "noAnswer",
      "data": UserMetaData(userId: callerId)
    }));
  }

  static void remoteHangup(int callerId) {
    send(json.encode({
      "action": "remoteHangup",
      "data": UserMetaData(userId: callerId)
    }));
  }

  static void switchCamera() {
    _localStream?.getVideoTracks()[0].switchCamera();
  }

  static void enableVideo(bool enable) {
    var videoTracks = _localStream?.getVideoTracks();
    for (MediaStreamTrack track in videoTracks) {
      track.enabled = enable;
    }
  }

  static void enableAudio(bool enable) {
    var audioTracks = _localStream?.getAudioTracks();
    for (MediaStreamTrack track in audioTracks) {
      track.enabled = enable;
    }
  }

  static _onSocketDone(){
    log2('Socket Done');
    isConnected = false;
    GlobalParam.homePageState?.updateConnectedMessageServerStatus(isConnected);
    _doneListeners.forEach((Function callback){
      callback();
    });
  }

  static _onSocketError(error){
    log('Socket Error $error');
    isConnected = false;
    GlobalParam.homePageState?.updateConnectedMessageServerStatus(isConnected);
    _errorListeners.forEach((Function callback){
      callback();
    });
  }

  static _onMessageFromServer(message){
    _messageListeners.forEach((Function callback){
      callback(message);
    });
  }

  static void addMessageListener(Function callback){
    _messageListeners.add(callback);
  }
  static void removeMessageListener(Function callback){
    _messageListeners.remove(callback);
  }

  static void addDoneListener(Function callback){
    _doneListeners.add(callback);
  }
  static void removeDoneListener(Function callback){
    _doneListeners.remove(callback);
  }

  static void addErrorListener(Function callback){
    _errorListeners.add(callback);
  }
  static void removeErrorListener(Function callback){
    _errorListeners.remove(callback);
  }

  static bool send(String data){
    try {
      if (_channel != null && _channel.sink != null) {
        _channel.sink.add(data);
        return true;
      }
    } catch (e) {
      print (e);
      return false;
    }
    return false;
  }

  static Future<void> leave() async {
    send(json.encode({
      "action": "leave",
      "data": UserMetaData(
        userId: _selfId,
      )
    }));
    GlobalParam.onlineUsers = null;
    await Future.delayed(Duration(milliseconds: 500), () async {
      await close();
      await reset();
    });
  }

}