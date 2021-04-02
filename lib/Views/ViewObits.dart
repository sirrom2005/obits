import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:obituaries/Classes/RouteSlider.dart';
import 'package:obituaries/Models/Account.dart';
import 'package:obituaries/Models/Obituary.dart';
import 'package:obituaries/ProfileInfo.dart';
import 'ViewObitsItemList.dart';

Widget viewObits(double screenHeight, double screenWidth, bool dataDidLoad, Account acc, List<Orituary> persons, textController)
{
  bool isHeightLess550 = screenHeight <550 ? true : false;

  return
    Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Padding(
        padding: isHeightLess550 ? const EdgeInsets.fromLTRB(0, 0, 0, 18) : const EdgeInsets.fromLTRB(0, 0, 0, 25),
        child: Text(
            "Broadcast a Live Stream\nMemorial Service",
            style: TextStyle(
              color: Colors.black,
              fontSize: isHeightLess550 ? 16 : 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center),
      ),
      Container(
          height:isHeightLess550 ? 40 : 52,
          decoration: BoxDecoration(
              color: new Color(0xFFF9F9F8),
              borderRadius: BorderRadius.circular(30)
          ),
          child: TextField(
            controller: textController,
              decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: new Color(0xFFF9F9F8), width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: new Color(0xFFF9F9F8), width: 1.0),
                  ),
                  hintText: 'Search Obits',
                  hintStyle: TextStyle(fontSize:isHeightLess550 ? 12 :14),
                  icon: Padding(
                    padding: isHeightLess550 ? const EdgeInsets.fromLTRB(10, 0, 0, 0) : const EdgeInsets.fromLTRB(15, 0, 0, 0) ,
                    child: Icon(Icons.search, size:isHeightLess550 ? 18 : 20)
                  )
              )
          )
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 25, 10, 0),
          child: Align(alignment: Alignment.topLeft, child: Text("Your Obit's", style: TextStyle(color: Colors.black, fontSize:isHeightLess550 ? 13 : 16)))
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: new Divider(color: Colors.black),
      ),
      SingleChildScrollView(
        //TO DO fix height
        scrollDirection: Axis.vertical,
        child: Container(
          height:((screenHeight * 0.45)).floorToDouble(),
          child:
          persons.length == 0 ?
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Text(dataDidLoad? 'Obits Not Found' : "", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18))
          ) :
          ListView.separated(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount: persons.length,
            itemBuilder: (BuildContext context, int index)
            {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: viewObitsItemList(screenWidth, persons.elementAt(index), isHeightLess550),
                onTap:(){
                  Map<String, dynamic> args = {
                    "account": acc,
                    "person" : persons.elementAt(index)
                  };
                  Navigator.push(context, RouteSlider(page: ProfileInfo(args), dir: Direction().ZERO));
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