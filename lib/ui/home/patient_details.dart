import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';
import 'package:YOURDRS_FlutterAPP/common/app_loader.dart';
import 'package:YOURDRS_FlutterAPP/common/app_log_helper.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/common/app_toast_message.dart';
import 'package:YOURDRS_FlutterAPP/cubit/pateint_details/get_image_files_cubit.dart';
import 'package:YOURDRS_FlutterAPP/helper/db_helper.dart';
import 'package:YOURDRS_FlutterAPP/network/models/dictations/dictations_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/dictations/post_dictations_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/home/profilephotos.dart';
import 'package:YOURDRS_FlutterAPP/network/models/home/schedule.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/dictation.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/photo_list.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:YOURDRS_FlutterAPP/network/services/dictation/dictation_services.dart';
import 'package:YOURDRS_FlutterAPP/network/services/dictation/post_dictation_image_service.dart';
import 'package:YOURDRS_FlutterAPP/network/services/dictation/post_dictations_service.dart';
import 'package:YOURDRS_FlutterAPP/network/services/schedules/appointment_service.dart';
import 'package:YOURDRS_FlutterAPP/ui/home/view_images.dart';
import 'package:YOURDRS_FlutterAPP/ui/patient_dictation/dictation_type.dart';
import 'package:YOURDRS_FlutterAPP/ui/patient_dictation/offline_dictation_list.dart';
import 'package:YOURDRS_FlutterAPP/utils/cached_image.dart';
import 'package:YOURDRS_FlutterAPP/utils/route_generator.dart';
import 'package:YOURDRS_FlutterAPP/widget/buttons/material_buttons.dart';
import 'package:YOURDRS_FlutterAPP/widget/buttons/mic_button.dart';
import 'package:YOURDRS_FlutterAPP/widget/buttons/raised_buttons.dart';
import 'package:connectivity/connectivity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';

import '../../common/app_colors.dart';
import '../../common/app_constants.dart';
import '../../common/app_constants.dart';
import '../../common/app_constants.dart';

class PatientDetail extends StatefulWidget {
  static const String routeName = '/PatientDetails';

  @override
  _PatientDetailState createState() => _PatientDetailState();
}

class _PatientDetailState extends State<PatientDetail> {
  List allDiction = [];
  List allPrevDiction = [];
  List myPrevDiction = [];
  Services apiServices = Services();
  var dId, data, imageName, images;
  bool cameraImageVisible = false;
  bool buttonVisible = false;
  bool isSwitched = false;
  File newImage, image;
  String fileName, filepath, memberId, memberRoleId;
  Map<String, String> paths;
  List<String> extensions;
  bool isLoadingPath = false;
  bool isMultiPick = false;
  FileType fileType;
  bool imageVisible = true;
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat(AppStrings.dateFormat);
  int dictationIds,
      dictaId,
      offlineUploadedToServer = 0,
      onlineUploadToServer = 1;
  List listId, dictId;
  bool galButtonVisible = false;
  int roleId, episodeId, appointmentId;
  String dictationId;
  List cameraImages = [];
  final ScrollController _ScrollController = ScrollController();
  bool internetAvailable = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black87),
          title: Text(" ",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14.0,
                  fontFamily: AppFonts.regular)),
          backgroundColor: CustomizedColors.primaryBgColor,
          elevation: 0,
        ),
        body: BlocListener<GetImageFilesCubit, GetImageFilesState>(
          listener: (context, state) {
            if (state.isLoading == true) {
              showLoaderDialog(this.context, text: AppStrings.loading);
            }
            if (state?.image?.attachmentNamesList != null) {
              Navigator.of(this.context, rootNavigator: true).pop();
              String files = state.image.attachmentNamesList;
              var imageFiles = files.split(",");
              RouteGenerator.navigatorKey.currentState
                  .pushNamed(ViewImages.routeName, arguments: imageFiles);
            }
          },
          child: ListView(children: [
            Container(
                width: double.infinity,
                decoration:
                    BoxDecoration(color: CustomizedColors.primaryBgColor),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 10, 10, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: width * 0.05,
                                ),
                                //...hero widget to show elevation
                                heroWidget(),
                                SizedBox(
                                  width: width * 0.07,
                                ),
                                //...patient details
                                patientDetails()
                              ],
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            patientDetailedDetails(),
                            SizedBox(
                              height: height * 0.02,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(60),
                                topRight: Radius.circular(60))),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 20),
                            audioAndCameraButtons(),
                            //.....view camera image
                            viewCameraImage(),
                            //...view gallery images
                            SizedBox(
                              height: 12,
                            ),
                            //...buttons
                            audioDictationAndImagesButton()
                          ],
                        ),
                      ),
                      // ),
                    ])),
          ]),
        ));
  }

  allDictation(int appointmentId) async {
    AllDictationService apiServices1 = AllDictationService();
    Dictations allDictations = await apiServices1.getDictations(appointmentId);
    allDiction = allDictations.audioDictations;
  }

  allPrevDictation(int episodeId, int appointmentId) async {
    AllPreviousDictationService apiServices2 = AllPreviousDictationService();
    Dictations allPreviousDictations =
        await apiServices2.getAllPreviousDictations(episodeId, appointmentId);
    allPrevDiction = allPreviousDictations.audioDictations;
  }

  myPrevDictation(int episodeId, int appointmentId) async {
    MyPreviousDictationService apiServices3 = MyPreviousDictationService();
    Dictations myPreviousDictations =
        await apiServices3.getMyPreviousDictations(episodeId, appointmentId);
    myPrevDiction = myPreviousDictations.audioDictations;
  }

  ///delete 90 days older records
  _deleteFiles() async {
    return await DatabaseHelper.db.deleteAllOlderRecords();
  }

  _deleteImages() async {
    return await DatabaseHelper.db.deleteAllOlderImagesRecords();
  }

  ///sync offline records to server
  _syncOfflineRecords() async {
    try {
      internetAvailable = await AppConstants.checkInternet();
      if (internetAvailable == true) {
        var allRows = await DatabaseHelper.db.queryUnsynchedRecords();
        allRows.forEach((row) async {
          if (row['episodeid'] != null && row['appointmentid'] != null) {
            int dictationId = await saveOfflineDictationsToServer(row);
            if (dictationId != null) {
              await DatabaseHelper.db.updateRecords(1, dictationId, row['id']);
            }
          }
        });
      } else {
        // print("Failed to update the records");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  ///call api for auto sync offline records
  Future<int> saveOfflineDictationsToServer(Map<String, dynamic> row) async {
    final ScheduleList item = ModalRoute.of(this.context).settings.arguments;
    String lastAudioFilePath = row['physicalfilename'];
    if (lastAudioFilePath != null && lastAudioFilePath.isNotEmpty) {
      String audioFileName = path.basename(lastAudioFilePath);
      List<int> fileBytes = await File(lastAudioFilePath).readAsBytes();
      String base64String = base64Encode(fileBytes);
      try {
        PostDictationsService apiPostServices = PostDictationsService();
        PostDictationsModel saveDictations =
            await apiPostServices.postApiMethod(
                row['memberid'],
                row['patientdob'],
                row['episodeid'],
                row['appointmentid'],
                roleId,
                row['dictationtypeid'],
                row['patientfirstname'],
                row['patientlastname'],
                item.lynxId,
                row['patientdob'],
                base64String,
                audioFileName);
        data = saveDictations.header.statusCode;
        if (data == '200') {
          return saveDictations.dictationId;
        }
      } catch (e) {
        throw Exception(e.toString());
        // print('${e.toString()}');
      }
    }
    return null;
  }

  //.....syncing of offline images and data
  _syncOfflineImages() async {
    try {
      final ScheduleList item = ModalRoute.of(this.context).settings.arguments;
      List allData;
      List allRow;
      internetAvailable = await AppConstants.checkInternet();
      if (internetAvailable == true) {
        //.....get dictationId from sqlite
        await getDictationId(
            item.episodeId ?? '', item.episodeAppointmentRequestId ?? '');

        ///....if list is not empty get all records from table
        if (listId.isNotEmpty) {
          List allRows =
              await DatabaseHelper.db.queryUnsynchedImageRecord(listId[0].id);
          if (allRows.length == 0) {
            allData =
                await DatabaseHelper.db.queryUnsynchedImages(listId[0].id);
            allRow = await DatabaseHelper.db.queryUnsynchedImageRecords(
              listId[0].id,
            );

            if (allRow.isEmpty) {
              return null;
            } else {
              print(allData);
              allData.forEach((element) async {
                for (int i = 0; i < allRow.length; i++) {
                  await saveOfflineImages(element, allRow[i]);
                  await DatabaseHelper.db.updateImageRecords(1, listId[0].id);
                }
              });
            }
          } else {
            allRow = await DatabaseHelper.db
                .queryUnsynchedImageRecords(listId[0].id);
            allRows.forEach((row) async {
              for (int i = 0; i < allRow.length; i++) {
                int dictationId = await saveOfflineImages(row, allRow[i]);
                if (dictationId != null) {
                  await DatabaseHelper.db
                      .updateRecords(1, dictationId, row['id']);
                  await DatabaseHelper.db.updateImageRecords(1, listId[0].id);
                }
              }
            });
          }
        } else {}
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //....sync offline data to server with api call
  Future<int> saveOfflineImages(
      Map<String, dynamic> row, Map<String, dynamic> photoRow) async {
    if (photoRow != null && photoRow.isNotEmpty) {
      String imageFile = photoRow["fileName"];
      List<int> fileBytes =
          await File(photoRow["physicalfilename"]).readAsBytesSync();
      String base64String = base64Encode(fileBytes);
      try {
        PostDictationsImageService apiPostServices =
            PostDictationsImageService();
        PostDictationsModel saveDictations =
            await apiPostServices.postApiMethod(
          row['episodeid'],
          row['appointmentid'],
          row['memberid'],
          roleId,
          row['patientfirstname'],
          row['patientlastname'],
          base64String,
          imageFile,
          AppStrings.imageFormat,
          row['patientdob'],
          row['locationid'],
          row['practiceid'],
          row['providerid'],
        );
        data = saveDictations.header.statusCode;
        if (data == '200') {
          return saveDictations.dictationId;
        }
      } catch (e) {
        throw Exception(e.toString());
      }
    }
    return null;
  }

  //..fetch memberId from SharedPreference
  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memberId = (prefs.getString(Keys.memberId) ?? '');
      var memberRoleId = (prefs.getString(Keys.memberRoleId) ?? '');
      roleId = int.tryParse(memberRoleId);
    });
  }

  //....function to open camera
  Future openCamera() async {
    try {
      image = await ImagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 100);
      cameraImages.add(image.path);
      String path = image.path;
      createFileName(path);
      setState(() {
        cameraImages;
        cameraImageVisible = true;
        imageVisible = true;
        buttonVisible = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  //....function to open gallery
  Future openGallery() async {
    setState(() => isLoadingPath = true);
    try {
      if (!isMultiPick) {
        filepath = null;
        paths = await FilePicker.getMultiFilePath(
          type: fileType != null ? fileType : FileType.image,
          allowedExtensions: extensions,
        );
        paths.forEach((key, value) {
          cameraImages.add(value);
        });
      } else {
        filepath = await FilePicker.getFilePath(
            type: fileType != null ? fileType : FileType.image,
            allowedExtensions: extensions);
        paths.forEach((key, value) {
          cameraImages.add(value);
        });
        paths = null;
      }
    } on PlatformException catch (e) {
      print(AppStrings.filePathNotFound + e.toString());
    }
    try {
      if (!mounted) return;
      setState(() {
        isLoadingPath = false;
        fileName = filepath != null
            ? filepath.split('/').last
            : paths != null
                ? paths.keys.toString()
                : '...';
        if (paths != null) {
          cameraImages;
          cameraImageVisible = true;
          imageVisible = true;
          buttonVisible = true;
        }
      });
    } on PlatformException catch (e) {
      print(AppStrings.filePathNotFound + e.toString());
    }
  }

  //.......save to server
  saveDictationsToServer() async {
    final ScheduleList item = ModalRoute.of(this.context).settings.arguments;
    for (int k = 0; k < cameraImages.length; k++) {
      List<int> fileBytes = await File(cameraImages[k]).readAsBytes();
      String byteImage = base64Encode(fileBytes);
      final String dateFormat = formatter.format(now);
      try {
        ///.........save data to server
        PostDictationsImageService apiPostServices =
            PostDictationsImageService();
        PostDictationsModel saveDictations =
            await apiPostServices.postApiMethod(
          item.episodeId ?? '',
          item.episodeAppointmentRequestId ?? '',
          int.parse(memberId),
          roleId,
          item.patient.firstName ?? '',
          item.patient.lastName ?? '',
          byteImage,
          '${item.patient.firstName ?? ''}_ ${dateFormat}_${basename('${cameraImages[k]}')}',
          AppStrings.imageFormat,
          item.patient.dob ?? '',
          item.locationId ?? '',
          item.practiceId ?? '',
          item.providerId ?? '',
        );
        dId = saveDictations.dictationId;
        data = saveDictations?.header?.statusCode;

        //.printing status code
      } catch (e) {}
    } //close
  }

  //.....saveDictation to localDb
  saveDictationToOffline(int id, int uploadedToServer) async {
    final ScheduleList item = ModalRoute.of(this.context).settings.arguments;
    await DatabaseHelper.db.insertAudioRecords(PatientDictation(
      dictationId: '${dId}',
      patientFirstName: '${item.patient.firstName ?? ''}',
      patientLastName: '${item.patient.lastName ?? ''}',
      providerName: '${item.patient.providerName ?? ''}',
      providerId: item.providerId ?? '',
      patientDOB: '${item.patient.dob ?? ''}',
      episodeId: item.episodeId ?? '',
      appointmentId: item.episodeAppointmentRequestId ?? '',
      practiceName: '${item.practice ?? ''}',
      practiceId: item.practiceId ?? '',
      createdDate: '${DateTime.now()}',
      dos: item.appointmentStartDate ?? '',
      memberId: int.parse(memberId),
      uploadedToServer: uploadedToServer ?? '',
      locationId: item.locationId ?? '',
    ));
  }

  //.....saveImages to localDb
  saveImagesToOffline(int id, int uploadedToServer) async {
    final String dateFormat = formatter.format(now);
    final ScheduleList item = ModalRoute.of(this.context).settings.arguments;
    for (int j = 0; j < cameraImages.length; j++) {
      await DatabaseHelper.db.insertPhotoList(PhotoList(
          dictationLocalId: id,
          attachmentname: '${item.patient.displayName ?? ''}_ $dateFormat',
          fileName:
              '${item.patient.firstName ?? ''}_ ${dateFormat}_${basename('${cameraImages[j]}')}',
          physicalfilename: cameraImages[j],
          attachmenttype: AppStrings.imageFormat,
          createddate: '${DateTime.now()}',
          uploadToServer: uploadedToServer ?? ''));
    }
  }

  //...get dictationId using episodeId and appointmentId
  getDictationId(int episodeId, int appointmentId) async {
    listId = await DatabaseHelper.db.getId(episodeId, appointmentId);
  }

  //...get dictationId
  getDictId() async {
    dictId = await DatabaseHelper.db.getDectionId();
    dictationIds = dictId[dictId.length - 1].id;
  }

//............save cameraImages to server
  _saveCameraImagesToServer() async {
    final String dateFormat = formatter.format(now);
    final ScheduleList item = ModalRoute.of(this.context).settings.arguments;
    internetAvailable = await AppConstants.checkInternet();

    ///..........Internet Present Case
    if (internetAvailable == true) {
      try {
        ///.........save data to server
        await saveDictationsToServer();
      } catch (e) {}
      setState(() {
        cameraImageVisible = false;
        buttonVisible = false;
        cameraImages.clear();
      });

      ///..........save data to local using Id
      await getDictationId(
        item.episodeId ?? '',
        item.episodeAppointmentRequestId ?? '',
      );
      if (listId.isNotEmpty) {
        ///..........insert images using dictionId
        await saveImagesToOffline(listId[0].id, onlineUploadToServer);
      } else {
        ///........save new diction if user is not present
        await saveDictationToOffline(dId, onlineUploadToServer);
        //.......return of dictionId
        await getDictId();

        ///..........insert images using dictionId
        await saveImagesToOffline(dictationIds, onlineUploadToServer);
      }
    }

    ///.....offline data saving to local
    else {
      await getDictationId(
        item.episodeId ?? '',
        item.episodeAppointmentRequestId ?? '',
      );
      if (listId.isNotEmpty) {
        //...save images to offline
        await saveImagesToOffline(listId[0].id, offlineUploadedToServer);
      } else {
        //...save dictation to offline
        await saveDictationToOffline(dId, offlineUploadedToServer);
        //return dictationId
        await getDictId();
        //...save images to offline
        await saveImagesToOffline(dictationIds, offlineUploadedToServer);
      }
      setState(() {
        cameraImages.clear();
        buttonVisible = false;
        cameraImageVisible = false;
        galButtonVisible = false;
      });
      AppToast().showToast(AppStrings.no_internet);
    }
  }

  //custom file name
  Future<String> createFileName(String mockName) async {
    final ScheduleList item = ModalRoute.of(this.context).settings.arguments;
    final String dateFormat = formatter.format(now);
    try {
      imageName =
          item.patient.firstName ?? '' + basename(mockName).replaceAll(".", "");
      if (imageName.length > 10) {
        imageName = imageName.substring(0, 10);

        // final Directory directory = await getExternalStorageDirectory();
        Directory appDocDirectory;
        //platform checking conditions
        if (Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }
        String path = '${appDocDirectory.path}/${AppStrings.folderName}';
        final myImgDir = await Directory(path).create(recursive: true);
        newImage = await File(image.path).copy(
            '${myImgDir.path}/${basename(imageName + '$dateFormat' + AppStrings.imageFormat)}');
        setState(() {
          newImage;
        });
      }
    } catch (e, s) {
      imageName = "";
      AppLogHelper.printLogs(e, s);
    }
    return "$dateFormat" + imageName + AppStrings.imageFormat;
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _deleteFiles();
    _deleteImages();
    // _syncOfflineRecords();
    Future.delayed(Duration.zero, () {
      this._syncOfflineImages();
    });
  }

  loadProfilePicUrls(ScheduleList item) async {
    if (item.profilePhotoContent == null) {
      PatientProfilePhotos patientProfilePhotos = await apiServices
          .getPatientProfilePhotos(item.patient.profilePhotoName);
      if (patientProfilePhotos != null) {
        if (patientProfilePhotos.content != null &&
            patientProfilePhotos.content.isNotEmpty) {
          Uint8List decoded = base64.decode(patientProfilePhotos.content);
          item.profilePhotoContent = decoded;
          setState(() {});
        }
      }
    }
  }

  //...cupertinoactionsheet
  Widget cupertinoActionSheet(BuildContext context) {
    final action = CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.camera,
                style: TextStyle(
                  fontFamily: AppFonts.regular,
                ),
              ),
            ],
          ),
          onPressed: () {
            openCamera();
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        CupertinoActionSheetAction(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.PhotoGallery,
                style: TextStyle(
                  fontFamily: AppFonts.regular,
                ),
              ),
            ],
          ),
          onPressed: () {
            openGallery();
            Navigator.of(context, rootNavigator: true).pop();
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          AppStrings.cancel,
          style: TextStyle(
            fontFamily: AppFonts.regular,
          ),
        ),
        isDestructiveAction: true,
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  //..........view camera image
  Widget viewCameraImage() {
    return Visibility(
      visible: cameraImageVisible,
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Wrap(children: [
            Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: CustomizedColors.homeSubtitleColor,
                  ),
                ),
                height: 100,
                margin: const EdgeInsets.all(10),
                child: cameraImages.length > 3
                    ? Container(
                      child: RawScrollbar(
                          controller: _ScrollController,
                          isAlwaysShown: true,
                          thumbColor: CustomizedColors.buttonTitleColor,
                          radius: Radius.circular(20),
                          thickness: 5,
                          child: GridView.count(
                            controller: _ScrollController,
                            crossAxisCount: 3,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 8.0,
                            children: List.generate(cameraImages.length, (index) {
                              var img = cameraImages[index];
                              return Container(
                                  color: CustomizedColors.primaryBgColor,
                                  margin: const EdgeInsets.all(5),
                                  child: Stack(children: [
                                    cameraImages.isEmpty || cameraImages == null
                                        ? Text(
                                            AppStrings.noImageSelected,
                                            style: TextStyle(
                                              fontFamily: AppFonts.regular,
                                            ),
                                          )
                                        : Center(
                                            child: FullScreenWidget(
                                              child: Image.file(
                                                File(img),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                    Positioned(
                                      right: -16,
                                      top: -13,
                                      child: Visibility(
                                        visible: imageVisible,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            color: CustomizedColors
                                                .SplashScreenBackgroundColor,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              //image = null;
                                              cameraImages.removeAt(index);
                                              if (cameraImages.length == 0) {
                                                imageVisible = false;
                                                cameraImageVisible = false;
                                                buttonVisible = false;
                                              } else {}
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ]));
                            }),
                          )),
                    )
                    : RawScrollbar(
                        controller: _ScrollController,
                        isAlwaysShown: true,
                        thumbColor:CustomizedColors.buttonTitleColor,
                        radius: Radius.circular(20),
                        thickness: 5,
                        child: GridView.count(
                          controller: _ScrollController,
                          crossAxisCount: 3,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 8.0,
                          children: List.generate(cameraImages.length, (index) {
                            var img = cameraImages[index];
                            return Container(
                                color: CustomizedColors.primaryBgColor,
                                margin: const EdgeInsets.all(5),
                                child: Stack(children: [
                                  cameraImages.isEmpty || cameraImages == null
                                      ? Text(
                                          AppStrings.noImageSelected,
                                          style: TextStyle(
                                            fontFamily: AppFonts.regular,
                                          ),
                                        )
                                      : Center(
                                          child: FullScreenWidget(
                                            child: Image.file(
                                              File(img),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                  Positioned(
                                    right: -16,
                                    top: -13,
                                    child: Visibility(
                                      visible: imageVisible,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: CustomizedColors
                                              .SplashScreenBackgroundColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            //image = null;
                                            cameraImages.removeAt(index);
                                            if (cameraImages.length == 0) {
                                              imageVisible = false;
                                              cameraImageVisible = false;
                                              buttonVisible = false;
                                            } else {}
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ]));
                          }),
                        )))
          ]),
        ]),
      ),
    );
  }

  //............patientDetails
  Widget patientDetails() {
    final ScheduleList item = ModalRoute.of(this.context).settings.arguments;
    loadProfilePicUrls(item);
    String dos = item.accidentDate ?? '';

    var date1 = AppConstants.parseDatePattern(dos, AppConstants.mmmdddyyyy);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.patient?.displayName ?? "",
          style: TextStyle(
              color: CustomizedColors.blueAppBarColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.regular),
        ),
        Row(
          children: [
            Text(
              item.patient?.sex ?? "",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontFamily: AppFonts.regular),
            ),
            Text("," + " ",
                style: TextStyle(
                  color: Colors.black87,
                )),
            Text(
              item.patient?.age.toString() + " " + AppStrings.yearOld ?? "",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontFamily: AppFonts.regular),
            ),
          ],
        ),
        Text(
          date1 ?? "",
          style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontFamily: AppFonts.regular),
        ),
        Text(
          item.appointmentType ?? "",
          style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontFamily: AppFonts.regular),
        )
      ],
    );
  }

//....patientDetailedDetails
  Widget patientDetailedDetails() {
    final ScheduleList item = ModalRoute.of(this.context).settings.arguments;
    String dos = item.appointmentStartDate ?? '';
    var date = AppConstants.parseDatePattern(dos, AppConstants.mmmdddyyyy);
    String dobirth=item.patient?.dob ??'';
    var dobDate=dobirth.replaceAll("/", "-");
    return Row(
      children: [
        Padding(padding: EdgeInsets.only(right: 10)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.dateOfBirth + " " + ":" + " " + dobDate,
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontFamily: AppFonts.regular),
            ),
            Text(
              AppStrings.caseNo + " " + ":" + " " + item?.lynxId ?? "",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontFamily: AppFonts.regular),
            ),
            Text(
              AppStrings.dos + " " + ":" + " " + date,
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontFamily: AppFonts.regular),
            ),
          ],
        ),
      ],
    );
  }

  //....dictation and view image buttons
  Widget audioDictationAndImagesButton() {
    final ScheduleList item = ModalRoute.of(this.context).settings.arguments;
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      ///...save images button
      Visibility(
        visible: buttonVisible,
        child: RaisedBtn(
            text: AppStrings.submitImages,
            onPressed: () async {
              showLoader(this.context, AppStrings.uploading);
              await _saveCameraImagesToServer();
              Navigator.of(this.context, rootNavigator: true).pop();
              AppToast().showToast(AppStrings.uploadedDataSuccessfully);
            },
            iconData: Icons.image),
      ),

      SizedBox(height: 15),
      //......all dictation button
      RaisedBtn(
          text: AppStrings.allDictations,
          onPressed: () async {
            internetAvailable = await AppConstants.checkInternet();
            if (internetAvailable == true) {
              showLoaderDialog(this.context, text: AppStrings.loading);
              await _syncOfflineRecords();

              Future.delayed(Duration(seconds: 8), () async {
                await allDictation(item.episodeAppointmentRequestId);
                await allPrevDictation(
                    item.episodeId, item.episodeAppointmentRequestId);
                await myPrevDictation(
                    item.episodeId, item.episodeAppointmentRequestId);
                Navigator.of(this.context, rootNavigator: true).pop();
                if (allDiction.length == 0 &&
                    allPrevDiction.length == 0 &&
                    myPrevDiction.length == 0) {
                  AppToast().showToast(AppStrings.noDictations);
                } else {
                  RouteGenerator.navigatorKey.currentState
                      .pushNamed(DictationType.routeName, arguments: {
                    'allDictation': allDiction,
                    'allPreDictation': allPrevDiction,
                    'myPreDictation': myPrevDiction,
                    'item': item
                  });
                }
              });
            } else {
              RouteGenerator.navigatorKey.currentState.pushNamed(
                  OfflineDictationsList.routeName,
                  arguments: {'item': item});
            }
          },
          iconData: Icons.mic_rounded),
      SizedBox(height: 15),

      ///....all images button
      RaisedBtn(
          text: AppStrings.images,
          onPressed: () async {
            try {
              internetAvailable = await AppConstants.checkInternet();
              if (internetAvailable == true) {
                //...checking dictationId is null from ScheduleList
                if (((item.dictationId ?? '') == 0)) {
                  //...checking dictationId is null from server
                  if (dId == null) {
                    AppToast().showToast(AppStrings.noImageSelected);
                  }
                  //if not null getting images from server using Did
                  else {
                    BlocProvider.of<GetImageFilesCubit>(this.context)
                        .getImageFiles(dId);
                  }
                } else {
                  //if not null getting images from server using Did from scheduleList
                  BlocProvider.of<GetImageFilesCubit>(this.context)
                      .getImageFiles(item.dictationId ?? '');
                }
              } else {
                ///get offline images
                await getDictationId(
                  item.episodeId ?? '',
                  item.episodeAppointmentRequestId ?? '',
                );
                if ((listId.isNotEmpty)) {
                  List attachments =
                      await DatabaseHelper.db.getAllImages(listId[0].id);
                  if (attachments.isEmpty && attachments.length == 0) {
                    AppToast().showToast(AppStrings.noImageSelected);
                  } else {
                    RouteGenerator.navigatorKey.currentState.pushNamed(
                        ViewImages.routeName,
                        arguments: attachments);
                  }
                } else {
                  AppToast().showToast(AppStrings.noImageSelected);
                }
              }
            } catch (e) {
              // print(e.toString());
            }
          },
          iconData: Icons.camera_alt),
    ]);
  }

  //....audio and camera button
  Widget audioAndCameraButtons() {
    final ScheduleList item = ModalRoute.of(this.context).settings.arguments;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        //Button for mic
        roleId != 1
            ? AudioMicButtons(
                patientFName: item.patient.firstName,
                patientLName: item.patient.lastName,
                caseId: item.lynxId,
                patientDob: item.patient.dob,
                practiceId: item.practiceId,
                statusId: item.dictationStatusId,
                episodeId: item.episodeId,
                episodeAppointmentRequestId: item.episodeAppointmentRequestId,
                appointmentType: item.appointmentType,
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
            : Container(height: 5, width: 5),

        //Button for camera
        roleId != 1
            ? MaterialButtons(
                onPressed: () {
                  // CupertinoActionSheet for camera and gallery
                  cupertinoActionSheet(this.context);
                },
                iconData: Icons.camera_alt,
              )
            : Container(height: 5, width: 5)
      ],
    );
  }

  //....hero widget
  Widget heroWidget() {
    final ScheduleList item = ModalRoute.of(this.context).settings.arguments;
    return Hero(
      transitionOnUserGestures: true,
      tag: item,
      child: Transform.scale(
        scale: 2.0,
        child: item.profilePhotoContent != null
            ? CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[200],
                child: ClipOval(
                  child: Image.memory(item.profilePhotoContent,
                      fit: BoxFit.contain),
                ),
              )
            : CachedImage(
                null,
                isRound: true,
                radius: 35.0,
              ),
      ),
    );
  }

  showLoader(BuildContext context, String text) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
            backgroundColor: Colors.white,
            children: <Widget>[
              Center(
                  child: Row(
                children: [
                  SizedBox(width: 25),
                  CupertinoActivityIndicator(radius: 20),
                  SizedBox(width: 35),
                  Text(
                    text,
                    style: TextStyle(
                        fontFamily: AppFonts.regular,
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              )),
            ],
          ),
        );
      },
    );
  }
}
