import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:obituaries/Common.dart';
import 'package:obituaries/Models/Account.dart';
import 'package:obituaries/Models/Obituary.dart';
import 'package:obituaries/Services/Service.dart';
import 'package:obituaries/Views/ViewObits.dart';
import 'package:obituaries/Views/ViewOrbitTemplate.dart';

import 'Login.dart';

Account _account;

class Obits extends StatefulWidget {
  static const String id = "obits";

  final Account args;

  Obits(this.args){
    _account = this.args;
  }

  @override
  _MyObitsPageState createState() => _MyObitsPageState();
}

class _MyObitsPageState extends State<Obits>
{
  bool dataDidLoad = false;
  bool isHeightLess550;
  double screenWidth, screenHeight;
  Account account;
  List<Orituary> T = [];
  List<Orituary> persons = [];
  TextEditingController textController = new TextEditingController();

  final bool isIos = Platform.isIOS ? true : false;

  backBtn(){}

  closeBtn(){
    Navigator.pop(context);
  }

  _filterOrbits(e){
    List<Orituary> tmp = T.where((per) => per.fullName.toLowerCase().contains(e.toString().toLowerCase())).toList();

    setState(() {
      persons = tmp;
    });
  }

  Future<Null> getOrbituaries() async
  {
    String token = await Common().getSavedToken();

    if(token != "_pref_error_token_not_found_") {
      try {
        T = await Services().getOrituary(token);

        setState(() {
          persons = T;
          dataDidLoad = true;
        });
      } catch (e) {
        showConfirmationBox(context, "Error", '$e');
        //Navigator.pop(context);
      }
    }else{
      //Need message box for reason
      Common().saveToken(null);
      Common().saveAccount(null);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Login()),
          ModalRoute.withName('/')
      );
    }
  }

  @override
  void initState(){
    super.initState();

    textController.addListener(() {
      _filterOrbits(textController.text);
    });

    Future.delayed(Duration.zero, () {
      getOrbituaries();
    });
  }

  Widget infoWindow(){
    return viewObits(screenHeight, screenWidth, dataDidLoad, account, persons, textController);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
    isHeightLess550 = screenHeight<550 ? true : false;
    account = _account;
    return layoutFrame(this, false, isHeightLess550);
  }


  showConfirmationBox(BuildContext __context, String title, String message) {
    message = message.replaceAll("Exception: ", "");
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext _context) {
        return
          isIos ?
          CupertinoAlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(message, style: TextStyle(fontSize: 16))
                  ],
                ),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop("Discard");
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: Text('Retry'),
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                    getOrbituaries();
                  },
                ),
              ]
          ) :
          AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(message, style: TextStyle(fontSize: 16))
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop("Discard");
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('Retry'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    getOrbituaries();
                  },
                ),
              ],
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              elevation: 24
          );
      },
    );
  }
}
