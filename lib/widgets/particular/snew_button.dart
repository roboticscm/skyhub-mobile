import 'package:flutter/material.dart';
import 'package:mobile/locale/locales.dart';

import 'constants.dart';

class SNewButton extends StatelessWidget {
  final Function() onTap;
  SNewButton({this.onTap});

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
            Icon(Icons.new_releases),
            Text(L10n.ofValue().addNew,)
          ],
        ),
      ),
    );
  }
}