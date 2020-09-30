import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/calendar/model.dart';
import 'package:mobile/modules/calendar/month/month_api.dart';
import 'package:mobile/modules/calendar/month/month_event.dart';
import 'package:mobile/modules/calendar/month/month_state.dart';

class MonthBloc extends Bloc<MonthEvent, MonthState> {
  final MonthAPI monthAPI;
  StreamController<ScheduleView> streamController;

  MonthBloc({
    @required this.monthAPI,
  })  : assert(monthAPI != null);

  @override
  MonthState get initialState => MonthInitial();

  @override
  Stream<MonthState> mapEventToState(MonthEvent event) async* {
    if (event is OnMonthLoad) {
      yield MonthInitial();
      try {
        final response = await monthAPI.findScheduleByMonth(
          startDate: event.startDate,
          endDate: event.endDate,
          empId: event.empId
        );
        yield MonthLoading(response);

      } catch (error) {
        print(error);
        yield MonthFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
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