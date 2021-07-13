import 'dart:io';

import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/helper/db_helper.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/photo_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';

import '../external_component.dart';

class ExternalattachmentType extends StatefulWidget {
  static const String routeName = '/ExternalAttachments';
  var displayfilename;
  var practicename;
  var locationname;
  var externaldocumenttype;
  var providername;
  var patientfirstname;
  var patientlastname;
  var patientdob;
  var isemergencyaddon;
  var description;
  var attachmentId;
  var attachmnetname;
  var physicalImage; //image fethcing variable
  var uploadedtoserver;
  ExternalattachmentType(
      {this.attachmentId,
      this.displayfilename,
      this.practicename,
      this.locationname,
      this.externaldocumenttype,
      this.providername,
      this.patientfirstname,
      this.patientdob,
      this.isemergencyaddon,
      this.description,
      this.physicalImage,
      this.attachmnetname,
      this.uploadedtoserver,
      this.patientlastname});

  @override
  _ExternalattachmentTypeState createState() => _ExternalattachmentTypeState();
}

class _ExternalattachmentTypeState extends State<ExternalattachmentType> {
  bool isLoadingPath = false;
  bool emergencyAddOn = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomizedColors.ExtAppbarColor,
          toolbarHeight: 70,
          automaticallyImplyLeading: true,
          title: Container(
              child: Text(
            widget.displayfilename,
            style: TextStyle(
              fontSize: 18,
              fontFamily: AppFonts.regular,
            ),
            overflow: TextOverflow.fade,
          )),
          centerTitle: true,
        ),
        body: ListView(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppStrings.casedetails_text,
                style: TextStyle(
                    fontFamily: AppFonts.regular,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
            ),
            CustomTile(
                text1: AppStrings.practice_text,
                text2: widget.practicename ?? 'NA'),
            Divider(
              color: Colors.blue,
              height: 0,
            ),
            CustomTile(
                text1: AppStrings.locationtxt,
                text2: widget.locationname ?? 'NA'),
            Divider(
              color: Colors.blue,
              height: 0,
            ),
            CustomTile(
                text1: AppStrings.doc_text,
                text2:
                    widget.externaldocumenttype ?? 'ExternalDocumentType NA'),
            Divider(
              color: Colors.blue,
              height: 0,
            ),
            CustomTile(
                text1: AppStrings.provider, text2: widget.providername ?? 'NA'),
            Divider(
              color: Colors.blue,
              height: 0,
              thickness: 0.60,
            ),
            // CustomTile(text1: AppStrings.name_text, text2: widget.patientfirstname??null),
            CustomTile(
                text1: AppStrings.name_text,
                text2:
                    widget.patientfirstname + "\t" + widget.patientlastname ??
                        "NA"),
            Divider(
              color: Colors.blue,
              height: 0,
              thickness: 0.60,
            ),
            CustomTile(
                text1: AppStrings.dob_text, text2: widget.patientdob ?? "NA"),
            Divider(
              color: Colors.blue,
              height: 0,
            ),
            CustomTile(
                text1: AppStrings.isemergency_text,
                text2: widget.isemergencyaddon.toString() == "true"
                    ? 'yes'
                    : 'no'),
            Divider(
              color: Colors.blue,
              height: 0,
            ),
            CustomTile(
                text1: AppStrings.description,
                text2: widget.description ?? "NA"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppStrings.uploadedattachments_text,
                style: TextStyle(
                    fontFamily: AppFonts.regular,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
            ),
            //--------------fetching images from local data base
            Container(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 280,
                  child: FutureBuilder<List<PhotoList>>(
                      future: DatabaseHelper.db
                          .getAttachmentImages(widget.attachmentId),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<PhotoList>> snapshot) {
                        try {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              primary: false,
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                PhotoList item = snapshot.data[index];
                                return Card(
                                  child: ListTile(
                                      leading: Container(
                                        //  alignment: Alignment.centerLeft,
                                        height: 100,
                                        width: 280,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            item.attachmentname,
                                            style: TextStyle(
                                              fontFamily: AppFonts.regular,
                                            ),
                                          ),
                                        ),
                                        // ),
                                      ),
                                      trailing: TextButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) => Dialog(
                                                child: Stack(
                                              children: [
                                                FullScreenWidget(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.7,
                                                    child:
                                                        // // PhotoView.customChild(
                                                        // //   child:
                                                        Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.6,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: FileImage(
                                                                  new File(item
                                                                      .physicalfilename)),
                                                              fit: BoxFit
                                                                  .cover)),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    right: 1,
                                                    top: 1,
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                      },
                                                      child: Card(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        140)),
                                                        child: Icon(
                                                          Icons.cancel,
                                                          color: Colors.black,
                                                          size: 25,
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            )),
                                          );
                                        },
                                        child: Icon(Icons.remove_red_eye),
                                      )),
                                );
                              },
                            );
                          }
                        } on PlatformException {}
                        return Container();
                      })),
            )
          ])
        ]));
  }
}
