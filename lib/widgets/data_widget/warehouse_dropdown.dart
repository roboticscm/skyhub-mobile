import 'package:flutter/material.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/system/loader/data.dart';
import 'package:mobile/system/loader/model.dart';
import 'package:mobile/widgets/sdropdown_button.dart';

class WarehouseDropdown extends StatefulWidget {
  final Function(int) onChanged;
  final bool showAllItem;
  int selectedId;
  WarehouseDropdown({this.onChanged, this.selectedId, this.showAllItem = true});

  @override
  _WarehouseDropdownState createState() => _WarehouseDropdownState();
}

class _WarehouseDropdownState extends State<WarehouseDropdown> {
  @override
  Widget build(BuildContext context) {
    var list = List.from(GlobalData.parentWarehouseList);

    if (widget.showAllItem)
      list.insert(0, Warehouse(name: '${L10n.ofValue().inventory}: ${L10n.ofValue().all}'));

    return SDropdownButton<int>(
        onChanged: (value) {
          widget.onChanged(value);
          widget.selectedId = value;
          if(mounted)
            setState(() {
            });
        },
        value: widget.selectedId,
        items: list.map((item){
          return SDropdownMenuItem<int>(
            child: LimitedBox(maxWidth: 150, child: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis,)),
            value: item.id,
          );
        }).toList()
    );
  }
}