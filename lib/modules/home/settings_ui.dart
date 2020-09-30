import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/main.dart';
import 'package:mobile/system/config/prefs_key.dart';
import 'package:mobile/widgets/particular/sclose_button.dart';
import 'package:mobile/widgets/particular/ssave_button.dart';
import 'package:mobile/widgets/sdialog.dart';
import 'package:mobile/widgets/sradio.dart';
import 'package:mobile/widgets/stext.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsUI extends StatefulWidget  {
  @override
  _SettingsUIState createState() => _SettingsUIState();
}

enum LanguageConfig{
  system, vietnamese, english
}

class _SettingsUIState extends State<SettingsUI> with TickerProviderStateMixin {
  TabController _tabController;
  SharedPreferences prefs;
  StreamController<SharedPreferences> prefsStreamController = StreamController.broadcast();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _init();
  }

  void _init() async {
    prefs = await SharedPreferences.getInstance();
    prefsStreamController.sink.add(prefs);
  }

  @override
  Widget build(BuildContext context) {
    return SDialog(
      title: SText(L10n.of(context).settings),
      content: LimitedBox(
        maxHeight: 200,
        child: Scaffold(
          body: TabBarView(
            controller: _tabController,
            children: [
              LanguageUI(prefsStream: prefsStreamController.stream),
              Text(L10n.of(context).underConstruction)
            ]
          ),
          appBar: TabBar(
            labelColor: Colors.black,
            controller: _tabController, tabs: [
              Tab(icon: Icon(Icons.language), text: L10n.of(context).language,),
              Tab(icon: Icon(Icons.android), text: L10n.of(context).underConstruction,),
            ]),
        ),
      ),
      actions: <Widget>[
        LimitedBox(child: SCloseButton()),
        LimitedBox(child: SSaveButton(
          onTap: () async {
            await LanguageUI.languageUIState.saveSettings();
            Navigator.pop(context);
          },
        )),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    prefsStreamController.close();
  }
}

class LanguageUI extends StatefulWidget {
  final Stream<SharedPreferences> prefsStream;

  static _LanguageUIState languageUIState;

  LanguageUI({
    this.prefsStream,
  });

  @override
  _LanguageUIState createState() {
    languageUIState = _LanguageUIState();
    return languageUIState;
  }
}

class _LanguageUIState extends State<LanguageUI> with AutomaticKeepAliveClientMixin {
  LanguageConfig _selectLang;
  SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
  }

  Future<void> saveSettings() async {
    await _prefs.setInt(PrefsKey.language.toString(), _selectLang.index);
    App.appState.setLocale(_selectLang);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<SharedPreferences>(
      stream: widget.prefsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _prefs ??= snapshot.data;
          _selectLang ??= LanguageConfig.values[_prefs.getInt(PrefsKey.language.toString())??0];
        }

        return Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SRadio(
                    value: LanguageConfig.system,
                    groupValue: _selectLang,
                    onChanged: (value){
                      _selectLang = value;
                      setState(() {
                      });
                    },
                  ),
                  SText(L10n.ofValue().system),
                ],
              ),
              Row(
                children: <Widget>[
                  SRadio(
                    value: LanguageConfig.vietnamese,
                    groupValue: _selectLang,
                    onChanged: (value){
                      _selectLang = value;
                      print(_selectLang);
                      setState(() {
                      });
                    },
                  ),
                  SText(L10n.ofValue().vietnamese),
                ],
              ),
              Row(
                children: <Widget>[
                  SRadio(
                    value: LanguageConfig.english,
                    groupValue: _selectLang,
                    onChanged: (value){
                      _selectLang = value;
                      print(_selectLang);
                      setState(() {
                      });
                    },
                  ),
                  SText(L10n.ofValue().english),
                ],
              ),
            ],
          ),
        );
      }
    );
  }

  @override
  bool get wantKeepAlive => true;
}