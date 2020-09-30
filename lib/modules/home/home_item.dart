import 'package:flutter/material.dart';

class NotificationItem {
  int groupId;
  String name;
  Icon icon;
  String assetIcon;
  int totalNotify;
  DateTime lastNotify;
  NotificationItem({this.icon, @required this.groupId, this.name, this.assetIcon, this.totalNotify, this.lastNotify});
}