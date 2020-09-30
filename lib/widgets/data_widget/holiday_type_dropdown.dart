import 'package:flutter/material.dart';
import 'package:mobile/common/tuple.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/office/holiday/holiday_model.dart';

class HolidayTypeDropdown extends StatefulWidget {
  final Function(String) onChanged;
  final bool showAllItem;
  String selectedId;
  final TextStyle style;
  final double width;
  HolidayTypeDropdown({this.style , this.onChanged, this.selectedId, this.showAllItem = true, this.width=double.infinity});

  @override
  _HolidayTypeDropdownState createState() => _HolidayTypeDropdownState();

  static String getHolidayTypeName(String code) {
    switch (code) {
      case "AN":
        return L10n.ofValue().annualLeave;
      case "AL":
        return L10n.ofValue().publicLeave;
      case "WD":
        return L10n.ofValue().marriedLeave;
      case "SK":
        return L10n.ofValue().sickLeave;
      case "FN":
        return L10n.ofValue().funeralLeave;
      case "MT":
        return L10n.ofValue().maternityLeave;
      case HolidayView.TYPE_PERSONAL_LEAVE:
        return L10n.ofValue().personalLeave;
      case "AC":
        return L10n.ofValue().injuryLeave;
      case "SP":
        return L10n.ofValue().specialLeave;
    }

    return code??'';
  }
}

class _HolidayTypeDropdownState extends State<HolidayTypeDropdown> {
  @override
  Widget build(BuildContext context) {
    List<Tuple2<String, String>> list = [];

    if (widget.showAllItem)
      list.add(Tuple2(null, '${L10n.ofValue().leavesRequestType}: ${L10n.ofValue().all}'));

    list.add(Tuple2("AN", HolidayTypeDropdown.getHolidayTypeName("AN")));
    list.add(Tuple2("AL", HolidayTypeDropdown.getHolidayTypeName("AL")));
    list.add(Tuple2("WD", HolidayTypeDropdown.getHolidayTypeName("WD")));
    list.add(Tuple2("SK", HolidayTypeDropdown.getHolidayTypeName("SK")));
    list.add(Tuple2("FN", HolidayTypeDropdown.getHolidayTypeName("FN")));
    list.add(Tuple2("MT", HolidayTypeDropdown.getHolidayTypeName("MT")));
    list.add(Tuple2("AC", HolidayTypeDropdown.getHolidayTypeName("AC")));
    list.add(Tuple2("SP", HolidayTypeDropdown.getHolidayTypeName("SP")));
    list.add(Tuple2(HolidayView.TYPE_PERSONAL_LEAVE, HolidayTypeDropdown.getHolidayTypeName(HolidayView.TYPE_PERSONAL_LEAVE)));

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
            child: LimitedBox(
              maxWidth: widget.width,
              child: Text(
                tuple2.item2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ),
            value: tuple2.item1,
          );
        }).toList()
    );
  }
}
