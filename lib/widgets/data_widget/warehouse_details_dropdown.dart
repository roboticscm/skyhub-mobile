import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/inventory/inventory_api.dart';
import 'package:mobile/system/loader/data.dart';
import 'package:mobile/system/loader/model.dart';
import 'package:mobile/widgets/sdropdown_button.dart';

class WarehouseDetailsDropdown extends StatefulWidget {
  final Function(int) onChanged;
  List<Warehouse> list;
  int selectedId;
  WarehouseDetailsDropdown({this.onChanged, this.selectedId, this.list});

  @override
  _WarehouseDetailsDropdownState createState() => _WarehouseDetailsDropdownState();
}

class _WarehouseDetailsDropdownState extends State<WarehouseDetailsDropdown> {
  @override
  Widget build(BuildContext context) {
    widget.list ??= [];
    if(widget.list.length == 0 || widget.list[0].id != null)
      widget.list.insert(0, Warehouse(name: '${L10n.ofValue().inventory}: ${L10n.ofValue().defaultWarehouse}'));

    bool contained = widget.list.where((test) => test.id == widget.selectedId).length > 0;

    return SDropdownButton<int>(
        onChanged: (value) {
          widget.onChanged(value);
          widget.selectedId = value;
          if(mounted)
            setState(() {
            });
        },
        value: contained ? widget.selectedId : null,
        items: widget.list.map((item){
          return SDropdownMenuItem<int>(
            child: LimitedBox(maxWidth: 150, child: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis,)),
            value: item.id,
          );
        }).toList()
    );

  }

}