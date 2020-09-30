import 'package:flutter/material.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/system/loader/data.dart';
import 'package:mobile/widgets/sdropdown_form_field.dart';


class SupplierAutoComplete extends StatefulWidget {
  final Function(int) onChanged;
  int selectedId;
  SupplierAutoComplete({this.onChanged, this.selectedId});
  static _SupplierAutoCompleteState SupplierAutoCompleteState;
  @override
  _SupplierAutoCompleteState createState() {
    SupplierAutoCompleteState = _SupplierAutoCompleteState();
    return SupplierAutoCompleteState;
  }
}

class _SupplierAutoCompleteState extends State<SupplierAutoComplete> {
  var _textController;
  Map _map = Map<String, int>.fromIterable(GlobalData.supplierList, key: (e) => e.name, value: (e) => e.id);
  @override
  Widget build(BuildContext context) {
    _textController = TextEditingController(text: _getKey(_map, widget.selectedId));
    return SDropDownField(
      controller: _textController,
      value: _getKey(_map, widget.selectedId),
      hintText: L10n.ofValue().supplier,
      items: _map.keys.toList(),
      strict: false,
      onValueChanged: (value){
        widget.onChanged(_map[value]);
      },
    );
  }

  int getSelectedKey() {
    return _map[_textController.text.trim()];
  }

  String getText() {
    return _textController.text.trim();
  }

  String _getKey(Map<String, int> map, int selectedId) {
    var foundKey;
    map.forEach((String key, int value){
      if (value == selectedId) {
        foundKey = key;
      }
    });
    if(foundKey != null)
      return foundKey;
    return null;
  }
}