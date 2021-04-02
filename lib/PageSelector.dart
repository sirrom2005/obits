import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:obituaries/Login.dart';
import 'Dashboard.dart';
import 'Models/Account.dart';
import 'Common.dart';

class PageSelector extends StatefulWidget {
  static const String id = "pageSelector";

  @override
  _MyPageSelectorState createState() => _MyPageSelectorState();
}

class _MyPageSelectorState extends State<PageSelector>
{
  getAccountPrefs() async {
    Account acc = await Common().getAccount();
    if(acc!=null) {
      Navigator.pushNamedAndRemoveUntil(
          context, DashBoard.id,
          ModalRoute.withName('/'),
          arguments: acc
      );

//      var args = <String, dynamic>{
//        "account"       : new Account(id:10, name:"asasa", avatar_url: ""),
//        "obitId"        : 1,
//        "fullName"      : "Jhon",
//        "profilePicUrl" : "https://www.newmynamepix.com/upload/post/sample/1575707401_Beautiful_Cool_Girl_Hand_Writing_Your_Name_Dp_Picture.jpg",
//        "eventType"     : "xxxx",
//        "date"          : "12/12/12",
//        "time"          : "1:00pm",
//        "authToken"     :"authToken_authToken_authToken"
//      };
//      Navigator.push(context, RouteSlider(page: GoLive(args), dir: Direction().ZERO));

    }else{
      Navigator.pushNamedAndRemoveUntil(
          context, Login.id,
          ModalRoute.withName('/')
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getAccountPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Material(color: Colors.white,);
  }
}
