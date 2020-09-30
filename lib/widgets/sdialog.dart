import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/widgets/particular/sclose_button.dart';
import 'package:mobile/widgets/shtml.dart';
import 'package:mobile/widgets/stext.dart';

enum DialogButton {
  yes, no
}
class StatefulDialog extends StatefulWidget {
  final String message;
  final String messageDetails;
  StatefulDialog({this.message, this.messageDetails});
  @override
  _StatefulDialogState createState() => _StatefulDialogState();
}

class _StatefulDialogState extends State<StatefulDialog> {
  String _buttonTitle;
  bool _showMore = false;

  @override
  void initState() {
    super.initState();
    _buttonTitle = L10n.ofValue().showMore;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SHtml(data: widget.message),
        InkWell(
          child: Text(_buttonTitle, style: TextStyle(color: Colors.blue),),
          onTap: () {
            if (_showMore)
              _buttonTitle = L10n.ofValue().showMore;
            else
              _buttonTitle = L10n.ofValue().showLess;
            setState(() {

            });

            _showMore = !_showMore;
          },
        ),
        if (_showMore)
        SHtml(
          data: widget.messageDetails,
          defaultTextStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey
          ),
        ),
      ],
    );
  }
}

class SDialog extends StatelessWidget {
  static Future<DialogButton> confirm(String title, String message, {bool barrierDismissible = true}) async {
    return showDialog(
      builder: (context) => AlertDialog(
        title: SText(title),
        content: SizedBox(
          height: 80,
          child: SingleChildScrollView(child: SHtml(data: message))
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(L10n.ofValue().yes, style: TextStyle(fontWeight: FontWeight.bold),),
            onPressed: () {
              Navigator.of(context).pop(DialogButton.yes);
            },
          ),
          FlatButton(
            child: Text(L10n.ofValue().no),
            onPressed: () {
              Navigator.of(context).pop(DialogButton.no);
            },
          ),
        ],
      ),
      context: GlobalParam.appContext,
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<void> alert(String title, String message, {bool barrierDismissible = true}) async {
    showDialog(
      builder: (context) => AlertDialog(
        title: SText(title),
        content: SizedBox(
            height: 80,
            child: SingleChildScrollView(child: SHtml(data: message))
        ),
        actions: <Widget>[
          SCloseButton(),
        ],
      ),
      context: GlobalParam.appContext,
      barrierDismissible: barrierDismissible,
    );
  }

  static void lessMoreAlert(String title, String message, String messageDetails, {bool barrierDismissible = true}) {
    showDialog(
      builder: (context) => AlertDialog(
        title: SText(title),
        content: SizedBox(
            height: 100,
            child: SingleChildScrollView(
              child: StatefulDialog(message: message, messageDetails: messageDetails,)
            )
        ),
        actions: <Widget>[
          SCloseButton(),
        ],
      ),
      context: GlobalParam.appContext,
      barrierDismissible: barrierDismissible,
    );
  }



  static void customAlert(String title, Widget content, { bool barrierDismissible = true}) {
    showDialog(
      builder: (context) => SDialog(
        title: SText(title),
        content: content,
        contentPadding: EdgeInsets.all(10),
        actions: <Widget>[
          SCloseButton(),
        ],
      ),
      context: GlobalParam.appContext,
      barrierDismissible: barrierDismissible,
    );
  }

  const SDialog({
    Key key,
    this.title,
    this.titlePadding,
    this.content,
    this.contentPadding = const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
    this.actions,
    this.semanticLabel,
  }) : assert(contentPadding != null),
        super(key: key);

  final Widget title;
  final EdgeInsetsGeometry titlePadding;
  final Widget content;
  final EdgeInsetsGeometry contentPadding;
  final List<Widget> actions;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    String label = semanticLabel;

    if (title != null) {
      children.add(new Padding(
        padding: titlePadding ?? new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, content == null ? 10.0 : 0.0),
        child: new DefaultTextStyle(
          style: Theme.of(context).textTheme.title,
          child: new Semantics(child: title, namesRoute: true),
        ),
      ));
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
          label = semanticLabel;
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          label = semanticLabel ?? MaterialLocalizations.of(context)?.alertDialogLabel;
      }
    }

    if (content != null) {
      children.add(new Flexible(
        child: new Padding(
          padding: contentPadding,
          child: new DefaultTextStyle(
            style: Theme.of(context).textTheme.subhead,
            child: content,
          ),
        ),
      ));
    }

    if (actions != null) {
      children.add(new ButtonTheme.bar(
        child: new ButtonBar(
          children: actions,
        ),
      ));
    }

    Widget dialogChild = new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );

    if (label != null)
      dialogChild = new Semantics(
          namesRoute: true,
          label: label,
          child: dialogChild
      );

    return Dialog(child: dialogChild);
  }
}

class Dialog extends StatelessWidget {
  /// Creates a dialog.
  ///
  /// Typically used in conjunction with [showDialog].
  const Dialog({
    Key key,
    this.backgroundColor,
    this.elevation,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.shape,
    this.child,
  }) : super(key: key);

  /// {@template flutter.material.dialog.backgroundColor}
  /// The background color of the surface of this [Dialog].
  ///
  /// This sets the [Material.color] on this [Dialog]'s [Material].
  ///
  /// If `null`, [ThemeData.cardColor] is used.
  /// {@endtemplate}
  final Color backgroundColor;

  /// {@template flutter.material.dialog.elevation}
  /// The z-coordinate of this [Dialog].
  ///
  /// If null then [DialogTheme.elevation] is used, and if that's null then the
  /// dialog's elevation is 24.0.
  /// {@endtemplate}
  /// {@macro flutter.material.material.elevation}
  final double elevation;

  /// The duration of the animation to show when the system keyboard intrudes
  /// into the space that the dialog is placed in.
  ///
  /// Defaults to 100 milliseconds.
  final Duration insetAnimationDuration;

  /// The curve to use for the animation shown when the system keyboard intrudes
  /// into the space that the dialog is placed in.
  ///
  /// Defaults to [Curves.fastOutSlowIn].
  final Curve insetAnimationCurve;

  /// {@template flutter.material.dialog.shape}
  /// The shape of this dialog's border.
  ///
  /// Defines the dialog's [Material.shape].
  ///
  /// The default shape is a [RoundedRectangleBorder] with a radius of 2.0.
  /// {@endtemplate}
  final ShapeBorder shape;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  // TODO(johnsonmh): Update default dialog border radius to 4.0 to match material spec.
  static const RoundedRectangleBorder _defaultDialogShape =
  RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0)));
  static const double _defaultElevation = 24.0;

  @override
  Widget build(BuildContext context) {
    final DialogTheme dialogTheme = DialogTheme.of(context);
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets + const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 280.0),
            child: Material(
              color: backgroundColor ?? dialogTheme.backgroundColor ?? Theme.of(context).dialogBackgroundColor,
              elevation: elevation ?? dialogTheme.elevation ?? _defaultElevation,
              shape: shape ?? dialogTheme.shape ?? _defaultDialogShape,
              type: MaterialType.card,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}