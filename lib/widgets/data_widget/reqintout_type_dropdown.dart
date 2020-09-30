import 'package:flutter/material.dart';
import 'package:mobile/common/tuple.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/widgets/sdropdown_button.dart';

class ReqinvoutTypeDropdown extends StatefulWidget {
   static const int TYPE_SALES = 1;
   static const int TYPE_FREE_SAMPLE = 2;
   static const int TYPE_CONSIGNMENT = 3;
   static const int TYPE_LOAN = 4;
   static const int TYPE_LEASE = 5;
   static const int TYPE_LOAN_INTERNAL = 6;
   static const int TYPE_RETURN = 7;
   static const int TYPE_CHANGE = 8;
   static const int TYPE_DAMAGED = 9;
   static const int TYPE_LOSS = 10;
   static const int TYPE_WARRANTY = 11;
   static const int TYPE_LIQUIDATION = 12;
   static const int TYPE_INVENTORY = 18;
   static const int TYPE_OTHER = 19;

  final Function(String) onChanged;
  final bool showAllItem;
  String selectedId;
  final TextStyle style;
  final double width;
  final bool smallWidget;
  ReqinvoutTypeDropdown({this.style , this.smallWidget = true, this.onChanged, this.selectedId, this.showAllItem = true, this.width = double.infinity});

  @override
  _ReqinvoutTypeDropdownState createState() => _ReqinvoutTypeDropdownState();

  static String getTypeName(int type) {
    switch(type) {
      case ReqinvoutTypeDropdown.TYPE_SALES:
        return L10n.ofValue().typeSales;
      case ReqinvoutTypeDropdown.TYPE_FREE_SAMPLE:
        return L10n.ofValue().typeFreeSample;
      case ReqinvoutTypeDropdown.TYPE_CONSIGNMENT:
        return L10n.ofValue().typeConsignment;
      case ReqinvoutTypeDropdown.TYPE_LOAN:
        return L10n.ofValue().typeLoan;
      case ReqinvoutTypeDropdown.TYPE_LEASE:
        return L10n.ofValue().typeLease;
      case ReqinvoutTypeDropdown.TYPE_LOAN_INTERNAL:
        return L10n.ofValue().typeLoanInternal;
      case ReqinvoutTypeDropdown.TYPE_RETURN:
        return L10n.ofValue().typeReturn;
      case ReqinvoutTypeDropdown.TYPE_CHANGE:
        return L10n.ofValue().typeChange;
      case ReqinvoutTypeDropdown.TYPE_DAMAGED:
        return L10n.ofValue().typeDamaged;
      case ReqinvoutTypeDropdown.TYPE_LOSS:
        return L10n.ofValue().typeLoss;
      case ReqinvoutTypeDropdown.TYPE_WARRANTY:
        return L10n.ofValue().typeWarranty;
      case ReqinvoutTypeDropdown.TYPE_LIQUIDATION:
        return L10n.ofValue().typeLiquidation;
      case ReqinvoutTypeDropdown.TYPE_INVENTORY:
        return L10n.ofValue().typeInventory;
      case ReqinvoutTypeDropdown.TYPE_OTHER:
        return L10n.ofValue().typeOther;
    }
    return type.toString();
  }

  static Color getStatusColor(int status) {
    switch(status) {

    }
    return Colors.black;
  }

  static Icon getStatusIcon(int status, double size) {
    switch(status) {
    }
    return Icon(Icons.android, size: size);
  }
}

class _ReqinvoutTypeDropdownState extends State<ReqinvoutTypeDropdown> {
  @override
  Widget build(BuildContext context) {
    List<Tuple2<List<int>, String>> list = [];

    if (widget.showAllItem)
      list.add(Tuple2(null, '${L10n.ofValue().inventoryType}: ${L10n.ofValue().all}'));

    list.add(Tuple2([ReqinvoutTypeDropdown.TYPE_SALES], L10n.ofValue().typeSales));
    list.add(Tuple2([ReqinvoutTypeDropdown.TYPE_FREE_SAMPLE], L10n.ofValue().typeFreeSample));
    list.add(Tuple2([ReqinvoutTypeDropdown.TYPE_CONSIGNMENT], L10n.ofValue().typeConsignment));
    list.add(Tuple2([ReqinvoutTypeDropdown.TYPE_LOAN], L10n.ofValue().typeLoan));
    list.add(Tuple2([ReqinvoutTypeDropdown.TYPE_LEASE], L10n.ofValue().typeLease));
    list.add(Tuple2([ReqinvoutTypeDropdown.TYPE_LOAN_INTERNAL], L10n.ofValue().typeLoanInternal));
    list.add(Tuple2([ReqinvoutTypeDropdown.TYPE_RETURN], L10n.ofValue().typeReturn));
    list.add(Tuple2([ReqinvoutTypeDropdown.TYPE_CHANGE], L10n.ofValue().typeChange));
    list.add(Tuple2([ReqinvoutTypeDropdown.TYPE_DAMAGED], L10n.ofValue().typeDamaged));
    list.add(Tuple2([ReqinvoutTypeDropdown.TYPE_LOSS], L10n.ofValue().typeLoss));
    list.add(Tuple2([ReqinvoutTypeDropdown.TYPE_WARRANTY], L10n.ofValue().typeWarranty));
    list.add(Tuple2([ReqinvoutTypeDropdown.TYPE_LIQUIDATION], L10n.ofValue().typeLiquidation));
    list.add(Tuple2([ReqinvoutTypeDropdown.TYPE_INVENTORY], L10n.ofValue().typeInventory));
    list.add(Tuple2([ReqinvoutTypeDropdown.TYPE_OTHER], L10n.ofValue().typeOther));

    return widget.smallWidget ? SDropdownButton<String>(
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
          child: LimitedBox(
            maxWidth: widget.width,
            child: Text(
              tuple2.item2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: _getTypeColor((tuple2.item1?.length??0) > 0  ? tuple2.item1[0] : null)),
            ),
          ),
          value: tuple2.item1 == null ? null : tuple2.item1.join(","),
        );
      }).toList()
    ) : DropdownButton<String>(
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
          return DropdownMenuItem<String>(
            child: LimitedBox(
              maxWidth: widget.width,
              child: Text(
                tuple2.item2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: _getTypeColor((tuple2.item1?.length??0) > 0  ? tuple2.item1[0] : null)),
              ),
            ),
            value: tuple2.item1 == null ? null : tuple2.item1.join(","),
          );
        }).toList()
    );

  }

  Color _getTypeColor(int type) {
    switch(type) {
      case ReqinvoutTypeDropdown.TYPE_SALES:
      case ReqinvoutTypeDropdown.TYPE_FREE_SAMPLE:
        return Colors.blue;

      case ReqinvoutTypeDropdown.TYPE_CONSIGNMENT:
      case ReqinvoutTypeDropdown.TYPE_LOAN:
      case ReqinvoutTypeDropdown.TYPE_LEASE:
      case ReqinvoutTypeDropdown.TYPE_LOAN_INTERNAL:
        return Colors.red;

      case ReqinvoutTypeDropdown.TYPE_RETURN:
      case ReqinvoutTypeDropdown.TYPE_CHANGE:
        return Colors.blue;

      case ReqinvoutTypeDropdown.TYPE_DAMAGED:
        return Colors.red;

      case ReqinvoutTypeDropdown.TYPE_LOSS:
      case ReqinvoutTypeDropdown.TYPE_WARRANTY:
      case ReqinvoutTypeDropdown.TYPE_LIQUIDATION:
      case ReqinvoutTypeDropdown.TYPE_INVENTORY:
      case ReqinvoutTypeDropdown.TYPE_OTHER:
        return Colors.blue;
    }
    return Colors.black;
  }
}
