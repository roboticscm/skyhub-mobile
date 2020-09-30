import 'package:flutter/material.dart';
import 'package:mobile/style/text_style.dart';

class SGradientButton extends StatelessWidget {
  final Key key;
  final VoidCallback onPressed;
  final String text;
  SGradientButton({this.key, @required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
          colors: <Color>[
            STextStyle.GRADIENT_COLOR1,
            STextStyle.GRADIENT_COLOR2,
          ],
        ),
      ),
      child: FlatButton(
        child: Text(text, style: TextStyle(color: STextStyle.LIGHT_TEXT_COLOR)),
        onPressed: onPressed,
      ),
    );
  }
}