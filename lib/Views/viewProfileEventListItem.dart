import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:obituaries/Models/Obituary.dart';

Widget viewProfileEventListItem(double screenWidth, bool isHeightLess550, Events _events) {
  return
    Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 22, 0, 22),
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _events.eventType,
                              style: TextStyle(color: new Color(0xFF159343), fontWeight: FontWeight.bold, fontSize:15),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.calendar_today, size:isHeightLess550 ? 18 : 20),
                            SizedBox(width:5),
                            SizedBox(child: Text(_events.date, style: TextStyle(color: Colors.black, fontSize:15)), width:165),
                            Icon(Icons.access_time, size:isHeightLess550 ? 18 : 20),
                            SizedBox(width:5),
                            Text(_events.time, style: TextStyle(color: Colors.black, fontSize:15)),
                          ],
                        ),
                      ],
                    ),
                  )
                ),
                Positioned(
                    right: 0,
                    top:0,
                    bottom:0,
                    child: Icon(Icons.arrow_forward_ios, size:isHeightLess550 ? 18 : 20)
                )
              ],
            ),
          ),
        ),
        Divider(height:1, color: Color(0xFFE3E3E3))
      ],
    );
}