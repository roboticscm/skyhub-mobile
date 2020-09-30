import 'package:flutter/material.dart';

class SCircularProgressIndicator {
  static Widget buildSmallCenter(){
    return Center(child: SizedBox( width: 40, height: 40, child: CircularProgressIndicator()));
  }

  static Widget buildSmallest(){
    return FittedBox(
        fit: BoxFit.scaleDown,
        child: LimitedBox(
            maxWidth: 20,
            maxHeight: 20,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.green),
            )
        )
    );
  }

}