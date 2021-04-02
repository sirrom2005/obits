import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:obituaries/Models/Account.dart';
import 'package:obituaries/Models/Obituary.dart';
import 'package:obituaries/Views/ViewOrbitTemplate.dart';

import 'Dashboard.dart';
import 'Views/ViewProfileInfo.dart';

Map<String, dynamic> _map;
class ProfileInfo extends StatefulWidget {
  static const String id = "profileInfo";

  Map<String, dynamic> args;

  ProfileInfo(this.args){
    _map = args;
  }

  @override
  _MyProfileInfotState createState() => _MyProfileInfotState();
}

class _MyProfileInfotState extends State<ProfileInfo>
{
  double screenWidth, screenHeight;
  bool isHeightLess550;
  Orituary person;
  Account account;
  Map<String, dynamic> args;
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
    return viewProfileInfo(screenHeight, screenWidth, account, person);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
    isHeightLess550 = screenHeight<550 ? true : false;
    args = _map;
    person = args["person"];
    account = args["account"];

    return layoutFrame(this, true, isHeightLess550);
  }
}
