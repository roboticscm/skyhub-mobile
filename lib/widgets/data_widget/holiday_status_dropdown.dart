import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/common/tuple.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/style/text_style.dart';

class HolidayStatusDropdown extends StatefulWidget {
  static const int STATUS_NEW = 1;
  static const int STATUS_REJECT = 2;
  static const int STATUS_WAITING = 3;
  static const int STATUS_SUBMIT = 4;
  static const int STATUS_MANAGER = 5;
  static const int STATUS_APPROVED = 6;
  static const int STATUS_CANCEL = -1;
  final Function(String) onChanged;
  final bool showAllItem;
  String selectedId;
  final TextStyle style;
  HolidayStatusDropdown({this.style , this.onChanged, this.selectedId, this.showAllItem = true});

  @override
  _HolidayStatusDropdownState createState() => _HolidayStatusDropdownState();

  static String getStatusName(int status) {
    switch(status) {
      case HolidayStatusDropdown.STATUS_NEW:
        return L10n.ofValue().newStatus;
      case HolidayStatusDropdown.STATUS_REJECT:
        return L10n.ofValue().rejectStatus;
      case HolidayStatusDropdown.STATUS_WAITING:
        return L10n.ofValue().waitingStatus;
      case HolidayStatusDropdown.STATUS_SUBMIT:
        return L10n.ofValue().submitStatus;
      case HolidayStatusDropdown.STATUS_MANAGER:
        return L10n.ofValue().submitStatus;
      case HolidayStatusDropdown.STATUS_CANCEL:
        return L10n.ofValue().cancelStatus;
      case HolidayStatusDropdown.STATUS_APPROVED:
        return L10n.ofValue().submitStatus;
    }
    return status.toString();
  }

  static Color getStatusColor(int status) {
    switch(status) {
      case HolidayStatusDropdown.STATUS_NEW:
        return Colors.green;
      case HolidayStatusDropdown.STATUS_REJECT:
        return Colors.grey;
      case HolidayStatusDropdown.STATUS_WAITING:
        return Colors.red;
      case HolidayStatusDropdown.STATUS_SUBMIT:
        return Colors.orange;
      case HolidayStatusDropdown.STATUS_MANAGER:
        return STextStyle.GRADIENT_COLOR1;
      case HolidayStatusDropdown.STATUS_CANCEL:
        return Colors.red;
      case HolidayStatusDropdown.STATUS_APPROVED:
        return Colors.blue;
    }
    return Colors.black;
  }

  static Icon getStatusIcon(int status, double size) {
    switch(status) {
      case HolidayStatusDropdown.STATUS_NEW:
        return Icon(Icons.new_releases, color: getStatusColor(status), size: size,);
      case HolidayStatusDropdown.STATUS_REJECT:
        return Icon(Icons.arrow_back, color: getStatusColor(status), size: size);
      case HolidayStatusDropdown.STATUS_WAITING:
        return Icon(Icons.hourglass_empty, color: getStatusColor(status), size: size);
//      case HolidayStatusDropdown.STATUS_SUBMIT:
//        return Icon(Icons.arrow_upward, color: getStatusColor(status), size: size);
//      case HolidayStatusDropdown.STATUS_MANAGER:
//        return Icon(FontAwesomeIcons.userPlus, color: getStatusColor(status), size: size);
      case HolidayStatusDropdown.STATUS_CANCEL:
        return Icon(Icons.cancel, color: getStatusColor(status), size: size);
      case HolidayStatusDropdown.STATUS_APPROVED:
      case HolidayStatusDropdown.STATUS_MANAGER:
      case HolidayStatusDropdown.STATUS_SUBMIT:
        return Icon(Icons.check, color: getStatusColor(status), size: size);
    }
    return Icon(Icons.android, size: size);
  }
}

class _HolidayStatusDropdownState extends State<HolidayStatusDropdown> {
  @override
  Widget build(BuildContext context) {
    List<Tuple2<List<int>, String>> list = [];

    if (widget.showAllItem)
      list.add(Tuple2(null, '${L10n.ofValue().status}: ${L10n.ofValue().all}'));

    list.add(Tuple2([HolidayStatusDropdown.STATUS_NEW, HolidayStatusDropdown.STATUS_WAITING], '${L10n.ofValue().newOrWaitingStatus}'));

    list.add(Tuple2([HolidayStatusDropdown.STATUS_NEW], '${L10n.ofValue().newStatus}'));
    list.add(Tuple2([HolidayStatusDropdown.STATUS_REJECT], '${L10n.ofValue().rejectStatus}'));
    list.add(Tuple2([HolidayStatusDropdown.STATUS_WAITING], '${L10n.ofValue().waitingStatus}'));
    list.add(Tuple2([HolidayStatusDropdown.STATUS_SUBMIT], '${L10n.ofValue().submitStatus}'));
    list.add(Tuple2([HolidayStatusDropdown.STATUS_MANAGER], '${L10n.ofValue().managerStatus}'));
    list.add(Tuple2([HolidayStatusDropdown.STATUS_APPROVED], '${L10n.ofValue().approvedStatus}'));
    list.add(Tuple2([HolidayStatusDropdown.STATUS_CANCEL], '${L10n.ofValue().cancelStatus}'));

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
