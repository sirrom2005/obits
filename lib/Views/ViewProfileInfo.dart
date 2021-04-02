import 'package:flutter/material.dart';
import 'package:obituaries/Classes/RouteSlider.dart';
import 'package:obituaries/Models/Account.dart';
import 'package:obituaries/Models/Obituary.dart';

import '../GoLive.dart';
import 'ProfileInfoLayout.dart';
import 'viewProfileEventListItem.dart';

Widget viewProfileInfo(double screenHeight, double screenWidth, Account acc, Orituary person)
{
  bool isHeightLess550 = screenHeight<550 ? true : false;
  return
    Column(
      children: <Widget>[
        profilePhotoView(screenWidth, screenHeight, Colors.black, person.fullName, person.avatarUrl),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 10, 0),
            child: Align(alignment: Alignment.topLeft, child: Text("Upcoming Services", style: TextStyle(color: Colors.black, fontSize:screenHeight<550 ? 14 : 16)))
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: new Divider(color: Colors.black),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height:person.events.length==0 ? null : ((screenHeight * 0.3)).floorToDouble(),
            child:
            person.events.length==0 ?
            Text('None found', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),) :
            ListView.separated(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: person.events.length,
              itemBuilder: (BuildContext context, int index) {
                return
                GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: viewProfileEventListItem(screenWidth, isHeightLess550, person.events.elementAt(index)),
                    onTap:(){
                      var args = <String, dynamic>{
                        "account"       : acc,
                        "obitId"        : person.events.elementAt(index).id,
                        "fullName"      : person.fullName,
                        "profilePicUrl" : person.avatarUrl,
                        "eventType"     : person.events.elementAt(index).eventType,
                        "date"          : person.events.elementAt(index).date,
                        "time"          : person.events.elementAt(index).time
                      };
                      Navigator.push(context, RouteSlider(page: GoLive(args), dir: Direction().ZERO));
                    }
                );
              },
              separatorBuilder: (BuildContext context, int index) => Divider(height:0,color: Colors.white, thickness:0,),
            ),
          )
        )
      ],
    );
}