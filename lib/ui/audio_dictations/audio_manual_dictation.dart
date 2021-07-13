import 'dart:convert';
import 'dart:io';
import 'package:YOURDRS_FlutterAPP/blocs/dictation_screen/audio_dictation_bloc.dart';
import 'package:YOURDRS_FlutterAPP/blocs/dictation_screen/audio_dictation_state.dart';
import 'package:YOURDRS_FlutterAPP/blocs/dictation_screen/audio_dictation_event.dart';
import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';
import 'package:YOURDRS_FlutterAPP/common/app_loader.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/common/app_toast_message.dart';
import 'package:YOURDRS_FlutterAPP/helper/db_helper.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/dictation.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/external_dictation_attachment_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/photo_list.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:YOURDRS_FlutterAPP/network/services/dictation/external_attachment_dictation.dart';
import 'package:YOURDRS_FlutterAPP/ui/audio_dictations/random_waves.dart';
import 'package:connectivity/connectivity.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:YOURDRS_FlutterAPP/utils/route_generator.dart';
import 'package:YOURDRS_FlutterAPP/ui/manual_dictaions/manual_dictations.dart';
import 'package:path/path.dart' as path;

class ManualAudioDictation extends StatefulWidget {
  final String patientFName,
      patientLName,
      patientDob,
      patientDos,
      caseNum,
      attachmentname,
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

  const ManualAudioDictation({
    Key key,
    this.patientFName,
    this.patientLName,
    this.patientDob,
    this.patientDos,
    this.fileName,
    this.docType,
    this.appointmentType,
    this.caseNum,
    this.attachmentname,
    this.physicalFileName,
    this.practiceName,
    this.providerName,
    this.locationName,
    this.emergency,
    this.descp,
    this.practiceId,
    this.providerId,
    this.locationId,
    this.arrayOfImages,
    this.convertedImg,
  }) : super(key: key);

  @override
  _ManualAudioDictationState createState() => _ManualAudioDictationState();
}

class _ManualAudioDictationState extends State<ManualAudioDictation>
    with WidgetsBindingObserver {
  bool isInternetAvailable = false;
  String finalFilepath, savedFilePath;
  String name;
  var statusCode;
  var dicId;
  String attachmentContent;
  String abcd;
  int idGallery;
  LocalFileSystem localFileSystem;
  File image;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool viewVisible = true;
  String memberId;
  bool isStarted = false;
  String attachmentNameMp4;
  bool isUpload = false;
  bool offlineUpload = false;
  String mp4Base64, mp4Content;
  String attachmentTypeMp4 = 'mp4';
  List memberPhotos = [];

  bool emergencyAddOn = true;

  int uploadedToServerTrue = 1;
  int uploadedToServerFalse = 0;

  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat(AppConstants.dateFormat);

  // internet check
  Future<bool> checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      isInternetAvailable = true;
    } else {
      isInternetAvailable = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.localFileSystem = localFileSystem ?? LocalFileSystem();
    if (mounted) {
      /// bloc provider for init event
      BlocProvider.of<AudioDictationBloc>(context).add(InitRecord());
    }
  }

  @override
  void initState() {
    super.initState();

    checkNetwork();
    _loadData();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:

      /// bloc provider for pause record event
        isStarted
            ? BlocProvider.of<AudioDictationBloc>(context).add(PauseRecord())
            : null;
        //Toast for recording paused
        isStarted ? AppToast().showToast(AppStrings.recordingPaused) : null;
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        isStarted
            ? BlocProvider.of<AudioDictationBloc>(context).add(DeleteRecord())
            : null;
        //Toast for recording deleted.
        isStarted ? AppToast().showToast(AppStrings.recordingDeleted) : null;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: _body(),
        ),
      ),
    );
  }

  _body() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocListener<AudioDictationBloc, AudioDictationState>(
      listener: (context, state) async {
        finalFilepath = BlocProvider.of<AudioDictationBloc>(context).finalPath;
        attachmentContent = state.attachmentContent;

        if (isUpload) {
          if (attachmentContent != null && attachmentContent.isNotEmpty) {
            mp4Base64 = attachmentContent;
          } //test braces remove
          isUpload = false;
          if (widget.arrayOfImages == null) {
            //camera images

            showLoaderDialog(context, text: AppStrings.uploading);
            await saveAttachmentDictation();

            await insertRecordsToDataBaseOnline();
            Navigator.of(this.context, rootNavigator: true).pop();
            // memberPhotos.clear();
            await RouteGenerator.navigatorKey.currentState
                .pushReplacementNamed(ManualDictations.routeName);
          } else if (widget.arrayOfImages != null) {
            //gallery images
            showLoaderDialog(context, text: AppStrings.uploading);
            await saveGalleryImageToServer();
            await insertRecordsWithGalleryImagesOnline();
            Navigator.of(this.context, rootNavigator: true).pop();
            // memberPhotos.clear();
            await RouteGenerator.navigatorKey.currentState
                .pushReplacementNamed(ManualDictations.routeName);
          }
          // }
        } else {
          isUpload = false;
        }

        if (offlineUpload) {
          offlineUpload = false;
          //  if (finalFilepath != null || finalFilepath.isNotEmpty) {
          if (widget.arrayOfImages != null) {
            ///upload gallery images to the db

            showLoaderDialog(context, text: AppStrings.saveToDB);
            await insertRecordsWithGalleryImagesOffline();
            Navigator.of(this.context, rootNavigator: true).pop();

            await RouteGenerator.navigatorKey.currentState
                .pushReplacementNamed(ManualDictations.routeName);
          } else if (widget.arrayOfImages == null) {
            ///upload camera image to the db
            ///

            showLoaderDialog(context, text: AppStrings.saveToDB);
            await insertRecordsToDataBaseOffline();
            Navigator.of(this.context, rootNavigator: true).pop();

            await RouteGenerator.navigatorKey.currentState
                .pushReplacementNamed(ManualDictations.routeName);
          }
          // }
        } else {
          offlineUpload = false;
        }

        _currentStatus = state.currentStatus;
        _current = state.current;
        viewVisible = state.viewVisible;
        isStarted = (_currentStatus == RecordingStatus.Recording ||
            _currentStatus == RecordingStatus.Paused);
        if (state.errorMsg != null && state.errorMsg.isNotEmpty) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                state.errorMsg ?? 'Something went wrong',
                style: TextStyle(fontFamily: AppFonts.regular),
              )));
        }
      },
      child: BlocBuilder<AudioDictationBloc, AudioDictationState>(
        builder: (context, state) {
          return Center(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width / 30, vertical: height / 150),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${_printDuration(_current?.duration)}",
                              style: TextStyle(fontFamily: AppFonts.regular),
                            ),
                            TextButton(
                                onPressed: () async {
                                  /// bloc provider for save record event
                                  BlocProvider.of<AudioDictationBloc>(context)
                                      .add(StopRecord());

                                  checkNetwork();
                                  viewVisible = false;

                                  if (isInternetAvailable == true) {
                                    isUpload = true;
                                    await AppToast()
                                        .showToast(AppStrings.recordingSaved);
                                  }
                                  //internet is not there
                                  else {
                                    offlineUpload = true;
                                  }
                                },
                                child: Text(
                                  AppStrings.saveRecording,
                                  style: TextStyle(
                                      fontFamily: AppFonts.regular,
                                      fontWeight: FontWeight.bold,
                                      color: CustomizedColors.saveLaterColor,
                                      fontSize: 18),
                                ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              color: CustomizedColors.waveBGColor,
                              child: Visibility(
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  visible: viewVisible,

                                  /// calling random wave class
                                  child: RandomWaves()),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width / 30,
                                  vertical: height / 150),
                              child: TextButton(
                                  onPressed: () {
                                    switch (_currentStatus) {
                                      case RecordingStatus.Initialized:
                                        {
                                          /// bloc provider for start record event
                                          BlocProvider.of<AudioDictationBloc>(
                                              context)
                                              .add(StartRecord());
                                          AppToast().showToast(
                                              AppStrings.recordingStarted);
                                          break;
                                        }
                                      case RecordingStatus.Recording:
                                        {
                                          /// bloc provider for pause record event
                                          BlocProvider.of<AudioDictationBloc>(
                                              context)
                                              .add(PauseRecord());
                                          AppToast().showToast(
                                              AppStrings.recordingPaused);
                                          break;
                                        }
                                      case RecordingStatus.Paused:
                                        {
                                          /// bloc provider for resume record event
                                          BlocProvider.of<AudioDictationBloc>(
                                              context)
                                              .add(ResumeRecord());
                                          AppToast().showToast(
                                              AppStrings.recordingResumed);
                                          break;
                                        }
                                      case RecordingStatus.Stopped:
                                        {
                                          /// bloc provider for init event
                                          BlocProvider.of<AudioDictationBloc>(
                                              context)
                                              .add(InitRecord());
                                          break;
                                        }
                                      default:
                                        break;
                                    }
                                  },
                                  child: _buildText(_currentStatus)),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ignore: deprecated_member_use
                            FlatButton(
                              onPressed: () {
                                if (isStarted == false) {
                                  Navigator.of(this.context,
                                      rootNavigator: true)
                                      .pop();
                                } else {
                                  /// bloc provider for delete record event
                                  BlocProvider.of<AudioDictationBloc>(context)
                                      .add(DeleteRecord());
                                  Navigator.of(this.context,
                                      rootNavigator: true)
                                      .pop();
                                }
                              },
                              child: Container(
                                height: height * 0.07,
                                width: width * 0.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: CustomizedColors.waveBGColor,
                                ),
                                child: Center(
                                  child: Text(
                                    AppStrings.cancel,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: CustomizedColors
                                            .cancelDictationTextColor),
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.only(top: 5),
                            )
                          ],
                        )
                      ]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  ///--------------setting timer format
  String _printDuration(Duration duration) {
    if (duration != null) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
    return '';
  }

  ///-----------------play pause button icons
  Widget _buildText(RecordingStatus status) {
    var icon;
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          icon = Icons.not_started;
          break;
        }
      case RecordingStatus.Recording:
        {
          icon = Icons.pause;
          break;
        }
      case RecordingStatus.Paused:
        {
          icon = Icons.play_arrow;
          break;
        }
      case RecordingStatus.Stopped:
        {
          icon = Icons.stop_outlined;
          break;
        }
      default:
        break;
    }
    return Icon(
      icon,
      color: CustomizedColors.waveColor,
      size: 60,
    );
  }

//---------------Insert Dictation Data when online and camera images
  insertRecordsToDataBaseOnline() async {
    try {
      String a = widget.fileName;
      String b = a.substring(0, a.length - 1);

      String audioFilePath =
          BlocProvider.of<AudioDictationBloc>(context).finalPath;
      // String fileNameWithoutExt = path.basename(savedFilePath);
      final String formatted = formatter.format(now);

      await DatabaseHelper.db.insertAudioRecords(PatientDictation(
        dictationId: dicId.toString() ?? null,
        attachmentType: attachmentTypeMp4,
        fileName: path.basename(finalFilepath),
        locationName: widget.locationName ?? null,
        attachmentName: path.basename(finalFilepath),
        physicalFileName: finalFilepath ?? '@',
        locationId: widget.locationId ?? null,
        practiceName: widget.practiceName ?? null,
        practiceId: widget.practiceId ?? null,
        providerName: widget.providerName ?? null,
        providerId: widget.providerId ?? null,
        patientFirstName: widget.patientFName ?? null,
        patientLastName: widget.patientLName ?? null,
        patientDOB: widget.patientDob ?? null,
        dos: widget.patientDos ?? null,
        uploadedToServer: uploadedToServerTrue,
        isEmergencyAddOn: widget.emergency ?? null,
        externalDocumentTypeId: widget.docType ?? null,
        appointmentTypeId: widget.appointmentType ?? null,
        description: widget.descp ?? null,
        createdDate: '${DateTime.now()}' ?? 'NA',
        displayFileName: path.basenameWithoutExtension(finalFilepath),
      ));

      await DatabaseHelper.db.insertPhotoList(PhotoList(
          dictationLocalId: dicId ?? null,
          attachmentname: b ?? null,
          createddate: '${DateTime.now()}',
          fileName: b ?? null,
          attachmenttype: AppStrings.imageFormat,
          physicalfilename: widget.physicalFileName ?? "NA"));
    } catch (e) {
      // print('_insertRecordsToDataBase ${e.toString()}');
    }
  }

//----------------insert into database if offline and camera images

  insertRecordsToDataBaseOffline() async {
    try {
      String a = widget.fileName;
      String b = a.substring(0, a.length - 1);
      final String formatted = formatter.format(now);

      await DatabaseHelper.db.insertAudioRecords(PatientDictation(
        dictationId: dicId.toString() ?? null,
        attachmentType: "mp4",
        fileName: widget.patientFName +
            "_" +
            widget.patientLName +
            "_" +
            formatted +
            ".mp4",
        locationName: widget.locationName ?? null,
        attachmentName: widget.patientFName +
            "_" +
            widget.patientLName +
            "_" +
            formatted +
            ".mp4",
        locationId: widget.locationId ?? null,
        memberId: int.parse(memberId),
        physicalFileName: finalFilepath ?? '*#',
        practiceName: widget.practiceName ?? null,
        practiceId: widget.practiceId ?? null,
        providerName: widget.providerName ?? null,
        providerId: widget.providerId ?? null,
        patientFirstName: widget.patientFName ?? null,
        uploadedToServer: uploadedToServerFalse,
        patientLastName: widget.patientLName ?? null,
        patientDOB: widget.patientDob ?? null,
        dos: widget.patientDos ?? null,
        isEmergencyAddOn: widget.emergency ?? null,
        externalDocumentTypeId: widget.docType ?? null,
        appointmentTypeId: widget.appointmentType ?? null,
        description: widget.descp ?? null,
        createdDate: '${DateTime.now()}' ?? 'NA',
        displayFileName: widget.patientFName +
            "_" +
            widget.patientLName +
            "_" +
            formatted +
            ".mp4",
      ));

      List dictId = await DatabaseHelper.db.getDectionId();
      int id;
      id = dictId[dictId.length - 1].id;

      await DatabaseHelper.db.insertPhotoList(PhotoList(
          dictationLocalId: id,
          attachmentname: b ?? null,
          createddate: '${DateTime.now()}',
          fileName: b ?? null,
          attachmenttype: AppStrings.imageFormat,
          physicalfilename: widget.physicalFileName ?? null));
    } catch (e) {
      // print('_insertRecordsToDataBase ${e.toString()}');
    }
  }

//---------post to the API
  saveAttachmentDictation() async {
    try {
      //when path is null no camera image is selected
      if (widget.arrayOfImages == null || widget.arrayOfImages.isEmpty) {
        final String formatted = formatter.format(now);
        attachmentNameMp4 = '${widget.patientFName}' +
            '_' +
            '${widget.patientLName}' +
            '_' +
            '${formatted}' +
            '.mp4';
        String attachmentTypeJpg = "jpg";
        name = '${widget.patientFName}_${widget.patientLName}_${formatted}' +
            '.jpg';

        if (widget.emergency == 0) {
          emergencyAddOn = false;
        } else {
          emergencyAddOn = true;
        }

        ExternalDictationAttachment apiAttachmentPostServices =
        ExternalDictationAttachment();
        SaveExternalDictationOrAttachment saveDictationAttachments =
        await apiAttachmentPostServices.postApiServiceMethod(
          widget.practiceId,
          widget.locationId,
          widget.providerId,
          widget.patientFName,
          widget.patientLName,
          widget.patientDob,
          widget.patientDos,
          memberId,
          widget.docType,
          widget.appointmentType,
          emergencyAddOn,
          widget.descp,
          attachmentTypeMp4, //attachmentTypeMp4,
          mp4Base64,
          attachmentNameMp4,
          null,
        );
        dicId = saveDictationAttachments.dictationId;
        statusCode = saveDictationAttachments?.header?.statusCode;
      }
      //saving when selected camera images selected and path is not empty
      else {
        for (int j = 0; j < widget.arrayOfImages.length; j++) {
          final bytes =
          File(widget?.arrayOfImages[j] ?? null).readAsBytesSync();
          String img64 = base64Encode(bytes);
          final String formatted = formatter.format(now);
          attachmentNameMp4 = '${widget.patientFName}' +
              '_' +
              '${widget.patientLName}' +
              '_' +
              '${formatted}' +
              '.mp4';
          // String attachmentTypeJpg = "jpg";
          name =
              '${widget.patientFName}_${widget.patientLName}_${j}_${formatted}' +
                  '.jpg';

          memberPhotos.add({
            "header": {
              "status": "string",
              "statusCode": "string",
              "statusMessage": "string"
            },
            "content": img64,
            "name": name,
            "attachmentType": "jpg"
          });
        }

        if (widget.emergency == 0) {
          emergencyAddOn = false;
        } else {
          emergencyAddOn = true;
        }

        ExternalDictationAttachment apiAttachmentPostServices =
        ExternalDictationAttachment();
        SaveExternalDictationOrAttachment saveDictationAttachments =
        await apiAttachmentPostServices.postApiServiceMethod(
          widget.practiceId,
          widget.locationId,
          widget.providerId,
          widget.patientFName,
          widget.patientLName,
          widget.patientDob,
          widget.patientDos,
          memberId,
          widget.docType,
          widget.appointmentType,
          emergencyAddOn,
          widget.descp,
          attachmentTypeMp4, //attachmentTypeMp4,
          mp4Base64,
          attachmentNameMp4,
          memberPhotos,
        );

        dicId = saveDictationAttachments.dictationId;
        statusCode = saveDictationAttachments?.header?.statusCode;
      }
    } catch (e) {
      // print('SaveAttachmentDictation exception ${e.toString()}');
    }
  }

//----------------getting memberId from sharedPrefarance
  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memberId = (prefs.getString(Keys.memberId) ?? '');
    });
  }

//----------------insert records with gallery images to db when online
  insertRecordsWithGalleryImagesOnline() async {
    final String formatted = formatter.format(now);
    String nameFinal =
        widget.patientFName + "_" + widget.patientLName + "_" + formatted;
    try {
      for (int i = 0; i < widget.arrayOfImages.length; i++) {
        await DatabaseHelper.db.insertPhotoList(PhotoList(
            dictationLocalId: int.parse(dicId),
            attachmentname: ('${(widget.arrayOfImages[i])}'),
            fileName: '${widget.patientFName ?? ''}_ ${formatted}_[$i]',
            createddate: '${DateTime.now()}',
            attachmenttype: AppStrings.imageFormat,
            physicalfilename: '${widget.arrayOfImages[i]}'));
      }
      await DatabaseHelper.db.insertAudioRecords(
        PatientDictation(
          fileName: nameFinal + ".mp4",
          attachmentType: 'mp4',
          displayFileName: nameFinal,
          attachmentName: nameFinal + ".mp4",
          physicalFileName: finalFilepath ?? '^',
          dictationId: dicId.toString(),
          locationName: widget.locationName ?? null,
          locationId: widget.locationId ?? null,
          practiceName: widget.practiceName ?? null,
          practiceId: widget.practiceId ?? null,
          providerName: widget.providerName ?? null,
          providerId: widget.providerId ?? null,
          patientFirstName: widget.patientFName ?? null,
          patientLastName: widget.patientLName ?? null,
          patientDOB: widget.patientDob ?? null,
          dos: widget.patientDos ?? null,
          isEmergencyAddOn: widget.emergency ?? null,
          externalDocumentTypeId: widget.docType ?? null,
          appointmentTypeId: widget.appointmentType ?? null,
          description: widget.descp ?? null,
          memberId: int.parse(memberId) ?? null,
          createdDate: '${DateTime.now()}',
          uploadedToServer: uploadedToServerTrue,
          statusId: null,
        ),
      );
    } on PlatformException catch (e) {
      // print("Exception handling" + e.toString());
    }
  }

//----------------insert records with gallery images to db when offline
  insertRecordsWithGalleryImagesOffline() async {
    final String formatted = formatter.format(now);
    String nameFinal =
        widget.patientFName + "_" + widget.patientLName + "_" + formatted;
    try {

      await DatabaseHelper.db.insertAudioRecords(
        PatientDictation(
          attachmentType: 'mp4',
          fileName: nameFinal + ".mp4",
          attachmentName: nameFinal + ".mp4",
          displayFileName: nameFinal,
          dictationId: null,
          physicalFileName: finalFilepath ?? '??',
          locationName: widget.locationName ?? null,
          locationId: widget.locationId ?? null,
          practiceName: widget.practiceName ?? null,
          practiceId: widget.practiceId ?? null,
          providerName: widget.providerName ?? null,
          providerId: widget.providerId ?? null,
          patientFirstName: widget.patientFName ?? null,
          patientLastName: widget.patientLName ?? null,
          patientDOB: widget.patientDob ?? null,
          dos: widget.patientDos ?? null,
          isEmergencyAddOn: widget.emergency ?? null,
          externalDocumentTypeId: widget.docType ?? null,
          appointmentTypeId: widget.appointmentType ?? null,
          description: widget.descp ?? null,
          memberId: int.parse(memberId) ?? null,
          createdDate: '${DateTime.now()}',
          uploadedToServer: uploadedToServerFalse,
          statusId: null,
        ),
      );
      for (int i = 0; i < widget.arrayOfImages.length; i++) {
        List listId = await DatabaseHelper.db.getGalleryId();
        idGallery = listId[listId.length - 1].id;
        await DatabaseHelper.db.insertPhotoList(PhotoList(
            dictationLocalId:idGallery ?? "NA",
            attachmentname:'${widget.patientFName ?? ''}_ ${formatted}_${i}' + '.jpg',
            fileName: path.basename('${(widget.arrayOfImages[i])}'),
            createddate: '${DateTime.now()}',
            attachmenttype: AppStrings.imageFormat,
            physicalfilename: '${widget.arrayOfImages[i]}'));
      }

    } on PlatformException catch (e) {
      // print("Exception handling" + e.toString());
    }
  }

//-----------------gallery images to API
  saveGalleryImageToServer() async {
    String attachmentTypeJpg = 'jpg';

    final String formatted = formatter.format(now);
    attachmentNameMp4 = '${widget.patientFName}' +
        '_' +
        '${widget.patientLName}' +
        '_' +
        '${formatted}' +
        '.mp4';

    for (int i = 0; i < widget.arrayOfImages.length; i++) {
      final bytes = File('${widget.arrayOfImages[i]}').readAsBytesSync();
      String images = base64Encode(bytes);

      memberPhotos.add(
        {
          "header": {
            "status": "string",
            "statusCode": "string",
            "statusMessage": "string"
          },
          "content": images,
          "name": '${widget.patientFName}' +
              '_' +
              '${widget.patientLName}' +
              '_' +
              '${i}' +
              '_' +
              '${formatted}'
                  '.jpg',
          "attachmentType": "jpg"
        },
      );
    }

    try {
      if (widget.emergency == 0) {
        emergencyAddOn = false;
      } else {
        emergencyAddOn = true;
      }
      ExternalDictationAttachment apiAttachmentPostServices =
      ExternalDictationAttachment();
      SaveExternalDictationOrAttachment saveDictationAttachments =
      await apiAttachmentPostServices.postApiServiceMethod(
        widget.practiceId,
        widget.locationId,
        widget.providerId,
        widget.patientFName,
        widget.patientLName,
        widget.patientDob,
        widget.patientDos,
        memberId,
        widget.docType,
        widget.appointmentType,
        emergencyAddOn,
        widget.descp,
        attachmentTypeMp4, //attachmentTypeMp4,
        mp4Base64,
        attachmentNameMp4,
        memberPhotos, //memberPhotos,
      );
      dicId = saveDictationAttachments.dictationId.toString();

      statusCode = saveDictationAttachments?.header?.statusCode;
      // print("status $statusCode");
    } catch (e) {}
// }
  }
}
