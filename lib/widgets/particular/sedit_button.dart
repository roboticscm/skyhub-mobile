import 'package:flutter/material.dart';
import 'package:mobile/locale/locales.dart';

import 'constants.dart';

class SEditButton extends StatelessWidget {
  final Function() onTap;
  final color;
  SEditButton({this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.only(left: BUTTON_PADDING, right: BUTTON_PADDING),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.edit, color: color,),
            Text(L10n.ofValue().edit, style: TextStyle(color: color),)
          ],
        ),
      ),
    );
  }
}