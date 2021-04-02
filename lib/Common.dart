import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:obituaries/Models/Account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Common {
  static final String tagAdminPhoto = "tagAdminPhoto";
  static final String tagProfilePhoto = "tagProfilePhoto";
  final bool isIos = Platform.isIOS ? true : false;

  Future<void> showAlertBox(BuildContext _context, String title, String message) async {
    message = message.replaceAll("Exception: ", "");
    return showDialog<void>(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext c) {
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
                FlatButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(_context).pop();
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
                    Navigator.of(_context).pop();
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

  saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("key_token", token);
  }

  Future<String> getSavedToken() async
  {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("key_token") ?? "_pref_error_token_not_found_";
  }

  saveAccount(Account acc) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('key_account', acc!=null ? json.encode(acc) : null);
  }

  Future<Account> getAccount() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String s =  prefs.getString('key_account') ?? null;
    if(s!=null){
      return new Account.fromJson(json.decode(s));
    }
    return null;
  }
}