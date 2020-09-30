import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/widgets/stext.dart';


class EventUI extends StatefulWidget {
  EventUI({
    Key key,
  }) : super(key: key);

  @override
  State<EventUI> createState() {
    GlobalParam.eventUIState = EventUIState();
    return GlobalParam.eventUIState;
  }
}

class EventUIState extends State<EventUI> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return _buildRecentChatList();
  }

  Widget _buildRecentChatList() {
    return Scaffold(
        backgroundColor: STextStyle.BACKGROUND_COLOR,
        appBar: _buildAppBar(L10n.of(context).event,  0,),
        body: Text('EVENT')
    );
  }
  Widget _buildAppBar(String text, int numberOfNotifications) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(children: <Widget>[
        IconButton(
          icon: SvgPicture.asset('assets/event.svg', color: STextStyle.PRIMARY_TEXT_COLOR),
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
          icon: SvgPicture.asset('assets/filter.svg', color: STextStyle.ACTIVE_BOTTOM_BAR_COLOR, semanticsLabel: L10n.of(context).event),
          onPressed: (){

          },
        ),

      ],
    );
  }


}
