import 'package:flutter/material.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/system/loader/data.dart';
import 'package:mobile/system/loader/model.dart';
import 'package:mobile/widgets/sdropdown_button.dart';

class EmployeeDropdown extends StatefulWidget {
  final Function(int) onChanged;
  final bool showAllItem;
  int selectedId;
  final double width;
  EmployeeDropdown({this.onChanged, this.selectedId, this.showAllItem = true, this.width=double.infinity});

  @override
  _EmployeeDropdownState createState() => _EmployeeDropdownState();
}

class _EmployeeDropdownState extends State<EmployeeDropdown> {
  @override
  Widget build(BuildContext context) {
    var list = List.from(GlobalData.employeeList);

    if (widget.showAllItem)
      list.insert(0, Employee(name: '${L10n.ofValue().employee}: ${L10n.ofValue().all}'));

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
            child: LimitedBox(
              maxWidth: widget.width,
              child: Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ),
            value: item.id,
          );
        }).toList()
    );
  }
}