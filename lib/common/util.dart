import 'dart:io';
import 'dart:math';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:intl/intl.dart';
import 'package:device_info/device_info.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/modules/calendar/lunar/lunar_solar_converter.dart';
import 'package:mobile/modules/chat/chat_model.dart';
import 'package:rxdart/rxdart.dart';
import 'common.dart';
import 'tuple.dart';

class Util {
  static String getSubStringWholeWord(String source, int maxLen) {
    if(source.trim().length <= maxLen)
      return source;

    var len = min(maxLen, source.length);
    source = source.substring(0, len);
    if (source.contains(' ')) {
      while (len > 0) {
        len--;
        if (source.codeUnitAt(len) == 32)///space bar
          break;
      }
    }
    return source.substring(0, len) + "...";
  }

  static String getEasyReadingDateTime(DateTime now, DateTime source)  {
    if (now == null || source == null) {
      return '';
    }

    if (now.difference(source).inDays == 0) {
      return DateFormat.Hm().format(source);
    }

    return DateFormat.yMd().format(source);
  }

  static DateTime getSmallestDate()  {
    return DateTime(1900, 1, 1);
  }

  static String getDateStr(DateTime source) {
    if (source == null)
      return '';

    return DateFormat.yMd().format(source);
  }

  static String getDateTimeStr(DateTime source) {
    if (source == null)
      return '';

    return DateFormat.yMd().format(source) + " - " + DateFormat.Hm().format(source);
  }

  static String getDateTimeWithoutYearStr(DateTime source) {
    if (source == null)
      return '';

    return DateFormat.Hm().format(source) + ' - ' + DateFormat.Md().format(source);
  }

  static String getTimeStr(DateTime source) {
    if (source == null)
      return '';
    return DateFormat.Hm().format(source);
  }

  static String getShortDateTimeStr(DateTime source) {
    if (source == null)
      return '';
    return  DateFormat.Md().format(source) + " " + (source.hour<10 ? '0${source.hour}' : '${source.hour}') + ":" + (source.minute<10 ? '0${source.minute}' : '${source.minute}');
  }

  static updateBadgerNotification(int number) async {
    bool isSupported = await FlutterAppBadger.isAppBadgeSupported();
    if (isSupported) {
      if (number!=null && number > 0)
        FlutterAppBadger.updateBadgeCount(number);
      else
        FlutterAppBadger.removeBadge();
    }
  }

  static Future<void> playMessageTone() async {
    AudioPlayer audioPlayer = new AudioPlayer();
    AudioCache audioCache = new AudioCache(fixedPlayer: audioPlayer);

    try {
      //await audioCache.play('message_tone.mp3');
      await audioCache.play('message.wav');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<String> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.brand + ' - ' + androidInfo.model + ' - OS: Android ' + androidInfo.version.release;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.utsname.machine + ' - ' + iosInfo.model;
    } else
      return 'Generic Mobile Device';
  }

  static Future<String> getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.brand + ' - ' + androidInfo.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.utsname.machine + ' - ' + iosInfo.model;
    } else
      return 'Generic Mobile Device';
  }

  static Future<String> getDeviceOS() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return  'Android ' + androidInfo.version.release;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.utsname.version;
    } else
      return 'Unkown OS';
  }

  static double getScreenWidth() {
    return MediaQuery.of(GlobalParam.appContext).size.width;
  }

  static double getScreenHeight() {
    return MediaQuery.of(GlobalParam.appContext).size.height;
  }

  static bool isPhoneScreen() {
    return getScreenWidth () < 640;
  }

  static int calcNumOfGridColumn() {
    return (getScreenWidth()/200).round();
  }

  static Future<int> getTotalNotify(List<SkyNotification> list) {
    if (list == null || list.length == 0 )
      return Future.value(0);
    return Observable(Stream.fromIterable(list))
        .where((item) => ![
       SkyNotification.GROUP_EMPLOYEE
    ].contains(item.displayId))
        .map((item) => item.count)
        .switchIfEmpty(Stream.fromFuture(Future.value(0)))
        .reduce((v1, v2) => v1 + v2);
   // return Stream.fromIterable(list).map((item) => item.count).reduce((v1, v2) => v1 + v2);
  }

  static Future<int> getTotalBottomNotify(List<SkyNotification> list) {
    if (list == null || list.length == 0 )
      return Future.value(0);
    return Observable(Stream.fromIterable(list))
      .where((item) => ![
        SkyNotification.GROUP_MESSAGE,  SkyNotification.GROUP_EMPLOYEE
        ].contains(item.displayId))
      .map((item) => item.count)
      .switchIfEmpty(Stream.fromFuture(Future.value(0)))
      .reduce((v1, v2) => v1 + v2);
  }


  static String _getNotifyDesc(int groupId) {
    switch (groupId) {
      case SkyNotification.GROUP_EMPLOYEE:
        return L10n.of(GlobalParam.appContext).employee;
      case SkyNotification.GROUP_TRAVELING:
        return L10n.of(GlobalParam.appContext).traveling;
      case SkyNotification.GROUP_QOTATION:
        return L10n.of(GlobalParam.appContext).quotation;
      case SkyNotification.GROUP_HOLIDAY:
        return L10n.of(GlobalParam.appContext).holiday;
      case SkyNotification.GROUP_INVENTORYOUT:
        return L10n.of(GlobalParam.appContext).reqInventoryOut;
      case SkyNotification.GROUP_INVENTORYIN:
        return L10n.of(GlobalParam.appContext).reqInventoryIn;
      case SkyNotification.GROUP_REQPO:
        return L10n.of(GlobalParam.appContext).reqPo;
      case SkyNotification.GROUP_MESSAGE:
        return L10n.of(GlobalParam.appContext).message;
      case SkyNotification.GROUP_EVENT:
        return L10n.of(GlobalParam.appContext).event;
      case SkyNotification.GROUP_TASK:
        return L10n.of(GlobalParam.appContext).task;
      default:
        return '';
    }
  }

  static Future<String> getNotificationDesc(List<SkyNotification> list) {
    if (list == null || list.length == 0 )
      return Future.value('');

    return Stream.fromIterable(list).where((item) => item.count > 0)
      .map((item) => _getNotifyDesc(item.displayId) + ': ' + item.count.toString())
      .join(", ");
  }

  static Future<int> getNotificationByGroupId(int groupId) {
    if (groupId == null || GlobalParam.notify == null || GlobalParam.notify.length == 0)
      return Future.value(0);

    return Observable(Stream.fromIterable(GlobalParam.notify)).where((item) => item.displayId == groupId)
      .map((item) => item.count)
      .switchIfEmpty(Stream.fromFuture(Future.value(0)))
      .single;
  }

  static Future<DateTime> getLastNotifyByGroupId(int groupId) {
    if (groupId == null || GlobalParam.notify == null || GlobalParam.notify.length == 0)
      return Future.value(getSmallestDate());

    return Observable(Stream.fromIterable(GlobalParam.notify)).where((item) => item.displayId == groupId)
        .map((item) => item.sendDate)
        .switchIfEmpty(Stream.fromFuture(Future.value(getSmallestDate())))
        .single;
  }



  static Future<String> generateUUID() async {
    String uuid;
    try {
      uuid = await FlutterUdid.udid;
      uuid = uuid.toUpperCase();
    } catch (e) {
      uuid = 'Failed to get UUID.';
    }
    return uuid;
  }

  static Color getColorByExpireDate(DateTime date) {
    if (date == null)
      return Color.fromRGBO(0x0, 0x64, 0xFF, 1);

    var days = date.difference(DateTime.now()).inDays;
    print(days);
    if (days <= 0)
      return Color.fromRGBO(0xFF, 0x0, 0x0, 1);
    else if (days > 0 && days <= 60)
      return Color.fromRGBO(0xFF, 0x14, 0x93, 1);
    else if (days > 60 && days <= 180)
      return Color.fromRGBO(0xFF, 0x8C, 0x0, 1);
    else if (days > 180 && days <= 365)
      return Color.fromRGBO(0x99, 0x32, 0xCC, 1);
    else if (days > 365 && days <= 730)
      return Color.fromRGBO(0x0, 0x0, 0x0, 1);

    return Color.fromRGBO(0x0, 0x0, 0xFF, 1);
  }
  static String getDmyStr(DateTime date) {
    return '${DateFormat.d().format(date)}/${DateFormat.M().format(date)}/${DateFormat.y().format(date)}';
  }

  static String getDmyHmsStr(DateTime date) {
    return '${DateFormat.d().format(date)}/${DateFormat.M().format(date)}/${DateFormat.y().format(date)} ${DateFormat.H().format(date)}:${DateFormat.m().format(date)}:${DateFormat.s().format(date)}';
  }

  static getShortDateStr(DateTime source) {
    if (source == null)
      return '';

    return DateFormat.Md().format(source);
  }

  static double round0_5(double d) {
    return (d*2).round()/2;
  }

  static String getTextByLine(String text, int lines, bool useEllipsis) {
    const int LINE_LENGTH = 50;
    int len = min(LINE_LENGTH*lines, text.length);
    print(len.toString() + "-" + text.length.toString());
    if (len >= text.length)
      return text.substring(0, len);
    else
      return text.substring(0, len-3) + "...";
  }

  static String getLunarDateString(int lunarYear, int lunarMonth, int lunarDay) {
    return getLunarDateStringTuple(Tuple3(lunarYear, lunarMonth, lunarDay));
  }

  static String getLunarDateStringTuple(Tuple3<int, int, int> date) {
    return '${date.item3}/${date.item2}/${date.item1%2000}';// + L10n.ofValue().shortLunar;
  }

  static String getShortLunarDateStringTuple(Tuple3<int, int, int> date) {
    return '${date.item3}/${date.item2}';// + L10n.ofValue().shortLunar;
  }

  static String getShortLunarMonthStringTuple(Tuple3<int, int, int> date) {
    return '${date.item2}/${date.item1%2000}';// + L10n.ofValue().shortLunar;
  }

  static Tuple3<int, int, int> convertToLunarDate(DateTime source) {
    Solar solar = Solar(solarYear: source.year,
        solarMonth: source.month,
        solarDay: source.day
    );
    Lunar lunar = LunarSolarConverter.solarToLunar(solar);
    return Tuple3(lunar.lunarYear, lunar.lunarMonth, lunar.lunarDay);
  }


}