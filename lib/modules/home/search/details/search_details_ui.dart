import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/widgets/scontainer.dart';
import 'package:mobile/widgets/shtml.dart';
import 'package:mobile/widgets/stext.dart';

import '../home_page_search_model.dart';
import 'search_details_bloc.dart';
import 'search_details_event.dart';
import 'search_details_model.dart';
import 'search_details_state.dart';

class SearchDetailsUI extends StatefulWidget {
  final SearchDetailsBloc searchDetailsBloc;
  final String code;
  final String name;
  final num totalQuantity;
  final String dateStr;
  final bool exactlySearch;

  SearchDetailsUI({
    Key key,
    this.searchDetailsBloc,
    this.code,
    this.name,
    this.dateStr,
    this.exactlySearch,
    this.totalQuantity
  }) : super(key: key);

  @override
  State<SearchDetailsUI> createState() => SearchDetailsUIState();
}

class SearchDetailsUIState extends State<SearchDetailsUI> {
  List<SearchDetailsResult> _list;
  final _numberFormatter = NumberFormat("#,###");
  get _searchDetailsBloc => widget.searchDetailsBloc;
  get _code => widget.code;
  get _name => widget.name;
  get _totalQuantity => widget.totalQuantity;
  get _exactlySearch => widget.exactlySearch;
  get _dateStr => widget.dateStr;

  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    _searchInventory();
  }

  void _searchInventory() {
    _searchDetailsBloc.dispatch(OnSearchInventoryDetails(
        userId: GlobalParam.USER_ID,
        code: _code.toString().replaceAll("<mark>", "").replaceAll("</mark>", ""),
        currentPage: _currentPage,
        exactlySearch: _exactlySearch,
        dateStr: _dateStr,
        pageSize: GlobalParam.PAGE_SIZE
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchDetailsEvent, SearchDetailsState>(
      bloc: _searchDetailsBloc,
      builder: (BuildContext context, SearchDetailsState state) {
        if (state is SearchDetailsFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: SText(state.error),
                backgroundColor: Colors.red,
              ),
            );
          });
        }
        if (state is SearchDetailsLoading) {
          _list = state.list;
        }
        return _buildUI(state);
      },
    );
  }

  Widget _buildUI(SearchDetailsState state) {
    return Scaffold(
      backgroundColor: STextStyle.BACKGROUND_COLOR,
      appBar: _buildAppBar(),
      body: state is SearchDetailsLoading ? _buildResult() : Container(),
      bottomNavigationBar: SContainer(
        child: SText(
          (_list?.length ?? 0) > 0 ?
            '${_list.length == GlobalParam.PAGE_SIZE ? L10n.of(context).moreThan : ""} '
                '${_list.length} ${ L10n.of(context).record} ${ L10n.of(context).totalQuantity}: ${_numberFormatter.format(_totalQuantity)}' : L10n.of(context).noRecordFound
        )
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: STextStyle.appBarDecoration()
      ),
      titleSpacing: -5,
      title: Container(
        padding: EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SHtml(data: _code),
            SHtml(data: '<small>$_name</small>'),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
    var count = 0;
    return ListView(
      children: <Widget>[
        for (var item in _list)
          _buildListItem(item, ++count),
      ],
    );
  }


  Widget _buildListItem(SearchDetailsResult item, int count) {
    var color = Colors.black;
    var expColor = Util.getColorByExpireDate(item.expireDate);

    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: expColor,
          width: 2
        )
      ),
      child: ListTile(
        title: Text('#$count: ${item.nameOrigin} - ${item.brand }', style: TextStyle(color: color)),
        subtitle: Container(
          padding: EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (item.barcode != null)
                SText('• ${L10n.of(context).barcode}: ${item.barcode}', style: TextStyle(color: color)),
              Row(
                children: <Widget>[
                  SText('• ' + '${L10n.of(context).quantity}: ${item.stock}', style: TextStyle(color: expColor)),
                  Expanded(
                    child: Container(),
                  ),
                  SText('• ' + '${L10n.of(context).unit}: ${item.unit}', style: TextStyle(color: color)),
                ],
              ),
              Row(
                children: <Widget>[
                  if ((item.model?.length??0) > 0)
                    SText('• ' + '${L10n.of(context).model}: ${item.model}', style: TextStyle(color: color)),
                  Expanded(
                    child: Container(),
                  ),
                  if ((item.serial?.length??0) > 0)
                    SText('• ' + '${L10n.of(context).serial}: ${item.serial}', style: TextStyle(color: color)),
                ],
              ),
              Row(
                children: <Widget>[
                  SText('• ' + '${L10n.of(context).lot}: ${item.lot}', style: TextStyle(color: color)),
                  Expanded(
                    child: Container(),
                  ),
                  SText('• ' + '${L10n.of(context).expireDate}: ${Util.getDateStr(item.expireDate)}', style: TextStyle(color: expColor)),
                ],
              ),
              if (item.locationCode!=null)
                SText('• ' + (item.locationCode??''), style: TextStyle(color: color)),
              if (item.locationDesc!=null)
                SText('• ' + (item.locationDesc??''), style: TextStyle(color: color)),
              if(item.group!=null)
                SText('• ' + (item.group??''), style: TextStyle(color: color)),
              if (item.type != null)
                SText('• ' + SearchResult.getWarehouseTypeName(GlobalParam.appContext, item.type), style: TextStyle(color: color)),
              if(item.warehouse != null)
                SText('• ' + (item.warehouse??''), style: TextStyle(color: color)),
              SText('• ' + '${L10n.of(context).orderBy}: ${item.order??''}', style: TextStyle(color: color)),
              SText('• ' + '${L10n.of(context).requesterForDelivery}: ${item.requesterForDelivery??''}', style: TextStyle(color: color)),
            ],
          ),
        )
      ),
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}
