import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/common/tuple.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/system/loader/data.dart';
import 'package:mobile/system/loader/model.dart';

class ReqinvoutStatusDropdown extends StatefulWidget {
  static const int STATUS_NEW = 1;
  static const int STATUS_REJECT = 2;
  static const int STATUS_WAITING = 3;
  static const int STATUS_SUBMIT = 4;
  static const int STATUS_STOCKER = 5;
  static const int STATUS_APPROVED = 6;
  static const int STATUS_UNDONE = 7;
  static const int STATUS_DONE = 8;
  static const int STATUS_CANCELED = -1;

  final Function(String) onChanged;
  final bool showAllItem;
  String selectedId;
  final TextStyle style;
  ReqinvoutStatusDropdown({this.style , this.onChanged, this.selectedId, this.showAllItem = true});

  @override
  _ReqinvoutStatusDropdownState createState() => _ReqinvoutStatusDropdownState();

  static String getStatusName(int status) {
    switch(status) {
      case ReqinvoutStatusDropdown.STATUS_NEW:
        return L10n.ofValue().newStatus;
      case ReqinvoutStatusDropdown.STATUS_REJECT:
        return L10n.ofValue().rejectStatus;
      case ReqinvoutStatusDropdown.STATUS_WAITING:
        return L10n.ofValue().waitingStatus;
      case ReqinvoutStatusDropdown.STATUS_SUBMIT:
        return L10n.ofValue().submitStatus;
      case ReqinvoutStatusDropdown.STATUS_STOCKER:
        return L10n.ofValue().stockerStatus;
      case ReqinvoutStatusDropdown.STATUS_APPROVED:
        return L10n.ofValue().submitStatus;
      case ReqinvoutStatusDropdown.STATUS_DONE:
        return L10n.ofValue().doneStatus;
      case ReqinvoutStatusDropdown.STATUS_UNDONE:
        return L10n.ofValue().undoneStatus;
      case ReqinvoutStatusDropdown.STATUS_CANCELED:
        return L10n.ofValue().cancelStatus;
    }
    return status.toString();
  }

  static Color getStatusColor(int status) {
    switch(status) {
      case ReqinvoutStatusDropdown.STATUS_NEW:
        return Colors.green;
      case ReqinvoutStatusDropdown.STATUS_REJECT:
        return Colors.grey;
      case ReqinvoutStatusDropdown.STATUS_WAITING:
        return Colors.red;
      case ReqinvoutStatusDropdown.STATUS_SUBMIT:
        return Colors.orange;
      case ReqinvoutStatusDropdown.STATUS_APPROVED:
        return Colors.blue;
      case ReqinvoutStatusDropdown.STATUS_DONE:
        return Colors.blue;
    }
    return Colors.black;
  }

  static Icon getStatusIcon(int status, double size) {
    switch(status) {
      case ReqinvoutStatusDropdown.STATUS_NEW:
        return Icon(Icons.new_releases, color: getStatusColor(status), size: size,);
      case ReqinvoutStatusDropdown.STATUS_REJECT:
        return Icon(Icons.arrow_back, color: getStatusColor(status), size: size);
      case ReqinvoutStatusDropdown.STATUS_WAITING:
        return Icon(Icons.hourglass_empty, color: getStatusColor(status), size: size);
      case ReqinvoutStatusDropdown.STATUS_SUBMIT:
        return Icon(Icons.arrow_upward, color: getStatusColor(status), size: size);
      case ReqinvoutStatusDropdown.STATUS_APPROVED:
        return Icon(Icons.check, color: getStatusColor(status), size: size);
      case ReqinvoutStatusDropdown.STATUS_DONE:
        return Icon(Icons.check_circle, color: getStatusColor(status), size: size);
    }
    return Icon(Icons.android, size: size);
  }
}

class _ReqinvoutStatusDropdownState extends State<ReqinvoutStatusDropdown> {
  @override
  Widget build(BuildContext context) {
    List<Tuple2<List<int>, String>> list = [];

    if (widget.showAllItem)
      list.add(Tuple2(null, '${L10n.ofValue().status}: ${L10n.ofValue().all}'));

    list.add(Tuple2([ReqinvoutStatusDropdown.STATUS_NEW, ReqinvoutStatusDropdown.STATUS_WAITING], '${L10n.ofValue().newOrWaitingStatus}'));

    list.add(Tuple2([ReqinvoutStatusDropdown.STATUS_NEW], '${L10n.ofValue().newStatus}'));
    list.add(Tuple2([ReqinvoutStatusDropdown.STATUS_REJECT], '${L10n.ofValue().rejectStatus}'));
    list.add(Tuple2([ReqinvoutStatusDropdown.STATUS_WAITING], '${L10n.ofValue().waitingStatus}'));
    list.add(Tuple2([ReqinvoutStatusDropdown.STATUS_SUBMIT], '${L10n.ofValue().submitStatus}'));
    list.add(Tuple2([ReqinvoutStatusDropdown.STATUS_APPROVED], '${L10n.ofValue().approvedStatus}'));

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
