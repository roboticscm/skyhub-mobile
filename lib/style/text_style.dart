import 'package:flutter/material.dart';
import 'package:mobile/common/common.dart';

class STextStyle {
  static TextStyle biggerTextStyle(){
    return TextStyle(
      fontSize: GlobalParam.BIGGER_FONT_SIZE
    );
  }

  static TextStyle defaultTextStyle(){
    return TextStyle(
      fontSize: GlobalParam.DEFAULT_FONT_SIZE
    );
  }

  static TextStyle smallerTextStyle(){
    return TextStyle(
      fontSize: GlobalParam.SMALLER_FONT_SIZE
    );
  }

  static TextStyle italicTextStyle(){
    return TextStyle(
      fontStyle: FontStyle.italic
    );
  }

  static TextStyle boldTextStyle(){
    return TextStyle(
      fontWeight: FontWeight.bold
    );
  }

  static TextStyle blurTextStyle(){
    return TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: GlobalParam.SMALLER_FONT_SIZE,
      color: Colors.black54
    );
  }
  static BoxDecoration appBarDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          STextStyle.GRADIENT_COLOR1,
          STextStyle.GRADIENT_COLOR2,
        ],
      ),
    );
  }

  static const Color GRADIENT_COLOR_AlPHA = Color.fromRGBO(172, 84, 87, 1);
  static const Color PRIMARY_COLOR = Color.fromRGBO(202, 15, 66, 1);
  static const Color GRADIENT_COLOR1 = Color.fromRGBO(146, 0, 4, 1);
  static const Color GRADIENT_COLOR2 = Color.fromRGBO(146, 0, 4, 1);
  static const Color GRADIENT_COLOR3 = Color.fromRGBO(147, 0, 4, 1);
  static const Color BOTTOM_BAR_COLOR = Color.fromRGBO(255, 255, 255, 1);
  static const Color ACTIVE_BOTTOM_BAR_COLOR = Color.fromRGBO(0, 0, 0, 1);
  static const Color SECOND_TEXT_COLOR = Color.fromRGBO(255, 255, 255, 1);
  static const Color PRIMARY_TEXT_COLOR = Color.fromRGBO(0, 0, 0, 1);
  static const Color TASK_BAR_COLOR = Color.fromRGBO(146, 0, 4, 1);
  static const Color BACKGROUND_COLOR = Colors.white;
  static const Color LIST_BACKGROUND_COLOR = Colors.white70;
  static const Color SENDER_BACKGROUND_COLOR = Color.fromRGBO(245, 225, 215, 1);
  static const Color RECEIVER_BACKGROUND_COLOR = Colors.white;
  static const Color HOT_COLOR = Colors.red;
  static const Color LIGHT_TEXT_COLOR = Colors.white;
  static const Color NOTIFICATION_BACKGROUND_COLOR = Colors.pink;
}