import 'package:flutter/material.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/widgets/sdialog.dart';

import 'constants.dart';

class CancelSubmitButton extends StatefulWidget {
  final Function() onTap;
  final String Function() onAskMessage;
  final Color color;
  CancelSubmitButton({this.onTap, this.color, this.onAskMessage});

  @override
  _CancelSubmitButtonState createState() => _CancelSubmitButtonState();
}

class _CancelSubmitButtonState extends State<CancelSubmitButton> {


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if ( widget.onAskMessage!=null) {
          SDialog.confirm(L10n.ofValue().cancelSubmit, widget.onAskMessage()).then((value){
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
            Icon(Icons.arrow_downward, color: widget.color),
            Text(L10n.ofValue().cancelSubmit , style: TextStyle(color: widget.color),)
          ],
        ),
      ),
    );
  }
}