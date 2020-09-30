import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/locale/locales.dart';

import 'search_details_api.dart';
import 'search_details_event.dart';
import 'search_details_model.dart';
import 'search_details_state.dart';


class SearchDetailsBloc extends Bloc<SearchDetailsEvent, SearchDetailsState> {
  final SearchDetailsAPI searchDetailsAPI;
  StreamController<SearchDetailsResult> streamController;

  SearchDetailsBloc({
    @required this.searchDetailsAPI,
  })  : assert(searchDetailsAPI != null);

  @override
  SearchDetailsState get initialState => SearchDetailsInitial();

  @override
  Stream<SearchDetailsState> mapEventToState(SearchDetailsEvent event) async* {
    if (event is OnSearchInventoryDetails) {
      yield SearchDetailsInitial();
      try {
        final response = await searchDetailsAPI.findInventoryByIdAndUserId(
            userId: event.userId,
            code: event.code,
            dateStr: event.dateStr,
            exactlySearch: event.exactlySearch,
            currentPage: event.currentPage,
            pageSize: event.pageSize
        );

        if (response != null ) {
          yield SearchDetailsLoading(response);
        } else {
          yield SearchDetailsFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
        }
      } catch (error) {
        debugPrint(error.toString());
        yield SearchDetailsFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
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