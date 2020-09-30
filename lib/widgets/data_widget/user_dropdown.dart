import 'package:flutter/material.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/system/loader/data.dart';
import 'package:mobile/system/loader/model.dart';

class UserDropdown extends StatefulWidget {
  final Function(int) onChanged;
  final bool showAllItem;
  int selectedId;
  final double width;
  UserDropdown({this.onChanged, this.selectedId, this.showAllItem = true, this.width=double.infinity});

  @override
  _UserDropdownState createState() => _UserDropdownState();
}

class _UserDropdownState extends State<UserDropdown> {
  @override
  Widget build(BuildContext context) {
    var list = List.from(GlobalData.employeeList);

    if (widget.showAllItem)
      list.insert(0, Employee(name: '${L10n.ofValue().employee}: ${L10n.ofValue().all}'));

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
            child: LimitedBox(maxWidth: widget.width, child: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis,)),
            value: item.userId,
          );
        }).toList()
    );
  }
}