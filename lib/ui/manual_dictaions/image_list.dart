import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_loader.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/network/models/external_dictations/get_all_manual_dictation_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/external_dictations/get_external_document_details.dart';
import 'package:YOURDRS_FlutterAPP/network/models/external_dictations/get_external_photos.dart';
import 'package:YOURDRS_FlutterAPP/network/services/dictation/dictation_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';

class Manualimages extends StatefulWidget {
  final List<String> photolist;
  // const Manualimages({Key key}) : super(key: key);
  //var memberPhotos;
  Manualimages({this.photolist});

  @override
  _ManualimagesState createState() => _ManualimagesState();
}

class _ManualimagesState extends State<Manualimages> {
  List<ExternalAttachmentsDoc> _list = [];
//  List<String>listImages;
  AudioDictations audioDictations = AudioDictations();
  GetManualPhotosService apiServices2 = GetManualPhotosService();
  //final AudioDictations audioDictations = _audioDictates[index];
  // String memberPhotos= audioDictations.photoNameList;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Manual dictation Images"),
        centerTitle: true,
        backgroundColor: CustomizedColors.accentColor,
      ),
      body: Center(
          child: Container(
              height: height,
              //color:Colors.yellow,
              child: widget.photolist != null || widget.photolist.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      scrollDirection: Axis.vertical,
                      itemCount: widget.photolist.length,
                      itemBuilder: (context, index) {
                        // ExternalAttachmentsDoc item =
                        //     _list[index];

                        return Card(
                          //color: Colors.yellow,
                          child: ListTile(
                            leading: Container(
                              //alignment: Alignment.centerLeft,
                              //  color: Colors.green,
                              height: height * 0.08,
                              width: width * 0.70,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.photolist[index],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: AppFonts.regular,
                                  ),
                                ),
                              ),
                            ),
                            trailing: TextButton(
                              onPressed: () async {
                                showLoaderDialog(context,
                                    text: AppStrings.loading);
                                //-----------------get external attachments photos api
                                GetExternalPhotos getExternalPhotos =
                                    await apiServices2.getManualPhotos(
                                        widget.photolist[index]);

                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    child: Stack(
                                      children: [
                                        FullScreenWidget(
                                          child: Container(
                                            //  height: 416,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            // height: ,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.7,
                                            child:
                                                // // PhotoView
                                                // //     .customChild(
                                                // //   //onTapDown: Icon(),
                                                // //   child:
                                                Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.6,
                                              child: Image.network(
                                                getExternalPhotos.fileName,
                                                fit: BoxFit.cover,
                                                // fit: BoxFit
                                                //     .fitHeight,
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent
                                                            loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Center(
                                                      child:
                                                          CupertinoActivityIndicator(
                                                    radius: 20,
                                                  )
                                                      // Shimmer
                                                      //     .fromColors(
                                                      //   baseColor:
                                                      //   Colors
                                                      //       .black54,
                                                      //   highlightColor:
                                                      //   Colors
                                                      //       .grey,
                                                      //   period: Duration(
                                                      //       milliseconds:
                                                      //       1000),
                                                      //   child:
                                                      //   Container(
                                                      //     width: MediaQuery.of(
                                                      //         context)
                                                      //         .size
                                                      //         .width,
                                                      //     height: MediaQuery.of(context)
                                                      //         .size
                                                      //         .height,
                                                      //
                                                      //     color: Colors
                                                      //         .deepOrange,
                                                      //   ),
                                                      // )
                                                      //     CupertinoActivityIndicator(
                                                      //   radius: 20,
                                                      // ),
                                                      );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            right: 1,
                                            top: 1,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                              },
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            140)),
                                                child: Icon(
                                                  Icons.cancel,
                                                  color: Colors.black,
                                                  size: 25,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Icon(Icons.remove_red_eye),
                              //),
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      child: Center(
                        child: Text(
                          AppStrings.noimagefound_text,
                          style: TextStyle(
                            color: CustomizedColors.actionsheettext,
                            fontFamily: AppFonts.regular,
                          ),
                        ),
                      ),
                    ))),
    );
  }
}
