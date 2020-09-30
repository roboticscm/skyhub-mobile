import 'dart:convert';

import 'package:mobile/common/global_function.dart';
import 'package:mobile/common/http.dart';
import 'package:mobile/common/tuple.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/sales/quotation/quotation_model.dart';
import 'package:mobile/modules/sales/request_po/request_po_model.dart';

class QuotationAPI {
  Future<Tuple2<List<QuotationView>, String>> textSearch({
      bool defaultSearch,
      int userId,
      int empId,
      int customerId,
      String text,
      String content,
      String refNo,
      String customerName,
      List<int> statusRange,
      List<int> yearRange,
      int currentPage,
      int pageSize}) async {
    const URL = 'sales/quotation/text-search';

    try {
      var url = '$URL?empId=${empId??""}' +
        '&userId=${userId??""}' +
        '&customerId=${customerId??""}' +
        '&defaultSearch=$defaultSearch' +
        '&yearRange=${yearRange != null ? yearRange.join(","): ""}' +
        '&statusRange=${statusRange!=null ? statusRange.join(",") : "" }' +
        '&text=${Uri.encodeComponent(text??"")}' +
        '&refNo=${Uri.encodeComponent(refNo??"")}' +
        '&content=${Uri.encodeComponent(content??"")}' +
        '&customerName=${Uri.encodeComponent(customerName??"")}' +
        '&page=$currentPage' +
        '&pageSize=$pageSize';

      var response = await Http.get(url);

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        print(list);
        return Tuple2(list.map((model) => QuotationView.fromJson(model)).map((item) {
          if(text!=null && text.length > 0){
            item.code = item.code.replaceAll(text, "<mark>" + text + "</mark>");
            item.content = item.content.replaceAll(text, "<mark>" + text + "</mark>");
            item.customerName = item.customerName.replaceAll( text, "<mark>" + text + "</mark>");
          }

          if(refNo!=null && refNo.length > 0){
            item.code = item.code.replaceAll(refNo, "<mark>" + refNo + "</mark>");
          }
          if(content!=null && content.length > 0){
            item.content = item.content.replaceAll(content, "<mark>" + content + "</mark>");
          }
          if(customerName!=null && customerName.length > 0){
            item.customerName = item.customerName.replaceAll(customerName, "<mark>" + customerName + "</mark>");
          }
          return item;
        }).toList(), null);
      } else {
        return Tuple2(null, response.body);
      }
    }
    catch (e) {
      print('error1 ' + e.toString());
      return Tuple2(null, L10n.ofValue().connectApiError);
    }
  }

  Future<Tuple2<List<QuotationItemView>, String>> findQuotationItem({
    int quotationId}) async {
    const URL = 'sales/quotation/find-quotation-item';
    print(URL);
    try {
      var url = '$URL?quotationId=${quotationId??""}';
      var response = await Http.get(url);

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return Tuple2(list.map((model) => QuotationItemView.fromJson(model)).toList(), null);
      } else {
        return Tuple2(null, response.body);
      }
    }
    catch (e) {
      print('error1 ' + e.toString());
      return Tuple2(null, L10n.ofValue().connectApiError);
    }
  }

  Future<Tuple2<List<QuotationView>,String>> findQuotationById(int id) async {
    const URL = 'sales/quotation/quotation-by-id';
    try {
      var url ='$URL?id=$id';
      print(url);
      var response = await Http.get(url);

      if (response.statusCode == 200) {
        //var deleted = json.decode(response.body);
        //return Tuple2(true, null);
       // log2(json.decode(response.body));
        Iterable list = json.decode(response.body);
        return Tuple2(
            list.map((model) => QuotationView.fromJson(model))
                .toList(), null);
        //return Tuple2(QuotationView.fromJson(json.decode(response.body)),null);
      } else {
        return Tuple2(null, '${L10n.ofValue().resourceError} \n ${response.statusCode} \n ${response.body}' );
      }
    }
    catch (e) {
      print('error ' + e.toString());
      return Tuple2(null, '${L10n.ofValue().connectApiError}' );
    }
  }
}