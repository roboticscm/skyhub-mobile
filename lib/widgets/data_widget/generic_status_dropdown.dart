import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/common/tuple.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/style/text_style.dart';

class GenericStatusDropdown extends StatefulWidget {
  static const int STATUS_ALL = -2;
  static const int STATUS_NEW = 1;
  static const int STATUS_REJECT = 2;
  static const int STATUS_WAITING = 3;
  static const int STATUS_SUBMIT = 4;
  static const int STATUS_MANAGER = 5;
  static const int STATUS_APPROVED = 6;
  static const int STATUS_FOLLOW_UP = 7;
  static const int STATUS_SOLD = 8;
  static const int STATUS_CANCEL = 9;
  static const int STATUS_TIMEOUT = 10;
  static const int STATUS_FAILED = -1;

  final Function(String) onChanged;
  final bool showAllItem;
  String selectedId;
  final TextStyle style;
  GenericStatusDropdown({this.style , this.onChanged, this.selectedId, this.showAllItem = true});

  @override
  _GenericStatusDropdownState createState() => _GenericStatusDropdownState();

  static String getStatusName(int status) {
    switch(status) {
      case GenericStatusDropdown.STATUS_NEW:
        return L10n.ofValue().newStatus;
      case GenericStatusDropdown.STATUS_REJECT:
        return L10n.ofValue().rejectStatus;
      case GenericStatusDropdown.STATUS_WAITING:
        return L10n.ofValue().waitingStatus;
      case GenericStatusDropdown.STATUS_SUBMIT:
        return L10n.ofValue().submitStatus;
      case GenericStatusDropdown.STATUS_MANAGER:
        return L10n.ofValue().submitStatus;
      case GenericStatusDropdown.STATUS_FOLLOW_UP:
        return L10n.ofValue().followUpStatus;
      case GenericStatusDropdown.STATUS_SOLD:
        return L10n.ofValue().soldStatus;
      case GenericStatusDropdown.STATUS_CANCEL:
        return L10n.ofValue().cancelStatus;
      case GenericStatusDropdown.STATUS_TIMEOUT:
        return L10n.ofValue().timeoutStatus;
      case GenericStatusDropdown.STATUS_FAILED:
        return L10n.ofValue().failedStatus;
      case GenericStatusDropdown.STATUS_APPROVED:
        return L10n.ofValue().submitStatus;
    }
    return status.toString();
  }

  static Color getStatusColor(int status) {
    switch(status) {
      case GenericStatusDropdown.STATUS_NEW:
        return Colors.green;
      case GenericStatusDropdown.STATUS_REJECT:
        return Colors.grey;
      case GenericStatusDropdown.STATUS_WAITING:
        return Colors.red;
      case GenericStatusDropdown.STATUS_SUBMIT:
        return Colors.orange;
      case GenericStatusDropdown.STATUS_MANAGER:
        return STextStyle.GRADIENT_COLOR1;
      case GenericStatusDropdown.STATUS_FOLLOW_UP:
        return Colors.orange;
      case GenericStatusDropdown.STATUS_SOLD:
        return Colors.green;
      case GenericStatusDropdown.STATUS_CANCEL:
        return Colors.red;
      case GenericStatusDropdown.STATUS_TIMEOUT:
        return Colors.grey;
      case GenericStatusDropdown.STATUS_FAILED:
        return Colors.red;
      case GenericStatusDropdown.STATUS_APPROVED:
        return Colors.blue;
    }
    return Colors.black;
  }

  static Icon getStatusIcon(int status, double size) {
    switch(status) {
      case GenericStatusDropdown.STATUS_NEW:
        return Icon(Icons.new_releases, color: getStatusColor(status), size: size,);
      case GenericStatusDropdown.STATUS_REJECT:
        return Icon(Icons.arrow_back, color: getStatusColor(status), size: size);
      case GenericStatusDropdown.STATUS_WAITING:
        return Icon(Icons.hourglass_empty, color: getStatusColor(status), size: size);
//      case GenericStatusDropdown.STATUS_SUBMIT:
//        return Icon(Icons.arrow_upward, color: getStatusColor(status), size: size);
//      case GenericStatusDropdown.STATUS_MANAGER:
//        return Icon(FontAwesomeIcons.userPlus, color: getStatusColor(status), size: size);
      case GenericStatusDropdown.STATUS_FOLLOW_UP:
        return Icon(Icons.directions_run, color: getStatusColor(status), size: size);
      case GenericStatusDropdown.STATUS_SOLD:
        return Icon(FontAwesomeIcons.handHoldingHeart, color: getStatusColor(status), size: size);
      case GenericStatusDropdown.STATUS_CANCEL:
        return Icon(Icons.cancel, color: getStatusColor(status), size: size);
      case GenericStatusDropdown.STATUS_TIMEOUT:
        return Icon(FontAwesomeIcons.bellSlash, color: getStatusColor(status), size: size);
      case GenericStatusDropdown.STATUS_FAILED:
        return Icon(FontAwesomeIcons.exclamationTriangle, color: getStatusColor(status), size: size);
      case GenericStatusDropdown.STATUS_APPROVED:
      case GenericStatusDropdown.STATUS_MANAGER:
      case GenericStatusDropdown.STATUS_SUBMIT:
        return Icon(Icons.check, color: getStatusColor(status), size: size);
    }
    return Icon(Icons.android, size: size);
  }
}

class _GenericStatusDropdownState extends State<GenericStatusDropdown> {
  @override
  Widget build(BuildContext context) {
    List<Tuple2<List<int>, String>> list = [];

    if (widget.showAllItem)
      list.add(Tuple2(null, '${L10n.ofValue().status}: ${L10n.ofValue().all}'));

    list.add(Tuple2([
      GenericStatusDropdown.STATUS_NEW,
      GenericStatusDropdown.STATUS_REJECT,
      GenericStatusDropdown.STATUS_WAITING,
      GenericStatusDropdown.STATUS_SUBMIT,
      GenericStatusDropdown.STATUS_MANAGER,
      GenericStatusDropdown.STATUS_FOLLOW_UP,
      GenericStatusDropdown.STATUS_APPROVED,
      GenericStatusDropdown.STATUS_SOLD
      ], '${L10n.ofValue().allValid}'));

    list.add(Tuple2([GenericStatusDropdown.STATUS_NEW, GenericStatusDropdown.STATUS_WAITING], '${L10n.ofValue().newOrWaitingStatus}'));

    list.add(Tuple2([GenericStatusDropdown.STATUS_NEW], '${L10n.ofValue().newStatus}'));
    list.add(Tuple2([GenericStatusDropdown.STATUS_REJECT], '${L10n.ofValue().rejectStatus}'));
    list.add(Tuple2([GenericStatusDropdown.STATUS_WAITING], '${L10n.ofValue().waitingStatus}'));
    list.add(Tuple2([GenericStatusDropdown.STATUS_SUBMIT], '${L10n.ofValue().submitStatus}'));
    list.add(Tuple2([GenericStatusDropdown.STATUS_MANAGER], '${L10n.ofValue().managerStatus}'));
    list.add(Tuple2([GenericStatusDropdown.STATUS_FOLLOW_UP], '${L10n.ofValue().followUpStatus}'));
    list.add(Tuple2([GenericStatusDropdown.STATUS_APPROVED], '${L10n.ofValue().approvedStatus}'));
    list.add(Tuple2([GenericStatusDropdown.STATUS_SOLD], '${L10n.ofValue().soldStatus}'));
    list.add(Tuple2([GenericStatusDropdown.STATUS_CANCEL], '${L10n.ofValue().cancelStatus}'));
    list.add(Tuple2([GenericStatusDropdown.STATUS_TIMEOUT], '${L10n.ofValue().timeoutStatus}'));
    list.add(Tuple2([GenericStatusDropdown.STATUS_FAILED], '${L10n.ofValue().failedStatus}'));

    return DropdownButton<String>(
        style: widget.style != null ? widget.style : null,
        onChanged: (value) {
          widget.onChanged(value);
          widget.selectedId = value;
          if(mounted)
            setState(() {
            });
        },
        value: widget.selectedId,
        items: list.map((tuple2){
          return DropdownMenuItem<String>(
            child: Text(tuple2.item2),
            value: tuple2.item1 == null ? null : tuple2.item1.join(","),
          );
        }).toList()
    );
  }
}
