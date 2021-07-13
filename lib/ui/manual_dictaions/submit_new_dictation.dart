import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';
import 'package:YOURDRS_FlutterAPP/common/app_loader.dart';
import 'package:YOURDRS_FlutterAPP/common/app_log_helper.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/common/app_toast_message.dart';
import 'package:YOURDRS_FlutterAPP/cubit/manual_dictation_cubit/appointment_type_cubit.dart';
import 'package:YOURDRS_FlutterAPP/cubit/manual_dictation_cubit/location_cubit.dart';
import 'package:YOURDRS_FlutterAPP/cubit/manual_dictation_cubit/practice_cubit.dart';
import 'package:YOURDRS_FlutterAPP/cubit/manual_dictation_cubit/provider_cubit.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/external_dictation_attachment_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/practice.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/appointment_type.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/dictation.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/document_type.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/location_field_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/provider_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/photo_list.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:YOURDRS_FlutterAPP/network/services/dictation/external_attachment_dictation.dart';
import 'package:YOURDRS_FlutterAPP/ui/manual_dictaions/date_Valid.dart';
import 'package:YOURDRS_FlutterAPP/ui/manual_dictaions/manual_dictations.dart';
import 'package:YOURDRS_FlutterAPP/utils/route_generator.dart';
import 'package:YOURDRS_FlutterAPP/widget/buttons/mic_button.dart';
import 'package:YOURDRS_FlutterAPP/widget/buttons/raised_buttons.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/appointmenttype.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/external_documenttype.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/location_field.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/practice_field.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/provider_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';
import 'package:YOURDRS_FlutterAPP/helper/db_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';

class SubmitNewDictation extends StatefulWidget {
  @override
  _SubmitNewDictationState createState() => _SubmitNewDictationState();
}

class _SubmitNewDictationState extends State<SubmitNewDictation>
    with AutomaticKeepAliveClientMixin {
  AppToast appToast = AppToast();
  final DateTime now = DateTime.now();

  //final validationKey = GlobalKey<FormState>();
  final _fName = TextEditingController();
  final _lName = TextEditingController();
  final _descreiption = TextEditingController();
  final _dateOfServiceController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final ScrollController _ScrollController = ScrollController();
  var statusCode;
  bool isStarted = false;

  ///
  final _fnameKey = GlobalKey<FormFieldState>();
  final _lnameKey = GlobalKey<FormFieldState>();
  final _dobKey = GlobalKey<FormFieldState>();
  final _dosKey = GlobalKey<FormFieldState>();

  ///

  // FocusNode focusNodeDob = FocusNode();
  String _selectedLocationName,
      _selectedPracticeName,
      _selectedProviderName,
      _selectedDocName,
      _selectedAppointmentName,
      currentDOB,
      currentDOS,
      path,
      fileName,
      filepath,
      resultInternet,
      memberId,
      id,
      memeberRoleId,
      dictationId,
      episodeAppointmentRequestId,
      episodId,
      dateOfBirth,
      dateOfService,
      content,
      name,
      dicId;
  int _selectedDoc,
      idGallery,
      _selectedPracticeId,
      _selectedAppointment,
      _selectedLocationId,
      _selectedProvider,
      toggleVal = 0,
      uploadedToServerTrue = 1,
      uploadedToServerFalse = 0,
      gIndex;
  File image, newImage;
  bool widgetVisible = false;
  bool visible = false;

  //Directory directory;
  bool isSwitched = false;
  Map<String, String> paths;
  List<String> extensions;
  bool isLoadingPath = false;
  bool isMultiPick = false;
  FileType fileType;
  bool imageVisible = true;
  int imageIndex = 0;
  var imageName;
  String attachmentType = "jpg";
  bool isInternetAvailable = false;
  bool submitVisible = true;
  bool submitGVisible = false;
  final DateFormat formatter = DateFormat(AppStrings.dateFormat);
  int _groupButtonSelectedindex;

  // List arrayOfImages = [];
  List memberPhotos = [];
  bool emergencyAddOn = true;
  String convertedMp4Sync;
  List cameraImages = [];
  FocusNode focusNodeDob = FocusNode();
  FocusNode focusNodeDos = FocusNode();
  var photoListOfGallery = [];
  int _selectedDocId;

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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
//-----------------GestureDetector for shifting focus from input fields to background layout (for dismissing keyboard after clicking outside the textinput feilds)
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: RefreshIndicator(
            onRefresh: _pullToRefresh,
            child: Form(
              //   key: validationKey,
//------------------Scrollview for entire body
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
//------------------text for Practise
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
//-------------Practise drop down
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: BlocProvider(
                        create: (context) => PracticeListCubit(),
                        child: PracticeDropDown(
                          onTapOfPractice: (newValue) {
                            setState(() {
                              if (newValue != null) {
                                _selectedPracticeId =
                                    (newValue as PracticeList).id;
                                _selectedPracticeName =
                                    (newValue as PracticeList).name;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
//-----------------text for provider
                    Text(
                      AppStrings.locationtxt,
                      style: TextStyle(
                        fontFamily: AppFonts.regular,
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: CustomizedColors.accentColor,
                      ),
                    ),
                    SizedBox(height: 15),

//--------------Location drop down
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: BlocProvider(
                        create: (context) => LocationCubit(),
                        child: Locations(
                          onTapOfLocation: (newValue) async {
                            setState(() {
                              if (newValue != null) {
                                _selectedLocationId =
                                    (newValue as LocationList).id;
                                _selectedLocationName =
                                    (newValue as LocationList).name;
                              }
                            });
                          },
                          PracticeIdList: _selectedPracticeId.toString(),
                          selectedLocationId: _selectedLocationId?.toString(),
                          // prevPracticeId: _selectedPracticeId?.toString(),
                        ),
                      ),
                    ),

                    SizedBox(height: 15),
//------------------text for provider
                    Text(
                      AppStrings.treatingProvider,
                      style: TextStyle(
                        fontFamily: AppFonts.regular,
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: CustomizedColors.accentColor,
                      ),
                    ),
                    SizedBox(height: 15),

//-------------Provider drop down
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: BlocProvider(
                        create: (context) => ProviderCubit(),
                        child: ExternalProviderDropDown(
                          onTapOfProvider: (newValue) async {
                            setState(() {
                              if (newValue != null) {
                                _selectedProvider =
                                    (newValue as ProviderList).providerId;
                                _selectedProviderName =
                                    (newValue as ProviderList).displayname;
                              }
                            });
                          },
                          prevLocationId: _selectedLocationId.toString(),
                          //  prevLocationId: _selectedLocationId.toString(),
                          selectedProviderId: _selectedProvider.toString(),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
//-------------------label text first name
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        AppStrings.firstName,
                        style: TextStyle(
                          fontFamily: AppFonts.regular,
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: CustomizedColors.accentColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

//----------------TextField for First Name
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
                          WhitelistingTextInputFormatter(
                              RegExp(AppConstants.nameRegExp))
                        ],
                        validator: validateInput,
                        controller: _fName,
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
//-----------------label text last name
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        AppStrings.lastName,
                        style: TextStyle(
                          fontFamily: AppFonts.regular,
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: CustomizedColors.accentColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

//--------------TextField last name
                    Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: TextFormField(
                          key: _lnameKey,
                          focusNode: _myNodeForLname,
                          enableInteractiveSelection: false,
                          onChanged: (value) {
                            _lnameKey.currentState.validate();
                          },
                          inputFormatters: [
                            WhitelistingTextInputFormatter(
                                RegExp(AppConstants.nameRegExp))
                          ],
                          validator: validateInput,
                          controller: _lName,
                          decoration: InputDecoration(
                            hintText: AppStrings.lastName,
                            hintStyle: TextStyle(fontSize: 14),
                            contentPadding: EdgeInsets.all(20),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: CustomizedColors.accentColor),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue)),
                          )),
                    ),
                    SizedBox(height: 15),
//----------------label text date of birth
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
                        validator: validateInput,
                        controller: _dateOfBirthController,
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
                                _dateOfBirthController.clear();
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
                                  dateOfBirth = formats.format(dd);
                                  _dateOfBirthController.text =
                                      dateOfBirth.toString();
                                  _dosKey.currentState.validate();
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
//------------------label text date of service
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        AppStrings.dosDropDownText,
                        style: TextStyle(
                          fontFamily: AppFonts.regular,
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: CustomizedColors.accentColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
//---------------date of Service Picker
                    Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: TextFormField(
                        enableInteractiveSelection: false,
                        key: _dosKey,
                        onChanged: (value) {
                          _dosKey.currentState.validate();
                        },
                        focusNode: focusNodeDos,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(AppConstants.dateNumRegExp)),
                          LengthLimitingTextInputFormatter(10),
                          DateValidFormatter(),
                        ],
                        validator: validateInput,
                        controller: _dateOfServiceController,
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
                                _dateOfServiceController.clear();
                                focusNodeDos.unfocus();
                                focusNodeDos.canRequestFocus = false;
                                DateTime d = DateTime(1900);
                                d = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));
                                if (d != null) {
                                  final DateFormat formats = DateFormat(
                                      AppStrings.dateFormatForDatePicker);
                                  dateOfService = formats.format(d);
                                  _dateOfServiceController.text =
                                      dateOfService.toString();
                                  _dosKey.currentState.validate();
                                }
                                focusNodeDos.canRequestFocus = true;
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

                    SizedBox(height: 15),
//----------------label text for appointment type
                    Text(
                      AppStrings.documentType +
                          " " +
                          AppStrings.mandatoryAsterisk,
                      style: TextStyle(
                        fontFamily: AppFonts.regular,
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: CustomizedColors.accentColor,
                      ),
                    ),
                    SizedBox(height: 15),
//-----------------Document type Dropdown
                    ExternalDocumentDropDown(
                      onTapDocument: (ExternalDocumentTypesList newValue) {
                        if (newValue != null) {
                          _selectedDocId =
                              (newValue as ExternalDocumentTypesList).id;
                          _selectedDoc = int.tryParse(
                              (newValue as ExternalDocumentTypesList)
                                  .externalDocumentTypeName);
                        }
                      },
                    ),

                    SizedBox(height: 15),
//----------------label text for appointment type
                    Text(
                      AppStrings.appointmentType,
                      style: TextStyle(
                        fontFamily: AppFonts.regular,
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: CustomizedColors.accentColor,
                      ),
                    ),
                    SizedBox(height: 15),
//-----------------Appointment type Dropdown
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: BlocProvider(
                        create: (content) => AppointmentTypeCubit(),
                        child: AppointmentDropDown(
                          onTapOfAppointment: (newValue) {
                            setState(() {
                              if (newValue != null) {
                                _selectedAppointment =
                                    (newValue as AppointmentTypeList).id;
                                _selectedAppointmentName =
                                    (newValue as AppointmentTypeList).name;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
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
//-----------------Toggle button
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
                              'toggle value is ${toggleVal == 1 ? 'Yes' : 'No'}');
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
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        AppStrings.description,
                        style: TextStyle(
                          fontFamily: AppFonts.regular,
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: CustomizedColors.accentColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
//----------------TextField for description

                    TextFormField(
                      enableInteractiveSelection: false,
                      focusNode: _myNodeForDescription,
                      controller: _descreiption,
                      // validator: validateInput,
                      minLines: 1,
                      maxLines: null,
                      // expands: true,
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
//----------------visibility when selecting images
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
                                  //margin: const EdgeInsets.all(10),
                                  child:cameraImages.length>3?
                                  Container(
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
                                          children: List.generate(
                                            cameraImages.length,
                                            (index) {
                                              var img = cameraImages[index];
                                              return Container(
                                                color:
                                                    CustomizedColors.primaryBgColor,
                                                margin: const EdgeInsets.all(5),
                                                child: Stack(
                                                  children: [
                                                    cameraImages.isEmpty ||
                                                            cameraImages == null
                                                        ? Text(
                                                            AppStrings
                                                                .noImageSelected,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  AppFonts.regular,
                                                            ),
                                                          )
                                                        : Center(
                                                            child: FullScreenWidget(
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
                                                            setState(
                                                              () {
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
                                                              },
                                                            );
                                                          },
                                                          child: Card(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30)),
                                                            child: Icon(
                                                              Icons.close,
                                                              color: CustomizedColors
                                                                  .buttonTitleColor,
                                                              size: 18,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                    ),
                                  ):RawScrollbar(
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
                                      children: List.generate(
                                        cameraImages.length,
                                            (index) {
                                          var img = cameraImages[index];
                                          return Container(
                                            color:
                                            CustomizedColors.primaryBgColor,
                                            margin: const EdgeInsets.all(5),
                                            child: Stack(
                                              children: [
                                                cameraImages.isEmpty ||
                                                    cameraImages == null
                                                    ? Text(
                                                  AppStrings
                                                      .noImageSelected,
                                                  style: TextStyle(
                                                    fontFamily:
                                                    AppFonts.regular,
                                                  ),
                                                )
                                                    : Center(
                                                  child: FullScreenWidget(
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
                                                        setState(
                                                              () {
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
                                                          },
                                                        );
                                                      },
                                                      child: Card(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                30)),
                                                        child: Icon(
                                                          Icons.close,
                                                          color: CustomizedColors
                                                              .buttonTitleColor,
                                                          size: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

//---------------cupertino Action sheet
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
                      },
                    ),
                    SizedBox(height: 15),
//-----------------raised Button for Submit with Dictation
                    RaisedButtonCustom(
                      textColor: CustomizedColors.whiteColor,
                      onPressed: () {
//------------------If an of the feilds are null then recording is not possible
                        if (_selectedDocId != null) {
//---------Dialog box for Recorder
                          showDialog(
                            context: context,
                            builder: (ctxt) => AlertDialog(
                              title: Center(
                                  child: Text(
                                AppStrings.dictationtxt,
                                style: TextStyle(
                                    fontFamily: AppFonts.regular, fontSize: 14),
                              )),
                              content: Container(
                                height: 165,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
//-----------------material button for audio Recorder
                                    MicButtonForManualDictation(
                                      practiceName:
                                          null ?? _selectedPracticeName,
                                      practiceId: null ?? _selectedPracticeId,
                                      locationName:
                                          null ?? _selectedLocationName,
                                      locationId: null ?? _selectedLocationId,
                                      providerName:
                                          null ?? _selectedProviderName,
                                      providerId: null ?? _selectedProvider,
                                      patientFName: _fName.text,
                                      patientLName: _lName.text,
                                      patientDob: _dateOfBirthController.text,
                                      patientDos: _dateOfServiceController.text,
                                      docType: _selectedDoc ?? null,
                                      appointmentType:
                                          _selectedAppointment ?? null,
                                      emergency: toggleVal,
                                      descp: _descreiption.text,
                                      attachmentName: _fName.text +
                                              '_' +
                                              basename('$image') ??
                                          null,
                                      // cameraImages: cameraImages ?? null,
                                      fileName: _fName.text +
                                              '_' +
                                              basename('$image') ??
                                          null,
                                      arrayOfImages: cameraImages ?? null,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(11),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
//-----------------material button inside dialog box
                                          Container(
                                            height: 45,
                                            width: 98,
                                            child: MaterialButton(
                                              child: Text(
                                                AppStrings.cancel,
                                                style: TextStyle(
                                                    fontSize: 14.5,
                                                    fontFamily:
                                                        AppFonts.regular,
                                                    color: CustomizedColors
                                                        .whiteColor),
                                              ),
                                              color: CustomizedColors
                                                  .dialogCancelButton,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              elevation: 15,
                                              onPressed: () {
                                                Navigator.pop(ctxt);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          Fluttertoast.showToast(
                              msg: AppStrings.doctypealertmsg,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.SNACKBAR,
                              timeInSecForIosWeb: 2,
                              // backgroundColor: CustomizedColors.primaryColor,
                              backgroundColor: CustomizedColors.primaryColor,
                              textColor: CustomizedColors.whiteColor,
                              fontSize: 15.0);
                        }
                      },
                      text: AppStrings.submitwithDictButtonText,
                      buttonColor: CustomizedColors.accentColor,
                    ),

//------Submitting camera images
                    Visibility(
                      visible: submitVisible,
                      child: Column(
                        children: [
                          SizedBox(height: 15),
                          RaisedButtonCustom(
                            textColor: CustomizedColors.buttonTitleColor,
                            buttonColor: CustomizedColors.raisedBtnColor,
                            onPressed: () async {
                              try {
                                bool isInternetAvailable =
                                    await AppConstants.checkInternet();
                                if (isInternetAvailable == true) {
                                  if (_selectedDocId != null) {
                                    if (cameraImages.isEmpty ||
                                        cameraImages == null) {
                                      Fluttertoast.showToast(
                                          msg: AppStrings.selectImg,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.SNACKBAR,
                                          timeInSecForIosWeb: 2,
                                          // backgroundColor: CustomizedColors.primaryColor,
                                          backgroundColor:
                                              CustomizedColors.primaryColor,
                                          textColor:
                                              CustomizedColors.whiteColor,
                                          fontSize: 15.0);
                                      // AppToast().showToast(
                                      //     AppStrings.selectImgOrAudio);
                                    } else {
////-----------------------------post data to API the with internet
                                      showLoaderDialog(context,
                                          text: AppStrings.uploadingDialog);
                                      await saveAttachmentDictation();

////------------------------save data to the local table with response from API
                                      await saveCameraImagesToDbOnline();
                                      Navigator.of(this.context,
                                              rootNavigator: true)
                                          .pop();
                                      AppToast()
                                          .showToast(AppStrings.showtoast_text);
                                      memberPhotos.clear();
                                      await RouteGenerator
                                          .navigatorKey.currentState
                                          .pushReplacementNamed(
                                              ManualDictations.routeName);
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: AppStrings.doctypealertmsg,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.SNACKBAR,
                                        timeInSecForIosWeb: 2,
                                        // backgroundColor: CustomizedColors.primaryColor,
                                        backgroundColor:
                                            CustomizedColors.primaryColor,
                                        textColor: CustomizedColors.whiteColor,
                                        fontSize: 15.0);
                                  }
                                } else if (isInternetAvailable == false) {
////------------------------save data to the local table when no internet
                                  if (_selectedDocId != null) {
                                    if (cameraImages.isEmpty ||
                                        cameraImages == null) {
                                      Fluttertoast.showToast(
                                          msg: AppStrings.selectImg,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.SNACKBAR,
                                          timeInSecForIosWeb: 2,
                                          // backgroundColor: CustomizedColors.primaryColor,
                                          backgroundColor:
                                              CustomizedColors.primaryColor,
                                          textColor:
                                              CustomizedColors.whiteColor,
                                          fontSize: 15.0);
                                    } else {
                                      showLoaderDialog(context,
                                          text: AppStrings.uploadingDialog);
                                      await saveCameraImagesToDbOffline();
                                      Navigator.of(this.context,
                                              rootNavigator: true)
                                          .pop();
                                      AppToast()
                                          .showToast(AppStrings.showtoast_text);
                                      memberPhotos.clear();
                                      cameraImages.clear();

                                      await RouteGenerator
                                          .navigatorKey.currentState
                                          .pushReplacementNamed(
                                              ManualDictations.routeName);
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: AppStrings.doctypealertmsg,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.SNACKBAR,
                                        timeInSecForIosWeb: 2,
                                        // backgroundColor: CustomizedColors.primaryColor,
                                        backgroundColor:
                                            CustomizedColors.primaryColor,
                                        textColor: CustomizedColors.whiteColor,
                                        fontSize: 15.0);
                                  }
                                }

                                setState(() {
                                  widgetVisible = false;
                                  visible = false;
                                });
                              } on Exception catch (e) {
                                // print(e.toString());
                              }
                            },
                            text: AppStrings.submit,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
//----------------raised Button for clearing all the textediting controllers
                    RaisedButtonCustom(
                      textColor: CustomizedColors.buttonTitleColor,
                      buttonColor: CustomizedColors.raisedBtnColor,
                      onPressed: () {
                        RouteGenerator.navigatorKey.currentState
                            .pushReplacementNamed(ManualDictations.routeName);
                      },
                      text: AppStrings.clearAll,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

//------------------->>>>various methods<<<<---------------------
  @override
  void initState() {
    super.initState();
    _loadData();
    // syncOfflineData();
  }

// ignore: missing_return
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

//---------------to open cupertino action sheet
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
                  style: TextStyle(
                    fontSize: 14.5,
                    fontFamily: AppFonts.regular,
                  ),
                )),
            CupertinoActionSheetAction(
                onPressed: () {
                  openGallery();
                  Navigator.pop(ctctc);
                },
                child: Text(
                  AppStrings.PhotoGallery,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontFamily: AppFonts.regular,
                  ),
                )),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text(
              AppStrings.cancel,
              style: TextStyle(
                fontSize: 14.5,
                fontFamily: AppFonts.regular,
              ),
            ),
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(ctctc);
            },
          )),
    );
  }

//-----------------to open the camera in phone

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
        submitVisible = true;
        submitGVisible = false;
        imageVisible = true;
      });
    } catch (e) {
      // print(e.toString());
    }
  }

//---------------------to open the gallery in phone
  Future openGallery() async {
    setState(() => isLoadingPath = true);
    try {
      if (!isMultiPick) {
        filepath = null;
        paths = await FilePicker.getMultiFilePath(
            type: fileType != null ? fileType : FileType.image,
            allowedExtensions: extensions,
            allowCompression: true);
        // cameraImages.add(paths.values.toString());
        paths.forEach((key, value) => cameraImages.add(value));
        //print('array of images :::: ${(cameraImages)}');

        ;
      } else {
        filepath = await FilePicker.getFilePath(
            type: fileType != null ? fileType : FileType.image,
            allowedExtensions: extensions,
            allowCompression: true);
        // cameraImages.add(paths.values.toString());
        paths.forEach((key, value) => cameraImages.add(value));
        //print('array of images :::: ${(cameraImages)}');

        paths = null;
      }
    } on PlatformException catch (e) {
      // print("file not found" + e.toString());
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
        widgetVisible = true;
        visible = false;
        submitVisible = true;
        submitGVisible = false;
        imageVisible = true;
      });
    } on PlatformException catch (e) {
      // print("file not found" + e.toString());
    }
  }

//-----------file name for images
  Future<String> createFileName(String mockName) async {
    String fileName1;
    final DateFormat formatter = DateFormat(AppStrings.dateFormat);
    final String formatted = formatter.format(now);

    try {
      fileName1 = _fName.text + basename(mockName).replaceAll(".", "");
      if (fileName1.length > _fName.text.length) {
        fileName1 = fileName1.substring(0, _fName.text.length);
        Directory appDocDirectory;
        //platform checking conditions
        if (Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }
        path = '${appDocDirectory.path}/${AppStrings.folderName}';
        final myImgDir = await Directory(path).create(recursive: true);
        newImage = await image.copy(
            '${myImgDir.path}/${basename(fileName1 + '${formatted}' + AppStrings.imageFormat)}');
        setState(() {
          newImage;
        });
      }
    } catch (e, s) {
      fileName1 = "";
      AppLogHelper.printLogs(e, s);
    }

    return "${formatted}" + fileName1 + ".jpeg";
  }

//---------function for posting the details to the api

  saveAttachmentDictation() async {
    try {
      if (toggleVal == 0) {
        emergencyAddOn = false;
      } else {
        emergencyAddOn = true;
      }
      final String formatted = formatter.format(now);
      // final bytes = File(image.path).readAsBytesSync();
      // String convertedImg = base64Encode(bytes);
      for (int i = 0; i < cameraImages.length; i++) {
        final fileBytes = await File(cameraImages[i]).readAsBytes();
        String byteImage = base64Encode(fileBytes);
        name = "${_fName.text}_${formatted}_${basename('${cameraImages[i]}')}";

        memberPhotos.add({
          "header": {
            "status": "string",
            "statusCode": "string",
            "statusMessage": "string"
          },
          "content": byteImage,
          "name": name,
          "attachmentType": "jpg"
        });
      }

      ExternalDictationAttachment apiAttachmentPostServices =
          ExternalDictationAttachment();
      SaveExternalDictationOrAttachment saveDictationAttachments =
          await apiAttachmentPostServices.postApiServiceMethod(
              _selectedPracticeId,
              _selectedLocationId,
              _selectedProvider,
              _fName.text,
              _lName.text,
              _dateOfBirthController.text,
              _dateOfServiceController.text,
              memberId,
              _selectedDoc,
              _selectedAppointment,
              emergencyAddOn,
              _descreiption.text,
              null,
              //attachmentTypeMp4
              null,
              //attachmentContentMp4
              null,
              //attachmentNameMp4
              memberPhotos);
      dicId = saveDictationAttachments.dictationId.toString();

      statusCode = saveDictationAttachments?.header?.statusCode;
    } catch (e) {
      // print('SaveAttachmentDictation exception ${e.toString()}');
    }
  }

//--------------shared Prefarance load data
  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memberId = (prefs.getString(Keys.memberId) ?? '');
    });
  }

//------------------------insert camera images to the db when internet is there
  saveCameraImagesToDbOnline() async {
    await DatabaseHelper.db.insertAudioRecords(
      PatientDictation(
          dictationId: dicId ?? null,
          attachmentType: null,
          locationName: _selectedLocationName ?? null,
          locationId: _selectedLocationId ?? null,
          practiceName: _selectedPracticeName ?? null,
          practiceId: _selectedPracticeId ?? null,
          providerName: _selectedProviderName ?? null,
          providerId: _selectedProvider ?? null,
          patientFirstName: _fName.text ?? null,
          patientLastName: _lName.text ?? null,
          patientDOB: _dateOfBirthController.text ?? null,
          dos: _dateOfServiceController.text ?? null,
          isEmergencyAddOn: toggleVal ?? null,
          externalDocumentTypeId: _selectedDoc ?? null,
          attachmentName: _fName.text + '_' + _lName.text + '.mp4',
          appointmentTypeId: _selectedAppointment ?? null,
          description: _descreiption.text ?? null,
          memberId: int.parse(memberId) ?? null,
          createdDate: '${DateTime.now()}',
          statusId: null,
          uploadedToServer: uploadedToServerTrue),
    );

    final String formatted = formatter.format(now);
    for (int k = 0; k < cameraImages.length; k++) {
      DatabaseHelper.db.insertPhotoList(PhotoList(
          dictationLocalId: int.parse(dicId) ?? null,
          attachmentname: '${_fName.text ?? ''}' +
              "_" +
              '${formatted}' +
              '_' +
              basename(cameraImages[k]),
          createddate: '${DateTime.now()}',
          fileName: cameraImages[k],
          attachmenttype: AppStrings.imageFormat,
          physicalfilename: cameraImages[k]));
    }
  }

//--------------insert camera images to the db when internet is not there
  saveCameraImagesToDbOffline() async {
    await DatabaseHelper.db.insertAudioRecords(
      PatientDictation(
        dictationId: null,
        attachmentType: null,
        locationName: _selectedLocationName ?? "",
        locationId: _selectedLocationId ?? null,
        practiceName: _selectedPracticeName ?? "",
        practiceId: _selectedPracticeId ?? null,
        providerName: _selectedProviderName ?? "",
        providerId: _selectedProvider ?? null,
        patientFirstName: _fName.text ?? "",
        patientLastName: _lName.text ?? "",
        patientDOB: _dateOfBirthController.text ?? "",
        dos: _dateOfServiceController.text ?? "",
        isEmergencyAddOn: toggleVal ?? "",
        externalDocumentTypeId: _selectedDoc ?? null,
        appointmentTypeId: _selectedAppointment ?? null,
        description: _descreiption.text ?? "",
        memberId: int.parse(memberId) ?? "",
        createdDate: '${DateTime.now()}',
        statusId: null,
        uploadedToServer: uploadedToServerFalse,
      ),
    );

    List dictId = await DatabaseHelper.db.getDectionId();
    int id;
    id = dictId[dictId.length - 1].id;

    final String formatted = formatter.format(now);
    for (int y = 0; y < cameraImages.length; y++) {
// String b = a.substring(0, a.length - 1);
      await DatabaseHelper.db.insertPhotoList(PhotoList(
          dictationLocalId: id ?? null,
          attachmentname:
              '${_fName.text ?? ''}' + "_" + '${formatted}' + '_' + ('${y}'),
          createddate: '${DateTime.now()}',
          fileName: basename(cameraImages[y] ?? null),
          attachmenttype: AppStrings.imageFormat,
          physicalfilename: cameraImages[y]));
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Future<void> _pullToRefresh() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      RouteGenerator.navigatorKey.currentState
          .pushReplacementNamed(ManualDictations.routeName);
    });
  }
}
