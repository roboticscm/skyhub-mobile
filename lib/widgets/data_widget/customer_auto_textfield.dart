//import 'package:flutter/material.dart';
//
//class CustomerAutoTextField extends StatefulWidget {
//  final bool smallWidget;
//  final Function(int) onChanged;
//  int selectedId;
//
//  CustomerAutoTextField({this.smallWidget = false, this.onChanged, this.selectedId});
//  _CustomerAutoTextFieldState customerAutoTextFieldState = _CustomerAutoTextFieldState();
//
//  @override
//  _CustomerAutoTextFieldState createState() {
//    return customerAutoTextFieldState;
//  }
//}
//
//class _CustomerAutoTextFieldState extends State<CustomerAutoTextField> {
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return null;
//  }
//
//  String getSelectedText() {
//    return "";
//  }
//
//  int getSelectedId() {
//    return 1;
//  }
//
//}

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/system/loader/data.dart';
import 'package:mobile/system/loader/model.dart';

class CustomerAutoTextField extends StatefulWidget {
  final bool smallWidget;
  final Function(int) onChanged;
  int selectedId;

  CustomerAutoTextField({this.smallWidget = false, this.onChanged, this.selectedId});
  _CustomerAutoTextFieldState customerAutoTextFieldState = _CustomerAutoTextFieldState();

  @override
  _CustomerAutoTextFieldState createState() {
    return customerAutoTextFieldState;
  }
}

class _CustomerAutoTextFieldState extends State<CustomerAutoTextField> {
  static TextEditingController _searchTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    //_searchTextController.text='';
    _searchTextController.text = GlobalData
      .customerList
      .firstWhere((test) => test.id == widget.selectedId, orElse: () => Customer())?.name;
  }

  @override
  Widget build(BuildContext context) {
    var defaultStyle = TextStyle(fontSize: 12);
    return TypeAheadField<Customer>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _searchTextController,
        decoration: widget.smallWidget ?
        InputDecoration(
            contentPadding: EdgeInsets.only(top: 2, bottom: 2),
            filled: false,
            hintText: L10n.ofValue().customer + ": " + L10n.ofValue().all,
            suffix: InkWell(
                onTap: () {
                  _searchTextController.clear();
                  widget.selectedId = null;
                  setState(() {
                  });
                },
                child: Icon(Icons.close, size: 13,)
            )) : InputDecoration(
            filled: false,
            hintText: L10n.ofValue().customer + ": " + L10n.ofValue().all,
            suffix: InkWell(
                onTap: () {
                  _searchTextController.clear();
                  widget.selectedId = null;
                  setState(() {
                  });
                },
                child: Icon(Icons.close, size: 16,)
            )
        ),
      ),

      onSuggestionSelected: (customer) {
        widget.onChanged(customer.id);
        _searchTextController.text = customer.name;
      },
      suggestionsCallback: (pattern) async {
        return GlobalData.customerList.where((test)=>
            test.name.toLowerCase().contains(pattern.toLowerCase())
            || test.unaccentName.toLowerCase().contains(pattern.toLowerCase())
            || test.code.toLowerCase().contains(pattern.toLowerCase())
        ).toList();
      },

      itemBuilder: (BuildContext context, Customer item){
        return Container(
          alignment: Alignment.centerLeft,
          height: 30,
          child: Table(
            columnWidths: {0: FixedColumnWidth(120)},
            children:[
              TableRow(
                children: [
                  Text(
                    (item.code??'').trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: defaultStyle,
                  ),
                  Text(
                    (item.name??'').trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: defaultStyle,
                  ),
                ]
              )
            ],
          ),
        );
      },

    );
  }


  String getSelectedText() {
    return (_searchTextController.text??'').trim();
  }

  int getSelectedId() {
    var selectedText = getSelectedText();
    return GlobalData
        .customerList
        .firstWhere((test) => test.name == selectedText, orElse: () => Customer())?.id;
  }
}