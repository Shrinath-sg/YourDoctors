import 'dart:convert';
import 'dart:io';

import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';
import 'package:YOURDRS_FlutterAPP/common/app_loader.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_toast_message.dart';
import 'package:YOURDRS_FlutterAPP/helper/db_helper.dart';
import 'package:YOURDRS_FlutterAPP/network/models/external_dictations/external_database_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/external_dictation_attachment_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/photo_list.dart';
import 'package:YOURDRS_FlutterAPP/network/services/external_attachment/external_localtoserver_postapi.dart';
import 'package:YOURDRS_FlutterAPP/ui/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:YOURDRS_FlutterAPP/utils/route_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/app_text.dart';
import 'allattachment/external_serverfile/external_getattachments.dart';
import 'external_submitnew/external_submitscreen.dart';

class ExternalAttachments extends StatefulWidget {
  static const String routeName = '/ExternalAttachments';
  @override
  _ExternalAttachmentStat createState() => _ExternalAttachmentStat();
}

class _ExternalAttachmentStat extends State<ExternalAttachments> {
  AppToast appToast = AppToast();
  bool isInternetAvailable = false;

  bool emergencyAddOn = true;
  int toggleVal;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        //  MaterialApp(
        // debugShowCheckedModeBanner: false,
        //  home:
        //  WillPopScope(
        //    onWillPop: () =>
        //      RouteGenerator.navigatorKey.currentState
        //          .pushReplacementNamed(CustomBottomNavigationBar.routeName)
        //    ,
        //    child:
        Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                CustomBottomNavigationBar.routeName,
                (Route<dynamic> route) => false);
          },
        ),
        backgroundColor: CustomizedColors.appbarColor,
        title: Text(
          AppStrings.externalAttachment,
          style: TextStyle(fontFamily: AppFonts.regular, fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.cloud_upload_outlined, size: 35),
              onPressed: () async {
                ///sync offline records to server
                List<ExternalAttachmentList> offlineRecords =
                    await DatabaseHelper.db.getAllExtrenalAttachmentList();

                /// Each manual record
                bool isInternetAvailable = await AppConstants.checkInternet();
                if (isInternetAvailable == true) {
                  if (offlineRecords.length != 0) {
                    showLoaderDialog(context, text: AppStrings.uploading);
                    for (ExternalAttachmentList record in offlineRecords) {
                      toggleVal = record.isemergencyaddon;
                      List<PhotoList> offlinePhotoList = await DatabaseHelper.db
                          .getAttachmentImages(record?.id);

                      /// Each offline manual photo for id
                      var photoListOfGallery = [];
                      for (PhotoList photo in offlinePhotoList) {
                        String filePath = photo.physicalfilename;
                        List<int> fileBytes =
                            await File(filePath).readAsBytes();
                        String convertedImg = base64Encode(fileBytes);

                        photoListOfGallery.add({
                          "header": {
                            "status": "string",
                            "statusCode": "string",
                            "statusMessage": "string"
                          },
                          "content": convertedImg,
                          "name": photo?.attachmentname,
                          "attachmentType": photo?.attachmenttype
                        });
                      }

                      try {
                        if (toggleVal == 0) {
                          emergencyAddOn = false;
                        } else {
                          emergencyAddOn = true;
                        }
                        ExternalAttachmentDataApi apiAttachmentPostServices =
                            ExternalAttachmentDataApi();
                        SaveExternalDictationOrAttachment
                            saveDictationAttachments =
                            await apiAttachmentPostServices
                                .postApiServiceMethod(
                          record?.practiceid,
                          //selectedPracticeId
                          record?.locationid,
                          //locationId
                          record?.providerid,
                          //providerId
                          record?.patientfirstname,
                          //patientFname
                          record?.patientlastname,
                          //patientLname
                          record?.patientdob,
                          //patientDob
                          record?.memberid.toString(),
                          //memberId
                          record?.externaldocumenttypeid,
                          //externalDocumentTypeId
                          emergencyAddOn,
                          //isemergencyAddon
                          record?.description,
                          //description
                          null,
                          //content
                          null,
                          //name
                          null,
                          //attachmentType
                          photoListOfGallery, //
                        );

                        String statusCode =
                            saveDictationAttachments?.header?.statusCode;
                        //printing status code
                        // print("status $statusCode");
                        int externalDocumentUploadId =
                            saveDictationAttachments?.externalDocumentUploadId;
                        if (statusCode == '200' &&
                            externalDocumentUploadId != null) {
                          await DatabaseHelper.db
                              .updateExternalAttachmentRecord(
                                  1, externalDocumentUploadId, record?.id);
                          Navigator.of(context).pop();
                          appToast
                              .showToast(AppStrings.uploadedsuccessfully_text);
                        } else {
                          // print(
                          // "error !!!!!!!!!!!!!!!!!!!!!!!!!! ${saveDictationAttachments?.header?.statusMessage}");
                        }
                        await RouteGenerator.navigatorKey.currentState
                            .pushReplacementNamed(
                                ExternalAttachments.routeName);
                      } catch (e) {
                        // print(
                        // 'SaveAttachmentDictation exception ${e.toString()}');
                      }
                    }
                  } else {
                    appToast.showToast(AppStrings.noofflinerecordsfound_text);
                  }
                } else {
                  appToast.showToast(AppStrings.connection_text);
                }
              })
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(maxHeight: 150.0),
              child: Container(
                child: TabBar(
                  tabs: [
                    Tab(
                        child: Text(
                      AppStrings
                          .submitNew, //here we called the text for SubmitNew
                      style: TextStyle(
                        fontFamily: AppFonts.regular,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CustomizedColors.submitnew_textColor,
                      ),
                    )),
                    Tab(
                      child: Text(
                        AppStrings
                            .allattachment, //here we called the text for AllAttachment
                        style: TextStyle(
                          fontFamily: AppFonts.regular,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CustomizedColors.allattachment_textColor,
                        ),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(boxShadow: [
                  new BoxShadow(
                    color: Colors.white,
                  ),
                ]),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  //
                  SubmitNew(),
                  GetMyAttachments(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    //   ),
    // );
  }
}
