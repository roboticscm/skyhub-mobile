import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/inventory/inventory_api.dart';
import 'package:mobile/modules/inventory/inventory_model.dart' as prefix0;
import 'package:mobile/style/text_style.dart';
import 'package:mobile/widgets/scontainer.dart';
import 'package:mobile/widgets/shtml.dart';
import 'package:mobile/widgets/stext.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import '../inventory_bloc.dart';
import '../inventory_event.dart';
import '../inventory_model.dart';
import '../inventory_state.dart';
import 'details/search_details_ui.dart';

class InventorySearchUI extends StatefulWidget {
  final bool showDetails;
  bool searchReqPoItem = false;
  bool searchQuotation = false;
  bool searchContract = false;
  bool searchReqInventoryOut = false;
  String searchType ;
  InventorySearchUI({
    this.showDetails = true,
    this.searchReqPoItem,
    this.searchQuotation,
    this.searchReqInventoryOut,
    this.searchType,
    Key key,
  }) : super(key: key);

  @override
  State<InventorySearchUI> createState() => InventorySearchUIState();
}

class InventorySearchUIState extends State<InventorySearchUI> {
  TextEditingController _textController =  TextEditingController();
  InventoryAPI _inventoryApi = InventoryAPI();
  InventoryBloc _inventoryBloc;
  int _currentPage = 0;
  List<InventorySearchResult> _list;
  List<ReqPoItemSearchResult> _reqPoItemlist;
  final _numberFormatter = NumberFormat("#,###");
  bool _exactlySearch = false;
  String _dateStr;
  String _barcode;

  @override
  void initState() {



    super.initState();
    _inventoryBloc = InventoryBloc(inventoryAPI: _inventoryApi);
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryEvent, InventoryState>(
      bloc: _inventoryBloc,
      builder: (BuildContext context, InventoryState state) {
        if (state is InventorySearchFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: SText(state.error),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

        if(widget.searchReqPoItem == true){
          if (state is ReqPoItemSearchLoading) {
            _reqPoItemlist = state.list;

          }
        }
        else {
          if (state is InventorySearchLoading) {
            _list = state.list;
          }
        }

       // print("okkkkkkkkkkkkkkkkkkkkk");

        return _buildUI(state);
      },
    );
  }

  Widget _buildUI(InventoryState state) {
    return Scaffold(
      backgroundColor: STextStyle.BACKGROUND_COLOR,
      appBar: _buildAppBar(),

      //body: (state is InventorySearchLoading || state is InventorySearchDetailsLoading) ? _buildResult() : Container(),//SCircularProgressIndicator.buildSmallCenter(),
        body:_buildBody(state),
      bottomNavigationBar: SContainer(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SText(
              (_list == null)? '' :  (_list?.length ?? 0) > 0 ?  '${_list.length == GlobalParam.PAGE_SIZE ? L10n.of(context).moreThan : ""} ${_list.length} ${ L10n.of(context).record}' : L10n.of(context).noRecordFound
          )
      ),
    );
  }
  Widget _buildBody(InventoryState state ){
    if(widget.searchReqPoItem == true) {
      return (state is ReqPoItemSearchLoading) ? buildResultReqPo() : Container();
    }
    else {
      return  (state is InventorySearchLoading || state is InventorySearchDetailsLoading) ? _buildResult() : Container();
    }
  }
  Future<void> _showScanBarcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", L10n.of(context).cancel, true);
    } catch( e){
      print(e);
    }

    if (!mounted) return;

    _barcode = barcodeScanRes;
    setState(() {
      _textController.text = barcodeScanRes;
      _onSearch(_textController.text.trim());
    });
  }

  void _showDatePicker() async {
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
      context: context,
      initialFirstDate: new DateTime.now(),
      initialLastDate: new DateTime.now(),
      firstDate: new DateTime(2000),
      lastDate: new DateTime(2030),
    );
    if (picked != null) {
      _textController.text = Util.getDateStr(picked[0]);
      _onSearch(_textController.text);
    }
  }

  Widget _buildAppBar() {
    return AppBar(
      titleSpacing: -5,
      title: GestureDetector(
        onDoubleTap: (){
          _showDatePicker();
        },
        child: TextField(
          autofocus: true,
          onSubmitted: (_){

            _onSearch(_textController.text.trim());
          },
          onChanged: (value){
            _barcode = "";
          },
          controller: _textController,
          textAlign: TextAlign.center,
          style: TextStyle(color: STextStyle.BACKGROUND_COLOR),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              prefixIcon: IconButton(
                icon: Icon(FontAwesomeIcons.barcode, color: STextStyle.BACKGROUND_COLOR),
                onPressed: (){
                  _showScanBarcode();
                },
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.search, color: STextStyle.BACKGROUND_COLOR),
                onPressed: (){

                  _onSearch(_textController.text.trim());
                },
              ),
              hintStyle: TextStyle(
                  fontSize: 16,
                  color: STextStyle.BACKGROUND_COLOR
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              contentPadding: EdgeInsets.all(10),
              fillColor: STextStyle.GRADIENT_COLOR_AlPHA
          ),
        ),
      ),
      flexibleSpace: Container(
          decoration: STextStyle.appBarDecoration()
      ),
      actions: <Widget>[
        SizedBox(
          width: 15,
        )
      ],
    );
  }

  Future<void> _onSearch(String text) async {

    if (text.length < 1 && mounted) {
      setState(() {
        _list?.clear();
      });
      return;
    }
    var _text = text;

    try{
      _exactlySearch = _text.contains("#");

      var date = DateFormat.yMd().parse(text.replaceAll("#", ""));
      _text = Util.getDmyStr(date);
      _dateStr = _text;
    }catch (e){
      _dateStr = "";
      print (e);
    }

    if (_exactlySearch)
      _text = "#" + _text;


    if(widget.searchReqPoItem == true) {

      _inventoryBloc.dispatch(OnReqPoItemSearch(
          userId: GlobalParam.USER_ID,
          text: _text,
          currentPage: _currentPage,
          pageSize: GlobalParam.PAGE_SIZE,
          searchType: widget.searchType
      ));
    }
    else {
      _inventoryBloc.dispatch(OnInventorySearch(
          userId: GlobalParam.USER_ID,
          text: _text,
          currentPage: _currentPage,
          pageSize: GlobalParam.PAGE_SIZE
      ));
    }
  }

  Widget _buildResult() {
    _list ??= [];

    return ListView(
      children: <Widget>[
    if(_list.length > 0 )
    for (var item in _list)
      _buildInventoryListTile(item),

      ],
    );
  }

  Widget buildResultReqPo() {
    _reqPoItemlist ??= [];
    return ListView(
      children: <Widget>[
        if(_reqPoItemlist.length > 0 )
          for (var item in _reqPoItemlist)
            _buildReqPoItemListTile(item),

      ],
    );
  }


  Widget _buildReqPoItemListTile(ReqPoItemSearchResult item) {

    return ListTile(
      onTap: () {
          Navigator.pop(context, item);
      },
      subtitle: Container(
        margin: EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            _buildSearchTypeResult(item)
             ,
           // SHtml(data: '• ' + item.name),

            Divider()
          ],
        ),
      ),
    );
  }
  Widget _buildSearchTypeResult(ReqPoItemSearchResult item){
    if(widget.searchType == "itemcode"){
      return  SHtml(data: '<h3>${item.code} : ${item.name} : ${item.unitName}<h3>');
    }
    else {
      return  SHtml(data: '<h3>${item.searchCode} : ${item.searchName} <h3>');
    }

    return null;
  }
  Widget _buildInventoryListTile(InventorySearchResult item) {

    return ListTile(
      onTap: () {
       if (widget.showDetails)
          _showDetails(item);
        else {
          Navigator.pop(context, item);
        }
      },
      subtitle: Container(
        margin: EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SHtml(data: '<h3>${item.code}</h3>'),
            SHtml(data: '• ' + item.name),
            Row(
              children: <Widget>[
                SText('• ' + L10n.of(context).quantity + ": "),
                SText(_numberFormatter.format(item.stock), style: TextStyle(fontWeight: FontWeight.bold),),
                Expanded(child: Container(),),
                SText('• ' + L10n.of(context).unit + ": " + item.unit),
              ],
            ),
            Divider()
          ],
        ),
      ),
    );
  }


  void _showDetails(InventorySearchResult item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          SearchDetailsUI(
            inventoryBloc: _inventoryBloc,
            name: item.name,
            code: item.code,
            dateStr: (_barcode?.length??0) > 0 ? _barcode :  _dateStr,
            exactlySearch: _exactlySearch,
            totalQuantity: item.stock,
          )
      ),
    ).then((onValue) async{

    });
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }


}
