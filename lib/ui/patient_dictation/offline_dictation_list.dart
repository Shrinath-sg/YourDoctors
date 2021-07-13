import 'dart:io';
import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_loader.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/common/app_toast_message.dart';
import 'package:YOURDRS_FlutterAPP/helper/db_helper.dart';
import 'package:YOURDRS_FlutterAPP/network/models/home/schedule.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/dictation.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:YOURDRS_FlutterAPP/ui/patient_dictation/play_audio.dart';
import 'package:YOURDRS_FlutterAPP/widget/buttons/mic_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class OfflineDictationsList extends StatefulWidget {
  static const String routeName = '/OfflineDictationsList';
  @override
  _OfflineDictationsListState createState() => _OfflineDictationsListState();
}

class _OfflineDictationsListState extends State<OfflineDictationsList> {
  int roleId;
  List<PatientDictation> list = [];
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

  String dictationType;
  var filePath;
  bool audioAvailable;
  @override
  Widget build(BuildContext context) {
    final Map args3 = ModalRoute.of(context).settings.arguments;
    ScheduleList item = args3['item'];

    /// used to get the recording
    getRecordings(String fileName) async {
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
          audioAvailable = true;
        });
      } else {
        setState(() {
          audioAvailable = false;
        });
      }
    }

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
                    FutureBuilder<Object>(
                        future: DatabaseHelper.db
                            .getAllDictations(item.episodeAppointmentRequestId),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CupertinoActivityIndicator(
                                radius: 20,
                              ),
                            );
                          } else {
                            list = snapshot.data as List<PatientDictation>;
                            if (list.length != 0) {
                              return ListView.builder(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: list.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var date1 = DateFormat("yyyy-MM-dd")
                                      .parse(item.appointmentStartDate);
                                  final DateFormat formatter =
                                      DateFormat('yyyy-MM-dd');
                                  final String formatted =
                                      formatter.format(date1);
                                  if (list[index].dictationTypeId == 1) {
                                    dictationType = "OPR";
                                  } else if (list[index].dictationTypeId == 2) {
                                    dictationType = "MR";
                                  } else if (list[index].dictationTypeId == 3) {
                                    dictationType = "NBR";
                                  }
                                  return AnimationLimiter(
                                      child: Column(children: [
                                    AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: FadeInAnimation(
                                            child: SlideAnimation(
                                                horizontalOffset:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2,
                                                child: Card(
                                                  child: Container(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Container(
                                                              width:
                                                                  width * 0.70,
                                                              child: Text(
                                                                '$dictationType' +
                                                                    ', $formatted',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        AppFonts
                                                                            .regular,
                                                                    fontSize:
                                                                        14),
                                                                overflow:
                                                                TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                            Container(
                                                              width:
                                                                  width * 0.15,
                                                              color: CustomizedColors
                                                                  .primaryBgColor,
                                                              child: IconButton(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  onPressed:
                                                                      () async {
                                                                    showLoaderDialog(
                                                                      context,
                                                                      text: AppStrings
                                                                          .loading,
                                                                    );
                                                                    await getRecordings(
                                                                      list[index]
                                                                          .fileName,
                                                                    );
                                                                    Navigator.of(
                                                                            this
                                                                                .context,
                                                                            rootNavigator:
                                                                                true)
                                                                        .pop();
                                                                    if (audioAvailable ==
                                                                        true) {
                                                                      await showCupertinoModalPopup<
                                                                          void>(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return CupertinoActionSheet(
                                                                            actions: [
                                                                              Material(
                                                                                child: Container(
                                                                                  height: height * 0.35,
                                                                                  child: Center(
                                                                                    child: Container(
                                                                                      height: height * 0.50,
                                                                                      width: width * 0.90,
                                                                                      child: ListView(
                                                                                        children: [
                                                                                          Column(
                                                                                            children: [
                                                                                              PlayerWidget(
                                                                                                displayFileName: '${dictationType ?? ""}'+'$formatted',
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
                                                                              child: const Text(
                                                                                AppStrings.cancel,
                                                                                style: TextStyle(fontFamily: AppFonts.regular, color: CustomizedColors.canceltextColor),
                                                                              ),
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    } else {
                                                                      AppToast()
                                                                          .showToast(
                                                                              "audio not available");
                                                                    }
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .play_circle_fill,
                                                                    size: 30,
                                                                  ),
                                                                  color: CustomizedColors
                                                                      .customeColor),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                            )
                                        )
                                    )
                                  ]));
                                },
                              );
                            } else {
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
                          }
                        }),
                    Container(
                      height: 80,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
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
                screenName: "offlineDictationListScreen",
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
}
