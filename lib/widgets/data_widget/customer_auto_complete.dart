import 'package:flutter/material.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/system/loader/data.dart';
import 'package:mobile/widgets/sdropdown_form_field.dart';


class CustomerAutoComplete extends StatefulWidget {
  final Function(int) onChanged;
  int selectedId;
  CustomerAutoComplete({this.onChanged, this.selectedId});
  static _CustomerAutoCompleteState customerAutoCompleteState;
  @override
  _CustomerAutoCompleteState createState() {
    customerAutoCompleteState = _CustomerAutoCompleteState();
    return customerAutoCompleteState;
  }
}

class _CustomerAutoCompleteState extends State<CustomerAutoComplete> {
  var _textController;
  Map _map = Map<String, int>.fromIterable(GlobalData.customerList, key: (e) => e.name, value: (e) => e.id);

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: _getKey(_map, widget.selectedId));
  }


  @override
  Widget build(BuildContext context) {

    return SDropDownField(
      controller: _textController,
      value: _getKey(_map, widget.selectedId),
      hintText: L10n.ofValue().customer,
      items: _map.keys.toList(),
      strict: false,
      onValueChanged: (value){
        widget.onChanged(_map[value]);
        _textController.text = value;
        widget.selectedId = _map[value];
      },
    );
  }

  int getSelectedKey() {
    print(_textController.text.trim());
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