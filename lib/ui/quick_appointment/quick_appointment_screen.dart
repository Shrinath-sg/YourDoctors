import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';
import 'package:YOURDRS_FlutterAPP/common/app_icons.dart';
import 'package:YOURDRS_FlutterAPP/common/app_loader.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/common/app_toast_message.dart';
import 'package:YOURDRS_FlutterAPP/cubit/quick_appointment/case_type_states_cubit.dart';
import 'package:YOURDRS_FlutterAPP/cubit/quick_appointment/matching_patient_cubit.dart';
import 'package:YOURDRS_FlutterAPP/cubit/quick_appointment/practice_locations_cubit.dart';
import 'package:YOURDRS_FlutterAPP/cubit/quick_appointment/providers_for_practice_locations_cubit.dart';
import 'package:YOURDRS_FlutterAPP/cubit/quick_appointment/quick_appointment_case_types_cubit.dart';
import 'package:YOURDRS_FlutterAPP/cubit/quick_appointment/quick_appointment_type_cubit.dart';
import 'package:YOURDRS_FlutterAPP/cubit/quick_appointment/quick_time_slots_cubit.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/appointment_case_type.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/book_appointment.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/case_type_states.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/matching_patient.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/practice_locations.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/providers_for_practice_locations.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/quick_appointment_type.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/time_slots.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:YOURDRS_FlutterAPP/network/services/quick_appointments/quick_appointment_service.dart';
import 'package:YOURDRS_FlutterAPP/ui/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:YOURDRS_FlutterAPP/ui/home/home_screen.dart';
import 'package:YOURDRS_FlutterAPP/ui/manual_dictaions/date_Valid.dart';
import 'package:YOURDRS_FlutterAPP/ui/quick_appointment/quick_appointments_lists.dart';
import 'package:YOURDRS_FlutterAPP/utils/route_generator.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/case_type_states.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/practice_locations.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/providers_for_practice_locations.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/quick_appointment_type.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/quick_case_type.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/quick_time_slots.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuickAppointmentScreen extends StatefulWidget {
  static const String routeName = '/QuickAppointmentScreen';

  @override
  _QuickAppointmentScreenState createState() => _QuickAppointmentScreenState();
}

class _QuickAppointmentScreenState extends State<QuickAppointmentScreen> {
  bool isNewCase,
      newCase,
      newPatient,
      genderMale = false,
      genderFemale = false,
      genderUnknown = false,
      isInternetAvailable,
      dataAvailable,
      showCase = false,
      readOnly = false,
      readOnlyDob = false,
      readOnlyDoa = false;
  String _selectedTimeSlots,
      genderName,
      _dateOfBirth,
      _dateOfService,
      _dateOfAccident;
  String dateOfAccident, dateOfBirth, firstName, lastName;
  int newEpisodeId,
      patientId,
      episodeId,
      practiceLocationId,
      caseTypeId,
      appointmentTypeId = 6,
      timeSlotId,
      providerId,
      selectedCaseId,
      caseTypeStatesId,
      selectedCaseStatesId;
  // TextEditingController _firstName = TextEditingController();
  // TextEditingController _lastName = TextEditingController();
  // final _dateOfBirthController = TextEditingController();
  final _dateOfServiceController = TextEditingController(
      text:
          "${DateFormat(AppStrings.dateFormatForDatePicker).format(DateTime.now())}");
  // final _dateOfAccidentController = TextEditingController();
  TextEditingController reasonForPatient = TextEditingController();

  final _fnameKey = GlobalKey<FormFieldState>();
  final _lnameKey = GlobalKey<FormFieldState>();

  static FocusNode _focusNodeFname = new FocusNode();
  static FocusNode _focusNodeLname = new FocusNode();

  final OutlineInputBorder borders = OutlineInputBorder(
      borderSide: BorderSide(color: CustomizedColors.accentColor));

  final BorderRadius radius50 = BorderRadius.circular(50);
  bool isToday = true;

  // ignore: missing_return
  String validateInput(String value) {
    try {
      if (value.length == 0) {
        return 'This is required';
      } else {
        return null;
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  FocusNode focusNodeDob = FocusNode();
  FocusNode focusNodeDos = FocusNode();
  FocusNode focusNodeDoa = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _formKeyCase = GlobalKey<FormState>();

  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat(AppConstants.mmmdddyyyy);
  var todayDate =
  DateFormat(AppStrings.dateFormatForDatePicker).format(DateTime.now());
  var todayDateDoa;
  var selectedDosDate;
  var selDosDate;
  var selectedDoaDate;
  var selDoaDate;
  var selectedDobDate;
  var currentTime;
bool isInit=true;
  int _pageNumber;
  int member;
  int roleId;

  @override
  void initState() {
    _loadData();
    super.initState();
    _pageNumber = 1;
  }

  ///loading the shared preference data
  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var memberId = (prefs.getString(Keys.memberId) ?? '');
      member = int.tryParse(memberId);
      var memberRoleId = (prefs.getString(Keys.memberRoleId) ?? '');
      roleId = int.tryParse(memberRoleId);
    });
  }

  var book;

  bookAppointment(
      String firstName,
      String lastName,
      String dob,
      String gender,
      int caseTypeId,
      String dateOfAccident,
      int appointmentTypeId,
      int practiceLocationId,
      int providerId,
      String dateOfService,
      String timeSlot,
      String reasonForPatient,
      int caseTypeStateId,
      bool isNewPatient,
      int episodeId,
      int patientId,
      bool isNewCase) async {
    QuickAppointmentService quickAppointmentService = QuickAppointmentService();
    BookAppointment bookAppointment =
    await quickAppointmentService.bookAppointment(
      firstName,
      lastName,
      dob,
      gender,
      caseTypeId,
      dateOfAccident,
      appointmentTypeId,
      practiceLocationId,
      providerId,
      dateOfService,
      timeSlot,
      reasonForPatient,
      caseTypeStateId,
      isNewPatient,
      episodeId,
      patientId,
      isNewCase,
    );
    if (bookAppointment.header.statusCode == "200") {
      AppToast().showToast(AppStrings.appointmentCreated);
      Navigator.of(this.context, rootNavigator: true).pop();
      RouteGenerator.navigatorKey.currentState.pushReplacementNamed(
          QuickAppointmentScreen.routeName,
          arguments: {'showCase': false});
    } else {
      Navigator.of(this.context, rootNavigator: true).pop();
      AppToast().showToast(AppStrings.appointmentNotCreated);
    }
  }

  List<PatientList> data;
  var object = [];
  String dob;
  String doa;
  String dos;

  dateFormatDob(String dateOfB) {
    var date1 = DateFormat(AppStrings.dateFormatForDatePicker).parse(dateOfB);
    final DateFormat formatter = DateFormat(AppConstants.yyyyMMdd);
    final String formatted = formatter.format(date1);
    dob = "$formatted";
  }

  dateFormatDoa(String dateOfA) {
    if (dateOfA != "") {
      var date1 = DateFormat(AppStrings.dateFormatForDatePicker).parse(dateOfA);
      final DateFormat formatter = DateFormat(AppConstants.yyyyMMdd);
      final String formatted = formatter.format(date1);
      doa = "$formatted";
    } else {
      doa = "";
    }
  }

  dateFormatDos(String dateOfS) {
    var date1 = DateFormat(AppStrings.dateFormatForDatePicker).parse(dateOfS);
    final DateFormat formatter = DateFormat(AppConstants.yyyyMMdd);
    final String formatted = formatter.format(date1);
    dos = "$formatted";
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocListener<MatchingPatientCubit, MatchingPatientState>(
      listener: (context, state) {
        if (state.errorMsg != null) {
          print(state.errorMsg);
        }
        if (state.patients != null) {
          data = state.patients;
          if (data.length != 0) {
            if (dataAvailable == true) {
              object = [
                firstName,
                lastName,
                genderName,
                dateOfBirth
              ];
              RouteGenerator.navigatorKey.currentState.pushNamed(
                  QuickAppointmentList.routeName,
                  arguments: {'object': object});
            } else {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: Text(AppStrings.alert,
                      style: TextStyle(
                        fontFamily: AppFonts.regular,
                      )),
                  content: Text(AppStrings.patientExist,
                      style: TextStyle(
                        fontFamily: AppFonts.regular,
                      )),
                  actions: [
                    CupertinoDialogAction(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                                  title: Text(AppStrings.reasonRequired,
                                      style: TextStyle(
                                        fontFamily: AppFonts.regular,
                                      )),
                                  content: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10.0)),
                                      child: Container(
                                        padding: EdgeInsets.only(left: 5),
                                        child: TextFormField(
                                          inputFormatters: [
                                            // ignore: deprecated_member_use
                                            WhitelistingTextInputFormatter(
                                                RegExp(AppConstants.nameRegExp))
                                          ],
                                          enableInteractiveSelection: false,
                                          controller: reasonForPatient,
                                          decoration: InputDecoration(
                                              hintText: AppStrings.reasonForPatient,
                                              hintStyle: TextStyle(fontSize: 14),
                                              border: InputBorder.none),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color:
                                              CustomizedColors.dropdowntxtcolor,
                                          fontFamily: AppFonts.regular),
                                    ),
                                  )),
                              actions: [
                                CupertinoDialogAction(
                                    onPressed: () async {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      if (reasonForPatient.text != "") {
                                        showLoaderDialog(
                                          context,
                                          text: AppStrings.loading,
                                        );
                                        dateFormatDob(
                                            dateOfBirth);
                                        dateFormatDoa(
                                            dateOfAccident);
                                        dateFormatDos(
                                            _dateOfServiceController.text);
                                        await bookAppointment(
                                          firstName,
                                          lastName,
                                          dob,
                                          genderName,
                                          caseTypeId,
                                          doa,
                                          appointmentTypeId,
                                          practiceLocationId,
                                          providerId ?? member,
                                          dos,
                                          _selectedTimeSlots,
                                          reasonForPatient.text,
                                          caseTypeStatesId ??
                                              selectedCaseStatesId,
                                          newPatient = true,
                                          episodeId,
                                          patientId,
                                          newCase = true,
                                        );
                                      } else {
                                        AppToast().showToast(
                                            AppStrings.reasonForPatientToast);
                                      }
                                    },
                                    child: Text(AppStrings.createPatient,
                                        style: TextStyle(
                                          fontFamily: AppFonts.regular,
                                        ))),
                              ],
                            ),
                          );
                        },
                        child: Text(AppStrings.continueTxt,
                            style: TextStyle(
                              fontFamily: AppFonts.regular,
                            ))),
                    CupertinoDialogAction(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                          object = [
                            firstName,
                            lastName,
                            genderName,
                            dateOfBirth
                          ];
                          RouteGenerator.navigatorKey.currentState.pushNamed(
                              QuickAppointmentList.routeName,
                              arguments: {'object': object});
                        },
                        child: Text(AppStrings.selectPatient,
                            style: TextStyle(
                              fontFamily: AppFonts.regular,
                            )))
                  ],
                ),
              );
            }
          } else {
            if (dataAvailable == true) {
              AppToast().showToast(AppStrings.patientNotFound);
            } else {
              showLoaderDialog(
                context,
                text: AppStrings.loading,
              );
              dateFormatDob(dateOfBirth);
              dateFormatDoa(dateOfAccident);
              dateFormatDos(_dateOfServiceController.text);
              bookAppointment(
                firstName,
                lastName,
                dob,
                genderName,
                caseTypeId,
                doa,
                appointmentTypeId,
                practiceLocationId,
                providerId ?? member,
                dos,
                _selectedTimeSlots,
                reasonForPatient.text,
                caseTypeStatesId ?? selectedCaseStatesId,
                newPatient = true,
                episodeId,
                patientId,
                newCase = true,
              );
            }
          }
        }
      },
        child: WillPopScope(
          onWillPop: () async{
            onBackPressed();
          return true;
          },
          child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        CustomBottomNavigationBar.routeName,
                            (Route<dynamic> route) => false);
                  },
                ),
                title: Text(AppStrings.quickAppointment,
                    style: TextStyle(
                      fontFamily: AppFonts.regular,
                    )),
                backgroundColor: CustomizedColors.appBarColor,
              ),
              backgroundColor: CustomizedColors.primaryBgColor,
              body: BlocBuilder<MatchingPatientCubit, MatchingPatientState>(
                  builder: (context, state) {
                    Map args1 = ModalRoute.of(context).settings.arguments;
                    final Map args = ModalRoute.of(context).settings.arguments;
                    if (args1['showCase'] == true) {
                      PatientList list = args['selectedPatient'];
                      if (list != null) {
                        patientId = list.patientId;
                        newEpisodeId = list.episodeId;
                        firstName = list.firstName;
                        lastName = list.lastName;
                        if (list.dob != "") {
                          var date1 = DateFormat(AppConstants.MMddyyyy).parse(list.dob);
                          final DateFormat formatter =
                          DateFormat(AppStrings.dateFormatForDatePicker);
                          final String formatted = formatter.format(date1);
                          dateOfBirth = "$formatted";
                        }
                        if (list.doa != null) {
                          var date2 = DateFormat(AppConstants.yyyyMMdd).parse(list.doa);
                          final DateFormat formatterDoa =
                          DateFormat(AppStrings.dateFormatForDatePicker);
                          final String formattedDoa = formatterDoa.format(date2);
                          dateOfAccident = "$formattedDoa";
                        }
                        if (list.caseTypeStateId != null) {
                          selectedCaseStatesId = list.caseTypeStateId;
                        }
                        if (list.sex == AppStrings.shortMale) {
                          if(isInit){
                          genderMale = true;
                          genderFemale = false;
                          genderUnknown = false;

                            genderName = AppStrings.maleValue;
                          }

                        } else if (list.sex == AppStrings.shortFemale) {
                          if(isInit){
                          genderMale = false;
                          genderFemale = true;
                          genderUnknown = false;

                            genderName = AppStrings.femaleValue;
                          }

                        } else {
                          if(isInit){
                          genderMale = false;
                          genderFemale = false;
                          genderUnknown = true;

                            genderName = AppStrings.unknownValue;
                          }
                        }
                        isInit=false;
                        selectedCaseId = list.caseTypeId;
                        readOnly = true;
                      }
                    } else {
                      selectedCaseId = null;
                    }
                    return Container(
                      margin: EdgeInsets.only(top: 15),
                      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                      child: ListView(
                        children: [
                          Card(
                            child: Form(
                              key: _formKey,
                              child: Container(
                                width: width,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Text(AppStrings.patientDetails,
                                        style: TextStyle(
                                            fontFamily: AppFonts.regular,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: CustomizedColors.accentColor)),
                                    Row(
                                      children: [
                                        Text(AppStrings.firstName + " ",
                                            style: TextStyle(
                                                fontFamily: AppFonts.regular,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: CustomizedColors.accentColor)),
                                        Text(AppStrings.mandatoryAsterisk,
                                            style: TextStyle(
                                                fontFamily: AppFonts.regular,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: CustomizedColors.accentColor))
                                      ],
                                    ),
                                    TextFormField(
                                      initialValue: firstName,
                                      onSaved: (value){
                                        setState(() {
                                          firstName = value;
                                        });
                                      },
                                      inputFormatters: [
                                        // ignore: deprecated_member_use
                                        WhitelistingTextInputFormatter(
                                            RegExp(AppConstants.nameRegExp))
                                      ],
                                      enableInteractiveSelection: false,
                                      validator: validateInput,
                                      // controller: _firstName,
                                      focusNode: _focusNodeFname,
                                      key: _fnameKey,
                                      decoration: InputDecoration(
                                          hintText: AppStrings.firstName,
                                          hintStyle: TextStyle(fontSize: 14),
                                          border: borders,
                                          enabledBorder: borders),
                                      onChanged: (value) {
                                        _fnameKey.currentState.validate();
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Text(AppStrings.lastName + " ",
                                            style: TextStyle(
                                                fontFamily: AppFonts.regular,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: CustomizedColors.accentColor)),
                                        Text(AppStrings.mandatoryAsterisk,
                                            style: TextStyle(
                                                fontFamily: AppFonts.regular,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: CustomizedColors.accentColor))
                                      ],
                                    ),
                                    TextFormField(
                                      initialValue: lastName,
                                      onSaved: (value){
                                        setState(() {
                                          lastName = value;
                                        });
                                      },
                                      inputFormatters: [
                                        // ignore: deprecated_member_use
                                        WhitelistingTextInputFormatter(
                                            RegExp(AppConstants.nameRegExp))
                                      ],
                                      enableInteractiveSelection: false,
                                      validator: validateInput,
                                      // controller: _lastName,
                                      key: _lnameKey,
                                      focusNode: _focusNodeLname,
                                      decoration: InputDecoration(
                                          hintText: AppStrings.lastName,
                                          hintStyle: TextStyle(fontSize: 14),
                                          border: borders,
                                          enabledBorder: borders),
                                      onChanged: (value) {
                                        _lnameKey.currentState.validate();
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Text(AppStrings.dob_text,
                                            style: TextStyle(
                                                fontFamily: AppFonts.regular,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: CustomizedColors.accentColor)),
                                      ],
                                    ),
                                    TextFormField(
                                      initialValue: dateOfBirth,
                                      onSaved: (value){
                                        setState(() {
                                          dateOfBirth = value;
                                        });
                                      },
                                      focusNode: focusNodeDob,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(AppConstants.dateNumRegExp)),
                                        LengthLimitingTextInputFormatter(10),
                                        DateValidFormatter(),
                                      ],
                                      enableInteractiveSelection: false,
                                      // controller: _dateOfBirthController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          hintText: AppStrings.dateFormatLableHintText,
                                          // hintText: AppStrings.yyyymmdd,
                                          hintStyle: TextStyle(fontSize: 14),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              Icons.calendar_today_sharp,
                                              color: CustomizedColors.accentColor,
                                            ),
                                            onPressed: () async {
                                              focusNodeDob.unfocus();
                                              focusNodeDob.canRequestFocus = false;
                                              FocusManager.instance.primaryFocus.unfocus();
                                              DateTime dd = DateTime(1900);
                                              dd = await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now().subtract(Duration(days: 1)),
                                                  firstDate: DateTime(1900),
                                                  lastDate: DateTime.now().subtract(Duration(days: 1)));
                                              if (dd != null) {
                                                final DateFormat formats = DateFormat(
                                                    AppStrings.dateFormatForDatePicker);
                                                _dateOfBirth = formats.format(dd);
                                                dateOfBirth =
                                                    _dateOfBirth.toString();
                                              }
                                              focusNodeDob.canRequestFocus = true;
                                            },
                                          ),
                                          border: borders,
                                          enabledBorder: borders),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Text(AppStrings.gender,
                                            style: TextStyle(
                                                fontFamily: AppFonts.regular,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: CustomizedColors.accentColor)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                print('########$genderName');
                                                setState(() {
                                                  genderMale = true;
                                                  genderFemale = false;
                                                  genderUnknown = false;
                                                  genderName = AppStrings.maleValue;
                                                });
                                                print('########$genderName');
                                              },
                                              child: Card(
                                                elevation: 2,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: radius50,
                                                ),
                                                child: Container(
                                                  height: 45,
                                                  width: 45,
                                                  decoration: BoxDecoration(
                                                      color: genderMale
                                                          ? CustomizedColors.accentColor
                                                          : CustomizedColors.whiteColor,
                                                      borderRadius: radius50),
                                                  child: Image.asset(
                                                    AppImages.maleImg,
                                                    scale: 20,
                                                    color: genderMale
                                                        ? CustomizedColors.whiteColor
                                                        : CustomizedColors.accentColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: width * 0.1,
                                              child: Text(AppStrings.male,
                                                  style: TextStyle(
                                                      fontFamily: AppFonts.regular,
                                                      fontSize: 12)),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                print('########$genderName');
                                                setState(() {
                                                  genderFemale = true;
                                                  genderMale = false;
                                                  genderUnknown = false;
                                                  genderName = AppStrings.femaleValue;
                                                });
                                                print('########$genderName');
                                              },
                                              child: Card(
                                                elevation: 2,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: radius50,
                                                ),
                                                child: Container(
                                                  height: 45,
                                                  width: 45,
                                                  decoration: BoxDecoration(
                                                      color: genderFemale
                                                          ? CustomizedColors.accentColor
                                                          : CustomizedColors.whiteColor,
                                                      borderRadius: radius50),
                                                  child: Image.asset(
                                                    AppImages.femaleImg,
                                                    scale: 20,
                                                    color: genderFemale
                                                        ? CustomizedColors.whiteColor
                                                        : CustomizedColors.accentColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: width * 0.125,
                                              child: Text(AppStrings.female,
                                                  style: TextStyle(
                                                    fontFamily: AppFonts.regular,
                                                    fontSize: 12,
                                                  )),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  genderFemale = false;
                                                  genderMale = false;
                                                  genderUnknown = true;
                                                  genderName = AppStrings.unknownValue;
                                                });
                                              },
                                              child: Card(
                                                elevation: 2,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: radius50,
                                                ),
                                                child: Container(
                                                  height: 45,
                                                  width: 45,
                                                  decoration: BoxDecoration(
                                                      color: genderUnknown
                                                          ? CustomizedColors.accentColor
                                                          : CustomizedColors.whiteColor,
                                                      borderRadius: radius50),
                                                  child: Image.asset(
                                                    AppImages.unknownImg,
                                                    scale: 20,
                                                    color: genderUnknown
                                                        ? CustomizedColors.whiteColor
                                                        : CustomizedColors.accentColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: width * 0.15,
                                              child: Text(AppStrings.unknown,
                                                  style: TextStyle(
                                                    fontFamily: AppFonts.regular,
                                                    fontSize: 12,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: CustomizedColors.submitbuttonColor,
                                          ),
                                          onPressed: () async {
                                            _formKey.currentState.save();
                                            setState(() {
                                              dataAvailable = true;
                                            });
                                            if (_formKey.currentState.validate()) {
                                              isInternetAvailable =
                                              await AppConstants.checkInternet();
                                              if (isInternetAvailable == true) {
                                                showLoaderDialog(
                                                  context,
                                                  text: AppStrings.loading,
                                                );
                                                await BlocProvider.of<
                                                    MatchingPatientCubit>(context)
                                                    .getPatientList(
                                                    firstName,
                                                    lastName,
                                                    genderName,
                                                    dateOfBirth,
                                                    _pageNumber);
                                                Navigator.of(this.context,
                                                    rootNavigator: true)
                                                    .pop();
                                              } else {
                                                AppToast().showToast(
                                                    AppStrings.networkNotConnected);
                                              }
                                            }
                                          },
                                          child: Container(
                                            width: width * 0.32,
                                            child: Text(AppStrings.search,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: AppFonts.regular,
                                                  fontSize: 14,
                                                )),
                                          ),
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary:
                                              CustomizedColors.submitbuttonColor,
                                            ),
                                            onPressed: () async {
                                              _formKey.currentState.save();
                                              isInternetAvailable =
                                              await AppConstants.checkInternet();
                                              if (isInternetAvailable == true) {
                                                if (firstName != null &&
                                                    lastName != null &&
                                                    dateOfBirth != "" &&
                                                    genderName != null) {
                                                  setState(() {
                                                    showCase = true;
                                                  });
                                                } else {
                                                  AppToast().showToast(
                                                      AppStrings.fillAllFields);
                                                }
                                              } else {
                                                AppToast().showToast(
                                                    AppStrings.networkNotConnected);
                                              }
                                            },
                                            child: Container(
                                              width: width * 0.32,
                                              child: Text(AppStrings.createPatient,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: AppFonts.regular,
                                                    fontSize: 14,
                                                  )),
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          caseDetails(),
                        ],
                      ),
                    );
                  })),
        ),
     // ),
    );
  }
  Widget caseDetails() {
    double width = MediaQuery.of(context).size.width;
    Map args1 = ModalRoute.of(context).settings.arguments;
    if (args1['showCase'] == true || showCase == true) {
      return Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Card(
            child: Container(
              width: width * 1,
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKeyCase,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(AppStrings.caseType + " ",
                            style: TextStyle(
                                fontFamily: AppFonts.regular,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: CustomizedColors.accentColor)),
                        Text(AppStrings.mandatoryAsterisk,
                            style: TextStyle(
                                fontFamily: AppFonts.regular,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: CustomizedColors.accentColor))
                      ],
                    ),
                    BlocProvider(
                      create: (context) => QuickAppointmentCaseTypesCubit(),
                      child: QuickCaseTypeDropDown(
                        selectedCaseType: selectedCaseId,
                        onTapCaseType: (newValue) async {
                          setState(() {
                            if (newValue != null) {
                              caseTypeId =
                                  (newValue as CaseTypes).id ?? selectedCaseId;
                            }
                          });
                        },
                      ),
                    ),
                    readOnly
                        ? Center(
                            child: Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                borderRadius: radius50,
                                color: CustomizedColors.waveBGColor,
                              ),
                              child: Text(AppStrings.caseTxt,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AppFonts.regular,
                                    fontSize: 14,
                                  )),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 20,
                    ),
                    (caseTypeId == null ? selectedCaseId : caseTypeId) == 1
                        ? Row(
                            children: [
                              Text(AppStrings.caseTypeState + " ",
                                  style: TextStyle(
                                      fontFamily: AppFonts.regular,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: CustomizedColors.accentColor)),
                              Text(AppStrings.mandatoryAsterisk,
                                  style: TextStyle(
                                      fontFamily: AppFonts.regular,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: CustomizedColors.accentColor))
                            ],
                          )
                        : Container(),
                    (caseTypeId == null ? selectedCaseId : caseTypeId) == 1
                        ? BlocProvider(
                            create: (context) => CaseTypeStatesCubit(),
                            child: CaseTypeStatesDropDown(
                              selectedCaseTypeStates: selectedCaseStatesId,
                              onTapCaseTypeStates: (newValue) async {
                                setState(() {
                                  if (newValue != null) {
                                    caseTypeStatesId =
                                        (newValue as StatesList).id ??
                                            selectedCaseStatesId;
                                  }
                                });
                              },
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height:
                          (caseTypeId == null ? selectedCaseId : caseTypeId) == 1
                              ? 20
                              : 00,
                    ),
                    Row(
                      children: [
                        Text(AppStrings.doa + " ",
                            style: TextStyle(
                                fontFamily: AppFonts.regular,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: CustomizedColors.accentColor)),
                      ],
                    ),
                    TextFormField(
                      initialValue: dateOfAccident,
                      onSaved: (value){
                        setState(() {
                          dateOfAccident = value;
                        });
                      },
                      focusNode: focusNodeDoa,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(AppConstants.dateNumRegExp)),
                        LengthLimitingTextInputFormatter(10),
                        DateValidFormatter(),
                      ],
                      enableInteractiveSelection: false,
                      // controller: _dateOfAccidentController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: AppStrings.dateFormatLableHintText,
                          hintStyle: TextStyle(fontSize: 14),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.calendar_today_sharp,
                              color: CustomizedColors.accentColor,
                            ),
                            onPressed: () async {
                              focusNodeDoa.unfocus();
                              focusNodeDoa.canRequestFocus = false;
                              FocusManager.instance.primaryFocus.unfocus();
                              DateTime d = DateTime(1900);
                              d = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now());
                              if (d != null) {
                                final DateFormat formats = DateFormat(
                                    AppStrings.dateFormatForDatePicker);
                                _dateOfAccident = formats.format(d);
                                dateOfAccident = _dateOfAccident;
                              }
                              focusNodeDoa.canRequestFocus = true;
                            },
                          ),
                          border: borders,
                          enabledBorder: borders),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            child: Container(
              width: width * 1,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(AppStrings.appointmentType + " ",
                          style: TextStyle(
                              fontFamily: AppFonts.regular,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: CustomizedColors.accentColor)),
                      Text(AppStrings.mandatoryAsterisk,
                          style: TextStyle(
                              fontFamily: AppFonts.regular,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: CustomizedColors.accentColor))
                    ],
                  ),
                  BlocProvider(
                    create: (context) => QuickAppointmentTypeCubit(),
                    child: QuickAppointmentTypeDropDown(
                      selectedAppointmentType: 6,
                      onTapAppointmentType: (newValue) async {
                        setState(() {
                          if (newValue != null) {
                            appointmentTypeId =
                                (newValue as AppointmentTypeList).id;
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(AppStrings.practice + " ",
                          style: TextStyle(
                              fontFamily: AppFonts.regular,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: CustomizedColors.accentColor)),
                      Text(AppStrings.mandatoryAsterisk,
                          style: TextStyle(
                              fontFamily: AppFonts.regular,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: CustomizedColors.accentColor))
                    ],
                  ),
                  BlocProvider(
                    create: (context) => PracticeLocationsCubit(),
                    child: PracticeLocationsDropDown(
                      onTapOfPractice: (newValue) async {
                        setState(() {
                          if (newValue != null) {
                            practiceLocationId =
                                (newValue as LocationList).practiceLocationId;
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(AppStrings.provider + " ",
                          style: TextStyle(
                              fontFamily: AppFonts.regular,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: CustomizedColors.accentColor)),
                      Text(AppStrings.mandatoryAsterisk,
                          style: TextStyle(
                              fontFamily: AppFonts.regular,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: CustomizedColors.accentColor))
                    ],
                  ),
                  BlocProvider(
                    create: (context) => ProvidersForPracticeLocationsCubit(),
                    child: ProviderForPracticeLocationsDropDown(
                      onTapOfProvider: (newValue) async {
                        if (newValue != null) {
                          providerId =
                              (newValue as MemberList).memberId ?? member;
                        }
                      },
                      practiceLocationId: practiceLocationId,
                      selectedProviderId: roleId != 1 ? member : null,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(AppStrings.dosDropDownText + " ",
                          style: TextStyle(
                              fontFamily: AppFonts.regular,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: CustomizedColors.accentColor)),
                      Text(AppStrings.mandatoryAsterisk,
                          style: TextStyle(
                              fontFamily: AppFonts.regular,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: CustomizedColors.accentColor))
                    ],
                  ),
                  TextFormField(
                    focusNode: focusNodeDos,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(AppConstants.dateNumRegExp)),
                      LengthLimitingTextInputFormatter(10),
                      DateValidFormatter(),
                    ],
                    enableInteractiveSelection: false,
                    controller: _dateOfServiceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: AppStrings.dateFormatLableHintText,
                        hintStyle: TextStyle(fontSize: 14),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.calendar_today_sharp,
                            color: CustomizedColors.accentColor,
                          ),
                          onPressed: () async {
                            focusNodeDos.unfocus();
                            focusNodeDos.canRequestFocus = false;
                            FocusManager.instance.primaryFocus.unfocus();
                            DateTime d = DateTime(1900);
                            d = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100));
                            if (d != null) {
                              setState(() {
                                isToday = AppConstants.isSameDay(d);
                              });
                              final DateFormat formats = DateFormat(
                                  AppStrings.dateFormatForDatePicker);
                              _dateOfService = formats.format(d);
                              _dateOfServiceController.text =
                                  _dateOfService.toString();
                            }
                            focusNodeDos.canRequestFocus = true;
                          },
                        ),
                        border: borders,
                        enabledBorder: borders),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(AppStrings.time + " ",
                          style: TextStyle(
                              fontFamily: AppFonts.regular,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: CustomizedColors.accentColor)),
                      Text(AppStrings.mandatoryAsterisk,
                          style: TextStyle(
                              fontFamily: AppFonts.regular,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: CustomizedColors.accentColor))
                    ],
                  ),
                  BlocProvider(
                    create: (context) => QuickTimeSlotsCubit(),
                    child: TimeSlotsDropDown(
                      onTapTimeSlots: (newValue) async {
                        if (newValue != null) {
                          timeSlotId = (newValue as AppointmentTimeSlots).id;
                          _selectedTimeSlots =
                              (newValue as AppointmentTimeSlots).standardTime;
                        }
                      },
                      selectedDos: _dateOfServiceController.text,
                      todayDate: isToday,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: CustomizedColors.submitbuttonColor,
                  ),
                  onPressed: () {
                    RouteGenerator.navigatorKey.currentState
                        .pushReplacementNamed(QuickAppointmentScreen.routeName,
                        arguments: {'showCase': true});
                  },
                  child: Container(
                    width: width * 0.15,
                    child: Text(AppStrings.clearfiltertxt,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFonts.regular,
                          fontSize: 14,
                        )),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: CustomizedColors.submitbuttonColor,
                  ),
                  onPressed: () {
                    RouteGenerator.navigatorKey.currentState
                        .pushReplacementNamed(QuickAppointmentScreen.routeName,
                        arguments: {'showCase': false});
                  },
                  child: Container(
                    width: width * 0.18,
                    child: Text(AppStrings.cancel,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFonts.regular,
                          fontSize: 14,
                        )),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: CustomizedColors.submitbuttonColor,
                  ),
                  onPressed: () async {
                   // print('*******$genderName');
                    _formKeyCase.currentState.save();
                    _formKey.currentState.save();
                    if ((caseTypeId == null ? selectedCaseId : caseTypeId) !=
                        null &&
                        appointmentTypeId != null &&
                        practiceLocationId != null &&
                        (providerId == null ? member : providerId) != null &&
                        _selectedTimeSlots != null &&
                        _dateOfServiceController.text != "") {
                      if (((caseTypeId ?? selectedCaseId) == 1) &&
                          ((caseTypeStatesId == null
                              ? selectedCaseStatesId
                              : caseTypeStatesId) ==
                              null)) {
                        AppToast().showToast(AppStrings.fillAllFields);
                      } else {
                        selDosDate = _dateOfServiceController.text;
                        selectedDosDate =
                            DateFormat(AppStrings.dateFormatForDatePicker)
                                .parse(_dateOfServiceController.text)
                                .isAfter(DateTime.now());
                        if (dateOfAccident != null) {
                          selDoaDate = dateOfAccident;
                          todayDateDoa =
                              DateFormat(AppStrings.dateFormatForDatePicker)
                                  .format(DateTime.now());
                          selectedDoaDate =
                              DateFormat(AppStrings.dateFormatForDatePicker)
                                  .parse(dateOfAccident)
                                  .isBefore(DateTime.now());
                        } else {
                          selDoaDate = null;
                          selectedDoaDate = null;
                          todayDateDoa = null;
                        }
                        selectedDobDate =
                            DateFormat(AppStrings.dateFormatForDatePicker)
                                .parse(dateOfBirth)
                                .isBefore(DateTime.now());
                        if ((todayDate == selDosDate ||
                            selectedDosDate == true) &&
                            (todayDateDoa == selDoaDate ||
                                selectedDoaDate == true ??
                                null) &&
                            (selectedDobDate == true)) {
                          isInternetAvailable =
                          await AppConstants.checkInternet();
                          if (isInternetAvailable == true) {
                            if (showCase == true) {
                              setState(() {
                                dataAvailable = false;
                              });
                              showLoaderDialog(
                                context,
                                text: AppStrings.loading,
                              );
                              await BlocProvider.of<MatchingPatientCubit>(
                                  context)
                                  .getPatientList(
                                      firstName,
                                      lastName,
                                      genderName,
                                  dateOfBirth,
                                      _pageNumber);
                              Navigator.of(this.context, rootNavigator: true)
                                  .pop();
                            } else {
                              if (caseTypeId != null &&
                                  caseTypeId != selectedCaseId) {
                                isNewCase = true;
                                episodeId = null;
                              } else {
                                isNewCase = false;
                                episodeId = newEpisodeId;
                              }
                              showLoaderDialog(
                                context,
                                text: AppStrings.loading,
                              );
                              dateFormatDob(dateOfBirth);
                              dateFormatDoa(dateOfAccident);
                              dateFormatDos(_dateOfServiceController.text);

                              await bookAppointment(
                                firstName,
                                lastName,
                                dob,
                                genderName,
                                caseTypeId ?? selectedCaseId,
                                doa,
                                appointmentTypeId,
                                practiceLocationId,
                                providerId ?? member,
                                dos,
                                _selectedTimeSlots,
                                reasonForPatient.text,
                                caseTypeStatesId ?? selectedCaseStatesId,
                                newPatient = false,
                                episodeId,
                                patientId,
                                newCase = isNewCase,
                              );
                            }
                          } else {
                            AppToast()
                                .showToast(AppStrings.networkNotConnected);
                          }
                        } else {
                          AppToast().showToast(AppStrings.selectDate);
                        }
                      }
                    } else {
                      AppToast().showToast(AppStrings.fillAllFields);
                    }
                  },
                  child: Container(
                    width: width * 0.3,
                    child: Text(AppStrings.requestAppointment,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFonts.regular,
                          fontSize: 14,
                        )),
                  )),
            ],
          )
        ],
      );
    } else {
      return Container();
    }
  }

  onBackPressed() {
    Navigator.of(context).pushNamedAndRemoveUntil(CustomBottomNavigationBar.routeName, (Route<dynamic> route) => false);
  }
}