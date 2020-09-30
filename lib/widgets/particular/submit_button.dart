import 'package:flutter/material.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/widgets/sdialog.dart';

import 'constants.dart';

class SubmitButton extends StatefulWidget {
  final Function() onTap;
  final String Function() onAskMessage;
  final Color color;
  SubmitButton({this.onTap, this.color, this.onAskMessage});

  @override
  _SubmitButtonState createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if ( widget.onAskMessage!=null) {
          SDialog.confirm(L10n.ofValue().submit, widget.onAskMessage()).then((value){
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
            Icon(Icons.arrow_upward, color: widget.color),
            Text(L10n.ofValue().submit , style: TextStyle(color: widget.color))
          ],
        ),
      ),
    );
  }
}