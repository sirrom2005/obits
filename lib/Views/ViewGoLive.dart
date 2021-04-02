import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:obituaries/BroadCastEnded.dart';
import 'package:obituaries/Services/Service.dart';
import 'ProfileInfoLayout.dart';

Widget viewGoLive(BuildContext context, double screenWidth, double screenHeight, Map<String, dynamic> _data, isHeightLess550)
{
  const platform = const MethodChannel("START_CAMERA_APP");

  _startCameraActivity() async{
    try {
      var args = <String, String>{
        "bambUserAppId"   : "aRbX2a26M7xIZ3TDWEc0RQ",
        "bambUserAppIosId": "4WYlHrCEnIVaU2aEZZNKoA",
        "userName"        : _data["account"].name,
        "fullName"        : _data["fullName"],
        "profilePicUrl"   : _data["profilePicUrl"],
        "eventType"       : _data["eventType"],
        "date"            : _data["date"],
        "time"            : _data["time"],
        "authToken"       : _data["account"].authToken,
        "SaveResourceUrl" : Services.API_ENDPOINT + "api/v1/services/" + _data["obitId"].toString(),
        "EndBroadcastUrl" : Services.API_ENDPOINT + "api/v1/bambuser/broadcasts/"
      };

      String rs = await platform.invokeMethod('startCameraActivity', args);

      if(rs == 'RESULT_BROADCAST_ENDED'){
        var args = <String, dynamic>{
          "account"       : _data["account"],
          "fullName"      : _data["fullName"],
          "profilePicUrl" : _data["profilePicUrl"],
          "eventType"     : _data["eventType"],
        };
        Navigator.pushNamed(context, BroadCastEnded.id, arguments: args);
      }
    } on PlatformException catch (e) {
      print("_startCameraActivity() >> " + e.message);
    }
  }

  return
    Column(
      children: <Widget>[
        profilePhotoView(screenWidth, screenHeight, Colors.black, _data['fullName'], _data['profilePicUrl']),
        SizedBox(height:14),
        Text(
          _data['eventType'],
          style: TextStyle(color: new Color(0xFF159343), fontWeight: FontWeight.bold, fontSize:isHeightLess550 ? 15 : 20),
        ),
        SizedBox(height:16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.calendar_today, size:isHeightLess550 ? 18 : 20),
            SizedBox(width:5),
            SizedBox(child: Text(_data['date'], style: TextStyle(color: Colors.black, fontSize:15)), width:165),
            Icon(Icons.access_time, size:isHeightLess550 ? 18 : 20),
            SizedBox(width:5),
            Text(_data['time'], style: TextStyle(color: Colors.black, fontSize:15)),
          ],
        ),
        SizedBox(height: isHeightLess550 ? screenHeight * 0.08 : screenHeight * 0.1),
        Text('You are about to start a\nlive stream broadcast.', style: TextStyle(fontSize:isHeightLess550 ? 15 : 17, color: Colors.black), textAlign: TextAlign.center),
        SizedBox(height:screenHeight * 0.04),
        Container(
          width: double.infinity,
          child: MaterialButton(
            height:isHeightLess550 ? 35 : 45,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(25.0),
            ),
            color: new Color(0xFF2F2B43),
            child:Text(
              'START A STREAM',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: isHeightLess550 ? 12 : 15.0,
                  fontWeight: FontWeight.bold
              ),
            ),
            onPressed:(){
              _startCameraActivity();
            }
          ),
        )
      ],
    );
}