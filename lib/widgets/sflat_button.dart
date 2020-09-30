import 'package:flutter/material.dart';

class SFlatButton extends FlatButton {
  SFlatButton({
    Key key,
    @required VoidCallback onPressed,
    ValueChanged<bool> onHighlightChanged,
    ButtonTextTheme textTheme,
    Color textColor,
    Color disabledTextColor,
    Color color,
    Color disabledColor,
    Color highlightColor,
    Color splashColor,
    Brightness colorBrightness,
    EdgeInsetsGeometry padding,
    ShapeBorder shape,
    Clip clipBehavior = Clip.none,
    MaterialTapTargetSize materialTapTargetSize,
    @required Widget child,
  }) : super(
    key: key,
    onPressed: onPressed,
    onHighlightChanged: onHighlightChanged,
    textTheme: textTheme,
    textColor: textColor,
    disabledTextColor: disabledTextColor,
    color: color,
    disabledColor: disabledColor,
    highlightColor: highlightColor,
    splashColor: splashColor,
    colorBrightness: colorBrightness,
    padding: padding,
    shape: shape,
    clipBehavior: clipBehavior,
    materialTapTargetSize: materialTapTargetSize,
    child: child,
  );
}