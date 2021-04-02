import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:obituaries/Common.dart';
import 'package:obituaries/Login.dart';
import 'package:obituaries/Models/Account.dart';
import 'package:obituaries/obits.dart';

import 'Classes/RouteSlider.dart';
import 'Views/ProfileInfoLayout.dart';

class DashBoard extends StatefulWidget {
  static const String id = "dashboard";

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with SingleTickerProviderStateMixin
{
  Account args;
  bool _isLoading = false;
  bool isCallapsed = true;
  double screenWidth, screenHeight;
  bool isHeightLess550;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<Offset> _whiteBgSlideAnimation;

  getAccountPrefs() async {
    args = await Common().getAccount();
    if(args==null) {
      Navigator.pushNamedAndRemoveUntil(
          context, Login.id,
          ModalRoute.withName('/')
      );
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _whiteBgSlideAnimation = Tween<Offset>(begin: Offset(0, 0.95), end: Offset(0, 0)).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _profileButton() {
    return
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 16, 0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: InkWell(
                    child: Icon(isCallapsed? Icons.person : Icons.close, size: screenWidth * 0.06, color: Colors.black),
                    onTap:(){
                      setState(() {
                        if(isCallapsed)
                          _controller.forward();
                        else
                          _controller.reverse();
                        isCallapsed = !isCallapsed;
                      });
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  Widget _playHoverButton() {
    return MaterialButton(
      padding: EdgeInsets.all(10),
      shape: CircleBorder(),
      color: Colors.white,
      child:Image.asset('lib/images/record_icon.png', width:screenWidth/8.6, height:screenWidth/8.6),
      onPressed:(){
        setState(() {
          Navigator.push(context, RouteSlider(page: Obits(args), dir: Direction().UP));
        });
      } ,
    );
  }

  Widget _logoutScreen(BuildContext context) {
    return Container(
      child:
      SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                adminPhotoView(screenWidth, screenHeight, new Color(0xFF2F2B43), false, args.name, args.avatar_url),
                SizedBox(height:65),
                MaterialButton(
                  height:isHeightLess550 ? 35 : 45,
                  minWidth: 250,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                  color: new Color(0xFF2F2B43),
                  child:Text(
                    'LOGOUT',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: isHeightLess550 ? 12 : 15.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  onPressed:(){
                    setState(() {
                      _isLoading = true;
                      Future.delayed(const Duration(milliseconds: 1500), () {
                        Common().saveToken(null);
                        Common().saveAccount(null);
                        args = null;
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) => Login()),
                            ModalRoute.withName('/')
                        );
                      });
                    });
                  } ,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _dash(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          adminPhotoView(screenWidth, screenHeight, Colors.white, true, args.name, args.avatar_url),
          Padding(
              padding: EdgeInsets.fromLTRB(0, screenHeight * 0.1, 0, screenHeight * 0.1),
              child: Text('Tap the icon to begin streaming.', style: TextStyle(color: Colors.white, fontSize:15))
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
    isHeightLess550 = screenHeight<550 ? true : false;

    return Scaffold(
        body: LoadingOverlay(
          isLoading: _isLoading,
          opacity: 0.5,
          progressIndicator: CircularProgressIndicator(),
          child: FutureBuilder(
            future: getAccountPrefs(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return
                  Container(
                    color: new Color(0xFF2F2B43),
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Expanded(
                              flex: 85,
                              child: _dash(context),
                            ),
                            Expanded(
                              flex: 15,
                              child: Container(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: screenHeight * 0.1,
                          child: _playHoverButton(),
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: SlideTransition(
                            position: _whiteBgSlideAnimation,
                            child: Container(
                              color: Colors.white,
                              width: double.infinity,
                              height: double.infinity,
                              child: Visibility(
                                  visible: isCallapsed ? false : true,
                                  child: _logoutScreen(context)
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: _profileButton()
                        )
                      ],
                    ),
                  );
              }
            }
          ),
        )
    );
  }
}