import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/locale/locales.dart';

import 'menu_api.dart';

import 'menu_event.dart';
import 'menu_model.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuAPI menuAPI;
  StreamController<Menu> streamController;

  MenuBloc({
    @required this.menuAPI,
  })  : assert(MenuAPI != null);

  @override
  MenuState get initialState => MenuInitial();

  @override
  Stream<MenuState> mapEventToState(MenuEvent event) async* {
    if (event is OnMenuLoad) {
      yield MenuInitial();
      try {
        final response = await menuAPI.findByUserId(
            userId: event.userId,
        );

        if (response != null ) {
          yield MenuLoading(response);
        } else {
          yield MenuFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
        }
      } catch (error) {
        debugPrint(error.toString());
        yield MenuFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
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