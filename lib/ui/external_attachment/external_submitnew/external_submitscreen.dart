import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';
import 'package:YOURDRS_FlutterAPP/common/app_loader.dart';
import 'package:YOURDRS_FlutterAPP/common/app_log_helper.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_toast_message.dart';
import 'package:YOURDRS_FlutterAPP/cubit/manual_dictation_cubit/location_cubit.dart';
import 'package:YOURDRS_FlutterAPP/cubit/manual_dictation_cubit/practice_cubit.dart';
import 'package:YOURDRS_FlutterAPP/cubit/manual_dictation_cubit/provider_cubit.dart';
import 'package:YOURDRS_FlutterAPP/network/models/external_dictations/external_database_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/photo_list.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/practice.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/document_type.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/location_field_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/provider_model.dart';
import 'package:YOURDRS_FlutterAPP/helper/db_helper.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:YOURDRS_FlutterAPP/network/services/dictation/extrenalattachmnent_postapi.dart';
import 'package:YOURDRS_FlutterAPP/ui/manual_dictaions/date_Valid.dart';
import 'package:YOURDRS_FlutterAPP/utils/route_generator.dart';
import 'package:YOURDRS_FlutterAPP/widget/buttons/raised_buttons.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/external_documenttype.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/location_field.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/practice_field.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/provider_field.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/external_dictation_attachment_model.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import '../../../common/app_text.dart';
import '../external_attachment.dart';
import 'dart:async';

///------------------------------This is the SubmitNew class and this class contains all the fields for ExternalAttachment screen
class SubmitNew extends StatefulWidget {
  @override
  _SubmitNewState createState() => _SubmitNewState();
}

class _SubmitNewState extends State<SubmitNew> {
  bool widgetVisible = false;
  bool visible = false;
  Directory directory;
  bool isSwitched = false;
  File newImage, image;
  String fileName;
  String filepath;
  Map<String, String> paths;
  List<String> extensions;
  bool isLoadingPath = false;
  bool isMultiPick = false;
  FileType fileType;
  bool imageVisible = true;
  var imageName;
  int imageIndex = 0;
  bool changeOnTap;

  // ignore: deprecated_member_use
  List imageArray = new List();
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat(AppStrings.dateFormatr);
  String selectedProvidername;
  String selectedDate;
  String practiceId;
  String selectedPractice2;
  String selectedLocation;
  String selecteddocumnettype;
  String LocationId;
  String providerId1;
  int documenttypeId;
  int toggleVal = 0;
  var memberId;
  var statusCode, attachmentContent;
  var path;
  bool isInternetAvailable = true;
  bool cameraImageVisible = false;
  bool isToggle = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController Description = TextEditingController();
  final _dateOfbirthController = TextEditingController();
  String content, name;
  int uploadedToServerTrue = 1, uploadedToServerFalse = 0;
  AppToast appToast = AppToast();
  List photoListOfGallery = [];
  bool emergencyAddOn = true;
  List cameraImages = [];
  bool isCamera = false;
  List arrayOfImages = [];
  int _groupButtonSelectedindex;

  final ScrollController _ScrollController = ScrollController();
  FocusNode focusNodeDob = FocusNode();
  final _fnameKey = GlobalKey<FormFieldState>();
  final _lnameKey = GlobalKey<FormFieldState>();
  final _dobKey = GlobalKey<FormFieldState>();



  @override
  void initState() {
    _loadData();
    DeleteFiles();

    super.initState();
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      RouteGenerator.navigatorKey.currentState
          .pushReplacementNamed(ExternalAttachments.routeName);
    });
  }

  static void _listener() {
    if (_myNodeForFname.hasFocus ||
        _myNodeForLname.hasFocus ||
        _myNodeForDescription.hasFocus) {
      Timer(Duration(seconds: 10), () {
        FocusManager.instance.primaryFocus.unfocus();
      });
      // keyboard appeared
    } else {
      // keyboard dismissed
    }
  }

  static FocusNode _myNodeForFname = new FocusNode()..addListener(_listener);
  static FocusNode _myNodeForLname = new FocusNode()..addListener(_listener);
  static FocusNode _myNodeForDescription = new FocusNode()
    ..addListener(_listener);

  void DeleteFiles() async {
    await DatabaseHelper.db.deleteAllExternalRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 00, horizontal: 18),
//-----------------GestureDetector for shifting focus from input feilds to background layout (for dismissing keyboard after clicking outside the textinput feilds)
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: RefreshIndicator(
            child: Form(
              key: _formKey,
//------------------Scrollview for entire body,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
//----------------------------------Practice Field
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                        AppStrings.practice,
                        style: TextStyle(
                          fontFamily: AppFonts.regular,
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: CustomizedColors.accentColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: BlocProvider(
                        create: (context) => PracticeListCubit(),
                        child: PracticeDropDown(
                          onTapOfPractice: (newValue) {
                            setState(() {
                              if (newValue != null) {
                                practiceId =
                                    (newValue as PracticeList).id.toString();
                                selectedPractice2 =
                                    (newValue as PracticeList).name;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
//---------------------------------------------Location Field
                    Text(
                      AppStrings.locationtxt,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontFamily: AppFonts.regular,
                        fontWeight: FontWeight.bold,
                        color: CustomizedColors.practice_textColor,
                      ),
                    ),
                    SizedBox(height: 15),

                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: BlocProvider(
                        create: (context) => LocationCubit(),
                        child: Locations(
                          onTapOfLocation: (newValue) async {
                            setState(() {
                              if (newValue != null) {
                                LocationId =
                                    (newValue as LocationList).id.toString();
                                selectedLocation =
                                    (newValue as LocationList).name;
                              }
                            });
                          },
                          PracticeIdList: practiceId.toString(),
                        ),
                      ),
                    ),

//---------------------------------------Provider Field
                    SizedBox(height: 15),
                    Text(
                      AppStrings.provider,
                      style: TextStyle(
                        fontFamily: AppFonts.regular,
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: CustomizedColors.accentColor,
                      ),
                    ),
                    SizedBox(height: 15),

                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: BlocProvider(
                        create: (context) => ProviderCubit(),
                        child: ExternalProviderDropDown(
                          onTapOfProvider: (newValue) async {
                            if (newValue != null) {
                              providerId1 = (newValue as ProviderList)
                                  .providerId
                                  .toString();
                              selectedProvidername =
                                  (newValue as ProviderList).displayname;
                            }
                          },
                          prevLocationId: LocationId.toString(),
                          selectedProviderId: '',
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

//------------------------------------------First Name Field
                    Text(
                      AppStrings.firstName,
                      style: TextStyle(
                        fontFamily: AppFonts.regular,
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: CustomizedColors.accentColor,
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: TextFormField(
                        key: _fnameKey,
                        focusNode: _myNodeForFname,
                        onChanged: (value) {
                          _fnameKey.currentState.validate();
                        },
                        enableInteractiveSelection: false,
                        inputFormatters: [
                          // ignore: deprecated_member_use
                          WhitelistingTextInputFormatter(
                              RegExp(AppConstants.nameRegExp))
                        ],
                        //validator: validateInput,
                        controller: firstname,
                        decoration: InputDecoration(
                          hintText: AppStrings.firstName,
                          hintStyle: TextStyle(fontSize: 14),
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue)),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
//-----------------------------------------Last Name Field

                    Text(
                      AppStrings.lastName,
                      style: TextStyle(
                        fontFamily: AppFonts.regular,
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: CustomizedColors.accentColor,
                      ),
                    ),
                    SizedBox(height: 15),

//--------------TextFeild last name
                    Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: TextFormField(
                        key: _lnameKey,
                        focusNode: _myNodeForLname,
                        onChanged: (value) {
                          _lnameKey.currentState.validate();
                        },
                        enableInteractiveSelection: false,
                        inputFormatters: [
                          // ignore: deprecated_member_use
                          WhitelistingTextInputFormatter(
                              RegExp(AppConstants.nameRegExp))
                        ],
                        //validator: validateInput,
                        controller: lastname,
                        decoration: InputDecoration(
                          hintText: AppStrings.lastName,
                          hintStyle: TextStyle(fontSize: 14),
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue)),
                        ),
                      ),
                    ),

//------------------------------------------Date of birth Field
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        AppStrings.dateOfBirth,
                        style: TextStyle(
                          fontFamily: AppFonts.regular,
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: CustomizedColors.accentColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
//-----------------------date of Birth Picker
                    Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: TextFormField(
                        key: _dobKey,
                        onChanged: (value) {
                          _dobKey.currentState.validate();
                        },
                        enableInteractiveSelection: false,
                        focusNode: focusNodeDob,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(AppConstants.dateNumRegExp)),
                          LengthLimitingTextInputFormatter(10),
                          DateValidFormatter(),
                        ],
                        //validator: validateInput,
                        controller: _dateOfbirthController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: AppStrings.dateFormatLableHintText,
                          hintStyle: TextStyle(fontSize: 14),
                          labelText: AppStrings.dateFormatLableHintText,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.calendar_today_sharp,
                                color: CustomizedColors.accentColor,
                              ),
                              onPressed: () async {
                                focusNodeDob.unfocus();
                                focusNodeDob.canRequestFocus = false;
                                DateTime dd = DateTime(1900);
                                dd = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now());
                                if (dd != null) {
                                  final DateFormat formats = DateFormat(
                                      AppStrings.dateFormatForDatePicker);
                                  selectedDate = formats.format(dd);
                                  _dateOfbirthController.text =
                                      selectedDate.toString();
                                  _dobKey.currentState.validate();
                                }
                                focusNodeDob.canRequestFocus = true;
                              },
                            ),
                          ),
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue)),
                        ),
                      ),
                    ),

//----------------------------Document type Field
                    SizedBox(height: 15),
                    Container(
                      child: Text(
                        AppStrings.documenttype +
                            " " +
                            AppStrings.mandatoryAsterisk,
                        style: TextStyle(
                          fontFamily: AppFonts.regular,
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: CustomizedColors.accentColor,
                          //color: CustomizedColors.practice_textColor,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.95,
                    ),
                    SizedBox(height: 15),
                    ExternalDocumentDropDown(
                      onTapDocument: (ExternalDocumentTypesList value) {
                        if (value != null) {
                          selecteddocumnettype = value.externalDocumentTypeName;
                          documenttypeId = value.id;
                        }
                      },
                    ),
                    SizedBox(height: 15),
//----------------------------------emergency Field
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        AppStrings.emergencyText,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontFamily: AppFonts.regular,
                          fontWeight: FontWeight.bold,
                          color: CustomizedColors.accentColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: GroupButton(
                        buttonHeight: 50,
                        buttonWidth: 150,
                        spacing: 20,
                        isRadio: true,
                        selectedButton: -1,
                        onSelected: (index, isSelected) {
                          setState(() {
                            _groupButtonSelectedindex = index;
                            if (_groupButtonSelectedindex == 0) {
                              toggleVal = 1;
                            } else if (_groupButtonSelectedindex == 1) {
                              toggleVal = 0;
                            }
                          });
                          print(
                              'is Emergency ${toggleVal == 1 ? 'Yes' : 'No'}');
                        },
                        buttons: [
                          "Yes",
                          "No",
                        ],
                        selectedTextStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white),
                        unselectedTextStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        selectedColor: CustomizedColors.primaryColor,
                        unselectedColor: Colors.white10,
                        selectedBorderColor: CustomizedColors.primaryColor,
                        unselectedBorderColor: Colors.grey[500],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
//-----------------------------------Description Field
                    SizedBox(height: 15),
                    Text(
                      AppStrings.description,
                      style: TextStyle(
                        fontFamily: AppFonts.regular,
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: CustomizedColors.accentColor,
                      ),
                    ),

                    SizedBox(height: 15),
                    TextFormField(
                      focusNode: _myNodeForDescription,
                      enableInteractiveSelection: false,
                      controller: Description,
                      // validator: validateInput,
                      scrollPadding: EdgeInsets.only(bottom: 20),
                      // controller: Description,
                      // validator: validateInput,
                      minLines: 1,
                      maxLines: null,

                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: AppStrings.description,
                        hintStyle: TextStyle(fontSize: 14),
                        contentPadding: EdgeInsets.all(20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue)),
                      ),
                    ),
                    SizedBox(height: 15),

                    //---------------------------display the camera images to the ui
                    Visibility(
                      visible: widgetVisible,
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Wrap(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            // color:
                                            //     CustomizedColors.homeSubtitleColor,
                                            color: Colors.blue),
                                      ),
                                      height: 100,
                                      margin: const EdgeInsets.all(10),
                                      child:cameraImages.length>3? Container(
                                        child: RawScrollbar(
                                            thumbColor: CustomizedColors.buttonTitleColor,
                                            radius: Radius.circular(20),
                                            thickness: 5,
                                            isAlwaysShown: true,
                                            controller: _ScrollController,
                                            child: GridView.count(
                                              controller: _ScrollController,
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 4.0,
                                              mainAxisSpacing: 8.0,
                                              children: List.generate(
                                                  cameraImages.length, (index) {
                                                var img = cameraImages[index];
                                                return Container(
                                                    color: CustomizedColors
                                                        .primaryBgColor,
                                                    margin:
                                                        const EdgeInsets.all(5),
                                                    child: Stack(children: [
                                                      cameraImages.isEmpty ||
                                                              cameraImages == null
                                                          ? Text(
                                                              AppStrings
                                                                  .noImageSelected,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    AppFonts
                                                                        .regular,
                                                              ),
                                                            )
                                                          : Center(
                                                              child:
                                                                  FullScreenWidget(
                                                                child: Image.file(
                                                                    File(img),
                                                                    fit: BoxFit
                                                                        .contain),
                                                              ),
                                                            ),
                                                      Positioned(
                                                        right: -2,
                                                        top: -1,
                                                        child: Visibility(
                                                          visible: imageVisible,
                                                          child: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                //image = null;
                                                                cameraImages
                                                                    .removeAt(
                                                                        index);
                                                                if (cameraImages
                                                                        .length ==
                                                                    0) {
                                                                  imageVisible =
                                                                      false;
                                                                  widgetVisible =
                                                                      false;
                                                                  //  buttonVisible = false;
                                                                } else {}
                                                              });
                                                            },
                                                            child: Card(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30)),
                                                              child: Icon(
                                                                Icons.close,
                                                                size: 18,
                                                                color: CustomizedColors
                                                                    .SplashScreenBackgroundColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ]));
                                              }),
                                            )),
                                      ):RawScrollbar(
                                          thumbColor: CustomizedColors.buttonTitleColor,
                                          radius: Radius.circular(20),
                                          thickness: 5,
                                          isAlwaysShown: true,
                                          controller: _ScrollController,
                                          child: GridView.count(
                                            controller: _ScrollController,
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 4.0,
                                            mainAxisSpacing: 8.0,
                                            children: List.generate(
                                                cameraImages.length, (index) {
                                              var img = cameraImages[index];
                                              return Container(
                                                  color: CustomizedColors
                                                      .primaryBgColor,
                                                  margin:
                                                  const EdgeInsets.all(5),
                                                  child: Stack(children: [
                                                    cameraImages.isEmpty ||
                                                        cameraImages == null
                                                        ? Text(
                                                      AppStrings
                                                          .noImageSelected,
                                                      style: TextStyle(
                                                        fontFamily:
                                                        AppFonts
                                                            .regular,
                                                      ),
                                                    )
                                                        : Center(
                                                      child:
                                                      FullScreenWidget(
                                                        child: Image.file(
                                                            File(img),
                                                            fit: BoxFit
                                                                .contain),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: -2,
                                                      top: -1,
                                                      child: Visibility(
                                                        visible: imageVisible,
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              //image = null;
                                                              cameraImages
                                                                  .removeAt(
                                                                  index);
                                                              if (cameraImages
                                                                  .length ==
                                                                  0) {
                                                                imageVisible =
                                                                false;
                                                                widgetVisible =
                                                                false;
                                                                //  buttonVisible = false;
                                                              } else {}
                                                            });
                                                          },
                                                          child: Card(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    30)),
                                                            child: Icon(
                                                              Icons.close,
                                                              size: 18,
                                                              color: CustomizedColors
                                                                  .SplashScreenBackgroundColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ]));
                                            }),
                                          )),),
                                ],
                              ),
                            ]),
                      ),
                    ),

                    SizedBox(height: 8),
//-----------------------------------------add image/take image
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: CustomizedColors.whiteColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: CustomizedColors.accentColor,
                                size: 45,
                              ),
                              Text(
                                AppStrings.addImgandtakePic,
                                style: TextStyle(
                                    fontSize: 14.5,
                                    color: CustomizedColors.accentColor,
                                    fontFamily: AppFonts.regular),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () {
                          _show(context);
                          FocusScope.of(context).requestFocus(new FocusNode());
                        }),
                    SizedBox(height: 15),
//-------------------------------------Cancel and Submit Buttons

                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 60,
                            width: 150,
                            child: Card(
                              child: RaisedBttn(
                                onPressed: () {
                                  RouteGenerator.navigatorKey.currentState
                                      .pushNamedAndRemoveUntil(
                                    ExternalAttachments.routeName,
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                text: AppStrings.cancel,
                                buttonColor: CustomizedColors.cancelbuttonColor,
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            height: 60,
                            width: 150,
                            child: Card(
                                child: RaisedBttn(
                              onPressed: () async {
                                try {
                                  bool isInternetAvailable =
                                      await AppConstants.checkInternet();
                                  if (isInternetAvailable == true) {
                                    // if (_dobKey.currentState.validate() &&
                                    //     _fnameKey.currentState.validate() &&
                                    //     _lnameKey.currentState.validate())
                                    // {
                                      if (documenttypeId != null) {
                                        if (cameraImages.isEmpty ||
                                            cameraImages == null) {
                                          Fluttertoast.showToast(
                                              msg: AppStrings.selectImg,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.SNACKBAR,
                                              timeInSecForIosWeb: 2,
                                              // backgroundColor: CustomizedColors.primaryColor,
                                              backgroundColor: CustomizedColors.primaryColor,
                                              textColor: CustomizedColors
                                                  .whiteColor,
                                              fontSize: 15.0);
                                        } else {
                                          showLoaderDialog(context,
                                              text: AppStrings.uploading);
                                          //---------------------------------------------save camera images with internet
                                          await _saveCameraImagesToServer();

//------------------------------------------------post api data
                                          await _saveExternalAttachmentDictation();
                                          Navigator.of(this.context,
                                                  rootNavigator: true)
                                              .pop();

                                          await appToast.showToast(
                                              AppStrings.showtoast_text);
                                          photoListOfGallery.clear();
                                          cameraImages.clear();

                                          //clear the all the fields after submitting the data
                                          await RouteGenerator
                                              .navigatorKey.currentState
                                              .pushReplacementNamed(
                                                  ExternalAttachments
                                                      .routeName);
                                        }
                                      }
                                      else {
                                        // appToast.showToast(
                                        //     "please select document type");
                                        Fluttertoast.showToast(
                                            msg: AppStrings.doctypealertmsg,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.SNACKBAR,
                                            timeInSecForIosWeb: 2,
                                            // backgroundColor: CustomizedColors.primaryColor,
                                            backgroundColor:
                                                CustomizedColors.primaryColor,
                                            textColor:
                                                CustomizedColors.whiteColor,
                                            fontSize: 15.0);
                                      }
                                   // }

                                  } else if (isInternetAvailable == false) {
                                   //  if (_dobKey.currentState.validate() &&
                                   //      _fnameKey.currentState.validate() &&
                                   //      _lnameKey.currentState.validate())
                                   // {
                                      if (documenttypeId != null) {
                                        if (cameraImages.isEmpty ||
                                            cameraImages == null) {
                                          Fluttertoast.showToast(
                                              msg: AppStrings.selectImg,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.SNACKBAR,
                                              timeInSecForIosWeb: 2,
                                              // backgroundColor: CustomizedColors.primaryColor,
                                              backgroundColor: CustomizedColors.primaryColor,
                                              textColor: CustomizedColors
                                                  .whiteColor,
                                              fontSize: 15.0);
                                        } else {
                                          showLoaderDialog(context,
                                              text: AppStrings.uploading);
                                          //-------------------------------------------save camera images without internet
                                          await _saveCameraImagesToOfflinedata();

                                          Navigator.of(this.context,
                                              rootNavigator: true)
                                              .pop();


                                          appToast.showToast(
                                              AppStrings.showtoast_text);
                                          photoListOfGallery.clear();
                                          cameraImages.clear();

                                          //clear the all the fields after submitting the data
                                          await RouteGenerator
                                              .navigatorKey.currentState
                                              .pushReplacementNamed(
                                              ExternalAttachments
                                                  .routeName);
                                        }
                                      } else {
                                        // appToast.showToast(
                                        //     "please select document type");
                                        Fluttertoast.showToast(
                                            msg: AppStrings.doctypealertmsg,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.SNACKBAR,
                                            timeInSecForIosWeb: 2,
                                            // backgroundColor: CustomizedColors.primaryColor,
                                            backgroundColor:
                                            CustomizedColors.primaryColor,
                                            textColor:
                                            CustomizedColors.whiteColor,
                                            fontSize: 15.0);
                                      }
                                    }
                                 // }
                                } on Exception catch (e) {
                                  // print(e.toString());
                                }
                              },
                              text: AppStrings.submit,
                              buttonColor: CustomizedColors.submitbuttonColor,
                            )),
                            //color: Colors.blue,
                          ),
                        ],
                      ),
                      height: MediaQuery.of(context).size.height * 0.09,
                    ),
                    // ),
                  ],
                ),
              ),
            ),
            onRefresh: _refreshData,
          ),
        ),
      ),
    );
  }

  //////------------------**here calling the various methods**-------------///////////

  //----------validator function for various fields
  String validateInput(String value) {
    try {
      if (value.length == 0) {
        return 'This is required';
      } else {
        return null;
      }
    } on Exception catch (e) {
      // print(e.toString());
    }
  }

  //---------------------------------custom file name

  Future<String> createFileName(String mockName) async {
    final String formatted = formatter.format(now);
    try {
      imageName = '' + basename(mockName).replaceAll(".", "");
      if (imageName.length > 10) {
        imageName = imageName.substring(0, 10);

        final Directory directory = await getExternalStorageDirectory();
        String path = '${directory.path}/${AppStrings.folderName}';
        final myImgDir = await Directory(path).create(recursive: true);
        newImage = await File(image?.path).copy(
            '${myImgDir.path}/${basename(imageName + '${formatted}' + AppStrings.imageFormat)}');
        setState(() {
          newImage;
        });
      }
    } catch (e, s) {
      imageName = "";
      AppLogHelper.printLogs(e, s);
    }

    return "${formatted}" + imageName + AppStrings.imageFormat;
  }

// //-------------------save the gallery images to folder
//   void saveGalleryImageToFolder(String patientName, String dateFormat) async {
//     for (int i = 0; i < paths.keys.toList().length; i++) {
//       var galleryImage = paths.values.toList();
//       Directory appDocDirectory;
//       //platform checking conditions
//       if (Platform.isIOS) {
//         appDocDirectory = await getApplicationDocumentsDirectory();
//       } else {
//         appDocDirectory = await getExternalStorageDirectory();
//       }
//
//       String path = '${appDocDirectory.path}/${AppStrings.folderName}';
//       final myImgDir = await Directory(path).create(recursive: true);
//       newImage = await File((galleryImage[i])).copy(
//         '${myImgDir.path}/${patientName + dateFormat + basename((galleryImage[i]))}',
//       );
//     }
//   }

  //---------------------------------------function to open camera

  Future openCamera() async {
    try {
      image = await ImagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 100);
      cameraImages.add(image.path);
      String path = image.path;
      createFileName(path);
      setState(() {
        cameraImages;
        widgetVisible = true;
        visible = false;
        imageVisible = true;
      });
    } catch (e) {
      // print(e.toString());
    }
  }

  //--------------------------------------------------function to open gallery

  Future openGallery() async {
    setState(() => isLoadingPath = true);
    try {
      if (!isMultiPick) {
        filepath = null;
        paths = await FilePicker.getMultiFilePath(
            type: fileType != null ? fileType : FileType.image,
            allowedExtensions: extensions);
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
      // print(AppStrings.filePathNotFound + e.toString());
    }
    try {
      if (!mounted) return;
      setState(() {
        widgetVisible = true;
        imageVisible = true;
        isLoadingPath = false;
        fileName = filepath != null
            ? filepath.split('/').last
            : paths != null
                ? paths.keys.toString()
                : '...';
        visible = false;
      });
    } on PlatformException catch (e) {
      // print(AppStrings.filePathNotFound + e.toString());
    }
  }

  //----------------------------------------cupertino sheet
  _show(BuildContext ctx) {
    showCupertinoModalPopup(
      context: ctx,
      builder: (ctctc) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
                onPressed: () {

                  openCamera();
                  Navigator.pop(ctctc);
                },
                child: Text(
                  AppStrings.camera,
                  style: TextStyle(fontFamily: AppFonts.regular, fontSize: 14),
                )),
            CupertinoActionSheetAction(
                onPressed: () {

                  openGallery();
                  Navigator.pop(ctctc);
                },
                child: Text(
                  AppStrings.PhotoGallery,
                  style: TextStyle(fontFamily: AppFonts.regular, fontSize: 14),
                )),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text(
              AppStrings.cancel,
              style: TextStyle(fontFamily: AppFonts.regular, fontSize: 14),
            ),
            //isDefaultAction: true,
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(ctctc);
            },
          )),
    );
  }

  //-----------------------------post api data to store the  camera images and details to server
  _saveExternalAttachmentDictation() async {
    try {
      if (toggleVal == 0) {
        emergencyAddOn = false;
      } else {
        emergencyAddOn = true;
      }
      final String formatted = formatter.format(now);

      for (int i = 0; i < cameraImages.length; i++) {
        final fileBytes = await File(cameraImages[i]).readAsBytes();
        String convertedImg = base64Encode(fileBytes);
        imageName =
            "${firstname.text}_${formatted}_${basename('${cameraImages[i]}')}";
        photoListOfGallery.add({
          "header": {
            "status": "string",
            "statusCode": "string",
            "statusMessage": "string"
          },
          "content": convertedImg,
          "name": imageName,
          "attachmentType": ".jpg"
        });
      }

      ExternalAttachmentPost apiAttachmentPostServices =
          ExternalAttachmentPost();
      SaveExternalDictationOrAttachment saveDictationAttachments =
          await apiAttachmentPostServices.postApiServiceMethod(
              practiceId != null ? int.parse(practiceId) : null,
              LocationId != null ? int.parse(LocationId) : null,
              providerId1 != null ? int.parse(providerId1) : null,
              firstname.text,
              //patientFname
              lastname.text,
              //patientLname
              _dateOfbirthController.text,
              //patientDob
              memberId,
              documenttypeId != null ? (documenttypeId) : null,
              emergencyAddOn,
              Description.text,
              null,
              //convertedImg,
              null,
              null,
              photoListOfGallery ?? null);
      statusCode = saveDictationAttachments?.header?.statusCode;
    } catch (e) {
      // print('SaveAttachmentDictation exception ${e.toString()}');
    }
  }

  //--------------Shared Preference for getting memberID
  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memberId = (prefs.getString(Keys.memberId) ?? '');
    });
  }

  //------------save camera images to server with internet
  _saveCameraImagesToServer() async {
    if (cameraImages.isEmpty || cameraImages.length == 0) {
      return;
    }
    DateTime now = DateTime.now();
    String formattedDate = DateFormat(AppStrings.currentdate_text).format(now);
    int localExternalAttachmentId =
        await DatabaseHelper.db.insertExternalAttachmentData(
      ExternalAttachmentList(
        practiceid: practiceId != null ? int.parse(practiceId) : null,
        practicename: selectedPractice2 != null ? selectedPractice2 : null,
        locationid: LocationId != null ? int.parse(LocationId) : null,
        locationname: selectedLocation != null ? selectedLocation : null,
        providerid: providerId1 != null ? int.parse(providerId1) : null,
        providername:
            selectedProvidername != null ? selectedProvidername : null,
        externaldocumenttype:
            selecteddocumnettype != null ? selecteddocumnettype : null,
        externaldocumenttypeid: documenttypeId != null ? documenttypeId : null,
        patientfirstname: firstname.text ?? null,
        patientlastname: lastname.text ?? null,
        patientdob: _dateOfbirthController.text ?? null,
        isemergencyaddon: toggleVal ?? false,
        description: Description.text ?? null,
        memberid: int.parse(memberId) ?? null,
        createddate: '${DateTime.now()}',
        displayfilename: selecteddocumnettype ??
            "null" + "_" + memberId + "_" + formattedDate,
        uploadedtoserver: uploadedToServerTrue,
        statusid: null,
      ),
    );

    //----------------camera images insert to db
    if (localExternalAttachmentId > 0) {
      final String formatted = formatter.format(now);
      for (int k = 0; k < cameraImages.length; k++) {
        DatabaseHelper.db.ExternalinsertPhotoList(PhotoList(
            externalattachmentlocalid: localExternalAttachmentId,
            attachmentname:
                '${firstname.text ?? ''}_${formatted}_${basename(cameraImages[k])}',
            createddate: '$now',
            fileName: cameraImages[k],
            attachmenttype: AppStrings.imageFormat,
            physicalfilename: cameraImages[k]));
      }
    }
  }

  //-----------save camera images to without interent
  _saveCameraImagesToOfflinedata() async {
    if (cameraImages.isEmpty || cameraImages.length == 0) {
      return;
    }
    DateTime now = DateTime.now();
    String formattedDate = DateFormat(AppStrings.currentdate_text).format(now);
    int localExternalAttachmentId = await DatabaseHelper.db
        .insertExternalAttachmentData(ExternalAttachmentList(
      practiceid: practiceId != null ? int.parse(practiceId) : null,
      practicename: selectedPractice2 != null ? selectedPractice2 : null,
      locationid: LocationId != null ? int.parse(LocationId) : null,
      locationname: selectedLocation != null ? selectedLocation : null,
      providerid: providerId1 != null ? int.parse(providerId1) : null,
      providername: selectedProvidername != null ? selectedProvidername : null,
      externaldocumenttype:
          selecteddocumnettype != null ? selecteddocumnettype : null,
      externaldocumenttypeid: documenttypeId != null ? documenttypeId : null,
      patientfirstname: firstname.text ?? null,
      patientlastname: lastname.text ?? null,
      patientdob: _dateOfbirthController.text ?? null,
      isemergencyaddon: toggleVal ?? false,
      description: Description.text ?? null,
      memberid: int.parse(memberId) ?? null,
      createddate: '${DateTime.now()}',
      displayfilename:
          selecteddocumnettype + "_" + memberId + "_" + formattedDate,
      uploadedtoserver: uploadedToServerFalse,
      statusid: null,
    ));

    //----------------camera images insert to db
    if (localExternalAttachmentId > 0) {
      final String formatted = formatter.format(now);
      for (int y = 0; y < cameraImages.length; y++) {
        DatabaseHelper.db.ExternalinsertPhotoList(PhotoList(
            externalattachmentlocalid: localExternalAttachmentId,
            attachmentname:
                '${firstname.text ?? ''}_${formatted}_${basename(basename(cameraImages[y]))}',
            createddate: '$now',
            fileName: cameraImages[y],
            attachmenttype: AppStrings.imageFormat,
            physicalfilename: cameraImages[y]));
      }
    }
  }
}
