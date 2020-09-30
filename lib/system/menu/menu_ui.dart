import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/locale/r2.dart';
import 'package:mobile/modules/home/home_page.dart';
import 'package:mobile/modules/home/home_page.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/system/menu/sub/sub_menu_ui.dart';
import 'package:mobile/widgets/scircular_progress_indicator.dart';

import 'menu_api.dart';
import 'menu_bloc.dart';
import 'menu_event.dart';
import 'menu_model.dart';
import 'menu_state.dart';

class MenuUI extends StatefulWidget {
  final MenuBloc menuBloc;
  MenuUI ({this.menuBloc});
  
  @override
  _MenuUIState createState() => _MenuUIState();
}

class _MenuUIState extends State<MenuUI> {
  get _menuBloc => widget.menuBloc;
  
  List<Menu> _list;

  @override
  void initState()  {
    super.initState();
    _init();
  }

  void _init() async {
    _menuBloc.dispatch(OnMenuLoad(
        userId: GlobalParam.USER_ID
    ));
  }

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<MenuEvent, MenuState>(
      bloc: _menuBloc,
      builder: (BuildContext context, MenuState state) {
        if (state is MenuLoading) {
          _list = state.list;
        }
        return state is MenuLoading ? _buildMenu(state) : SCircularProgressIndicator.buildSmallCenter();
      },
    );
  }

  Widget _buildMenu(MenuState state){
    return GridView.count(
      mainAxisSpacing: 3,
      crossAxisSpacing: 3,
      childAspectRatio: 2,
      crossAxisCount: Util.calcNumOfGridColumn(),
      children: <Widget>[
        for (var menu in _list)
          if(menu.id != Menu.MESSAGE && menu.id != Menu.WORKS_MANAGERMENT )
            _buildMenuItem(menu)
      ],
    );
  }

  void _showSubMenu(int menuId) {
    GlobalParam.homePageState.changeStackIndex(HomePageState.SUB_MENU_INDEX, menuId);
  }

  Widget _getMenuIcon(String resourceKey) {
    if (["office", "administrive", "inventory"].contains(resourceKey.toLowerCase()))
      return SvgPicture.asset('assets/$resourceKey.svg'.toLowerCase(), color: STextStyle.LIGHT_TEXT_COLOR);
    else
      return Icon(_getIcon(resourceKey), color: Colors.white,);
  }

  IconData _getIcon(String resourceKey) {
    switch (resourceKey.toLowerCase()){
      case 'sales':
        return FontAwesomeIcons.searchDollar;
      case 'services':
        return FontAwesomeIcons.tools;
      case 'purchase':
        return FontAwesomeIcons.handHoldingUsd;
      case 'accounting':
        return FontAwesomeIcons.dollarSign;
      case 'employee':
        return FontAwesomeIcons.userFriends;
      case 'generic_info':
      case 'genericinfo':
        return FontAwesomeIcons.infoCircle;
    }

    return Icons.menu;
  }

  Widget _buildMenuItem(Menu menu) {
    return Card(
        child: Center(
          child: InkWell(
            onTap: () {
              print('You tap on: ${menu.resourceKey}');
              _showSubMenu(menu.id);
            },
            child: FittedBox(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: <Widget>[
                      Container(
                        width: 55,
                        height: 55,
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.only(top: 5, right: 5),
                        child: _getMenuIcon(menu.resourceKey),
                        decoration: BoxDecoration(
                            color: STextStyle.GRADIENT_COLOR1,
                            borderRadius: BorderRadius.circular(20)
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 2),
                        padding: EdgeInsets.only(left: 3, top: 0, right: 3, bottom: 0),
                        decoration: BoxDecoration(
                            color: STextStyle.NOTIFICATION_BACKGROUND_COLOR,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: ((menu.totalNotify ?? 0) <= 0) ? FittedBox() : Text('${menu.totalNotify}', style: TextStyle(color: Colors.white, fontSize: GlobalParam.SMALLER_FONT_SIZE),),
                      )
                    ],
                  )
                ),
                Container(
                    margin: EdgeInsets.only(top: 4),
                    child: Text(R2.r(menu.resourceKey), style: STextStyle.biggerTextStyle(),)
                ),
              ]),
            ),
          ),
        )
    );
  }
}