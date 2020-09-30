import 'package:flutter/material.dart';
import 'package:mobile/widgets/stext.dart';

class SubAppBar extends PreferredSize{
  final String text;
  final int numberOfNotifications;

  SubAppBar({this.text, this.numberOfNotifications});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(children: <Widget>[
        if (text != null)
          SText(text),
        if (numberOfNotifications != null && numberOfNotifications > 0)
          Container(
            child: SText(numberOfNotifications.toString())
          )
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: ClipOval(
            child: Image.asset('assets/filter.png' ,
              fit: BoxFit.fill,
              width: 30,
              height: 30,
            ),
          ),
          onPressed: (){

          },
        ),

      ],
    );
  }
}