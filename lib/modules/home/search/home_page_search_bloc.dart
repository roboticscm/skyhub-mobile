import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/locale/locales.dart';

import 'home_page_search_api.dart';
import 'home_page_search_event.dart';
import 'home_page_search_model.dart';
import 'home_page_search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchAPI searchAPI;

  SearchBloc({
    @required this.searchAPI,
  })  : assert(searchAPI != null);

  @override
  SearchState get initialState => SearchInitial();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is OnSearch) {
      yield SearchInitial();
      try {
        final response = await searchAPI.findByTextAndUserId(
            userId: event.userId,
            text: event.text,
            currentPage: event.currentPage,
            pageSize: event.pageSize
        );

        if (response != null ) {
          yield SearchLoading(response);
        } else {
          yield SearchFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
        }
      } catch (error) {
        debugPrint(error.toString());
        yield SearchFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}