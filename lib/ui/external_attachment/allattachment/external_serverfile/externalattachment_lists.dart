import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_loader.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/network/models/external_dictations/get_all_external_attachments_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/external_dictations/get_external_document_details.dart';
import 'package:YOURDRS_FlutterAPP/network/models/external_dictations/get_external_photos.dart';
import 'package:YOURDRS_FlutterAPP/network/services/external_attachment/all_external_attachment_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../external_component.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';

class ExternalAttachmentScreen extends StatefulWidget {
  static const String routeName = '/ExternalAttachments';

  @override
  _ExternalAttachmentScreenState createState() =>
      _ExternalAttachmentScreenState();
}

class _ExternalAttachmentScreenState extends State<ExternalAttachmentScreen> {
  GetExternalDocumentDetails getExternalDocumentDetails;
  ExternalDocumentList externalDocuments;

  AllMyExternalAttachments apiServices = AllMyExternalAttachments();
  GetExternalDocumentDetailsService apiService2 =
      GetExternalDocumentDetailsService();
  GetExternalPhotosService apiService3 = GetExternalPhotosService();

  // ignore: unused_field
  List<ExternalAttachmentsDoc> _list = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    final Map arguments = ModalRoute.of(context).settings.arguments;
    getExternalDocumentDetails = arguments["getExternalDocumentDetails"];
    externalDocuments = arguments["externalDocuments"];
    _list = getExternalDocumentDetails.attachments;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomizedColors.ExtAppbarColor,
          toolbarHeight: 70,
          automaticallyImplyLeading: true,
          title: Container(
              child: Text(
            externalDocuments?.displayFileName ?? "",
            style: TextStyle(
              fontSize: 18,
              fontFamily: AppFonts.regular,
            ),
            overflow: TextOverflow.fade,
          )),
          centerTitle: true,
        ),
        body: ListView(shrinkWrap: false, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppStrings.casedetails_text,
                style: TextStyle(
                    fontFamily: AppFonts.regular,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: CustomizedColors.customeColor),
              ),
            ),
            CustomTile(
                text1: AppStrings.practice_text,
                text2: getExternalDocumentDetails?.practiceName ?? "NA"),
            Divider(
              color: CustomizedColors.primaryColor,
              height: 0,
            ),
            CustomTile(
                text1: AppStrings.locationtxt,
                text2: getExternalDocumentDetails?.locationName ?? "NA"),
            Divider(
              color: CustomizedColors.primaryColor,
              height: 0,
            ),
            CustomTile(
                text1: AppStrings.doc_text,
                text2:
                    getExternalDocumentDetails?.externalDocumentTypeName ?? ""),
            Divider(
              color: CustomizedColors.primaryColor,
              height: 0,
            ),
            CustomTile(
                text1: AppStrings.provider,
                text2: getExternalDocumentDetails?.providerName ?? "NA"),
            Divider(
              color: CustomizedColors.primaryColor,
              height: 0,
            ),
            CustomTile(
                text1: AppStrings.name_text,
                // text2: getExternalDocumentDetails?.patientFirstName ?? ""),
                text2: getExternalDocumentDetails?.patientFirstName +
                        "\t" +
                        getExternalDocumentDetails.patientLastName ??
                    "NA"),
            Divider(
              color: CustomizedColors.primaryColor,
              height: 0,
            ),
            CustomTile(
                text1: AppStrings.dob_text,
                text2: getExternalDocumentDetails?.dob ?? "NA"),
            Divider(
              color: CustomizedColors.primaryColor,
              height: 0,
            ),
            CustomTile(
                text1: AppStrings.isemergency_text,
                text2:
                    getExternalDocumentDetails?.isEmergencyAddOn.toString() ==
                            "true"
                        ? 'yes'
                        : 'no'),
            Divider(
              color: CustomizedColors.primaryColor,
              height: 0,
            ),
            CustomTile(
                text1: AppStrings.description,
                text2: getExternalDocumentDetails.description ?? "NA"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppStrings.uploadedattachments_text,
                style: TextStyle(
                    fontFamily: AppFonts.regular,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: CustomizedColors.customeColor),
              ),
            ),
            Center(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 280,
                    child: _list != null || _list.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            scrollDirection: Axis.vertical,
                            itemCount: _list.length,
                            itemBuilder: (context, index) {
                              ExternalAttachmentsDoc item = _list[index];
                              return Card(
                                child: ListTile(
                                    leading: Container(
                                      // alignment: Alignment.centerLeft,
                                      height: height * 0.08,
                                      width: width * 0.70,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            item.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: AppFonts.regular,
                                            ),
                                          )),
                                    ),
                                    trailing: TextButton(
                                      onPressed: () async {
                                        showLoaderDialog(context,
                                            text: AppStrings.loading);
                                        //-----------------get external attachments photos api
                                        GetExternalPhotos getExternalPhotos =
                                            await apiService3
                                                .getExternalPhotos(item.name);

                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
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
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.6,
                                                      child: Image.network(
                                                        getExternalPhotos
                                                            .fileName,
                                                        fit: BoxFit.cover,
                                                        // fit: BoxFit
                                                        //     .fitHeight,
                                                        loadingBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Widget child,
                                                                ImageChunkEvent
                                                                    loadingProgress) {
                                                          if (loadingProgress ==
                                                              null)
                                                            return child;
                                                          return Center(
                                                            child:
                                                                CupertinoActivityIndicator(
                                                              radius: 20,
                                                            ),
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
                                            ),
                                          ),
                                        );
                                      },
                                      child: Icon(Icons.remove_red_eye),
                                    )),
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
          ])
        ]));
  }
}
