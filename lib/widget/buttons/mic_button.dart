import 'dart:convert';
import 'package:YOURDRS_FlutterAPP/blocs/dictation_screen/audio_dictation_bloc.dart';
import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/network/models/dictation_type/dictation_type_surgery.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:YOURDRS_FlutterAPP/ui/audio_dictations/audio_manual_dictation.dart';
import 'package:YOURDRS_FlutterAPP/ui/patient_dictation/audio_dictation.dart';
import 'package:YOURDRS_FlutterAPP/widget/buttons/dropdowns.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

//used in Manual Dictations Screens
class MicButtonForManualDictation extends StatefulWidget {
  final String patientFName,
      patientLName,
      patientDob,
      patientDos,
      caseId,
      attachmentName,
      physicalFileName,
      fileName,
      practiceName,
      providerName,
      locationName,
      descp,
      convertedImg;
  final List arrayOfImages;
  final int practiceId, providerId, locationId, docType, appointmentType;
  final int emergency;
  const MicButtonForManualDictation({
    Key key,
    this.patientFName,
    this.fileName,
    this.physicalFileName,
    this.attachmentName,
    this.patientLName,
    this.patientDob,
    this.patientDos,
    this.appointmentType,
    this.practiceName,
    this.providerName,
    this.locationName,
    this.emergency,
    this.descp,
    this.practiceId,
    this.providerId,
    this.locationId,
    this.docType,
    this.caseId,
    this.convertedImg,
    this.arrayOfImages,
  }) : super(key: key);
  @override
  _MicButtonForManualDictationState createState() =>
      _MicButtonForManualDictationState();
}

class _MicButtonForManualDictationState
    extends State<MicButtonForManualDictation> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
        showCupertinoModalPopup(
          barrierDismissible: false,
          context: context,
          builder: (ctctc) => CupertinoActionSheet(
            actions: [
              Container(
                height: height * 0.55,
                child: BlocProvider<AudioDictationBloc>(
                  create: (context) => AudioDictationBloc(
                      dictTypeId: widget.patientFName,
                      patientFName: widget.patientLName,
                      caseNumber: ""),

                  /// calling the audio dictation class from ui folder
                  child: ManualAudioDictation(
                    practiceName: widget.practiceName ?? null,
                    practiceId: widget.practiceId ?? null,
                    locationName: widget.locationName ?? null,
                    convertedImg: widget.convertedImg,
                    locationId: widget.locationId ?? null,
                    providerName: widget.providerName ?? null,
                    providerId: widget.providerId ?? null,
                    patientFName: widget.patientFName,
                    patientLName: widget.patientLName,
                    patientDob: widget.patientDob,
                    patientDos: widget.patientDos,
                    docType: widget.docType,
                    appointmentType: widget.appointmentType,
                    emergency: widget.emergency,
                    descp: widget.descp,
                    caseNum: null,
                    //physicalFileName: widget.physicalFileName,
                    //cameraImages: widget.cameraImages,
                    attachmentname: widget.attachmentName,
                    fileName: widget.fileName,
                    arrayOfImages: widget.arrayOfImages ?? null,
                  ),
                ),
              )
            ],
          ),
        );
      },
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
            color: CustomizedColors.circleAvatarColor,
            borderRadius: BorderRadius.circular(50)),
        child: Icon(
          Icons.mic,
          color: CustomizedColors.micIconColor,
          size: 40,
        ),
      ),
    );
  }
}

////used in Patient Details Screens
class AudioMicButtons extends StatefulWidget {
  final String patientFName;
  final String patientLName;
  final String caseId;
  final String patientDob;
  final String appointmentType;
  final String physicalPath;
  final int practiceId;
  final int statusId;
  final int episodeId;
  final String customPathName;
  final int episodeAppointmentRequestId;
  final String screenName;
  final int appointmentTypeId;
  final int nbrMemberId;
  final int surgeryAssociatedRoles;
  final int providerId;
  final double width;
  final double height;
  final double iconSize;
  final Color iconColor;
  final Color bgColor;

  const AudioMicButtons(
      {Key key,
      this.patientFName,
      this.patientLName,
      this.patientDob,
      this.caseId,
      this.appointmentType,
      this.physicalPath,
      this.practiceId,
      this.statusId,
      this.episodeId,
      this.customPathName,
      this.episodeAppointmentRequestId,
      this.screenName,
      this.appointmentTypeId,
      this.nbrMemberId,
      this.surgeryAssociatedRoles,
      this.providerId,
        this.width,
        this.height,
        this.iconSize,
        this.iconColor,
        this.bgColor})
      : super(key: key);
  @override
  _AudioMicButtonsState createState() => _AudioMicButtonsState();
}

class _AudioMicButtonsState extends State<AudioMicButtons> {
  var _currentSelectedValue;
  var dictationTypeId;
  var memberId;
  int member;
  @override
  void setState(fn) async {
    super.setState(fn);
    memberId = await MySharedPreferences.instance.getStringValue(Keys.memberId);
    member = int.tryParse(memberId);
  }

  // ignore: deprecated_member_use
  List<DictationTypeSurgery> data = List(); //edited line
  //for surgery appointment type
  loadDictationTypeSurgery() async {
    String jsonData = await DefaultAssetBundle.of(context)
        .loadString(AppStrings.dictationJsonFile);
    final jsonResult = json.decode(jsonData);
    data = List<DictationTypeSurgery>.from(
        jsonResult.map((x) => DictationTypeSurgery.fromJson(x)));
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadDictationTypeSurgery();
  }

  @override
  Widget build(BuildContext buildContext) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return TextButton(
      onPressed: () {
        if (widget.appointmentTypeId != 7) {
          setState(() {
            _currentSelectedValue = "MR";
            dictationTypeId = "2";
          });
          dictate();
        } else {
          if (member != widget.providerId && widget.nbrMemberId == member) {
            setState(() {
              _currentSelectedValue = "NBR";
              dictationTypeId = "3";
            });
            dictate();
          } else if (member != widget.providerId &&
              widget.nbrMemberId == null) {
            setState(() {
              _currentSelectedValue = "OPR";
              dictationTypeId = "1";
            });
            dictate();
          } else if (member == widget.providerId &&
              widget.nbrMemberId == member) {
            Alert(
              useRootNavigator: true,
              style: AlertStyle(overlayColor: CustomizedColors.filterTextColor),
              closeIcon: Icon(
                Icons.remove,
                color: Colors.white,
              ),
              closeFunction: () {},
              context: context,
              title: AppStrings.dictType,
              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CustomizedColors.alertColor,
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 10),
                height: height * 0.09,
                width: width * 0.65,
                child: dropDown(),
              ),
              buttons: [
                DialogButton(
                  color: CustomizedColors.alertCancelColor,
                  child: Text(
                    AppStrings.cancel,
                    style: TextStyle(
                        color: CustomizedColors.textColor,
                        fontSize: 20,
                        fontFamily: AppFonts.regular),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  width: 120,
                )
              ],
            ).show();
          } else {
            setState(() {
              _currentSelectedValue = "OPR";
              dictationTypeId = "1";
            });
            dictate();
          }
        }
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(50)),
        child: Icon(
          Icons.mic,
          color: widget.iconColor,
          size: widget.iconSize,
        ),
      ),
    );
  }

  //for checking surgery and non surgery appointment type
  List<DictationTypeSurgery> getList(String appointmentType) {
    if (appointmentType == AppStrings.appointmentTypeSurgery) {
      return data
          .where((element) => element.appointmentType == appointmentType)
          .toList();
    } else {
      return data
          .where((element) =>
              element.appointmentType != AppStrings.appointmentTypeSurgery)
          .toList();
    }
  }

  Widget dropDown() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        /// calling the drop down button widget from widget folder
        return DropDownDictationType(
          value: _currentSelectedValue = null,
          hint: AppStrings.dictationType,
          onChanged: (newValue) {
            Navigator.of(context, rootNavigator: true).pop();
            dictate();
            setState(() {
              _currentSelectedValue = newValue;
              state.didChange(newValue);
              setState(() {
                _currentSelectedValue = newValue;
                dictationTypeId = data
                    .firstWhere((element) =>
                        element.dictationType == _currentSelectedValue)
                    .dictationTypeId;
                state.didChange(newValue);
              });
            });
          },
          items: getList(widget.appointmentType).map((value) {
            return DropdownMenuItem<String>(
              value: value.dictationType,
              child: Text(
                value.dictationType,
                style: TextStyle(fontFamily: AppFonts.regular),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  dictate() {
    final height = MediaQuery.of(context).size.height;
    return showCupertinoModalPopup(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(bottom: 85),
          child: CupertinoActionSheet(
            actions: [
              Container(
                height: height * 0.50,
                child: BlocProvider<AudioDictationBloc>(
                  create: (context) => AudioDictationBloc(
                      patientFName: widget.patientFName,
                      patientLName: widget.patientLName,
                      caseNumber: widget.caseId,
                      dictTypeId: _currentSelectedValue),

                  /// calling the audio dictation class from ui folder
                  child: AudioDictationForPatientDetails(
                      patientFName: widget.patientFName,
                      patientLName: widget.patientLName,
                      patientDob: widget.patientDob,
                      caseNum: widget.caseId,
                      dictationTypeName: _currentSelectedValue,
                      appointmentType: widget.appointmentType,
                      episodeAppointmentRequestId:
                          widget.episodeAppointmentRequestId,
                      episodeId: widget.episodeId,
                      dictationTypeId: dictationTypeId,
                      screenName: widget.screenName),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
