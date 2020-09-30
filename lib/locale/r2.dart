import 'dart:convert';

import 'package:mobile/common/http.dart';
import 'package:mobile/common/tuple.dart';

class R2 {
  static Future<void> loadFromAPI() async {
    const URL = 'lang/find-all';
    try {
      var response = await Http.getWithoutToken(URL, 1);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        list.forEach((item){
          languages.putIfAbsent(item["key"], () => Tuple2(item["en"], item["vi"]));
        });
      }
    }
    catch (e) {
      print('error: ' + e.toString());
    }
  }

  static String locale = 'en';
  static Map<String, Tuple2<String, String>> languages = Map();

  static String r(String key) {
    if (languages == null)
      return '#';
    switch (locale){
      case 'vi':
        return languages[key]?.item2 ?? '#$key';
      default:
        return languages[key]?.item1 ?? '#$key';
    }
  }
}