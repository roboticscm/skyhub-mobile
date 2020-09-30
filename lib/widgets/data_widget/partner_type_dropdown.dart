import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/common/tuple.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/widgets/sdropdown_button.dart';

class PartnerTypeDropdown extends StatefulWidget {
  static const String CUSTOMER="C";
  static const String SUPPLIER="S";
  static const String EMPLOYEE="E";


  final Function(String) onChanged;
  final bool showAllItem;
  String selectedId;
  final TextStyle style;
  PartnerTypeDropdown({this.style , this.onChanged, this.selectedId, this.showAllItem = true});

  @override
  _PartnerTypeDropdownState createState() => _PartnerTypeDropdownState();

  static String getPartnerTypeName(String type) {
    switch(type) {
      case CUSTOMER:
        return L10n.ofValue().customer;
      case SUPPLIER:
        return L10n.ofValue().supplier;
      case EMPLOYEE:
        return L10n.ofValue().employee;
    }
    return type;
  }

  static Icon getIconForPartnerType(String type, double size) {
    switch (type) {
      case CUSTOMER:
        return Icon(Icons.shopping_cart, size: size,);
      case SUPPLIER:
        return Icon(FontAwesomeIcons.superscript, size: size);
      case EMPLOYEE:
        return Icon(FontAwesomeIcons.userTie, size: size);
    }
    return Icon(Icons.android, size: size);
  }
}

class _PartnerTypeDropdownState extends State<PartnerTypeDropdown> {
  @override
  Widget build(BuildContext context) {
    List<Tuple2<String, String>> list = [];

    list.add(Tuple2(PartnerTypeDropdown.CUSTOMER, '${L10n.ofValue().customer}'));
    list.add(Tuple2(PartnerTypeDropdown.SUPPLIER, '${L10n.ofValue().supplier}'));
    list.add(Tuple2(PartnerTypeDropdown.EMPLOYEE, '${L10n.ofValue().employee}'));

    return SDropdownButton<String>(
      style: widget.style != null ? widget.style : null,
      onChanged: (value) {
        widget.onChanged(value);
        widget.selectedId = value;
        if(mounted)
          setState(() {
          });
      },
      value: widget.selectedId,
      items: list.map((tuple2){
        return SDropdownMenuItem<String>(
          child: Text(tuple2.item2),
          value: tuple2.item1,
        );
      }).toList()
    );
  }
}
