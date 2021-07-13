import 'dart:io';

import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/helper/db_helper.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/photo_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';

class OfflineManualImages extends StatefulWidget {
  var id;
  OfflineManualImages({this.id});
  @override
  _OfflineManualImagesState createState() => _OfflineManualImagesState();
}

class _OfflineManualImagesState extends State<OfflineManualImages> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Manual dictation Images"),
        centerTitle: true,
        backgroundColor: CustomizedColors.accentColor,
      ),
      body: Center(
        child: Container(
            width: width,
            height: height,
            child: FutureBuilder<List<PhotoList>>(
                future: DatabaseHelper.db
                    .getManualAttachmentImages(widget.id),
                builder: (BuildContext context,
                    AsyncSnapshot<List<PhotoList>> snapshot) {
                  try {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        primary: false,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          PhotoList item = snapshot.data[index];
                          return Card(
                            child: ListTile(
                                title: Container(
                                  alignment: Alignment.centerLeft,
                                  height: height*0.08,
                                  width: width*0.70,
                                  child: Text(
                                    item.attachmentname,
                                    style: TextStyle(
                                      fontFamily: AppFonts.regular,
                                    ),
                                  ),
                                ),
                                trailing: TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => Dialog(
                                          child:
                                          Stack(
                                            children: [
                                          FullScreenWidget(
                                          child:
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height*0.6,
                                                child:
                                                // PhotoView.customChild(
                                                //   child:
                                                  Container(
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    height:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height*0.7,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: FileImage(new File(item.physicalfilename)),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                  right: 1,
                                                  top: 1,
                                           child: InkWell(onTap:(){
                                                Navigator.of(context,
                                                      rootNavigator: true)
                                                            .pop();
                                                     },
                                                          child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(140)),
                                                       child:Icon(Icons.cancel,color: Colors.black,size: 25,),

                                      ),
                                    )
                                              ),
                                            ],
                                          )
                                      ),
                                    );
                                  },
                                  child: Icon(
                                      Icons.remove_red_eye,
                                    color: CustomizedColors.customeColor,
                                  ),
                                )
                            ),
                          );
                        },
                      );
                    }else{
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              AppStrings.noresultsfoundrelatedsearch,
                              style: TextStyle(
                                  fontFamily: AppFonts.regular,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: CustomizedColors
                                      .buttonTitleColor),
                            ),
                          )
                        ],
                      );
                    }
                  } on PlatformException {}
                  return Container();
                })),
      ),
    );
  }
}
