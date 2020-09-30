import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/locale/locales.dart';

import 'constants.dart';

class SSelectButton extends StatelessWidget {
  final Function() onTap;
  SSelectButton({this.onTap});

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
            Icon(FontAwesomeIcons.check),
            Text(L10n.ofValue().select,)
          ],
        ),
      ),
    );
  }
}