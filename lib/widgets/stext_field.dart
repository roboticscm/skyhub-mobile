import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class STextField extends TextField {
  STextField({
    key,
    controller,
    focusNode,
    decoration = const InputDecoration(hintText: 'Hint text here'),
    keyboardType,
    textInputAction,
    textCapitalization = TextCapitalization.none,
    style,
    textAlign = TextAlign.start,
    textDirection,
    autofocus = false,
    obscureText = false,
    autocorrect = true,
    maxLines = 1,
    maxLength,
    maxLengthEnforced = true,
    onChanged,
    onEditingComplete,
    onSubmitted,
    inputFormatters,
    enabled,
    cursorWidth = 2.0,
    cursorRadius,
    cursorColor,
    keyboardAppearance,
    scrollPadding = const EdgeInsets.all(20.0),
    dragStartBehavior = DragStartBehavior.down,
    enableInteractiveSelection = true,
    onTap,
    buildCounter
  }) : super(
      key: key,
      controller: controller,
      focusNode: focusNode,
      decoration: decoration,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      style: style,
      textAlign: textAlign,
      textDirection: textDirection,
      autofocus: autofocus,
      obscureText: obscureText,
      autocorrect: autocorrect,
      maxLines: maxLines,
      maxLength: maxLength,
      maxLengthEnforced: maxLengthEnforced,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      inputFormatters: inputFormatters,
      enabled: enabled,
      cursorWidth: cursorWidth,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      keyboardAppearance: keyboardAppearance,
      scrollPadding: scrollPadding,
      dragStartBehavior: dragStartBehavior,
      enableInteractiveSelection: enableInteractiveSelection,
      onTap: onTap,
      buildCounter: buildCounter);
}