import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';
import 'package:YOURDRS_FlutterAPP/common/app_loader.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/common/app_toast_message.dart';
import 'package:YOURDRS_FlutterAPP/network/models/dictations/dictations_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/dictations/play_dictations.dart';
import 'package:YOURDRS_FlutterAPP/network/models/dictations/view_doc_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/home/schedule.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:YOURDRS_FlutterAPP/network/services/dictation/dictation_services.dart';
import 'package:YOURDRS_FlutterAPP/network/services/dictation/play_audio_services.dart';
import 'package:YOURDRS_FlutterAPP/widget/buttons/mic_button.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'play_audio.dart';

class DictationsList extends StatefulWidget {
  static const String routeName = '/DictationsList';
  @override
  _DictationsListState createState() => _DictationsListState();
}

class _DictationsListState extends State<DictationsList> {
  ViewDocumentService viewDocFileService = ViewDocumentService();
  final _key = UniqueKey();
  int roleId;
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var memberRoleId = (prefs.getString(Keys.memberRoleId) ?? '');
      roleId = int.tryParse(memberRoleId);
    });
  }

  bool isNetAvailable;
  var filePath;
  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    List<DictationItem> list = args['list'];
    final Map args3 = ModalRoute.of(context).settings.arguments;
    ScheduleList item = args3['item'];

    /// used to get the recording from the server
    getRecordings(String fileName, String displayFileName) async {
      Directory appDocDirectory;
      //platform checking conditions
      if (Platform.isIOS) {
        appDocDirectory = await getApplicationDocumentsDirectory();
      } else {
        appDocDirectory = await getExternalStorageDirectory();
      }
      String dir = appDocDirectory.path;
      String fileExists = "$dir/" + "$fileName";

      /// check whether the file is there or no in device storage
      if (File(fileExists).existsSync()) {
        filePath = fileExists;
        setState(() {
          isNetAvailable = true;
        });
      } else {
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi)
        {
          setState(() {
            isNetAvailable = true;
          });
          PlayAllAudioDictations apiServices1 = PlayAllAudioDictations();
          PlayDictations playDictations =
              await apiServices1.getDictationsPlayAudio(fileName);
          var getRecordings = playDictations.fileName;
          http.Response response = await http.get('$getRecordings');
          var _base64 = base64Encode(response.bodyBytes);
          Uint8List bytes = base64.decode(_base64);
          File file = File("$dir/" + '$displayFileName' + ".mp4");
          await file.writeAsBytes(bytes);
          filePath = file.path;
        } else {
          setState(() {
            isNetAvailable = false;
          });
        }
      }
    }

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '${item.patient?.displayName ?? ""}' +
                ', ${item.patient?.age.toString() + " " + AppStrings.yearOld ?? ""}' +
                ' ${item.patient?.sex ?? ""}',
            style: TextStyle(
              fontFamily: AppFonts.regular,
            ),
          ),
          backgroundColor: CustomizedColors.appBarColor,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 90,
            vertical: MediaQuery.of(context).size.height / 50,
          ),
          child: Column(
            children: [
              Container(
                child: Text(
                  AppStrings.dictationstxt,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.regular,
                  ),
                ),
                padding: EdgeInsets.only(bottom: 20),
              ),
              Flexible(
                child: ListView(
                  children: [
                    ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        var date1 =
                            DateFormat("MM/dd/yyyy").parse(list[index].dos);
                        final DateFormat formatter = DateFormat('yyyy-MM-dd');
                        final String formatted = formatter.format(date1);
                        return AnimationLimiter(
                            child: Column(children: [
                          AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              child: FadeInAnimation(
                                  child: SlideAnimation(
                                      horizontalOffset:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Card(
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    width: width * 0.55,
                                                    child: Text(
                                                      '${list[index].dictationType ?? ""}' +
                                                          ', ${formatted ?? ""}',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              AppFonts.regular,
                                                          fontSize: 14),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  list[index].transcriptionFileName !=
                                                          ""
                                                      ? Container(
                                                          width: width * 0.15,
                                                          color: CustomizedColors
                                                              .primaryBgColor,
                                                          child: IconButton(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            onPressed:
                                                                () async {
                                                          bool isNetOn =  await AppConstants.checkInternet();
                                                              if (isNetOn ==
                                                                  true) {
                                                                showLoaderDialog(
                                                                  context,
                                                                  text: AppStrings
                                                                      .loading,
                                                                );
                                                                ViewDocument
                                                                    docUrl =
                                                                    await viewDocFileService
                                                                        .getDocument(
                                                                            list[index].transcriptionFileName);
                                                                String urlFile =
                                                                    docUrl
                                                                        .fileName;
                                                                if (urlFile !=
                                                                    null) {
                                                                  Navigator.of(
                                                                          this
                                                                              .context,
                                                                          rootNavigator:
                                                                              true)
                                                                      .pop();
                                                                  _handleURLButtonPress(
                                                                      context,
                                                                      urlFile);
                                                                } else {
                                                                  Navigator.of(
                                                                      this
                                                                          .context,
                                                                      rootNavigator:
                                                                      true)
                                                                      .pop();
                                                                  AppToast().showToast(
                                                                      AppStrings
                                                                          .documentNotFound);
                                                                }
                                                              } else {
                                                                AppToast().showToast(
                                                                    AppStrings
                                                                        .networkNotConnected);
                                                              }
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .remove_red_eye,
                                                              size: 30,
                                                            ),
                                                            color: CustomizedColors
                                                                .dictationListIconColor,
                                                          ),
                                                        )
                                                      : Container(
                                                          width: width * 0.15,
                                                        ),
                                                  SizedBox(width: 5),
                                                  Container(
                                                    width: width * 0.15,
                                                    color: CustomizedColors
                                                        .primaryBgColor,
                                                    child: IconButton(
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        onPressed: () async {
                                                          showLoaderDialog(
                                                            context,
                                                            text: AppStrings
                                                                .loading,
                                                          );
                                                          await getRecordings(
                                                              list[index]
                                                                  .fileName,
                                                              list[index]
                                                                  .displayFileName);
                                                          Navigator.of(
                                                                  this.context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                          if (isNetAvailable ==
                                                              true) {
                                                            await showCupertinoModalPopup<
                                                                void>(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return CupertinoActionSheet(
                                                                  actions: [
                                                                    Material(
                                                                      child:
                                                                          Container(
                                                                        height: height *
                                                                            0.35,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                height * 0.50,
                                                                            width:
                                                                                width * 0.90,
                                                                            child:
                                                                                ListView(
                                                                              children: [
                                                                                Column(
                                                                                  children: [
                                                                                    PlayerWidget(
                                                                                      displayFileName: '${list[index].dictationType ?? ""}' + ', ${formatted ?? ""}',
                                                                                      url: filePath,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                  cancelButton:
                                                                      CupertinoActionSheetAction(
                                                                    child:
                                                                        const Text(
                                                                      AppStrings
                                                                          .cancel,
                                                                      style: TextStyle(
                                                                          fontFamily: AppFonts
                                                                              .regular,
                                                                          color:
                                                                              CustomizedColors.canceltextColor),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          } else {
                                                            AppToast().showToast(
                                                                AppStrings
                                                                    .networkNotConnected);
                                                          }
                                                        },
                                                        icon: Icon(
                                                          Icons
                                                              .play_circle_fill,
                                                          size: 30,
                                                        ),
                                                        color: CustomizedColors
                                                            .dictationListIconColor),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ))))
                        ]));
                      },
                    ),
                    Container(
                      height: 80,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),

        /// calling the mic button widget from widget folder
        floatingActionButton: roleId != 1
            ? AudioMicButtons(
                patientFName: item.patient.firstName,
                patientLName: item.patient.lastName,
                caseId: item.patient.accountNumber,
                patientDob: item.patient.dob,
                practiceId: item.practiceId,
                statusId: item.dictationStatusId,
                episodeId: item.episodeId,
                episodeAppointmentRequestId: item.episodeAppointmentRequestId,
                appointmentType: item.appointmentType,
                screenName: "dicatationListScreen",
                appointmentTypeId: item.appointmentTypeId,
                nbrMemberId: item.nbrMemberId,
                surgeryAssociatedRoles: item.surgeryAssociatedRoles,
                providerId: item.providerId,
          width: 80.0,
          height: 80.0,
          iconSize: 40.0,
          iconColor: CustomizedColors.micIconColor,
          bgColor: CustomizedColors.primaryColor,
              )
            : null);
  }

  void _handleURLButtonPress(BuildContext context, String urlFile) {
    String url = urlFile.replaceAll('&', '%26').replaceAll('=', '%3D');
    double width = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              insetPadding: EdgeInsets.symmetric(vertical: 70, horizontal: 10),
              contentPadding: EdgeInsets.zero,
              content: Container(
                  width: width * 80,
                  child: WebView(
                      key: _key,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: 'https://docs.google.com/viewer?url=$url')),
              actions: [
                TextButton(
                  child: Text(AppStrings.closeDialog),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            ));
  }
}
