import 'package:flutter/material.dart';
import 'package:mobile/locale/locales.dart';
import 'package:mobile/system/loader/data.dart';
import 'package:mobile/widgets/scircular_progress_indicator.dart';

class SplashPage extends StatefulWidget {

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(146, 0, 4, 1),
      body: Center(
        child: FittedBox(
          child: Column(
            children: <Widget>[
              Text(L10n.of(context).connectingToApiServer, style: TextStyle(color: Colors.white),),
              SizedBox(height: 20,),
              SCircularProgressIndicator.buildSmallCenter()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
