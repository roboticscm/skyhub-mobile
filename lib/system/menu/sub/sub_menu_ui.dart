import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/locale/r2.dart';
import 'package:mobile/modules/home/home_page.dart';
import 'package:mobile/modules/inventory/inventory_out/inventory_out_ui.dart';
import 'package:mobile/modules/inventory/request_inventory_out/request_inventory_out_ui.dart';
import 'package:mobile/modules/office/holiday/holiday_ui.dart';
import 'package:mobile/modules/sales/quotation/qutation_ui.dart';

import 'package:mobile/modules/sales/request_po/request_po_ui.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/system/menu/sub/sub_menu_bloc.dart';
import 'package:mobile/system/menu/sub/sub_menu_event.dart';
import 'package:mobile/system/menu/sub/sub_menu_model.dart';
import 'package:mobile/system/menu/sub/sub_menu_state.dart';
import 'package:mobile/widgets/scircular_progress_indicator.dart';

class SubMenuUI extends StatefulWidget {
  final SubMenuBloc subMenuBloc;
  static _SubMenuUIState subMenuUIState;
  const SubMenuUI({Key key, this.subMenuBloc}) : super(key: key);

  @override
  _SubMenuUIState createState() {
    subMenuUIState = _SubMenuUIState();
    return subMenuUIState;
  }
}

class _SubMenuUIState extends State<SubMenuUI> {
  SubMenuBloc get _subMenuBloc => widget.subMenuBloc;

  @override
  void initState() {
    super.initState();
  }

  void loadData(int parentID) {
    if(parentID != null) {
      _subMenuBloc.dispatch(OnSubMenuLoad(
        userId: GlobalParam.USER_ID,
        mainId: parentID
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _subMenuBloc,
      builder: (BuildContext context, SubMenuState state) {
        return state is SubMenuLoading ? _buildUI(state.list) : SCircularProgressIndicator.buildSmallCenter();
      },
    );
  }

  Widget _buildUI(List<SubMenu> list) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        onPressed: () {
          HomePage.homePageState.changeStackIndex(HomePageState.MENU_INDEX, null);
        }
      ),
      body: _buildMenu(list),
    );
  }

  Widget _buildMenu(List<SubMenu> list){
    return GridView.count(
      mainAxisSpacing: 3,
      crossAxisSpacing: 3,
      childAspectRatio: 2,
      crossAxisCount: Util.calcNumOfGridColumn(),
      children: <Widget>[
        for (var menu in list)
          _buildSubMenuItem(menu)
      ],
    );
  }

  void _showDetails(SubMenu menu) {
    Widget target;
    IconData icon = Icons.menu;

    switch (menu.resourceKey) {
      case 'quotation':
        target = QuotationUI(menu: menu,);
        break;
      case 'goodsRequest':
      case 'outputRequest':
        target = RequestInventoryOutUI(menu: menu,);
        break;
      case 'warehouseOutput':
        target = InventoryOutUI(menu: menu,);
        break;
      case 'leavesRequest':
        target = HolidayUI(menu: menu, icon: FontAwesomeIcons.umbrella);
        break;
      case 'orderRequest':
        target = RequestPoUI(menu: menu, icon: FontAwesomeIcons.umbrella);
        break;
      default:
        target = Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                  decoration: STextStyle.appBarDecoration()
              ),
              titleSpacing: -5,
              title: Text(R2.r(menu.resourceKey)),
            ),
            body: Text(L10n.ofValue().underConstruction)
        );
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return target;
    }));
  }

  Widget _buildSubMenuItem(SubMenu menu) {
    return Card(
        child: Center(
          child: InkWell(
            onTap: () {
              print('You tapped on ${menu.resourceKey}');
              _showDetails(menu);
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
                              child: Icon(Icons.subtitles, color: Colors.white,),///SvgPicture.asset('assets/${menu.resourceKey}.svg', color: STextStyle.LIGHT_TEXT_COLOR),
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