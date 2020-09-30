import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/system/config/prefs_key.dart';
import 'package:mobile/widgets/particular/sclose_button.dart';
import 'package:mobile/widgets/particular/ssave_button.dart';
import 'package:mobile/widgets/sflat_button.dart';
import 'package:mobile/widgets/snumber_form_field.dart';
import 'package:mobile/widgets/stext.dart';
import 'package:mobile/widgets/stext_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Server {
  static const DEFAULT_SERVER_URL_RELEASE_MODE = 'https://skyhub.suntech.com.vn:8443';
  static const DEFAULT_SERVER_URL_DEBUG_MODE = 'http://172.16.30.36:8182';

  static const DEFAULT_WS_SERVER_URL_RELEASE_MODE = 'wss://skyhub.suntech.com.vn:8888/hub/chatRoomServer';
  static const DEFAULT_WS_SERVER_URL_DEBUG_MODE = 'ws://172.16.30.36:8888/hub/chatRoomServer';

  static const DEFAULT_IMAGE_SERVER_URL_RELEASE_MODE = 'https://skyhub.suntech.com.vn:8888/hub';
  static const DEFAULT_IMAGE_SERVER_URL_DEBUG_MODE = 'http://172.16.30.12:8888/hub';

  static const DEFAULT_SERVER_URL = kReleaseMode ?  DEFAULT_SERVER_URL_RELEASE_MODE :DEFAULT_SERVER_URL_DEBUG_MODE ;
  static const DEFAULT_WS_SERVER_URL = kReleaseMode ?  DEFAULT_WS_SERVER_URL_RELEASE_MODE: DEFAULT_WS_SERVER_URL_DEBUG_MODE;
  static const DEFAULT_IMAGE_SERVER_URL = kReleaseMode ? DEFAULT_IMAGE_SERVER_URL_RELEASE_MODE : DEFAULT_IMAGE_SERVER_URL_DEBUG_MODE;
  static const DEFAULT_CONNECTION_TIMEOUT = 30; ///second


  static void showConfigDialog(BuildContext context) async {
    showDialog (
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ServerDialogContent();
      },
    );
  }
}

class ServerDialogContent extends StatefulWidget {
  @override
  _ServerDialogContentState createState() => _ServerDialogContentState();
}

class _ServerDialogContentState extends State<ServerDialogContent> {
  var serverURL;
  var chatServerURL;
  var imageServerURL;
  var timeout;

  var serverURLController;
  var webSocketServerURLController;
  var imageServerURLController;
  var timeoutController;

  SharedPreferences prefs;

  void _init() async {
    prefs = await SharedPreferences.getInstance();
    serverURL = prefs.getString(PrefsKey.serverURL.toString()) ?? Server.DEFAULT_SERVER_URL;
    chatServerURL = prefs.getString(PrefsKey.chatServerURL.toString()) ?? Server.DEFAULT_WS_SERVER_URL;
    imageServerURL = prefs.getString(PrefsKey.imageServerURL.toString()) ?? Server.DEFAULT_IMAGE_SERVER_URL;
    timeout = prefs.getInt(PrefsKey.connectionTimeout.toString()) ?? Server.DEFAULT_CONNECTION_TIMEOUT;

    setState(() {
      serverURLController =  TextEditingController(text: serverURL);
      webSocketServerURLController =  TextEditingController(text: chatServerURL);
      imageServerURLController =  TextEditingController(text: imageServerURL);
      timeoutController =  TextEditingController(text: timeout.toString());
    });

    serverURLController.addListener((){
      var serverIpOrName = _getServerIpOrName(serverURLController.text.trim());

      /// chat server
      var serverUrl = webSocketServerURLController.text;
      var startIndex = serverUrl.indexOf("//") + 2;
      if(startIndex < 2)
        startIndex = 0;

      var endIndex = serverUrl.lastIndexOf(":");
      if (endIndex < startIndex)
        endIndex = serverUrl?.length;

      var newServerUrl = serverUrl.substring(0, startIndex) +
          serverIpOrName + serverUrl.substring(endIndex, serverUrl?.length);
      setState(() {
        webSocketServerURLController.text = newServerUrl;
      });

      /// images server
      serverUrl = imageServerURLController.text;
      startIndex = serverUrl.indexOf("//") + 2;
      if(startIndex < 2)
        startIndex = 0;

      endIndex = serverUrl.lastIndexOf(":");
      if (endIndex < startIndex)
        endIndex = serverUrl?.length;

      newServerUrl = serverUrl.substring(0, startIndex) +
          serverIpOrName + serverUrl.substring(endIndex, serverUrl?.length);
      setState(() {
        imageServerURLController.text = newServerUrl;
      });
    });
  }


  @override
  void initState() {
    _init();
    super.initState();
  }

  static String _getServerIpOrName(String serverUrl) {
    var startIndex = serverUrl.indexOf("//") + 2;
    if(startIndex < 2)
      startIndex = 0;

    var endIndex = serverUrl.lastIndexOf(":");
    if (endIndex < startIndex)
      endIndex = serverUrl?.length;

    return  serverUrl.substring(startIndex, endIndex);
  }
  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: InkWell(
        onLongPress: () {
          if (serverURLController.text == Server.DEFAULT_SERVER_URL_RELEASE_MODE) {
            serverURLController.text = Server.DEFAULT_SERVER_URL_DEBUG_MODE;
            webSocketServerURLController.text = Server.DEFAULT_WS_SERVER_URL_DEBUG_MODE;
            imageServerURLController.text = Server.DEFAULT_IMAGE_SERVER_URL_DEBUG_MODE;
          } else {
            serverURLController.text = Server.DEFAULT_SERVER_URL_RELEASE_MODE;
            webSocketServerURLController.text = Server.DEFAULT_WS_SERVER_URL_RELEASE_MODE;
            imageServerURLController.text = Server.DEFAULT_IMAGE_SERVER_URL_RELEASE_MODE;
          }
        },
        child: SText(L10n.of(context).serverConfig)
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            STextFormField(
              controller: serverURLController,
              decoration: InputDecoration(
                  labelText: L10n.of(context).serverConnectionStringDesc
              ),
            ),
            STextFormField(
              controller: webSocketServerURLController,
              decoration: InputDecoration(
                  labelText: L10n.of(context).chatServerConnectionStringDesc
              ),
            ),
            STextFormField(
              controller: imageServerURLController,
              decoration: InputDecoration(
                  labelText: L10n.of(context).imageServerConnectionStringDesc
              ),
            ),
            SNumberFormField(
              controller: timeoutController,
              decoration: InputDecoration(
                  labelText: L10n.of(context).connectionTimeout
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        SCloseButton(),

        SSaveButton(
          onTap: () async {

            serverURL = serverURLController.text.trim();
            chatServerURL = webSocketServerURLController.text.trim();
            imageServerURL = imageServerURLController.text.trim();
            timeout = int.parse(timeoutController.text.trim());

            GlobalParam.SERVER_URL = serverURL;
            GlobalParam.BASE_API_URL = '$serverURL/api/';
            GlobalParam.CONNECTION_TIMEOUT = timeout;
            GlobalParam.CHAT_SERVER_URL = chatServerURL;
            GlobalParam.IMAGE_SERVER_URL = imageServerURL;

            await prefs.setString(PrefsKey.serverURL.toString(), serverURL);
            await prefs.setString(PrefsKey.chatServerURL.toString(), chatServerURL);
            await prefs.setString(PrefsKey.imageServerURL.toString(), imageServerURL);
            await prefs.setInt(PrefsKey.connectionTimeout.toString(), timeout);
            Navigator.of(context).pop();
          },
        ),

      ],
    );
  }
}
