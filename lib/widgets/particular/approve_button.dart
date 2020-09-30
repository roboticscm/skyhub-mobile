import 'package:flutter/material.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/widgets/sdialog.dart';

import 'constants.dart';

class ApproveButton extends StatefulWidget {
  final Function() onTap;
  final String Function() onAskMessage;
  final Color color;
   ApproveButton({this.onTap, this.color, this.onAskMessage,});

  @override
  _ApproveButtonState createState() => _ApproveButtonState();
}

class _ApproveButtonState extends State<ApproveButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if ( widget.onAskMessage!=null) {
          SDialog.confirm(L10n.ofValue().approve, widget.onAskMessage()).then((value){
            if (value == DialogButton.yes) {
              widget.onTap();

            }
          });
        } else {
          widget.onTap();

        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: BUTTON_PADDING, right: BUTTON_PADDING),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon( Icons.check, color: widget.color),
            Text( L10n.ofValue().approve, style: TextStyle(color: widget.color),)
          ],
        ),
      ),
    );
  }
}