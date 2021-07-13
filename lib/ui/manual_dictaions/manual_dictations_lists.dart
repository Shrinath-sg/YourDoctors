import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:YOURDRS_FlutterAPP/common/app_alertbox.dart';
import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';
import 'package:YOURDRS_FlutterAPP/common/app_loader.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/common/app_toast_message.dart';
import 'package:YOURDRS_FlutterAPP/helper/db_helper.dart';
import 'package:YOURDRS_FlutterAPP/network/models/dictations/play_dictations.dart';
import 'package:YOURDRS_FlutterAPP/network/models/dictations/view_doc_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/external_dictations/get_all_manual_dictation_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/dictation.dart';
import 'package:YOURDRS_FlutterAPP/network/services/dictation/dictation_services.dart';
import 'package:YOURDRS_FlutterAPP/network/services/dictation/play_audio_services.dart';
import 'package:YOURDRS_FlutterAPP/ui/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:YOURDRS_FlutterAPP/ui/manual_dictaions/offline_manual_images.dart';
import 'package:YOURDRS_FlutterAPP/ui/patient_dictation/play_audio.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../network/models/manual_dictations/external_dictation_attachment_model.dart';
import '../../network/models/manual_dictations/photo_list.dart';
import '../../network/repo/local/preference/local_storage.dart';
import '../../network/services/dictation/external_attachment_dictation.dart';
import '../../utils/route_generator.dart';
import 'image_list.dart';
import 'manual_dictations.dart';

class GetMyManualDictations extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GetMyManualDictationsState();
  }
}

class GetMyManualDictationsState extends State<GetMyManualDictations>
    with AutomaticKeepAliveClientMixin {
  /// Declaring variables
  bool _hasMore = true;
  int _pageNumber = 0;
  bool _error = false;
  bool _loading = false;
  bool isNetAvailable;
  final int _defaultDataPerPageCount = 20;
  List<AudioDictations> _audioDictates = [];
  int thresholdValue = 0;
  var filePath;
  AppToast appToast = AppToast();
  ViewDocumentService viewDocFileService = ViewDocumentService();
  String convertedMp4Sync;
  var photoListOfGallery = [];
  bool emergencyAddOn = true;

  /// Creating an object for GetAllMyManualDictationApi
  AllMyManualDictations apiServices = AllMyManualDictations();

  GetManualPhotosService apiServices2 = GetManualPhotosService();
  final _key = UniqueKey();
//bool isInit=true;
//Future _getAllOfflineManualDictations;
  var _scrollController = ScrollController();
  double maxScroll, currentScroll;
  bool isInternetAvailable = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    syncOfflineData();
  }

  // Future<void> loadPage()async{
  //   print('loading page');
  //   GetAllMyManualDictation allMyManualDictations =
  //   await apiServices.getMyManualDictations(_pageNumber);
  //   if (!mounted) return;
  //   setState(() {
  //     _hasMore = allMyManualDictations.audioDictations?.length ==
  //         _defaultDataPerPageCount;
  //     _loading = false;
  //     _pageNumber = _pageNumber + 1;
  //     _audioDictates.addAll(allMyManualDictations?.audioDictations);
  //   });
  // }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    isInternetAvailable = await AppConstants.checkInternet();
    getMyManualDictations();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    try {
      if (maxScroll > 0 && currentScroll > 0 && maxScroll == currentScroll) {
        getMyManualDictations();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  // @override
  // Future<void> didChangeDependencies() async {
  //
  //     if(isInit) {
  //       print("didChnage dependency......");
  //       GetAllMyManualDictation allMyManualDictations =
  //       await apiServices.getMyManualDictations(_pageNumber);
  //       if (!mounted) return;
  //       setState(() {
  //         _hasMore = allMyManualDictations.audioDictations?.length ==
  //             _defaultDataPerPageCount;
  //         _loading = false;
  //         _pageNumber = _pageNumber + 1;
  //         _audioDictates.addAll(allMyManualDictations?.audioDictations);
  //       });
  //       super.didChangeDependencies();
  //     }
  //
  //     isInit=false;
  // }

  /// build Method
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => RouteGenerator.navigatorKey.currentState
          .pushReplacementNamed(CustomBottomNavigationBar.routeName),
      child: Scaffold(
        body: SingleChildScrollView(
          controller: _scrollController,
          // shrinkWrap: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              getBodyOffline(),
              getBody(),
            ],
          ),
        ),
      ),
    );
  }

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
    if (File(fileExists).existsSync()) {
      filePath = fileExists;
      setState(() {
        isNetAvailable = true;
      });
    } else {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
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

  /// body Widget
  Widget getBody() {
    if (_loading && _pageNumber == 1) {
      return _loader();
    }

    // if (_error) {
    //   return _errorText(message: AppStrings.somethingwentwrong_text);
    // }
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // if (_audioDictates?.isEmpty ?? false) {
    //   if (_loading) {
    //     // return Center(
    //     //   // child: Padding(
    //     //   //   padding: const EdgeInsets.all(8),
    //     //   //   child: CupertinoActivityIndicator(
    //     //   //     radius: 19,
    //     //   //     // valueColor: AlwaysStoppedAnimation(CustomizedColors.primaryColor),
    //     //   //   ),
    //     //   // ),
    //     // );
    //   } else if (_error) {
    //     return Center(
    //         child: InkWell(
    //       onTap: () {
    //         setState(
    //           () {
    //             _loading = true;
    //             _error = false;
    //             didChangeDependencies();
    //           },
    //         );
    //       },
    //       child: Padding(
    //         padding: const EdgeInsets.all(16),
    //         child: Text(
    //           "Error while loading photos, tap to try again after sometime",
    //           style: TextStyle(
    //             fontFamily: AppFonts.regular,
    //             fontSize: 14,
    //           ),
    //         ),
    //       ),
    //     ));
    //   }
    // }
    // else {
    return _audioDictates?.isNotEmpty ?? false
        // Container(
        // child:
        ? ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _audioDictates.length + (_hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _audioDictates.length) {
                return _loader();
              }
              // final AudioDictations _audioDictations =_audioDictates[index];

              // if (index == _audioDictates.length) {
              //   if (_error) {
              //     return Center(
              //         child: InkWell(
              //       onTap: () {
              //         setState(() {
              //           _loading = true;
              //           _error = false;
              //           didChangeDependencies();
              //         });
              //       },
              //       child: Padding(
              //         padding: const EdgeInsets.all(16),
              //         child: Text(
              //           "Error while loading photos, tap to try again",
              //           style: TextStyle(
              //             fontFamily: AppFonts.regular,
              //             fontSize: 14,
              //           ),
              //         ),
              //       ),
              //     ));
              //   } else {
              //     return Center(
              //         child: Padding(
              //       padding: const EdgeInsets.all(8),
              //       child: CupertinoActivityIndicator(
              //         radius: 12,
              //       ),
              //     ));
              //   }
              // }
              final AudioDictations audioDictations = _audioDictates[index];
              String memberPhotos = audioDictations.photoNameList;
              final List<String> imagesList = [];
              final split = memberPhotos.split(',');
              if (!split.contains("") ||
                  !split.any((element) => element.contains(""))) {
                Map<int, String> photolist = {
                  for (int i = 0; i < split.length; i++) i: split[i]
                };
                for (int i = 0; i < photolist.length; i++) {
                  imagesList.add(photolist[i]);
                }
              }
              return AnimationLimiter(
                  child: Column(
                children: [
                  AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 10),
                    child: FadeInAnimation(
                      child: SlideAnimation(
                        horizontalOffset: MediaQuery.of(context).size.width / 2,
                        child: Card(
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: width * 0.40,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              audioDictations.patientFirstName +
                                                  ' ' +
                                                  audioDictations
                                                      .patientLastName +
                                                  ',' +
                                                  " ",
                                              style: TextStyle(
                                                  fontFamily: AppFonts.regular,
                                                  fontSize: 14),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                            audioDictations.dos,
                                            style: TextStyle(
                                                fontFamily: AppFonts.regular,
                                                fontSize: 14),
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                    ),
                                    audioDictations.transcriptionFileName != ""
                                        ? Container(
                                            width: width * 0.15,
                                            color:
                                                CustomizedColors.primaryBgColor,
                                            child: IconButton(
                                              padding: EdgeInsets.all(0),
                                              icon: Icon(
                                                Icons.remove_red_eye,
                                                size: 30,
                                              ),
                                              onPressed: () async {
                                                var connectivityResult =
                                                    await (Connectivity()
                                                        .checkConnectivity());
                                                if (connectivityResult ==
                                                        ConnectivityResult
                                                            .mobile ||
                                                    connectivityResult ==
                                                        ConnectivityResult
                                                            .wifi) {
                                                  setState(() {
                                                    isNetAvailable = true;
                                                  });
                                                } else {
                                                  setState(() {
                                                    isNetAvailable = false;
                                                  });
                                                }
                                                if (isNetAvailable == true) {
                                                  showLoaderDialog(
                                                    context,
                                                    text: AppStrings.loading,
                                                  );
                                                  ViewDocument docUrl =
                                                      await viewDocFileService
                                                          .getDocument(
                                                              audioDictations
                                                                  .transcriptionFileName);
                                                  String urlFile =
                                                      docUrl.fileName;

                                                  if (urlFile != null) {
                                                    Navigator.of(this.context,
                                                            rootNavigator: true)
                                                        .pop();
                                                    _handleURLButtonPress(
                                                        context, urlFile);
                                                  } else {
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
                                              color:
                                                  CustomizedColors.accentColor,
                                            ))
                                        : Container(width: width * 0.15),
                                    SizedBox(
                                      width: 1,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 5),
                                      child: Container(
                                        width: width * 0.10,
                                        color: CustomizedColors.primaryBgColor,
                                        child: IconButton(
                                          padding: EdgeInsets.only(right: 1),
                                          onPressed: () async {
                                            if (audioDictations.fileName.isEmpty ||
                                                audioDictations.fileName ==
                                                    null ||
                                                audioDictations
                                                        .displayFileName ==
                                                    null ||
                                                audioDictations
                                                    .displayFileName.isEmpty) {
                                              customAlertMessage(
                                                  AppStrings.noAudioRecordings,
                                                  context);
                                            } else {
                                              showLoaderDialog(context,
                                                  text: AppStrings.loading);
                                              await getRecordings(
                                                  audioDictations.fileName,
                                                  audioDictations
                                                      .displayFileName);
                                              Navigator.of(this.context,
                                                      rootNavigator: true)
                                                  .pop();
                                              if (isNetAvailable == true) {
                                                await showCupertinoModalPopup<
                                                    void>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CupertinoActionSheet(
                                                      actions: [
                                                        Material(
                                                          child: Container(
                                                            height:
                                                                height * 0.35,
                                                            child: Center(
                                                              child: Container(
                                                                height: height *
                                                                    0.50,
                                                                width: width *
                                                                    0.90,
                                                                child: ListView(
                                                                  children: [
                                                                    Column(
                                                                      children: [
                                                                        PlayerWidget(
                                                                          displayFileName: audioDictations.patientFirstName +
                                                                              ' ' +
                                                                              audioDictations.patientLastName +
                                                                              ',' +
                                                                              " " +
                                                                              audioDictations.dos,
                                                                          url:
                                                                              filePath,
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
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  AppFonts
                                                                      .regular,
                                                              fontSize: 14,
                                                              color: CustomizedColors
                                                                  .canceltextColor),
                                                        ),
                                                        //isDefaultAction: true,
                                                        // isDestructiveAction: true,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    );
                                                  },
                                                );
                                              } else {
                                                AppToast().showToast(AppStrings
                                                    .networkNotConnected);
                                              }
                                            }
                                          },
                                          icon: Icon(
                                            Icons.play_circle_fill,
                                            size: 30,
                                          ),
                                          color: CustomizedColors
                                              .dictationListIconColor,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        if (imagesList.isNotEmpty) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Manualimages(
                                                      photolist: imagesList,
                                                    )),
                                          );
                                        } else {
                                          customAlertMessage(
                                              "No image found", context);
                                        }
                                      },
                                      child: Container(
                                        width: width * 0.10,
                                        color: CustomizedColors.primaryBgColor,
                                        child: IconButton(
                                          padding: EdgeInsets.only(right: 1),
                                          icon: Icon(
                                            Icons.image,
                                            size: 30,
                                            color: CustomizedColors
                                                .dictationListIconColor,
                                          ),
                                          color: CustomizedColors
                                              .dictationListIconColor,
                                          //   onPressed: () {  },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
            },
          )
        : _errorText(message: AppStrings.nofutherrecords_text);
    //  CupertinoActivityIndicator(radius: 20);
    //);
    //  }
    return Container();
  }

  getMyManualDictations() async {
    if (!mounted) return;

    if (isInternetAvailable) {
      if (!_hasMore) {
        appToast.showToast(AppStrings.nofurtherdocumentsfound_text);
        return;
      }

      setState(() {
        _loading = true;
        _error = false;
      });

      _pageNumber = _pageNumber + 1;
      GetAllMyManualDictation allMyManualDictations =
          await apiServices.getMyManualDictations(_pageNumber);
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }

      if (allMyManualDictations != null) {
        if (allMyManualDictations.audioDictations == null ||
            allMyManualDictations.audioDictations.isEmpty) {
          _hasMore = false;
          _error = true;
        } else {
          _audioDictates.addAll(allMyManualDictations?.audioDictations);
          _error = false;
        }
      } else {
        _error = true;
      }
    } else {
      appToast.showToast(AppStrings.connection_text);
    }
  }

  Widget _loader() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8),
      child: CupertinoActivityIndicator(
        radius: 20,
      ),
    ));
  }

  Widget _errorText({String message}) {
    return Center(
        child: InkWell(
      onTap: () {
        _pageNumber = 0;
        _hasMore = true;
        getMyManualDictations();
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message ?? AppStrings.errorloadingphotos_text,
          style: TextStyle(
            fontFamily: AppFonts.regular,
          ),
        ),
      ),
    ));
  }

  /// Declaring variables
  var filePathOffline;
  bool audioAvailable;

  /// Creating an object for GetAllMyManualDictationApi
  List<PatientDictation> list = [];

  /// used to get the recording
  getRecordingsOffline(String fileName) async {
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
      filePathOffline = fileExists;
      setState(() {
        audioAvailable = true;
      });
    } else {
      setState(() {
        audioAvailable = false;
      });
    }
  }

  String audioFileName;

  /// body Widget
  Widget getBodyOffline() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: FutureBuilder<Object>(
          future: DatabaseHelper.db.getAllOfflineManualDictations(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CupertinoActivityIndicator(radius: 20),
              );
            } else {
              list = snapshot.data as List<PatientDictation>;
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  audioFileName = path
                      .basename(list[index].physicalFileName ?? "")
                      .split('/')
                      .last;
                  return AnimationLimiter(
                      child: Column(
                    children: [
                      AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 250),
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
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: width * 0.55,
                                          child:
                                              // Text(audioDictations.photoNameList),
                                              Text(
                                            '${list[index].patientFirstName} ${list[index].patientLastName}, ${list[index].dos}',
                                            style: TextStyle(
                                                fontFamily: AppFonts.regular,
                                                fontSize: 14),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 5),
                                          child: Container(
                                            width: width * 0.10,
                                            color:
                                                CustomizedColors.primaryBgColor,
                                            child: IconButton(
                                              padding:
                                                  EdgeInsets.only(right: 1),
                                              onPressed: () async {
                                                showLoaderDialog(
                                                  context,
                                                  text: AppStrings.loading,
                                                );
                                                await getRecordingsOffline(
                                                  audioFileName,
                                                );
                                                Navigator.of(this.context,
                                                        rootNavigator: true)
                                                    .pop();
                                                if (audioAvailable == true) {
                                                  await showCupertinoModalPopup<
                                                      void>(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return CupertinoActionSheet(
                                                        actions: [
                                                          Material(
                                                            child: Container(
                                                              height:
                                                                  height * 0.35,
                                                              child: Center(
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      height *
                                                                          0.50,
                                                                  width: width *
                                                                      0.90,
                                                                  child:
                                                                      ListView(
                                                                    children: [
                                                                      Column(
                                                                        children: [
                                                                          PlayerWidget(
                                                                            displayFileName:
                                                                                '${list[index].patientFirstName ?? ""} ${list[index].patientLastName ?? ""}, ${list[index].dos ?? ""}',
                                                                            url:
                                                                                filePathOffline,
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
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    AppFonts
                                                                        .regular,
                                                                color: CustomizedColors
                                                                    .canceltextColor),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  AppToast().showToast(
                                                      "audio not available");
                                                }
                                              },
                                              icon: Icon(
                                                Icons.play_circle_fill,
                                                size: 30,
                                              ),
                                              color:
                                                  CustomizedColors.customeColor,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 1),
                                          child: Container(
                                            width: width * 0.10,
                                            color:
                                                CustomizedColors.primaryBgColor,
                                            child: IconButton(
                                              padding:
                                                  EdgeInsets.only(right: 1),
                                              onPressed: () async {
                                                // List<PhotoList> offlinePhotoList =
                                                // await DatabaseHelper.db.getManualAttachmentImages(list[index].id);
                                                print(
                                                    "id=-- ${list[index].id}");
                                                // print(offlinePhotoList.length);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          OfflineManualImages(
                                                            id: list[index].id,
                                                          )),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.image,
                                                size: 30,
                                              ),
                                              color:
                                                  CustomizedColors.customeColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ));
                },
              );
            }
          }),
    );
  }

  void _handleURLButtonPress(BuildContext context, String urlFile) {
    String url = urlFile.replaceAll('&', '%26').replaceAll('=', '%3D');
    double width = MediaQuery.of(context).size.width;
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (context) => WebViewContainer(url)));
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
  /*
Sync offline Manual Dictations to Server
*/

  syncOfflineData() async {
    bool isInternetAvailable = await AppConstants.checkInternet();
    if (isInternetAvailable == true) {
      List<PatientDictation> offlineRecords =
          await DatabaseHelper.db.getAllOfflineManualDictations();
      if (offlineRecords.isNotEmpty) {
        showLoaderDialog(this.context, text: AppStrings.syncingOffline);

        /// Each manual record
        for (PatientDictation record in offlineRecords) {
          List<PhotoList> offlinePhotoList =
              await DatabaseHelper.db.getManualAttachmentImages(record?.id);

          if (record?.physicalFileName == null ||
              record?.physicalFileName == '' ||
              record?.displayFileName == null) {
            convertedMp4Sync = null;
          } else {
            String audioFilePath = record?.physicalFileName;
            List<int> audioBytes = await File(audioFilePath)?.readAsBytes();
            convertedMp4Sync = base64Encode(audioBytes);
          }

          /// Each offline manual photo for id

          for (PhotoList photo in offlinePhotoList) {
            String filePath = photo?.physicalfilename;

            if (filePath == null || filePath == '') {
              photoListOfGallery = null;
            } else {
              List<int> fileBytes = await File(filePath)?.readAsBytes();
              String convertedImg = base64Encode(fileBytes);
              photoListOfGallery.add({
                "header": {
                  "status": "string",
                  "statusCode": "string",
                  "statusMessage": "string"
                },
                "content": convertedImg,
                "name": photo?.fileName,
                "attachmentType": '.jpg'
              });
            }
          }

          try {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String memberId = (prefs.getString(Keys.memberId) ?? '');
            if (record.isEmergencyAddOn == 0) {
              emergencyAddOn = false;
            } else {
              emergencyAddOn = true;
            }
            ExternalDictationAttachment apiAttachmentPostServices =
                ExternalDictationAttachment();
            SaveExternalDictationOrAttachment saveDictationAttachments =
                await apiAttachmentPostServices.postApiServiceMethod(
              record?.practiceId ?? null,
              // practiceId,
              record?.locationId ?? null,
              //locationId,
              record?.providerId ?? null,
              //provderId,
              record?.patientFirstName,
              record?.patientLastName,
              record?.patientDOB,
              record?.dos,
              memberId,
              record?.externalDocumentTypeId ?? null,
              record?.appointmentTypeId ?? null,
              //appointmenttype
              emergencyAddOn,
              record?.description,
              record?.attachmentType ?? null,
              convertedMp4Sync ?? null,
              record?.attachmentName ?? null,
              photoListOfGallery,
            );

            String statusCode = saveDictationAttachments?.header?.statusCode;

            int dictationId = saveDictationAttachments?.dictationId;

            if (dictationId != null) {
              await DatabaseHelper.db
                  .updateManualRecord(1, dictationId, record?.id);
            } else {
              print('something wrong in manual dictation sync');
            }
          } catch (e) {
            // print('SaveAttachmentDictation exception ${e.toString()}');
          }
          offlinePhotoList.clear();
          photoListOfGallery.clear();
        }
        Navigator.of(this.context, rootNavigator: true).pop();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ManualDictations()));
      } else {
        print('no offline records');
      }
    } else {
      print('connect to internet');
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
