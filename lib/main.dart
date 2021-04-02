import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:obituaries/BroadCastEnded.dart';

import 'Dashboard.dart';
import 'Login.dart';
import 'PageSelector.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Obits',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: PageSelector.id,
      routes: {
        PageSelector.id: (context) => PageSelector(),
        Login.id: (context) => Login(),
        //Obits.id: (context) => Obits(),
        DashBoard.id: (context) => DashBoard(),
        //ProfileInfo.id: (context) => ProfileInfo(),
        //GoLive.id: (context) => GoLive(),
        BroadCastEnded.id: (context) => BroadCastEnded()
      }
    );
  }
}