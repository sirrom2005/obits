import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget layoutFrame(_mainWindow, showBackBtn, isHeightLess550)
{
  double imgSize = isHeightLess550 ? 34 : 44;
  return Scaffold(
      resizeToAvoidBottomPadding:false,
      body: Container(
          color: new Color(0xFF2F2B43),
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 14,
                  child:
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(isHeightLess550 ? 25 : 36, 0, 0, 0),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(imgSize),
                              child: CachedNetworkImage(
                                width: imgSize,
                                height: imgSize,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error){
                                  return Image.asset("lib/images/default_profile.png", fit:BoxFit.fill,width: imgSize, height: imgSize);
                                },
                                progressIndicatorBuilder: (context, url, progress) => CircularProgressIndicator(value: progress.progress,),
                                imageUrl:_mainWindow.account.avatar_url,
                              ),
                            ),
                            SizedBox(width:isHeightLess550 ? 5 : 10),
                            Expanded(child: Text(_mainWindow.account.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: isHeightLess550 ? 12 : 16)))
                          ],
                        ),
                      ),
                    ),
                  )
                //_orbitTopProfileLayout(_mainWindow.account, isHeightLess550)
              ),
              Expanded(
                flex: 86,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(isHeightLess550 ? 40 : 50),
                            topLeft:  Radius.circular(isHeightLess550 ? 40 : 50)
                        )
                    ),
                    child: Padding(
                      padding: isHeightLess550 ? const EdgeInsets.fromLTRB(20, 10, 20, 0) : const EdgeInsets.fromLTRB(30, 20, 30, 0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                  child: showBackBtn ? Icon(Icons.arrow_back_ios, size:isHeightLess550 ? 25 : 25) : SizedBox(height:isHeightLess550 ? 27 : 32),
                                  onTap: (){
                                    _mainWindow.backBtn();
                                  },
                                ),
                                InkWell(
                                  child: Icon(Icons.close, size:isHeightLess550 ? 27 : 32),
                                  onTap: (){
                                    _mainWindow.closeBtn();
                                  },
                                )
                              ],
                            ),
                          ),
                          _mainWindow.infoWindow()
                        ],
                      ),
                    )
                ),
              )
            ],
          )
      )
  );
}