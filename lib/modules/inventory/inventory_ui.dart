import 'package:flutter/material.dart';
import 'package:mobile/locale/locales.dart';

class InventoryUI extends StatefulWidget {
  @override
  _InventoryUIState createState() => _InventoryUIState();
}

class _InventoryUIState extends State<InventoryUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(L10n.ofValue().quickSearchInventoryOnly),
      ),
    );
  }
}