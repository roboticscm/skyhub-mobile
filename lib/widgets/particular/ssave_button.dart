import 'package:flutter/material.dart';
import 'package:mobile/locale/locales.dart';

import '../scircular_progress_indicator.dart';
import 'constants.dart';

class SSaveButton extends StatefulWidget {
  final Function() onTap;
  final Color color;
  final bool isToggle;
  bool isSaveMode;
  final Stream<bool> progressStream;
  SSaveButton({this.onTap, this.color, this.isSaveMode = true, this.isToggle = false, this.progressStream});

  @override
  _SSaveButtonState createState() => _SSaveButtonState();
}

class _SSaveButtonState extends State<SSaveButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap();
        if(widget.isToggle) {
          setState(() {
            widget.isSaveMode = !widget.isSaveMode;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: BUTTON_PADDING, right: BUTTON_PADDING),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.save, color: widget.color),
                StreamBuilder<bool>(
                  stream: widget.progressStream,
                  initialData: false,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data == true)
                      return LimitedBox(maxWidth: 20, child: SCircularProgressIndicator.buildSmallest());
                    else
                      return SizedBox(width: 1,);
                  }
                ),
              ],
            ),
            Text(widget.isSaveMode ? L10n.ofValue().save : L10n.ofValue().update, style: TextStyle(color: widget.color),)
          ],
        ),
      ),
    );
  }
}