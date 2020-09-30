import 'package:flutter/material.dart';
import 'package:mobile/common/tuple.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/system/loader/data.dart';
import 'package:mobile/system/loader/model.dart';

class YearDropdown extends StatefulWidget {
  final Function(int) onChanged;
  final bool showAllItem;
  int selectedId;
  YearDropdown({this.onChanged, this.selectedId, this.showAllItem = true});

  @override
  _YearDropdownState createState() => _YearDropdownState();
}

class _YearDropdownState extends State<YearDropdown> {
  static const int VIEW_ITEM_YEAR = 5;
  @override
  Widget build(BuildContext context) {
    List<Tuple2<int, String>> list = [];



    var nowYear = DateTime.now().year;
    list.add(Tuple2(-1, '${nowYear-1} - $nowYear'));
    for (var y = nowYear; y > nowYear -VIEW_ITEM_YEAR ; y--)
      list.add(Tuple2(y, y.toString()));

    if (widget.showAllItem)
      list.add(Tuple2(null, '${L10n.ofValue().year}: ${L10n.ofValue().all}'));

    return DropdownButton<int>(
        onChanged: (value) {
          widget.onChanged(value);
          widget.selectedId = value;
          if(mounted)
            setState(() {
            });
        },
        value: widget.selectedId,
        items: list.map((tuple2){
          return DropdownMenuItem<int>(
            child: Text(tuple2.item2),
            value: tuple2.item1,
          );
        }).toList()
    );
  }
}
