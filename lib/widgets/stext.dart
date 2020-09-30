import 'package:flutter/material.dart';

class SText extends Text {
  SText(String data, {
    Key key,
    style,
    strutStyle,
    textAlign,
    textDirection,
    locale,
    softWrap,
    overflow = TextOverflow.ellipsis,
    textScaleFactor,
    maxLines = 1,
    semanticsLabel
  }) : super(data,
      style: style,
      key: key,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel
  );
}