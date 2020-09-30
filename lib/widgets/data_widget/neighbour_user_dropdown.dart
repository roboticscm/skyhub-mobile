import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/system/loader/data.dart';
import 'package:mobile/system/loader/model.dart';

class NeighbourUserDropdown extends StatefulWidget {
  final Function(int) onChanged;
  final bool showAllItem;
  final String business;
  int selectedId;
  NeighbourUserDropdown({this.onChanged, this.business, this.selectedId, this.showAllItem = true});

  @override
  _NeighbourUserDropdownState createState() => _NeighbourUserDropdownState();
}

class _NeighbourUserDropdownState extends State<NeighbourUserDropdown> {
  var _userStreamController = StreamController<List<Employee>>();
  @override
  void initState() {
    super.initState();
    GlobalData.dataAPI.findNeighbourEmployee(GlobalParam.USER_ID, widget.business).then((value) {
      if (value != null)
        _userStreamController.sink.add(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Employee>>(
      stream: _userStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return DropdownButton<int>(
            onChanged: (value) {
              widget.onChanged(value);
              widget.selectedId = value;
              if(mounted)
                setState(() {
                });
            },
            value: widget.selectedId,
            items: snapshot.data.map((item){
              return DropdownMenuItem<int>(
                child: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis,),
                value: item.userId,
              );
            }).toList()
          );
        else
          return LimitedBox(maxWidth: 100, maxHeight: 15,);
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
    _userStreamController.close();
  }


}