import 'package:flutter/material.dart';
import 'package:mobile/locale/locales.dart';

import 'constants.dart';

class SDeleteButton extends StatelessWidget {
  final Function() onTap;
  SDeleteButton({this.onTap});

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
            Icon(Icons.delete, color: Colors.red,),
            Text(L10n.ofValue().delete, style: TextStyle(color: Colors.red),)
          ],
        ),
      ),
    );
  }
}