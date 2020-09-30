import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/system/menu/sub/sub_menu_api.dart';
import 'package:mobile/system/menu/sub/sub_menu_event.dart';
import 'package:mobile/system/menu/sub/sub_menu_model.dart';
import 'package:mobile/system/menu/sub/sub_menu_state.dart';


class SubMenuBloc extends Bloc<SubMenuEvent, SubMenuState> {
  final SubMenuAPI subMenuAPI;
  StreamController<SubMenu> streamController;

  SubMenuBloc({
    @required this.subMenuAPI,
  })  : assert(subMenuAPI != null);

  @override
  SubMenuState get initialState => SubMenuInitial();

  @override
  Stream<SubMenuState> mapEventToState(SubMenuEvent event) async* {
    if (event is OnSubMenuLoad) {
      yield SubMenuInitial();
      try {
        final response = await subMenuAPI.findByUserIdAndMainId(
          userId: event.userId,
          mainId: event.mainId
        );

        if (response != null ) {
          yield SubMenuLoading(response);
        } else {
          yield SubMenuFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
        }
      } catch (error) {
        debugPrint(error.toString());
        yield SubMenuFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
      }
    }
  }

  @override
  void dispose() {
    streamController?.close();
    streamController = null;
    super.dispose();
  }
}