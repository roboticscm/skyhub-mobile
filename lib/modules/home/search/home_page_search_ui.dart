import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobile/common/common.dart';
import 'package:mobile/common/global_function.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/chat/chat_model.dart';
import 'package:mobile/modules/chat/details/chat_details_api.dart';
import 'package:mobile/modules/chat/details/chat_details_bloc.dart';
import 'package:mobile/modules/chat/details/chat_details_ui.dart';
import 'package:mobile/modules/chat/details/chat_details_web_socket.dart';
import 'package:mobile/modules/video_call/calling_ui.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/widgets/scircular_progress_indicator.dart';
import 'package:mobile/widgets/scontainer.dart';
import 'package:mobile/widgets/shtml.dart';
import 'package:mobile/widgets/stext.dart';

import 'details/search_details_api.dart';
import 'details/search_details_bloc.dart';
import 'details/search_details_ui.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

import 'home_page_search_api.dart';
import 'home_page_search_bloc.dart';
import 'home_page_search_event.dart';
import 'home_page_search_model.dart';
import 'home_page_search_state.dart';

class HomePageSearchUI extends StatefulWidget {
  HomePageSearchUI({
    Key key,
  }) : super(key: key);

  @override
  State<HomePageSearchUI> createState() => HomePageSearchUIState();
}

class HomePageSearchUIState extends State<HomePageSearchUI> {
  TextEditingController _textController =  TextEditingController();
  SearchAPI _searchApi = SearchAPI();
  SearchBloc _searchBloc;
  String _oldText;
  int _currentPage = 0;
  List<SearchResult> _list;
  final _numberFormatter = NumberFormat("#,###");
  ChatDetailsAPI _chatDetailsAPI = ChatDetailsAPI();
  ChatDetailsWebSocket _chatDetailsWebSocket = ChatDetailsWebSocket();
  ChatDetailsBloc _chatDetailsBloc;
  SearchDetailsBloc _searchDetailsBloc;
  bool _exactlySearch = false;
  String _dateStr;
  String _barcode;

  @override
  void initState() {
    super.initState();
    _searchBloc = SearchBloc(searchAPI: _searchApi);
    _chatDetailsBloc = ChatDetailsBloc(
        chatDetailsAPI: _chatDetailsAPI,
        chatDetailsWebSocket: _chatDetailsWebSocket
    );
//    _textController.addListener((){
//      var text = _textController.text.trim();
//      if (text != _oldText) {
//        _oldText = text;
//        _onSearch(text);
//      }
//    });

    _searchDetailsBloc = SearchDetailsBloc(searchDetailsAPI: SearchDetailsAPI());
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchEvent, SearchState>(
      bloc: _searchBloc,
      builder: (BuildContext context, SearchState state) {
        if (state is SearchFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: SText(state.error),
                backgroundColor: Colors.red,
              ),
            );
          });
        }
        if (state is SearchLoading) {
          _list = state.list;
        }
        return _buildUI(state);
      },
    );
  }

  Widget _buildUI(SearchState state) {
    return Scaffold(
      backgroundColor: STextStyle.BACKGROUND_COLOR,
      appBar: _buildAppBar(),
      body: state is SearchLoading ? _buildResult() : Container(),//SCircularProgressIndicator.buildSmallCenter(),
      bottomNavigationBar: SContainer(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SText(
          (_list == null)? '' :  (_list?.length ?? 0) > 0 ?  '${_list.length == GlobalParam.PAGE_SIZE ? L10n.of(context).moreThan : ""} ${_list.length} ${ L10n.of(context).record}' : L10n.of(context).noRecordFound
        )
      ),
    );
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
    if (text.length < 3 && mounted) {
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

    _searchBloc.dispatch(OnSearch(
        userId: GlobalParam.USER_ID,
        text: _text,
        currentPage: _currentPage,
        pageSize: GlobalParam.PAGE_SIZE
    ));
  }

  Widget _buildResult() {
    return ListView(
      children: <Widget>[
        for (var item in _list)
          _buildListItem(item),
      ],
    );
  }

  Widget _buildListItem(SearchResult item) {
    return Column(
      children: <Widget>[
        _buildListTile(item),
      ],
    );
  }

  Widget _buildListTile(SearchResult item) {
    switch (item.category) {
      case "QUOTATION":
        return _buildQuotationListTile(item);
      case "EMPLOYEE":
        return _buildEmployeeListTile(item);
      case "INVENTORY":
        return _buildInventoryListTile(item);
      default:
        return Container();
    }
  }

  Widget _buildEmployeeListTile(SearchResult item) {
    return ListTile(
      leading: FittedBox(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            SCircularProgressIndicator.buildSmallCenter(),
            ClipOval(
              child: FadeInImage.memoryNetwork(
                placeholder: transparentImage,
                image: '${GlobalParam.IMAGE_SERVER_URL}/avartar?id=${item.id}',
                fit: BoxFit.fill,
                height: 55,
                width: 55,
              ),
            ),
          ],
        ),
      ),
      title: SHtml(data: item.customerName ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SHtml(data: item.title),
          SHtml(data: '<h5>${item.content}</h5>'),

          SText('• ' + L10n.of(context).email + ": " + item.detail, style: STextStyle.smallerTextStyle(),),
          SText('• ' + L10n.of(context).status + ": " + SearchResult.getEmployeeStatusDesc(context, item.status), style: STextStyle.smallerTextStyle()),
          SText('• ' + L10n.of(context).joinDate + ": " + Util.getDateStr(item.date), style: STextStyle.smallerTextStyle()),
          if (GlobalParam.USER_ID  != item.id)
          Row(
            children: <Widget>[

              IconButton(
                icon: Icon(Icons.call, color: Colors.blue,),
                onPressed: () {
                  _openCallingDialog(false, item.id, item.code, item.customerName);
                },
              ),

              IconButton(
                icon: Icon(Icons.videocam, color: Colors.blue,),
                onPressed: () {
                  _openCallingDialog(true, item.id, item.code, item.customerName);
                },
              ),

              IconButton(
                icon: Icon(Icons.message, color: Colors.blue,),
                onPressed: () {
                  _onTapChatContact(item);
                },
              ),
            ],
          ),
          Divider()
        ],
      ),
    );
  }

  void _onTapChatContact(SearchResult item){
    GlobalParam.currentGroupId = SkyNotification.GROUP_MESSAGE;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          ChatDetailsUI(
            chatDetailsBloc: _chatDetailsBloc,
            chatterName: item.customerName,
            chatterId: item.id,
            chatterAccount: item.code,
            lastAccess: null,
            isOnline: false,
          )
      ),
    ).then((onValue) async{
//      GlobalParam.isActivatedChat = false;
//      await _chatDetailsBloc.chatDetailsAPI.updateReceiveMessageStatus(GlobalParam.USER_ID, chatHistory.userId, SkyNotification.GROUP_MESSAGE, 2);///2=read
//      await GlobalParam.homePageState?.onNotify(SkyNotification.GROUP_MESSAGE);
    });
  }

  void _openCallingDialog(bool isVideoCalling, int userId, String username, String name) {
    Navigator.of(context).push(new MaterialPageRoute<String>(
        builder: (BuildContext context) {
          return CallingUI(
            isCallMode: true,
            receiverId: userId,
            receiverName: name,
            receiverAccount: username,
            isVideoCalling: isVideoCalling,
          );
        },
        fullscreenDialog: true));
  }

  Widget _buildQuotationListTile(SearchResult item) {
    return ListTile(
      title: Text(L10n.of(context).quotation, style: TextStyle(color: Colors.blue)),
      subtitle: Container(
        margin: EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SHtml(data: '• ' + item.title + " - " + item.code + " - " + _numberFormatter.format(item.sumAmount)  + _numberFormatter.currencySymbol),
            SHtml(data: '• ' + item.customerName),
            SHtml(data: '• ' + item.content),
            SText('• ' + L10n.of(context).status + ": " + SearchResult.getQuotationStatusDesc(context, item.status)),
            SText('• ' + Util.getDateStr(item.date)),
            Divider()
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryListTile(SearchResult item) {
    return ListTile(
      onTap: () {
        _showDetails(item);
      },
      title: SText(L10n.of(context).inventory, style: TextStyle(color: Colors.blue),),
      subtitle: Container(
        margin: EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SHtml(data: '<h3>${item.code}</h3>'),
            if (item.barcode != null)
              SText('• ${L10n.of(context).barcode}: ${item.barcode}'),
            SHtml(data: '• ' + item.customerName),
            Row(
              children: <Widget>[
                SText('• ' + L10n.of(context).quantity + ": "),
                SText(_numberFormatter.format(item.sumTotalAmount), style: TextStyle(fontWeight: FontWeight.bold),),
                Expanded(child: Container(),),
                SText('• ' + L10n.of(context).unit + ": " + item.detail),
              ],
            ),
            Divider()
          ],
        ),
      ),
    );
  }


  void _showDetails(SearchResult item) {
    print ((_barcode?.length??0) > 0 ? _barcode :  _dateStr);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          SearchDetailsUI(
            searchDetailsBloc: _searchDetailsBloc,
            name: item.customerName,
            code: item.code,
            dateStr: (_barcode?.length??0) > 0 ? _barcode :  _dateStr,
            exactlySearch: _exactlySearch,
            totalQuantity: item.sumTotalAmount,
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
