import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'dart:async';
import 'Dashboard.dart';
import 'Models/Account.dart';
import 'Services/Service.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'Common.dart';

class Login extends StatefulWidget {
  static const String id = "login";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const String openAccountUrl = "https://www.joinobit.com/";

class _MyHomePageState extends State<Login>
{
  bool _isLoading = false;
  final bool isIos = Platform.isIOS ? true : false;
  bool isHeightLess550;
  double screenWidth, screenHeight;
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  bool isEmailValid;
  FocusNode emailFocus = new FocusNode();
  FocusNode passwordFocus = new FocusNode();

  StreamController<String> emailStreamController;
  StreamController<String> passwordStreamController;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    emailStreamController = StreamController<String>.broadcast();
    passwordStreamController = StreamController<String>.broadcast();

    emailController.addListener(() {
      emailStreamController.sink.add(emailController.text.trim());
    });
    passwordController.addListener(() {
      passwordStreamController.sink.add(passwordController.text.trim());
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailStreamController.close();
    passwordStreamController.close();
  }

  Color getColor(String text, FocusNode focus) {
    if (focus.hasFocus && text == null) {
      return Colors.black;
    }
    if (focus.hasFocus && text.isEmpty) {
      return Colors.redAccent;
    } else if (focus.hasFocus && text.isNotEmpty) {
      return Colors.blueAccent;
    } else {
      return Colors.black;
    }
  }

  String errorMessage(String text, String message) {
    if (text == null) {
      return '';
    } else if (text.isEmpty) {
      return message;
    } else {
      return '';
    }
  }

  String validateEmail(String text, String message) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    isEmailValid = true;
    if (text == null) {
      return '';
    }
    if (!regex.hasMatch(text)) {
      isEmailValid = false;
      return message;
    }
    else
      return '';
  }

  submitLogin() async{
    _isLoading = true;

    if (_formKey.currentState.validate()) {
      try {
        final Account account = await Services().login(_email.trim(), _password.trim());
        if(account.id != null ){
          Common().saveToken(account.authToken);
          Common().saveAccount(account);
          Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
                builder: (context) => DashBoard()
            ), (_) => false,
          );
        }else{
          Common().showAlertBox(context, "Login Error", account.message);
        }
      }catch(e){
        Common().showAlertBox(context, "Login Error", '$e');
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget _logo() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, screenHeight*0.12, 0, 25),
      child: Image(image: AssetImage('lib/images/logo.png'), height: isHeightLess550 ? 30 : 38,),
    );
  }

  Widget _termAndCondition() {
    return Text(
        'By using our service you agree to our terms and\n'
        'conditions, privacy policy, cookies policy, and confirm\n'
        'that you are at least 16 years old.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize:isHeightLess550 ? 10 : 12),
    );
  }

  Widget _loginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          StreamBuilder(
            stream: emailStreamController.stream,
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    focusNode: emailFocus,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: getColor(snapshot.data, emailFocus),
                        )
                    ),
                    onChanged:(String e){
                      _email = e;
                    }
                  ),
                  Container(
                    child: Text(
                      validateEmail(snapshot.data, "Email is required"),
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  )
                ],
              );
            }
          ),
          SizedBox(height:isHeightLess550 ? 2 : 20),
          StreamBuilder(
            stream: passwordStreamController.stream,
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    obscureText: true,
                    focusNode: passwordFocus,
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(
                        color: getColor(snapshot.data, passwordFocus),
                      ),
                    ),
                    onChanged: (String e){
                      _password = e;
                    },
                  ),
                  Container(
                    child: Text(
                      errorMessage(snapshot.data, "Password is required"),
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  )
                ],
              );
            }
          ),
          Padding(
            padding: isHeightLess550 ? const EdgeInsets.fromLTRB(8, 25, 8, 25) : const EdgeInsets.fromLTRB(10, 35, 10, 35),
            child: Container(
              width: double.infinity,
              child: MaterialButton(
                height:isHeightLess550 ? 35 : 45,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                ),
                color: new Color(0xFF2F2B43),
                child:Text(
                  'LOGIN',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: isHeightLess550 ? 12 : 15.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
                onPressed:(){
                  if (emailController.text.trim().isEmpty)
                    emailStreamController.sink.add(emailController.text.trim());
                  if (passwordController.text.trim().isEmpty)
                    passwordStreamController.sink.add(passwordController.text.trim());
                  if(!passwordController.text.trim().isEmpty && isEmailValid) {
                    setState(() {
                      submitLogin();
                    });
                  };
                } ,
              ),
            ),
          ),
          InkWell(
            child: Text(
              'Don’t have an account?\nSign up on our website.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize:14),
            ),
            onTap: () async {
              if (await canLaunch(openAccountUrl)) {
                await launch(openAccountUrl);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
    isHeightLess550 = screenHeight<550 ? true : false;
    double sideMargin = (screenWidth * 0.09).floorToDouble();

    return Scaffold(
      body: LoadingOverlay(
        isLoading: _isLoading,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
        child: SingleChildScrollView(
          child: Container(
            height: screenHeight,
            child: Padding(
              padding: EdgeInsets.fromLTRB(sideMargin, 0, sideMargin, 0),
              child: Column(
                children: [
                  Expanded(
                    flex: 90,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _logo(),
                          _loginForm(),
                        ],
                      ),
                  ),
                  Expanded(
                    flex: 10,
                    child: _termAndCondition(),
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
