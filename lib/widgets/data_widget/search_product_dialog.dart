import 'package:flutter/material.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/widgets/particular/sclose_button.dart';
import 'package:mobile/widgets/particular/select_button.dart';
import 'package:mobile/widgets/sdialog.dart';
import 'package:mobile/widgets/stext_field.dart';

class SearchProductDialog extends StatefulWidget {
  @override
  _SearchProductDialogState createState() => _SearchProductDialogState();
}

class _SearchProductDialogState extends State<SearchProductDialog> {
  var _itemCodeTextController = TextEditingController();
  var _itemNameTextController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {

  }
  @override
  Widget build(BuildContext context) {
    return SDialog(
      title: Text(L10n.ofValue().item),
      content: _buildUI(),
      actions: <Widget>[
        SCloseButton(),
        SSelectButton(
          onTap: (){

          },
        )
      ],
    );
  }

  Widget _buildUI() {
    return Column(
      children: <Widget>[
        STextField(
          controller: _itemCodeTextController,
          decoration: InputDecoration(
            hintText: L10n.ofValue().itemCode
          ),
        ),
        STextField(
          controller: _itemNameTextController,
          decoration: InputDecoration(
              hintText: L10n.ofValue().itemName
          ),
        ),
        _buildSearchResult(),
      ],
    );
  }

  Widget _buildSearchResult() {

  }
}