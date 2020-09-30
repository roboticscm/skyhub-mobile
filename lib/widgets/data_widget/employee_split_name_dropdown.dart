import 'package:flutter/material.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/system/loader/data.dart';
import 'package:mobile/system/loader/model.dart';
import 'package:mobile/widgets/sdropdown_button.dart';

import '../stext.dart';

class EmployeeSplitNameDropdown extends StatefulWidget {
  final Function(int) onChanged;
  final bool showAllItem;
  int selectedId;
  final double width;
  EmployeeSplitNameDropdown({this.onChanged, this.selectedId, this.showAllItem = true, this.width=double.infinity});

  @override
  _EmployeeSplitNameDropdownState createState() => _EmployeeSplitNameDropdownState();
}

class _EmployeeSplitNameDropdownState extends State<EmployeeSplitNameDropdown> {
  @override
  Widget build(BuildContext context) {
    if ((GlobalData.employeeSplitNameList?.length??0) == 0)
      return SText(L10n.ofValue().noEmployee);

    var list = List.from(GlobalData.employeeSplitNameList);

    if (widget.showAllItem)
      list.insert(0, Employee(name: '${L10n.ofValue().employee}: ${L10n.ofValue().all}'));

    return InkWell(
      onLongPress: () {
        widget.selectedId = GlobalParam.EMPLOYEE_ID;
        widget.onChanged(widget.selectedId);
        setState(() {
        });
      },
      child: DropdownButton<int>(
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
      ),
    );
  }
}