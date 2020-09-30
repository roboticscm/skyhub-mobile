import 'package:flutter/material.dart';

class SContainer extends Container {
  SContainer({
    Key key,
    alignment,
    padding = const EdgeInsets.all(10),
    color,
    decoration,
    foregroundDecoration,
    width,
    height,
    constraints,
    margin,
    transform,
    child,
  }): super(
    key: key,
    alignment: alignment,
    padding: padding,
    color: color,
    decoration: decoration,
    foregroundDecoration: foregroundDecoration,
    width: width,
    height: height,
    constraints: constraints,
    margin: margin,
    transform: transform,
    child: child,
  );

}