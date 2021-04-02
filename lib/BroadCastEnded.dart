import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'Dashboard.dart';
import 'Views/ProfileInfoLayout.dart';

class BroadCastEnded extends StatefulWidget {
  static const String id = "broadcastended";

  @override
  _BroadCastEndedState createState() => _BroadCastEndedState();
}

class _BroadCastEndedState extends State<BroadCastEnded>
{
  Map<String, dynamic> args;
  double screenWidth, screenHeight;

  @override
  Widget build(BuildContext context)
  {
    args = ModalRoute.of(context).settings.arguments;
    Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;

    return Scaffold(
        body: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          child: Container(
            child:
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'Your live stream\nbroadcast has ended.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize:20),
                      ),
                      SizedBox(height:32),
                      profilePhotoView(screenWidth, screenHeight, Colors.black, args["fullName"], args["profilePicUrl"]),
                      SizedBox(height:8),
                      Text(args["eventType"], style: TextStyle(color: new Color(0xFF159343), fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height:39),
                      MaterialButton(
                        height:45,
                        minWidth: 250,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        color: new Color(0xFF2F2B43),
                        child:Text(
                          'BACK TO HOME',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        onPressed:(){
                          setState((){
                            Navigator.of(context).pushAndRemoveUntil(
                              CupertinoPageRoute(
                                  builder: (context) => DashBoard()
                              ), (_) => false,
                            );
                          });
                        } ,
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        )
    );
  }
}