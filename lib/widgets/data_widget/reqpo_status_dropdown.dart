import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/common/tuple.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/system/loader/data.dart';
import 'package:mobile/system/loader/model.dart';

class ReqPoStatusDropdown extends StatefulWidget {
  static const int STATUS_NEW = 1;
  static const int STATUS_REJECT = 2;
  static const int STATUS_WAITING = 3;
  static const int STATUS_SUBMIT = 4;
  static const int STATUS_PUR = 5;
  static const int STATUS_APPROVED = 6;
  static const int STATUS_WAITING_PO = 7;
  static const int STATUS_DONE = 8;
  static const int STATUS_NO_ENOUGH = 9;
  static const int STATUS_ENOUGH = 10;
  static const int STATUS_PROCESSING = 11;
  static const int STATUS_CANCELED = -1;
  static const int STAGE = 10;


  final Function(String) onChanged;
  final bool showAllItem;
  String selectedId;
  final TextStyle style;
  ReqPoStatusDropdown({this.style , this.onChanged, this.selectedId, this.showAllItem = true});

  @override
  _ReqPoStatusDropdownState createState() => _ReqPoStatusDropdownState();

  static String getStatusName(int status) {
    switch(status) {
      case ReqPoStatusDropdown.STATUS_NEW:
        return L10n.ofValue().newStatus;
      case ReqPoStatusDropdown.STATUS_REJECT:
        return L10n.ofValue().rejectStatus;
      case ReqPoStatusDropdown.STATUS_WAITING:
        return L10n.ofValue().waitingStatus;
      case ReqPoStatusDropdown.STATUS_SUBMIT:
        return L10n.ofValue().pur11StatusSubmit;
      case ReqPoStatusDropdown.STATUS_PUR:
        return L10n.ofValue().pur11StatusPur;
      case ReqPoStatusDropdown.STATUS_APPROVED:
        return L10n.ofValue().pur11StatusApprove;
      case ReqPoStatusDropdown.STATUS_WAITING_PO:
        return L10n.ofValue().waitPoStatus;
      case ReqPoStatusDropdown.STATUS_DONE:
        return L10n.ofValue().doneStatus;
      case ReqPoStatusDropdown.STATUS_NO_ENOUGH:
        return L10n.ofValue().noEnoughStatus;
      case ReqPoStatusDropdown.STATUS_ENOUGH:
        return L10n.ofValue().enoughStatus;
      case ReqPoStatusDropdown.STATUS_PROCESSING:
        return L10n.ofValue().processingStatus;
      case ReqPoStatusDropdown.STATUS_CANCELED:
        return L10n.ofValue().cancelStatus;
    }
    return status.toString();
  }

  static Color getStatusColor(int status) {
    switch(status) {
      case ReqPoStatusDropdown.STATUS_NEW:
        return Colors.green;
      case ReqPoStatusDropdown.STATUS_REJECT:
        return Colors.grey;
      case ReqPoStatusDropdown.STATUS_WAITING:
        return Colors.red;
      case ReqPoStatusDropdown.STATUS_SUBMIT:
        return Colors.orange;
      case ReqPoStatusDropdown.STATUS_APPROVED:
        return Colors.blue;
      case ReqPoStatusDropdown.STATUS_DONE:
        return Colors.blue;
    }
    return Colors.black;
  }

  static Icon getStatusIcon(int status, double size) {
    switch(status) {
      case ReqPoStatusDropdown.STATUS_NEW:
        return Icon(Icons.new_releases, color: getStatusColor(status), size: size,);
      case ReqPoStatusDropdown.STATUS_REJECT:
        return Icon(Icons.arrow_back, color: getStatusColor(status), size: size);
      case ReqPoStatusDropdown.STATUS_WAITING:
        return Icon(Icons.hourglass_empty, color: getStatusColor(status), size: size);
      case ReqPoStatusDropdown.STATUS_SUBMIT:
        return Icon(Icons.check, color: getStatusColor(status), size: size);
      case ReqPoStatusDropdown.STATUS_PUR:
        return Icon(Icons.check, color: getStatusColor(status), size: size);
      case ReqPoStatusDropdown.STATUS_APPROVED:
        return Icon(Icons.check, color: getStatusColor(status), size: size);
      case ReqPoStatusDropdown.STATUS_DONE:
        return Icon(Icons.check_circle, color: getStatusColor(status), size: size);
    }
    return Icon(Icons.android, size: size);
  }
}

class _ReqPoStatusDropdownState extends State<ReqPoStatusDropdown> {
  @override
  Widget build(BuildContext context) {
    List<Tuple2<List<int>, String>> list = [];

    if (widget.showAllItem)
      list.add(Tuple2(null, '${L10n.ofValue().status}: ${L10n.ofValue().all}'));

    list.add(Tuple2([ReqPoStatusDropdown.STATUS_NEW, ReqPoStatusDropdown.STATUS_WAITING], '${L10n.ofValue().newOrWaitingStatus}'));

    list.add(Tuple2([ReqPoStatusDropdown.STATUS_NEW], '${L10n.ofValue().newStatus}'));
    list.add(Tuple2([ReqPoStatusDropdown.STATUS_REJECT], '${L10n.ofValue().rejectStatus}'));
    list.add(Tuple2([ReqPoStatusDropdown.STATUS_WAITING], '${L10n.ofValue().waitingStatus}'));
    list.add(Tuple2([ReqPoStatusDropdown.STATUS_SUBMIT], '${L10n.ofValue().pur11StatusSubmit}'));
    list.add(Tuple2([ReqPoStatusDropdown.STATUS_PUR], '${L10n.ofValue().pur11StatusPur}'));
    list.add(Tuple2([ReqPoStatusDropdown.STATUS_APPROVED], '${L10n.ofValue().pur11StatusApprove}'));
    list.add(Tuple2([ReqPoStatusDropdown.STATUS_WAITING_PO], '${L10n.ofValue().waitPoStatus}'));
    list.add(Tuple2([ReqPoStatusDropdown.STATUS_DONE], '${L10n.ofValue().doneStatus}'));
    list.add(Tuple2([ReqPoStatusDropdown.STATUS_NO_ENOUGH], '${L10n.ofValue().noEnoughStatus}'));
    list.add(Tuple2([ReqPoStatusDropdown.STATUS_ENOUGH], '${L10n.ofValue().enoughStatus}'));
    list.add(Tuple2([ReqPoStatusDropdown.STATUS_PROCESSING], '${L10n.ofValue().processingStatus}'));
    list.add(Tuple2([ReqPoStatusDropdown.STATUS_CANCELED], '${L10n.ofValue().cancelStatus}'));
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
