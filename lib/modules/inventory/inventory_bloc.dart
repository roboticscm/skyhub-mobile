import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/locale/locales.dart';

import 'inventory_api.dart';
import 'inventory_event.dart';
import 'inventory_state.dart';


class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final InventoryAPI inventoryAPI;

  InventoryBloc({
    @required this.inventoryAPI,
  })  : assert(inventoryAPI != null);

  @override
  InventoryState get initialState => InventoryInitial();

  @override
  Stream<InventoryState> mapEventToState(InventoryEvent event) async* {
    if (event is OnInventorySearch) {
      yield InventorySearchInitial();
      try {
        final response = await inventoryAPI.textSearch(
            userId: event.userId,
            text: event.text,
            currentPage: event.currentPage,
            pageSize: event.pageSize
        );

        yield InventorySearchLoading(response.item1);
      } catch (error) {
        debugPrint(error.toString());
        yield InventorySearchFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
      }
    }

    if (event is OnReqPoItemSearch) {
      yield ReqPoItemSearchInitial();
      try {
        final response = await inventoryAPI.textSearchReqPoItem(
            userId: event.userId,
            text: event.text,
            currentPage: event.currentPage,
            pageSize: event.pageSize,
            typeSearch: event.searchType
        );

        yield ReqPoItemSearchLoading(response.item1);
      } catch (error) {
        debugPrint(error.toString());
        yield ReqPoItemSearchFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
      }
    }

    if (event is OnInventorySearchDetails) {
      yield InventorySearchDetailsInitial();
      try {
        final response = await inventoryAPI.textSearchDetails(
            userId: event.userId,
            code: event.code,
            dateStr: event.dateStr,
            exactlySearch: event.exactlySearch,
            currentPage: event.currentPage,
            pageSize: event.pageSize
        );

        if (response != null ) {
          yield InventorySearchDetailsLoading(response);
        } else {
          yield InventorySearchDetailsFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
        }
      } catch (error) {
        debugPrint(error.toString());
        yield InventorySearchDetailsFailure(error: L10n.of(GlobalParam.appContext).connectApiError);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}