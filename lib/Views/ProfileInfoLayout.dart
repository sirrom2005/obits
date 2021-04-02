import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget adminPhotoView(double screenWidth, double screenHeight, Color textColor, bool welcome, String name, String avatarUrl){
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      _imageBlock(screenWidth, avatarUrl),
      SizedBox(height:25),
      Text(
        (welcome ? "Welcome\n" : "") + name,
        style: TextStyle(color: textColor, fontSize: screenWidth<550 ? 20 : 26 ),textAlign: TextAlign.center,
      )
    ],
  );
}


Widget profilePhotoView(double screenWidth, double screenHeight, Color textColor, String text, String photoUrl){
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      Container(
        height: screenWidth/2.6,
        child: _imageBlock(screenWidth, photoUrl)
      ),
      SizedBox(height:screenHeight<550 ? 25 : 30),
      Text(
        text,
        style: TextStyle(color: textColor, fontSize:screenHeight<550 ? 20 : 26),textAlign: TextAlign.center,
      )
    ],
  );
}

_imageBlock(screenWidth, photoUrl){
  return
    Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(screenWidth/2.6),
          child: CachedNetworkImage(
            width: screenWidth/2.6,
            height:screenWidth/2.6,
            fit: BoxFit.cover,
            errorWidget: (context, url, error){
              return Image.asset("lib/images/default_profile.png", fit:BoxFit.fill ,width: screenWidth/2.6, height:screenWidth/2.6);
            },
            progressIndicatorBuilder: (context, url, progress) => CircularProgressIndicator(value: progress.progress),
            imageUrl: photoUrl,
          ),
        )
      ]
    );
}