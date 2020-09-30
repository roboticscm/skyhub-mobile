import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/locale/locales.dart';

import 'constants.dart';

class RequestInventoryOutButtonAddNew extends StatelessWidget {
  final Function() onTap;
  RequestInventoryOutButtonAddNew({this.onTap});

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
            Icon(FontAwesomeIcons.fileExport, color: Colors.white,),
            SizedBox(height: 5,),
            Text(L10n.ofValue().reqInventoryOutAddNew, style: TextStyle(color: Colors.white),)
          ],
        ),
      ),
    );
  }
}