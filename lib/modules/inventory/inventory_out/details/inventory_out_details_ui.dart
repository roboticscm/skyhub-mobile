import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/style/text_style.dart';
import 'package:mobile/widgets/data_widget/partner_type_dropdown.dart';
import 'package:mobile/widgets/data_widget/reqintout_type_dropdown.dart';
import 'package:mobile/widgets/data_widget/reqinvout_status_dropdown.dart';
import 'package:mobile/widgets/sdialog.dart';
import 'package:mobile/widgets/shtml.dart';
import 'package:mobile/widgets/stext.dart';
import 'package:rxdart/rxdart.dart';

import '../inventory_out_api.dart';
import '../inventory_out_model.dart';

class InventoryOutDetailsUI extends StatefulWidget {
  final InventoryOutView inventoryOut;
  final InventoryOutAPI inventoryOutAPI;

  InventoryOutDetailsUI({
    this.inventoryOut,
    this.inventoryOutAPI,
  });

  @override
  _InventoryOutDetailsUIState createState() => _InventoryOutDetailsUIState();
}

class _InventoryOutDetailsUIState extends State<InventoryOutDetailsUI> {
  StreamController<List<InventoryOutItemView>> _inventoryOutItemStreamController = StreamController.broadcast();
  InventoryOutView  get _inventoryOut  => widget.inventoryOut;
  List<InventoryOutItemView> _fullList;
  List<InventoryOutItemView> _groupList;
  var _tableBorder = TableBorder.all(color: Colors.grey, width: 0.2);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData()  {
    widget.inventoryOutAPI.findInventoryOutItem(inventoryOutId: _inventoryOut.id).then((value) async {
      if(value.item1 != null) {
        _fullList = value.item1;
        _groupList = await _groupByItem(_fullList);
        _inventoryOutItemStreamController.add(_groupList);
      } else {
        SDialog.lessMoreAlert(L10n.ofValue().inventoryOut, L10n.ofValue().connectApiError, value.item2);
      }
    });
  }

  static Future<List<InventoryOutItemView>> _groupByItem(List<InventoryOutItemView> list) async {
    return await Observable.fromIterable(list)
      .groupBy((item) => item.itemId)
      .flatMap((g) => g.reduce((x, y) => InventoryOutItemView(
        itemId: x.itemId,
        itemName: x.itemName,
        itemCode: x.itemCode,
        qty: x.qty + y.qty
      )).asObservable()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottom(),
    );
  }

  Widget _buildBottom() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              border: Border(top: BorderSide(
                  color: STextStyle.GRADIENT_COLOR1,
                  width: 1
              ))
          ),
          alignment: Alignment.centerRight,
          height: 30,
          width: double.infinity,
          child: SText(
            '${L10n.ofValue().totalQuantity}: ${_inventoryOut.sumQty.toInt()}',
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
          decoration: STextStyle.appBarDecoration()
      ),
      titleSpacing: -5,
      title: SText(
          L10n.ofValue().inventoryOut ,
          style: TextStyle(fontSize: 16)
      ),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<List<InventoryOutItemView>>(
      stream: _inventoryOutItemStreamController.stream,
      builder: (context, snapshot) {
        return _buildListView(snapshot.data);
      },
    );
  }

  Widget _buildListView(List<InventoryOutItemView> list) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView (
            children: <Widget>[
              _buildHeaderForm(widget.inventoryOut),
              for(var i = 0; i < (list?.length??0); i ++)
                _buildListItem(list[i], i)
            ],
          ),
        ),
      ],
    );
  }



  Widget _buildHeaderForm(InventoryOutView item) {
    const double ROW_HEIGHT = 20;
    return PreferredSize(
      child: Container(
        margin: EdgeInsets.only(left: 5, right: 5, top: 5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Color.fromRGBO(255, 0, 0, 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: STextStyle.GRADIENT_COLOR1,
                width: 2
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Table(
              border: _tableBorder,
              columnWidths: {0: FixedColumnWidth(130)},
              children: [
                TableRow(
                    children: [
                      TableCell(
                        child: Container(
                          height: ROW_HEIGHT,
                          alignment: Alignment.centerLeft,
                          child: SText(
                            _inventoryOut.code.replaceAll("<mark>", "").replaceAll("</mark>", ""),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      TableCell(
                        child: Row(
                          children: <Widget>[
                           ReqinvoutStatusDropdown.getStatusIcon(_inventoryOut.status, 20),
                            SText(
                              ' ' + ReqinvoutStatusDropdown.getStatusName(_inventoryOut.status),
                            ),
                          ],
                        ),
                      ),

                      TableCell(
                        child: Container(
                          height: ROW_HEIGHT,
                          alignment: Alignment.centerLeft,
                          child: SText(
                            Util.getDateTimeStr(_inventoryOut.inventoryDate),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ]
                ),
              ],
            ),
            Table(
              border: _tableBorder,
              //columnWidths: {0: FixedColumnWidth(130)},
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.category, size: 16,),
                          Flexible(
                            child: Container(
                              height: ROW_HEIGHT,
                              alignment: Alignment.centerLeft,
                              child: SText(
                                " " + ReqinvoutTypeDropdown.getTypeName(_inventoryOut.inventoryType)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    TableCell(
                      child: Container(
                        height: ROW_HEIGHT,
                        alignment: Alignment.centerLeft,
                        child: SText(
                          _inventoryOut.warehouseId==null ? L10n.ofValue().defaultWarehouse : _inventoryOut.warehouseName??''
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Table(
              border: _tableBorder,
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Row(
                        children: <Widget>[
                          PartnerTypeDropdown.getIconForPartnerType(_inventoryOut.partnerType, 16),
                          Flexible(
                            child: Container(
                              height: ROW_HEIGHT,
                              alignment: Alignment.centerLeft,
                              child: SText(
                                ' ' + (_inventoryOut.partnerName??'').replaceAll("<mark>", "").replaceAll("</mark>", "")
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if((_inventoryOut.contactName?.length??0)>0 || (_inventoryOut.contactPhone?.length??0)>0 )
            Table(
              border: _tableBorder,
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Table(
                        border: _tableBorder,
                        children: [
                          TableRow(children: [
                            if((_inventoryOut.contactName?.length??0)>0)
                              Row(
                                children: <Widget>[
                                  Icon(Icons.contact_phone, size: 16),
                                  Container(
                                    height: ROW_HEIGHT,
                                    alignment: Alignment.centerLeft,
                                    child: SText(
                                        ' ' + _inventoryOut.contactName??''
                                    ),
                                  ),
                                ],
                              ),
                            if((_inventoryOut.contactPhone?.length??0)>0)
                              Container(
                                height: ROW_HEIGHT,
                                alignment: Alignment.centerLeft,
                                child: SText(
                                    _inventoryOut.contactPhone??''
                                ),
                              )
                          ])
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Table(
              border: _tableBorder,
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Row(
                        children: <Widget>[
                          Icon(FontAwesomeIcons.userTie, size: 16),
                          Flexible(
                            child: Container(
                              height: ROW_HEIGHT,
                              alignment: Alignment.centerLeft,
                              child: SText(
                                ' ' + _inventoryOut.requesterName??''
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if((_inventoryOut.content?.length??0)>0)
            Table(
               border: _tableBorder,
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.content_copy, size: 16,),
                          Flexible(
                            child: Container(
                              height: ROW_HEIGHT,
                              alignment: Alignment.centerLeft,
                              child: SText(
                                ' ' + _inventoryOut.content??'',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if((_inventoryOut.notes?.length??0)>0)
            Table(
              border: _tableBorder,
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.edit, size: 16,),
                          Flexible(
                            child: Container(
                              height: ROW_HEIGHT,
                              alignment: Alignment.centerLeft,
                              child: SText(
                                ' ' + _inventoryOut.notes??'',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }

  Widget _buildListItem(InventoryOutItemView item, int index) {
    var headerStyle = TextStyle(fontSize: 12);
    var subList = List.from(_fullList.where((test) => test.itemId == item.itemId));
    var contentStyle = TextStyle(fontSize: 12);
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5, top: 5),
      padding: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.grey,
              width: 2
          )
      ),
      child: Row(
        children: <Widget>[
          RotatedBox(
            quarterTurns: 3,
            child: Container(
              alignment: Alignment.center,
              width: 20,
              child: SText('${index + 1}', style: TextStyle(fontSize: 16),),
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Table(
                  border: _tableBorder,
                  children: [
                    TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: SHtml(data:
                                      item.itemCode,
                                      defaultTextStyle: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SText('${item.qty??0}', style: TextStyle(fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ),
                          ),
                        ]
                    ),
                  ],
                ),
                Table(
                  border: _tableBorder,
                  children: [
                    TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              height: 22,
                              padding: const EdgeInsets.only(left: 2),
                              child: SHtml(data:
                                item.itemName,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ]
                    ),
                  ],
                ),
                Table(
                  border: _tableBorder,
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: {1: FixedColumnWidth(40)},
                  children: [
                    ///header
                    TableRow(
                      children: [
                        Table(
                          border: _tableBorder,
                          children: [
                            TableRow(children: [
                              SText(L10n.ofValue().lotModel, style: headerStyle, textAlign: TextAlign.center,),
                              SText(L10n.ofValue().dateSerial, style: headerStyle, textAlign: TextAlign.center,),
                              SText(L10n.ofValue().limitDate, style: headerStyle, textAlign: TextAlign.center,),
                            ]),
                          ],
                        ),
                        SText(L10n.ofValue().shortDeliveredQty, style: headerStyle, textAlign: TextAlign.center,),
                      ]
                    ),
                    ///content
                    for(var i = 0; i < subList.length; i++)
                      _buildSubItem(subList[i], contentStyle),

                  ],
                ),

//                if ((item.notes?.length??0)>0)
//                Table(
//                  border: _tableBorder,
//                  children: [
//                    TableRow(
//                      children: [
//                        Padding(
//                          padding: const EdgeInsets.only(left: 2),
//                          child: Text(
//                            item.notes,
//                            maxLines: 1,
//                            style: contentStyle.merge(TextStyle(fontStyle: FontStyle.italic)),
//                          ),
//                        ),
//                      ]
//                    ),
//                  ],
//                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  TableRow _buildSubItem(InventoryOutItemView item, TextStyle contentStyle) {
    return TableRow(
      children: [
        Table(
          border: _tableBorder,
          children: [
            TableRow(
              children: [
                Table(
                  border: _tableBorder,
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: SText(_getLotModel(item), style: contentStyle, textAlign: TextAlign.center, ),
                        ),
                        SText(_getDateSerial(item), style: contentStyle, textAlign: TextAlign.center,),
                        SText('${Util.getDateStr(item.limitDate)}', style: contentStyle.merge(TextStyle(color: Colors.red)), textAlign: TextAlign.center,),
                      ]
                    )
                  ],
                )
              ]
            ),
            TableRow(
                children: [
                  if ((item.barcode?.length??0) > 0)
                    Table(
                      border: _tableBorder,
                      children: [
                        TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: Row(
                                  children: <Widget>[
                                    Icon(FontAwesomeIcons.barcode, size: 14),
                                    Text(
                                      ' ' +item.barcode,
                                      maxLines: 1,
                                      style: contentStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ]
                        ),
                      ],
                    )
                  else
                    SizedBox(height: 0,)
                ]
            ),
            TableRow(
                children: [
                  if ((item.notes?.length??0) > 0)
                    Table(
                      border: _tableBorder,
                      children: [
                        TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: Text(
                                  item.notes,
                                  maxLines: 1,
                                  style: contentStyle.merge(TextStyle(fontStyle: FontStyle.italic)),
                                ),
                              ),
                            ]
                        ),
                      ],
                    )
                  else
                    SizedBox(height: 0,)
                ]
            ),
          ],
        ),
        SText('${item.qty??0}', style: contentStyle, textAlign: TextAlign.right,)
      ]
    );
  }

  String _getLotModel(InventoryOutItemView item) {
    if((item.model?.length??0) > 0)
      return item.model;
    else
      return item.lot??'';
  }

  String _getDateSerial(InventoryOutItemView item) {
    if((item.serial?.length??0) > 0)
      return item.serial;
    else
      return Util.getDateStr(item.expireDate);
  }

  @override
  void dispose() {
    super.dispose();
    _inventoryOutItemStreamController.close();
  }


}