import 'package:flutter/material.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/system/loader/data.dart';
import 'package:mobile/system/loader/model.dart';

class BranchDropdown extends StatefulWidget {
  final Function(int) onChanged;
  final bool showAllItem;
  int selectedId;
  BranchDropdown({this.onChanged, this.selectedId, this.showAllItem = true});

  @override
  _BranchDropdownState createState() => _BranchDropdownState();
}

class _BranchDropdownState extends State< BranchDropdown> {
  @override
  Widget build(BuildContext context) {
    var list = List.from(GlobalData.branchList);

    if (widget.showAllItem)
      list.insert(0, Employee(name: '${L10n.ofValue().branch}: ${L10n.ofValue().all}'));

    return DropdownButton<int>(
        onChanged: (value) {
          widget.onChanged(value);
          widget.selectedId = value;
          if(mounted)
            setState(() {
            });
        },
        value: widget.selectedId,
        items: list.map((item){
          return DropdownMenuItem<int>(
            child: Text(item.name),
            value: item.id,
          );
        }).toList()
    );
  }
}