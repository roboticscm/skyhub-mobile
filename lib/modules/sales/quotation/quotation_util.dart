import 'package:flutter/material.dart';

class QuotationUtil {
  static Color getQtyColor(String type) {
    switch(type){
      case "qty":
        return Colors.black;
      case "deliveredQty":
        return Color.fromRGBO(0x66, 0, 0, 1);
      case "remainedQty":
      case "waitingOutQty":
        return Color.fromRGBO(0xFF, 0, 0, 1);
      case "stockQty":
        return Color.fromRGBO(0, 0, 0xFF, 1);
      default:
        return Colors.black;
    }
  }
}