import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:obituaries/Models/Account.dart';
import 'package:obituaries/Views/ViewOrbitTemplate.dart';

import 'Dashboard.dart';
import 'Views/ViewGoLive.dart';

Map<String, dynamic> _map;
class GoLive extends StatefulWidget {
  static const String id = "golive";

  Map<String, dynamic> args;

  GoLive(this.args){
    _map = args;
  }

  @override
  _MyGoLiveState createState() => _MyGoLiveState();
}

class _MyGoLiveState extends State<GoLive>
{
  BuildContext myContext;
  double screenWidth, screenHeight;
  bool isHeightLess550;
  Map<String, dynamic> _data;
  Account account;
  final bool isIos = Platform.isIOS ? true : false;

  backBtn(){
    Navigator.pop(context);
  }

  closeBtn(){
    Navigator.pushNamedAndRemoveUntil(
        context,
        DashBoard.id,
        ModalRoute.withName('/'),
        arguments: account
    );
  }

  Widget infoWindow(){
    return viewGoLive(myContext, screenWidth, screenHeight, _data, isHeightLess550);
  }

  @override
  Widget build(BuildContext context) {
    myContext = context;
    Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
    isHeightLess550 = screenHeight<550 ? true : false;
    _data = _map;//ModalRoute.of(context).settings.arguments;
    account = _data["account"];

    return layoutFrame(this, true, isHeightLess550);
  }
}
