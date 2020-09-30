import 'package:flutter/material.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/style/text_style.dart';

class CalendarSearchUI extends StatefulWidget {
  @override
  _CalendarSearchUIState createState() => _CalendarSearchUIState();
}

class _CalendarSearchUIState extends State<CalendarSearchUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Center(
        child: Text(L10n.ofValue().underConstruction),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      titleSpacing: -5,
      title: GestureDetector(
        child: TextField(
          autofocus: true,

          textAlign: TextAlign.center,
          style: TextStyle(color: STextStyle.BACKGROUND_COLOR),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.search, color: STextStyle.BACKGROUND_COLOR),
                onPressed: (){
                },
              ),
              hintStyle: TextStyle(
                  fontSize: 16,
                  color: STextStyle.BACKGROUND_COLOR
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              contentPadding: EdgeInsets.all(10),
              fillColor: STextStyle.GRADIENT_COLOR_AlPHA
          ),
        ),
      ),
      flexibleSpace: Container(
          decoration: STextStyle.appBarDecoration()
      ),
      actions: <Widget>[
        SizedBox(
          width: 15,
        )
      ],
    );
  }
}