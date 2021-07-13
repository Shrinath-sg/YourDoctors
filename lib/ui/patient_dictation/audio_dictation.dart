import 'package:YOURDRS_FlutterAPP/blocs/dictation_screen/audio_dictation_bloc.dart';
import 'package:YOURDRS_FlutterAPP/blocs/dictation_screen/audio_dictation_event.dart';
import 'package:YOURDRS_FlutterAPP/blocs/dictation_screen/audio_dictation_state.dart';
import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';
import 'package:YOURDRS_FlutterAPP/common/app_loader.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/common/app_toast_message.dart';
import 'package:YOURDRS_FlutterAPP/helper/db_helper.dart';
import 'package:YOURDRS_FlutterAPP/network/models/dictations/post_dictations_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/dictation.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:YOURDRS_FlutterAPP/network/services/dictation/post_dictations_service.dart';
import 'package:YOURDRS_FlutterAPP/ui/audio_dictations/random_waves.dart';
import 'package:YOURDRS_FlutterAPP/widget/save_dictations_alert.dart';
import 'package:file/local.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class AudioDictationForPatientDetails extends StatefulWidget {
  final String patientFName,
      patientLName,
      patientDob,
      dictationTypeId,
      caseNum,
      dictationTypeName,
      appointmentType,
      screenName;
  final int onlineDictationId = 107;
  final int offlineStatusId = 107;
  final episodeAppointmentRequestId, episodeId;
  final int offlineUploadedToServer = 0, onlineUploadToServer = 1;
  final int statusId = 17;

  const AudioDictationForPatientDetails(
      {Key key,
      this.patientFName,
      this.patientLName,
      this.patientDob,
      this.dictationTypeId,
      this.caseNum,
      this.appointmentType,
      this.dictationTypeName,
      this.episodeId,
      this.episodeAppointmentRequestId,
      this.screenName})
      : super(key: key);

  @override
  _AudioDictationState createState() => _AudioDictationState();
}

class _AudioDictationState extends State<AudioDictationForPatientDetails>
    with WidgetsBindingObserver {
  var data, dictId;
  String memberId;
  var dob;
  var memeberRoleId;
  int dictStatusId;
  String attachmentContent;
  String fName;
  String lName;
  bool isStarted = false;
  bool isStartedUploadBtn = true;
  bool isUpload = false;
  bool saveforlater = false;

  @override
  void initState() {
    super.initState();
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
    switch(state){
      case AppLifecycleState.paused:
        /// bloc provider for pause record event
        isStarted? BlocProvider.of<
            AudioDictationBloc>(
            context)
            .add(PauseRecord()):null;
        //Toast for recording paused
        isStarted? AppToast().showToast(
            AppStrings.recordingPaused):null;
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        isStarted? BlocProvider.of<AudioDictationBloc>(
            context)
            .add(DeleteRecord()):null;
        //Toast for recording deleted.
        isStarted? AppToast().showToast(
            AppStrings.recordingDeleted):null;
        break;
    }
  }

  ///Loading data from shared preferences.
  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memberId = (prefs.getString(Keys.memberId) ?? '');
      dob = (prefs.getString(Keys.dob) ?? '');
      memeberRoleId = (prefs.getString(Keys.memberRoleId) ?? '');
    });
  }

  /// parsing parameters to service class
  saveDictations() async {
    String audioFilePath =
        BlocProvider.of<AudioDictationBloc>(context).finalPath;
    String audioFileName = path.basename(audioFilePath);
    fName = widget.patientFName;
    lName = widget.patientLName;
    try {
      PostDictationsService apiPostServices = PostDictationsService();
      PostDictationsModel saveDictations = await apiPostServices.postApiMethod(
          int.tryParse(memberId),
          dob,
          widget.episodeId,
          widget.episodeAppointmentRequestId,
          int.parse(memeberRoleId),
          int.parse(widget.dictationTypeId),
          fName,
          lName,
          widget.caseNum,
          widget.patientDob,
          attachmentContent,
          audioFileName);
      dictId = saveDictations.dictationId;
      data = saveDictations.header.statusCode;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  ///Alert dialouge box to show success and Fail status.
  _dialogBox(int i) {
    if (data == "200") {
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (ctx) => SaveDictationsAlert(
                title: AppStrings.uploadToServer,
                clr: CustomizedColors.uploadToServerTextColor,
                count: i,
              ));
    } else {
      int count = 1;
      Navigator.of(context).popUntil((_) => count++ >= i-1);
    }
  }

  LocalFileSystem localFileSystem;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool viewVisible = true;
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat(AppConstants.dateFormat);

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _body(),
      ),
    );
  }

  _body() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocListener<AudioDictationBloc, AudioDictationState>(
      listener: (context, state) async {
        if (state.errorMsg != null && state.errorMsg.isNotEmpty) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(state.errorMsg ?? AppStrings.someThingWentWrong)));
          return;
        }

        _currentStatus = state.currentStatus;
        _current = state.current;
        viewVisible = state.viewVisible;
        isStarted = (_currentStatus == RecordingStatus.Recording ||
            _currentStatus == RecordingStatus.Paused);

        if (isUpload || saveforlater) {
          bool isInternetAvailable = await AppConstants.checkInternet();
          int statusId = saveforlater
              ? widget.statusId
              : isUpload
                  ? isInternetAvailable
                      ? widget.onlineDictationId
                      : widget.offlineStatusId
                  : null;

          int dialogInt;
          if(widget.screenName=="dictationScreen"){
            dialogInt = saveforlater?4:5;

          }else if(widget.screenName =="dicatationListScreen"){
               dialogInt = saveforlater?5:6;
          }else if(widget.screenName == "offlineDictationListScreen"){
            dialogInt = saveforlater?4:5;
          }
          else{
            dialogInt = saveforlater?3:4;
          }
          saveforlater = false;
          isUpload = false;

          attachmentContent = state.attachmentContent;
          if (attachmentContent != null && attachmentContent.isNotEmpty) {
            //checking internet connection

            if (isInternetAvailable) {
              ///progress bar
              showLoaderDialog(context, text: AppStrings.uploading);
              await saveDictations();
              _insertRecordsToDataBase(statusId, widget.onlineUploadToServer,
                  dictationId: dictId.toString());
              await _dialogBox(dialogInt);
            } else {
              AppToast().showToast(AppStrings.networkNotConnected);

              ///save dictations offline
              _insertRecordsToDataBase(
                  statusId, widget.offlineUploadedToServer);
              await _dialogBox(dialogInt);
            }
          }
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
                            Text("${_timerDurarion(_current?.duration)}"),
                            /////Save for later flat button
                            Text("${widget.dictationTypeName}", style: TextStyle(fontSize: 16,fontFamily: AppFonts.regular, color: CustomizedColors.primaryColor, fontWeight: FontWeight.bold),),
                            // ignore: deprecated_member_use
                            FlatButton(
                                onPressed: isStarted
                                    ? () async {
                                        saveforlater = true;

                                        ///calling post api to upload audio file
                                        BlocProvider.of<AudioDictationBloc>(
                                                context)
                                            .add(StopRecord());
                                      }
                                    : null,
                                child: Text(
                                  AppStrings.saveForLater,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isStarted
                                          ? CustomizedColors.saveLaterColor
                                          : null,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // ignore: deprecated_member_use
                            FlatButton(
                                padding: EdgeInsets.all(0),

                                ///on press for start and resume.
                                onPressed: isStartedUploadBtn
                                    ? () {
                                        switch (_currentStatus) {
                                          case RecordingStatus.Initialized:
                                            {
                                              /// bloc provider for start record event
                                              BlocProvider.of<
                                                          AudioDictationBloc>(
                                                      context)
                                                  .add(StartRecord());
                                              //Toast for recording started
                                              AppToast().showToast(
                                                  AppStrings.recordingStarted);
                                              break;
                                            }
                                          case RecordingStatus.Recording:
                                            {
                                              /// bloc provider for pause record event
                                              BlocProvider.of<
                                                          AudioDictationBloc>(
                                                      context)
                                                  .add(PauseRecord());
                                              //Toast for recording paused
                                              AppToast().showToast(
                                                  AppStrings.recordingPaused);
                                              break;
                                            }
                                          case RecordingStatus.Paused:
                                            {
                                              /// bloc provider for resume record event
                                              BlocProvider.of<
                                                          AudioDictationBloc>(
                                                      context)
                                                  .add(ResumeRecord());
                                              //Toast for recording resumed
                                              AppToast().showToast(
                                                  AppStrings.recordingResumed);
                                              break;
                                            }
                                          case RecordingStatus.Stopped:
                                            {
                                              /// bloc provider for init event
                                              BlocProvider.of<
                                                          AudioDictationBloc>(
                                                      context)
                                                  .add(InitRecord());
                                              break;
                                            }
                                          default:
                                            break;
                                        }
                                      }
                                    : null,
                                child: _buildText(_currentStatus)),
                            // ),
                            ////upload icon
                            // ignore: deprecated_member_use
                            FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: isStarted
                                    ? () async {
                                        BlocProvider.of<AudioDictationBloc>(
                                                context)
                                            .add(PauseRecord());

                                        /// Upload audio popup screen
                                        await showCupertinoModalPopup(
                                          //   barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext sheetContext) {
                                            return CupertinoActionSheet(
                                                actions: [
                                                  Material(
                                                    child: Container(
                                                      height: height * 0.35,
                                                      child: Column(
                                                        children: [
                                                          Icon(
                                                            Icons.cloud_upload,
                                                            size: 75,
                                                            color:
                                                                CustomizedColors
                                                                    .waveColor,
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                height * 0.01,
                                                          ),
                                                          Text(
                                                            AppStrings.dict,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                height * 0.025,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              /// cancel button in upload dictation dialouge
                                                              // ignore: deprecated_member_use
                                                              RaisedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  AppStrings
                                                                      .cancel,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: CustomizedColors
                                                                          .alertCancelColor),
                                                                ),
                                                              ),

                                                              ///upload button with functionalities.
                                                              // ignore: deprecated_member_use
                                                              RaisedButton(
                                                                onPressed:
                                                                    () async {
                                                                  isUpload =
                                                                      true;
                                                                  setState(() {
                                                                    isStartedUploadBtn =
                                                                        false;
                                                                  });

                                                                  ///calling post api to upload audio file
                                                                  BlocProvider.of<
                                                                              AudioDictationBloc>(
                                                                          context)
                                                                      .add(
                                                                          StopRecord());
                                                                },
                                                                child: Text(
                                                                  AppStrings
                                                                      .upload,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: CustomizedColors
                                                                          .textColor),
                                                                ),
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ]);
                                          },
                                        );
                                      }
                                    : null,
                                //cloud icon to upload file.
                                child: Icon(
                                  Icons.cloud_upload,
                                  size: 60,
                                  color: isStarted
                                      ? CustomizedColors.waveColor
                                      : null,
                                )),
                            // ignore: deprecated_member_use
                            FlatButton(
                              child: Icon(
                                Icons.delete,
                                color: isStarted
                                    ? CustomizedColors.deleteIconColor
                                    : null,
                                size: 50,
                              ),
                              onPressed: isStarted
                                  ? () {
                                      /// bloc provider for delete record event
                                      BlocProvider.of<AudioDictationBloc>(
                                              context)
                                          .add(DeleteRecord());
                                      //Toast for recording deleted.
                                      AppToast().showToast(
                                          AppStrings.recordingDeleted);
                                    }
                                  : null,
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
                                  Navigator.pop(context);
                                } else {
                                  /// bloc provider for delete record event
                                  BlocProvider.of<AudioDictationBloc>(context)
                                      .add(DeleteRecord());
                                  Navigator.pop(context);
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

  /// setting timer format
  String _timerDurarion(Duration duration) {
    if (duration != null) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
    return '';
  }

  ///play pause button icons
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
      color: isStartedUploadBtn ? CustomizedColors.waveColor : null,
      size: 60,
    );
  }

  ///insert online and offline Dictation Data
  _insertRecordsToDataBase(int statusId, int uploadToServer,
      {String dictationId}) async {
    try {
      String audioPathName =
          BlocProvider.of<AudioDictationBloc>(context).finalPath;
      String audioFileName =
          path.basename(audioPathName).replaceFirst(AppStrings.audioFormat, '');
      var audioByteSize =
          BlocProvider.of<AudioDictationBloc>(context).attachmentSizeBytes;
      await DatabaseHelper.db.insertAudioRecords(PatientDictation(
          dictationId: dictationId,
          fileName: '$audioFileName${AppStrings.audioFormat}',
          attachmentSizeBytes: audioByteSize,
          patientFirstName: '${widget.patientFName ?? ''}',
          patientLastName: '${widget.patientLName ?? ''}',
          patientDOB: '${widget.patientDob ?? ''}',
          attachmentName: '$audioFileName${AppStrings.audioFormat}',
          createdDate: '${DateTime.now() ?? ''}',
          memberId: int.parse(memberId),
          episodeId: widget.episodeId ?? '',
          appointmentId: widget.episodeAppointmentRequestId,
          dictationTypeId: int.tryParse(widget.dictationTypeId),
          physicalFileName: audioPathName ?? '',
          statusId: statusId,
          displayFileName: '$audioFileName',
          uploadedToServer: uploadToServer,
          attachmentType: AppStrings.attachmentType));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
