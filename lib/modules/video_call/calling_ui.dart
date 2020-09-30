import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_incall_manager/incall.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/global_function.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/common/sky_websocket.dart';
import 'package:mobile/widgets/stext.dart';

class CallingUI extends StatefulWidget {
  final int receiverId;
  final String receiverName;
  final String receiverAccount;
  final bool isVideoCalling;
  final bool isCallMode;
  final String sessionId;

  CallingUI({@required this.sessionId, @required this.isCallMode, @required this.isVideoCalling, @required this.receiverId, @required this.receiverName, @required this.receiverAccount});

  @override
  CallingUIState createState() {
    GlobalParam.callingUIState = CallingUIState();
    return GlobalParam.callingUIState;
  }
}

class CallingUIState extends State<CallingUI> {
  int get _receiverId => widget.receiverId;
  String get _receiverName => widget.receiverName;
  String get _receiverAccount => widget.receiverAccount;
  String get _sessionId => widget.sessionId;
  bool get isCallMode => widget.isCallMode;
  bool get isVideoCalling => widget.isVideoCalling;
  RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();
  bool _acceptCall = false;
  bool _enableVideo = true;
  bool _enableAudio = true;
  bool _enableMic = true;
  bool _fullScreen = false;
  static Timer _ringtoneTimer;
  static Timer _ringbackTimer;
  @override
  void initState() {
    super.initState();
    _initCall();
  }

  _initCall() async {
    GlobalParam.callingPageGlobalKey = new GlobalKey<CallingUIState>();
    GlobalParam.inCall ??= IncallManager();
//    await GlobalParam.inCall.checkRecordPermission();
//    await GlobalParam.inCall.requestRecordPermission();
//    await GlobalParam.inCall?.start({'media':'audio', 'auto': true, 'ringback': ''});
//    await GlobalParam.inCall.turnScreenOn();
//    await GlobalParam.inCall.setSpeakerphoneOn(true);
//    await GlobalParam.inCall.setKeepScreenOn(true);

    await initRenderer();

    SkyWebSocket.initCall(peerId: _receiverId, peerName: _receiverName, peerAccount: _receiverAccount);

    if (isCallMode) {
      try{
        SkyWebSocket.openPopup(isVideoCalling);
      } catch (e) {
        print(e);
      }

      await playCallerTone();
    } else {
      await playRemoteRingtone();
    }
  }

  initRenderer() async {
    await _localRenderer?.initialize();
    await _remoteRenderer?.initialize();

    _registerListener();
  }

  void _registerListener() {
    SkyWebSocket.onLocalStream = ((stream) {
      _localRenderer?.srcObject = stream;
    });

    SkyWebSocket.onAddRemoteStream = ((stream) {
      _remoteRenderer?.srcObject = stream;
    });

    SkyWebSocket.onRemoveRemoteStream = ((stream) {
      _remoteRenderer?.srcObject = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: GlobalParam.callingPageGlobalKey,
        body: InkWell(
          onTap: (){
            setState(() {
              if (_acceptCall)
                _fullScreen = !_fullScreen;
            });
          },
          child: Stack(
            children: <Widget>[
              Container(
                  color: Colors.black
              ),
              Column(
                children: <Widget>[
                  if (!_fullScreen)
                    Container(
                      padding: EdgeInsets.only(top: 25),
                      height: 85,
                      child: ListTile(
                        leading: ClipOval(
                            child: Image.network('${GlobalParam
                                .IMAGE_SERVER_URL}/avartar?id=$_receiverId',
                              fit: BoxFit.fill,
                              width: 40,
                            )
                        ),
                        title: SText(
                          _receiverName, style: TextStyle(color: Colors.white),),
                        subtitle: SText(
                            (isCallMode ? L10n
                                .of(context)
                                .callingTo : L10n
                                .of(context)
                                .callingFrom) + "..." + _receiverAccount,
                            style: TextStyle(color: Colors.white)),
                        trailing: IconButton(
                            icon: Icon(Icons.directions, color: Colors.white),
                            onPressed: () {
                              SkyWebSocket.switchCamera();
                            }),
                      )
                  ),
                  Expanded(
                      child: Container(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              child: _remoteRenderer == null
                              ? Container()
                              : RTCVideoView(_remoteRenderer)),
                            if (!_fullScreen)
                              Container(
                                width: 80,
                                height: 80,
                                child: _localRenderer == null
                                    ? Container()
                                    : RTCVideoView(_localRenderer)),
                          ],
                        ),
                      ),
                  ),
                  if (!_fullScreen)
                    Container(
                    height: 70,
                    child: isCallMode ? (_acceptCall ? _buildAcceptCallControl() : _buildCallingControl()) : (_acceptCall ? _buildAcceptCallControl() : _buildAnswerControl())
                  )
                ],
              ),
            ],
          ),
        )
    );
  }

  void acceptCall() {
    setState(() {
      _acceptCall = true;
    });
  }

  Widget _buildCallingControl() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30)
            ),
            child: IconButton(icon: Icon(
              Icons.videocam_off, color: Colors.white,))
        ),
        Container(
            child: _buildHangupButton()
        ),
        Container(
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30)
            ),
            child: IconButton(
                icon: Icon(Icons.mic_off, color: Colors.white,))
        ),
      ],
    );
  }
  Widget _buildAnswerControl() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildHangupButton(),
       _buildAnswerButton(),
      ],
    );
  }

  Widget _buildAcceptCallControl() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildHangupButton(),
        _buildEnableVideo(),
        _buildEnableAudio(),
        _buildEnableMic(),
      ],
    );
  }

  Widget _buildEnableVideo(){
    return Container(
      decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(30)
      ),
      child: IconButton(
        icon: Icon(_enableVideo ? Icons.videocam_off : Icons.video_call, color: Colors.white,),
        onPressed: () {
          setState(() {
            _enableVideo = !_enableVideo;
          });
          SkyWebSocket.enableVideo(_enableVideo);
        },
      ),
    );
  }

  Widget _buildEnableAudio(){
    return Container(
      decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(30)
      ),
      child: IconButton(
        icon: Icon(_enableAudio ? Icons.volume_down : Icons.volume_up, color: Colors.white,),
        onPressed: () {
          setState(() {
            _enableAudio = !_enableAudio;
          });
          GlobalParam.inCall.setSpeakerphoneOn(_enableAudio);
        },
      ),
    );
  }

  Widget _buildEnableMic(){
    return Container(
      decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(30)
      ),
      child: IconButton(
        icon: Icon(_enableMic ? Icons.mic_off : Icons.mic, color: Colors.white,),
        onPressed: () {
          setState(() {
            _enableMic = !_enableMic;
          });
          SkyWebSocket.enableAudio(_enableMic);
        },
      ),
    );
  }

  Widget _buildHangupButton() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(30)
      ),
      child: IconButton(
        icon: Icon(Icons.call_end, color: Colors.white,),
        onPressed: () {
          onClose(true);
        },
      ),
    );
  }

  Widget _buildAnswerButton() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(30)
      ),
      child: IconButton(
        icon: Icon(Icons.call, color: Colors.white,),
        onPressed: () async {
          stopInCallTone();
          SkyWebSocket.acceptCall(_sessionId, GlobalParam.USER_ID, _receiverId, isVideoCalling);
          setState(() {
            _acceptCall = true;
          });
        },
      ),
    );
  }

  playCallerTone() async {
    GlobalParam.inCall.startRingback();
    _ringbackTimer = Timer(Duration(seconds: GlobalParam.WAITING_RINGTONE), () {
      onClose(true);
    });
  }

  Future<void> playRemoteRingtone() async {
    GlobalParam.inCall.startRingtone('BUNDLE', 'default',30);
    _ringtoneTimer = Timer(Duration(seconds: GlobalParam.WAITING_RINGTONE), () {
      onClose(true);
    });
  }

  Future<void> onClose(bool notifyHangupToPeer) async {
    stopInCallTone();
    if (notifyHangupToPeer) {
      try{
        SkyWebSocket.hangup(_sessionId);
      } catch (e) {
        log2(e);
      }

    }
    SkyWebSocket.close();
    GlobalParam.inCall.setSpeakerphoneOn(false);
    GlobalParam.inCall.setKeepScreenOn(false);
    _localRenderer?.srcObject = null;
    _localRenderer?.dispose();

    _remoteRenderer?.srcObject = null;
    _remoteRenderer?.dispose();
    _localRenderer = null;
    _remoteRenderer = null;
    if (mounted) {
      if (GlobalParam.callingPageGlobalKey?.currentContext != null) {
        if (Navigator.of(GlobalParam.callingPageGlobalKey?.currentContext)
            .canPop())
          Navigator.of(GlobalParam.callingPageGlobalKey?.currentContext)?.pop(
              'returned value');
      }
    }
  }

  static void stopInCallTone() {
    _ringbackTimer?.cancel();
    _ringtoneTimer?.cancel();
    GlobalParam.inCall.stopRingback();
    GlobalParam.inCall.stopRingtone();

  }
  @override
  void dispose() {
    super.dispose();

  }

  void callAcceptedByOther() {
    stopInCallTone();
    GlobalParam.inCall.setSpeakerphoneOn(false);
    GlobalParam.inCall.setKeepScreenOn(false);
    _localRenderer?.srcObject = null;
    _localRenderer?.dispose();

    _remoteRenderer?.srcObject = null;
    _remoteRenderer?.dispose();
    _localRenderer = null;
    _remoteRenderer = null;

    if (GlobalParam.callingPageGlobalKey?.currentContext != null) {
      if(Navigator.of(GlobalParam.callingPageGlobalKey?.currentContext).canPop())
        Navigator.of(GlobalParam.callingPageGlobalKey?.currentContext)?.pop('returned value');
    }
  }
}