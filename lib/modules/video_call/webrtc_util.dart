import 'package:flutter_webrtc/webrtc.dart';

class WebRtcUtil {
  static Future<MediaStream> openLocalStream(bool isVideoCall, {int width=640, int height=360}) async {
    final Map<String, dynamic> mediaConstraints = {
      "audio": true,
      "video": isVideoCall == false ? false : {
        "mandatory": {
          "minWidth": width,
          "minHeight": height,
          "minFrameRate": '30',
        },
        "facingMode": "user",
        "optional": [],
      }
    };

    return await navigator.getUserMedia(mediaConstraints);
  }

  static playStream(MediaStream stream, RTCVideoRenderer render) {
    render.srcObject = stream;
  }
}