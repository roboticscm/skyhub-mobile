import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SSingleChildScrollView extends SingleChildScrollView {
  SSingleChildScrollView({
    Key key,
    scrollDirection = Axis.vertical,
    reverse = false,
    padding = const EdgeInsets.all(10),
    primary,
    physics,
    controller,
    child,
    dragStartBehavior = DragStartBehavior.down
  }) : super(
      key: key,
      scrollDirection: scrollDirection,
      reverse: reverse,
      padding: padding,
      primary: primary,
      physics: physics,
      controller: controller,
      child: child,
      dragStartBehavior: dragStartBehavior
  );
}