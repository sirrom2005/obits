import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:obituaries/Models/Obituary.dart';

Widget viewObitsItemList(double screenWidth, Orituary obj, isHeightLess550){
  double _circleDiameter = screenWidth * 0.15;
  return
    Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          child: Padding(
            padding: isHeightLess550 ? const EdgeInsets.fromLTRB(0, 10, 0, 10) : const EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      width: _circleDiameter,
                      height:_circleDiameter,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error){
                        return Image.asset("lib/images/default_profile.png", fit:BoxFit.fill ,width: _circleDiameter, height:_circleDiameter);
                      },
                      progressIndicatorBuilder: (context, url, progress) => CircularProgressIndicator(value: progress.progress,),
                      imageUrl: obj.avatarUrl,
                    ),
                  ),
                ),
                Positioned(
                  top:0,
                  bottom:0,
                  left:_circleDiameter+10,
                  right:32,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(obj.fullName, style: TextStyle(fontSize:isHeightLess550 ? 15 : 20),)
                  ),
                ),
                Positioned(
                    right: 0,
                    top:0,
                    bottom:0,
                    child: Icon(Icons.arrow_forward_ios, size:isHeightLess550 ? 18 : 20))
              ],
            ),
          ),
        ),
        Divider(height:1, color: Color(0xFFE3E3E3))
      ],
    );
}