import 'package:flutter/material.dart';
import 'package:mobile/locale/locales.dart';

import 'constants.dart';

class SCloseButton extends StatelessWidget {
  final Function() onTap;
  final Color color;
  SCloseButton({this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap!= null)
          onTap();
        else
          Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.only(left: BUTTON_PADDING, right: BUTTON_PADDING),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.close, color: color),
            SizedBox(height: 5,),
            Text(L10n.ofValue().close, style: TextStyle(color: color),)
          ],
        ),
      ),
    );
  }

}