library flutter_html;

import 'package:flutter/material.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/image_properties.dart';
import 'package:mobile/widgets/rich_text_parser.dart';

class SHtml extends StatelessWidget {
  SHtml({
    Key key,
    @required this.data,
    this.padding,
    this.backgroundColor,
    this.defaultTextStyle,
    this.onLinkTap,
    this.renderNewlines = false,
    this.customRender,
    this.customEdgeInsets,
    this.customTextStyle,
    this.customTextAlign,
    this.blockSpacing = 14.0,
    this.useRichText = true,
    this.onImageError,
    this.linkStyle = const TextStyle(
        decoration: TextDecoration.underline,
        color: Colors.blueAccent,
        decorationColor: Colors.blueAccent),
    this.imageProperties,
    this.onImageTap,
    this.showImages = true,
    this.maxLines,
  }) : super(key: key);

  final String data;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final TextStyle defaultTextStyle;
  final OnLinkTap onLinkTap;
  final bool renderNewlines;
  final double blockSpacing;
  final bool useRichText;
  final ImageErrorListener onImageError;
  final TextStyle linkStyle;

  /// Properties for the Image widget that gets rendered by the rich text parser
  final ImageProperties imageProperties;
  final OnImageTap onImageTap;
  final bool showImages;

  /// Either return a custom widget for specific node types or return null to
  /// fallback to the default rendering.
  final CustomRender customRender;
  final CustomEdgeInsets customEdgeInsets;
  final CustomTextStyle customTextStyle;
  final CustomTextAlign customTextAlign;
  final int maxLines;
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
      padding: padding,
      color: backgroundColor,
      width: width,
      child: DefaultTextStyle.merge(
        style: defaultTextStyle ?? DefaultTextStyle.of(context).style,
        child: (useRichText)
            ? HtmlRichTextParser(
          width: width,
          onLinkTap: onLinkTap,
          renderNewlines: renderNewlines,
          customEdgeInsets: customEdgeInsets,
          customTextStyle: customTextStyle,
          customTextAlign: customTextAlign,
          html: data,
          onImageError: onImageError,
          linkStyle: linkStyle,
          imageProperties: imageProperties,
          onImageTap: onImageTap,
          showImages: showImages,
          maxLines: maxLines,
        )
            : HtmlOldParser(
          width: width,
          onLinkTap: onLinkTap,
          renderNewlines: renderNewlines,
          customRender: customRender,
          html: data,
          blockSpacing: blockSpacing,
          onImageError: onImageError,
          linkStyle: linkStyle,
          showImages: showImages,
        ),
      ),
    );
  }
}
