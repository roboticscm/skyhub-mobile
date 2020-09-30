import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/calendar/day/day_api.dart';
import 'package:mobile/modules/calendar/day/day_event.dart';
import 'package:mobile/modules/calendar/day/day_state.dart';
import 'package:mobile/modules/calendar/model.dart';

class DayBloc extends Bloc<DayEvent, DayState> {
  final DayAPI dayAPI;
  StreamController<ScheduleView> streamController;
  List<ScheduleView> _list;
  DayBloc({
    @required this.dayAPI,
  })  : assert(dayAPI != null);

  @override
  DayState get initialState => DayInitial();

  @override
  Stream<DayState> mapEventToState(DayEvent event) async* {
    if (event is OnDayLoad) {
      yield DayInitial();
      try {
        _list = await dayAPI.findScheduleByDate(date: event.date);
        yield DayLoading(_list);

      } catch (error) {
        print(error);
        yield DayFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
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