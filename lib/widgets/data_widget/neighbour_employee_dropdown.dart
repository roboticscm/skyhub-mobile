import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/tuple.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/system/loader/data.dart';
import 'package:mobile/system/loader/model.dart';

import '../scircular_progress_indicator.dart';

class NeighbourEmployeeDropdown extends StatefulWidget {
  final Function(int) onChanged;
  final bool showAllItem;
  final String business;
  int selectedId;
  final double width;
  NeighbourEmployeeDropdown({this.onChanged, this.business, this.selectedId, this.width=double.infinity, this.showAllItem = true});

  static NeighbourEmployeeDropdownState state;

  @override
  NeighbourEmployeeDropdownState createState() {
    return state = NeighbourEmployeeDropdownState();
  }
}

class NeighbourEmployeeDropdownState extends State<NeighbourEmployeeDropdown> {
  var _userStreamController = StreamController<List<Employee>>();
  var itemCount = 0;

  @override
  void initState() {
    super.initState();
    GlobalData.dataAPI.findNeighbourEmployee(GlobalParam.USER_ID, widget.business).then((value) {
      if (value != null) {
        itemCount = value.length;
        if(widget.showAllItem && (value?.length??0) > 1){
          value.insert(0, Employee(name: '${L10n.ofValue().employee}: ${L10n.ofValue().all}'));
        }
        _userStreamController.sink.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Employee>>(
        stream: _userStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
                    widget.selectedId =   value;
                    if(mounted)
                      setState(() {
                      });
                  },
                  value: (snapshot.data.length==1) ? snapshot.data[0].id : widget.selectedId,
                  items: snapshot.data.map((item){
                    return DropdownMenuItem<int>(
                      child: LimitedBox(maxWidth: widget.width, child: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                      value: item.id,
                    );
                  }).toList()
              ),
            );
          } else
              return SCircularProgressIndicator.buildSmallest();
        }
    );
  }

  @override
  void dispose() {
    super.dispose();
    _userStreamController.close();
  }


}