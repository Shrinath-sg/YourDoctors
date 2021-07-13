import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:ui';
import 'package:YOURDRS_FlutterAPP/blocs/home/patient_bloc.dart';
import 'package:YOURDRS_FlutterAPP/blocs/home/patient_bloc_event.dart';
import 'package:YOURDRS_FlutterAPP/blocs/home/patient_bloc_state.dart';
import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';
import 'package:YOURDRS_FlutterAPP/common/app_icons.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/common/app_toast_message.dart';
import 'package:YOURDRS_FlutterAPP/cubit/location_dropdown_cubit.dart';
import 'package:YOURDRS_FlutterAPP/cubit/pateint_details/get_image_files_cubit.dart';
import 'package:YOURDRS_FlutterAPP/cubit/provider_cubit.dart';
import 'package:YOURDRS_FlutterAPP/network/models/home/dictation.dart';
import 'package:YOURDRS_FlutterAPP/network/models/home/location.dart';
import 'package:YOURDRS_FlutterAPP/network/models/home/provider.dart';
import 'package:YOURDRS_FlutterAPP/network/models/home/schedule.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:YOURDRS_FlutterAPP/network/services/schedules/appointment_service.dart';
import 'package:YOURDRS_FlutterAPP/provider/filter_button_provider.dart';
import 'package:YOURDRS_FlutterAPP/ui/home/drawer.dart';
import 'package:YOURDRS_FlutterAPP/ui/home/patient_details.dart';
import 'package:YOURDRS_FlutterAPP/utils/cached_image.dart';
import 'package:YOURDRS_FlutterAPP/utils/route_generator.dart';
import 'package:YOURDRS_FlutterAPP/widget/buttons/mic_button.dart';
import 'package:YOURDRS_FlutterAPP/widget/date_range_picker.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/dictation.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/location.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/provider.dart';
import 'package:YOURDRS_FlutterAPP/widget/patient_list_shimmer.dart';
import 'package:dio/dio.dart';
import 'package:YOURDRS_FlutterAPP/widget/input_fields/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class PatientAppointment extends StatefulWidget {
  static const String routeName = '/HomeScreen';

  @override
  _PatientAppointmentState createState() => _PatientAppointmentState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    try {
      if (null != _timer) {
        _timer.cancel();
      }
    } catch (e) {
      throw Exception(AppStrings.errortext);
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _PatientAppointmentState extends State<PatientAppointment> {
  final _debouncer = Debouncer(milliseconds: 500);
  var displayName = "";
  Services apiServices = Services();
  AppToast appToast = AppToast();
  GlobalKey _key = GlobalKey();
  final validationKey = GlobalKey<FormState>();
  Map<String, dynamic> appointment;
  bool contains = false;

//var for selected Provider Id ,Dictation Id,Location Id
  var _currentSelectedProviderId;
  var _currentSelectedLocationId;
  var _currentSelectedDictationId;

// list of Patients
  List<ScheduleGroupList> patients = [];
  List<ScheduleGroupList> filteredPatients = [];
  List<ScheduleList> appointments = [];
  List<ScheduleList> filteredAppointments = [];
// Declared Variables for start Date and end Date
  String startDate;
  String endDate;

//boolean property for visibility for Date Picker
  bool datePicker = true;
  bool isExpanded = false;
  bool dateRange = false;
  bool selectedDateRange = false;
  bool isShowToast = false;
  String codeDialog;
  String valueText;
  var selectedDate;
  bool isFilterApplied = false;
  String selectedProvider;
  String selectedLocation;
  String selectedDictation;
  bool patientSearchIcon = true;
  bool patientClearIcon = false;
  bool okButtonEnabled = false;
  bool clearButtonEnabled = false;
  bool settingSelectedDateToNull = false;
  bool expandedPanel = false;
  int practiceLocationId;
  String todayDate;

  ///counting for each practice location using hashmap
  HashMap<String, int> locationCountMap = HashMap();
  HashMap<String, int> practiceCountMap = HashMap();
  HashMap<String, String> locationName = HashMap();
  HashMap<String, String> practiceName = HashMap();
  bool isLoadingVertical = false;
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _searchFilterController = TextEditingController();

//Infinite Scroll Pagination related code//
  var _scrollController = ScrollController();
  double maxScroll, currentScroll;
  int page;
  CancelToken cancelToken = CancelToken();
  var profilePic = "";
  int initialValue = 1;
  Services _services = Services();

  @override
  void initState() {
    super.initState();
  // _services.getExternalAttachmnetDocumentType();
    super.initState();
    page = 1;
    DateTime defaultDate = DateTime.now();
    todayDate = AppConstants.parseDate(-1, AppConstants.MMDDYYYY,
        dateTime: defaultDate);
    BlocProvider.of<PatientBloc>(context).add(GetSchedulePatientsList(
        keyword1: todayDate,
        providerId: null,
        locationId: null,
        dictationId: null,
        startDate: null,
        endDate: null,
        pageKey: page,
        practiceLocationId: null));
    _loadData();
    /// Loading date picker current date
    Future.delayed(Duration(milliseconds: 500), () {
      _controller?.animateToDate(DateTime.now().subtract(Duration(days: 3)));
    });
  }

  getSchedules(practiceLocationId, ScheduleGroupList patient) async {
    print(this._textFieldController.text);
    if (patient.scheduleList?.isEmpty ?? true) {
      page = 1;

      DateTime defaultDate = DateTime.now();
      todayDate = AppConstants.parseDate(-1, AppConstants.MMDDYYYY,
          dateTime: defaultDate);

      List<ScheduleList> appointments =
          await apiServices.getScheduleForPracticeLocations(
              !settingSelectedDateToNull ? selectedDate ?? todayDate : null,
              _currentSelectedProviderId ?? null,
              _currentSelectedLocationId ?? null,
              _currentSelectedDictationId ?? null,
              startDate ?? null,
              endDate ?? null,
              this._textFieldController.text == ""
                  ? this._searchFilterController.text
                  : this._textFieldController.text,
              page,
              practiceLocationId);
      practiceLocationId = null;
      patient.scheduleList = appointments;
    }
    expandedPanel = false;
    return patient.scheduleList;
  }

  bool init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _scrollController.addListener(_onScroll);
  }

  // void _onScroll() {
  //   final maxScroll = _scrollController.position.maxScrollExtent;
  //   final currentScroll = _scrollController.position.pixels;
  //   try {
  //     if (maxScroll > 0 && currentScroll > 0 && maxScroll == currentScroll) {
  //       page = page + 1;
  //       BlocProvider.of<PatientBloc>(context).add(GetSchedulePatientsList(
  //           keyword1: selectedDate,
  //           providerId: _currentSelectedProviderId,
  //           locationId: _currentSelectedLocationId,
  //           dictationId: _currentSelectedDictationId,
  //           startDate: startDate,
  //           endDate: endDate,
  //           pageKey: page,
  //           practiceLocationId: null));
  //     }
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }

//dispose methods//
  @override
  void dispose() {
    _scrollController.dispose();
    cancelToken.cancel(AppStrings.canceltxt);
    super.dispose();
  }

  DatePickerController _controller = DatePickerController();
  DateTime _selectedValue = DateTime.now();

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = (prefs.getString(Keys.displayName) ?? '');
      profilePic = (prefs.getString(Keys.displayPic) ?? '');
    });
    contains = profilePic.contains('https');
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white, // CustomizedColors.primaryBgColor,
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomizedColors.clrCyanBlueColor,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
          title: Row(
            children: [
              profilePic != null && profilePic != "" && contains == true
                  ? CachedImage(
                      profilePic,
                      isRound: true,
                      radius: 40.0,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.file(
                        File(profilePic),
                        fit: BoxFit.fill,
                        height: 40.0,
                        width: 40.0,
                      ),
                    ),
              SizedBox(
                width: 10,
              ),
              Text(
                displayName ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: <Widget>[
            // action button
            IconButton(
              icon: !isFilterApplied
                  ? Icon(
                      Icons.filter_alt_outlined,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.filter_alt,
                      color: Colors.white,
                    ),
              iconSize: 30.0,
              onPressed: () {
                Provider.of<FilterButtonProvider>(context,listen: false).setFilterValue(false);
                selectedDateRange = false;
                // _currentSelectedProviderId = null;
                // _currentSelectedDictationId = null;
                // _currentSelectedLocationId = null;
                _textFieldController.clear();
                _filterDialog(context, _currentSelectedProviderId,
                    _currentSelectedDictationId, _currentSelectedLocationId);
              },
            ),
            // action button
          ]),
      drawer: DrawerScreen(),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: RefreshIndicator(
          onRefresh: () {
            return _pullToRefresh(
                selectedDate,
                _currentSelectedProviderId,
                _currentSelectedLocationId,
                _currentSelectedDictationId,
                page,
                startDate,
                endDate);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 40,
                    color: CustomizedColors.clrCyanBlueColor,
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: PatientSerach(
                      trailing: patientSearchIcon
                          ? Icon(Icons.search)
                          : IconButton(
                              // padding: EdgeInsets.all(0),
                              alignment: Alignment.centerRight,
                              icon: Image.asset(AppImages.clearIcon,
                                  width: 20, height: 20),
                              onPressed: () {
                                setState(() {
                                  this.patientSearchIcon = true;
                                  settingSelectedDateToNull = false;
                                });

                                String string = "";
                                _textFieldController.clear();
                                _debouncer.run(() {
                                  // BlocProvider.of<PatientBloc>(context)
                                  //     .add(SearchPatientEvent(keyword: string));
                                  page = 1;
                                  BlocProvider.of<PatientBloc>(
                                          context)
                                      .add(GetSchedulePatientsList(
                                          keyword1: selectedDate ?? todayDate,
                                          providerId:
                                              _currentSelectedProviderId != null
                                                  ? _currentSelectedProviderId
                                                  : null,
                                          locationId:
                                              _currentSelectedLocationId !=
                                                      null
                                                  ? _currentSelectedLocationId
                                                  : null,
                                          dictationId:
                                              _currentSelectedDictationId !=
                                                      null
                                                  ? int.tryParse(
                                                      _currentSelectedDictationId)
                                                  : null,
                                          startDate: startDate != ""
                                              ? startDate
                                              : null,
                                          endDate:
                                              endDate != "" ? endDate : null,
                                          searchString: string,
                                          pageKey: page,
                                          practiceLocationId: null));
                                });
                              }),
                      width: 250,
                      height: 60,
                      decoration: InputDecoration(
                        hintText: AppStrings.searchpatienttitle,
                        border: InputBorder.none,
                      ),
                      controller: _textFieldController,
                      onChanged: (string) {
                        setState(() {
                          this.patientSearchIcon = false;
                          settingSelectedDateToNull = false;
                        });
                        _debouncer.run(() {
                          // BlocProvider.of<PatientBloc>(context)
                          //     .add(SearchPatientEvent(keyword: string));
                          page = 1;
                          BlocProvider.of<PatientBloc>(context).add(
                              GetSchedulePatientsList(
                                  keyword1: selectedDate ?? todayDate,
                                  providerId:
                                      _currentSelectedProviderId !=
                                              null
                                          ? _currentSelectedProviderId
                                          : null,
                                  locationId: _currentSelectedLocationId != null
                                      ? _currentSelectedLocationId
                                      : null,
                                  dictationId:
                                      _currentSelectedDictationId != null
                                          ? int.tryParse(
                                              _currentSelectedDictationId)
                                          : null,
                                  startDate: startDate != "" ? startDate : null,
                                  endDate: endDate != "" ? endDate : null,
                                  searchString:
                                      this._textFieldController.text != null
                                          ? this._textFieldController.text
                                          : null,
                                  pageKey: page,
                                  practiceLocationId: null));
                        });
                      },
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: datePicker,
                child: Container(
                  child: DatePicker(
                    DateTime.now().subtract(Duration(days: 365)),
                    width: width < 600 ? 50.0 : 120.0,
                    height: 80,
                    controller: _controller,
                    initialSelectedDate: DateTime.now(),
                    selectionColor: CustomizedColors.primaryColor,
                    selectedTextColor: CustomizedColors.textColor,
                    dayTextStyle:
                        TextStyle(fontSize: 12.0, fontFamily: AppFonts.regular),
                    dateTextStyle:
                        TextStyle(fontSize: 12.0, fontFamily: AppFonts.regular),
                    monthTextStyle:
                        TextStyle(fontSize: 12.0, fontFamily: AppFonts.regular),
                    onDateChange: (date) {
                      _textFieldController.clear();
                      this.patientSearchIcon = true;
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      // New date selected
                      setState(() {
                        _selectedValue = date;
                        selectedDate = AppConstants.parseDate(
                            -1, AppConstants.MMDDYYYY,
                            dateTime: _selectedValue);
                        page = 1;
                        // getSelectedDateAppointments();
                        BlocProvider.of<PatientBloc>(context).add(
                            GetSchedulePatientsList(
                                keyword1: selectedDate,
                                providerId: null,
                                locationId: null,
                                dictationId: null,
                                pageKey: page,
                                practiceLocationId: null));
                      });
                    },
                  ),
                ),
              ),
              Visibility(
                visible: dateRange,
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  width: width,
                  child: Row(
                    children: [
                      Container(
                          width: width * 0.80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(text: '', children: <TextSpan>[
                                  TextSpan(
                                      text: startDate != null
                                          ? AppStrings.daterange +
                                              ": " +
                                              '${AppConstants.parseDatePattern(startDate, AppConstants.MMMddyyyy)}' +
                                              "-" +
                                              '${AppConstants.parseDatePattern(endDate, AppConstants.MMMddyyyy)}'
                                          : "",
                                      style: TextStyle(
                                          color:
                                              CustomizedColors.filterTextColor,
                                          fontSize: 12.0,
                                          fontFamily: AppFonts.regular)),
                                  TextSpan(
                                      text: _currentSelectedProviderId != null
                                          ? ", " +
                                              AppStrings.provider +
                                              " : " +
                                              '${this.selectedProvider}'
                                          : "",
                                      style: TextStyle(
                                          color:
                                              CustomizedColors.filterTextColor,
                                          fontSize: 12.0,
                                          fontFamily: AppFonts.regular)),
                                  TextSpan(
                                      text: _currentSelectedDictationId != null
                                          ? ", " +
                                              AppStrings.dictationtxt +
                                              " : " +
                                              '${this.selectedDictation}'
                                          : "",
                                      style: TextStyle(
                                          color:
                                              CustomizedColors.filterTextColor,
                                          fontSize: 12.0,
                                          fontFamily: AppFonts.regular)),
                                  TextSpan(
                                      text: _currentSelectedLocationId != null
                                          ? ", " +
                                              AppStrings.locationtxt +
                                              " : " +
                                              '${this.selectedLocation}'
                                          : "",
                                      style: TextStyle(
                                          color:
                                              CustomizedColors.filterTextColor,
                                          fontSize: 12.0,
                                          fontFamily: AppFonts.regular)),
                                  TextSpan(
                                      text: this._searchFilterController.text !=
                                              ""
                                          ? ", " +
                                              AppStrings.selectedPatient +
                                              " : " +
                                              '${this._searchFilterController.text}'
                                          : "",
                                      style: TextStyle(
                                          color:
                                              CustomizedColors.filterTextColor,
                                          fontSize: 12.0,
                                          fontFamily: AppFonts.regular))
                                ]),
                              )
                            ],
                          )),
                      Container(
                        width: width * 0.10,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Image.asset(AppImages.clearFilterIcon,
                                    width: 20,
                                    height: 20,
                                    color: CustomizedColors.filterTextColor),
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  _textFieldController.clear();
                                  _searchFilterController.clear();
                                  settingSelectedDateToNull = false;
                                  setState(() {
                                    datePicker = true;
                                    dateRange = false;
                                    this.selectedDictation = "";
                                    this.selectedLocation = "";
                                    this.selectedProvider = "";
                                    isFilterApplied = false;
                                    _currentSelectedProviderId = null;
                                    _currentSelectedDictationId = null;
                                    _currentSelectedLocationId = null;
                                    _searchFilterController.clear();
                                    startDate = null;
                                    endDate = null;
                                  });
                                  Future.delayed(Duration(milliseconds: 500),
                                      () {
                                    _controller?.animateToDate(DateTime.now()
                                        .subtract(Duration(days: 3)));
                                  });
                                  page = 1;
                                  DateTime defaultDate = DateTime.now();
                                  todayDate = AppConstants.parseDate(
                                      -1, AppConstants.MMDDYYYY,
                                      dateTime: defaultDate);
                                  BlocProvider.of<PatientBloc>(context).add(
                                      GetSchedulePatientsList(
                                          keyword1: todayDate,
                                          providerId: null,
                                          locationId: null,
                                          dictationId: null,
                                          startDate: null,
                                          endDate: null,
                                          searchString: null,
                                          pageKey: page,
                                          practiceLocationId: null));
                                },
                              )
                            ]),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(child: patientAppointmentCard())
            ],
          ),
        ),
      ),
    );
  }

// patient Appointment card related code//
  Widget patientAppointmentCard() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Form(
        key: validationKey,
        child: Padding(
          // padding: EdgeInsets.symmetric(vertical: 40, horizontal: 00),
          padding: EdgeInsets.only(bottom: 40),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                BlocBuilder<PatientBloc, PatientAppointmentBlocState>(
                    builder: (context, state) {
                  // print(state);
                  try {
                    if (state.isLoading &&
                        (state.patients == null || state.patients.isEmpty)) {
                      // showLoadingDialog(context, text: 'Getting appointments');
                      //return CustomizedCircularProgressBar();
                      return PatientListShimmer();
                    }
                  } catch (e) {
                    throw Exception(AppStrings.errortext);
                  }
                  try {
                    if (state.errorMsg != null && state.errorMsg.isNotEmpty) {
                      return Container(
                        padding: EdgeInsets.only(top: 175),
                        child: Center(
                            child: Text(
                          state.errorMsg,
                          style: TextStyle(
                              color: CustomizedColors.buttonTitleColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFonts.regular),
                        )),
                      );
                    }
                  } catch (e) {
                    throw Exception(e.toString());
                  }
                  try {
                    if (state.patients == null || state.patients.isEmpty) {
                      return Text(
                        AppStrings.nopatients,
                        style: TextStyle(
                            fontFamily: AppFonts.regular,
                            fontSize: 18.0,
                            color: CustomizedColors.noAppointment),
                      );
                    }
                  } catch (e) {
                    throw Exception(e.toString());
                  }
                  patients = state.patients;

                  try {
                    if (state.patients.length == 1) {
                      // String value1 = AppStrings.noData;
                      expandedPanel = true;
                      if (!isShowToast) {}
                    }
                  } catch (e) {
                    throw Exception(e.toString());
                  }

                  return patients != null && patients.isNotEmpty
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: patients.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(
                            color: Colors.white,
                          ),
                          itemBuilder: (context, index) {
                            // return Flexible(
                            return ExpansionPanelList(
                              animationDuration: Duration(milliseconds: 1000),
                              dividerColor: Colors.red,
                              elevation: 0,
                              children: [
                                ExpansionPanel(
                                    canTapOnHeader: true,
                                    body: patients[index].isExpanded ||
                                            expandedPanel
                                        ? FutureBuilder(
                                            future: getSchedules(
                                                patients[index]
                                                    .practiceLocationId,
                                                patients[index]),
                                            builder: (context,
                                                AsyncSnapshot snapshot) {
                                              if (!snapshot.hasData) {
                                                return Center(
                                                  child:
                                                      CupertinoActivityIndicator(
                                                    radius: 20,
                                                  ),
                                                );
                                              } else {
                                                return Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0),
                                                    // height: 200,
                                                    child: ListView.builder(
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        controller:
                                                            _scrollController,
                                                        shrinkWrap: true,
                                                        itemCount: snapshot
                                                            .data.length,
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          // return Text('${snapshot.data[index].patient.displayName}');
                                                          return GestureDetector(
                                                            onTap: () {
                                                              RouteGenerator
                                                                  .navigatorKey
                                                                  .currentState
                                                                  .pushNamed(
                                                                      PatientDetail
                                                                          .routeName,
                                                                      arguments:
                                                                          snapshot
                                                                              .data[index]);
                                                            },
                                                            child: Card(
                                                              elevation: 0,
                                                              color:
                                                                  Colors.white,
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  boxShadow: <
                                                                      BoxShadow>[
                                                                    BoxShadow(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade400,
                                                                        blurRadius:
                                                                            3.0,
                                                                        offset: Offset(
                                                                            0.0,
                                                                            0.95)),
                                                                  ],
                                                                ),
                                                                padding: height <
                                                                        550
                                                                    ? EdgeInsets.only(
                                                                        left: 5,
                                                                        right:
                                                                            5,
                                                                        top: 0,
                                                                        bottom:
                                                                            0)
                                                                    : EdgeInsets.only(
                                                                        left: 5,
                                                                        right:
                                                                            5,
                                                                        top: 5,
                                                                        bottom:
                                                                            5),

                                                                ///edited
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Container(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            0,
                                                                            10,
                                                                            0,
                                                                            10),
                                                                        width: width *
                                                                            0.95,
                                                                        //color: Colors.yellow,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Column(
                                                                              children: [
                                                                                Hero(
                                                                                  transitionOnUserGestures: true,
                                                                                  tag: snapshot,
                                                                                  child: Transform.scale(
                                                                                      scale: 1.0,
                                                                                      child: snapshot.data[index].isNewPatient == true
                                                                                          ? Container(
                                                                                              padding: EdgeInsets.all(5),
                                                                                              decoration: BoxDecoration(shape: BoxShape.circle, color: CustomizedColors.greenDotColor),
                                                                                              child: Image.asset(AppImages.defaultImg, width: 30, height: 30, alignment: Alignment.center),
                                                                                            )
                                                                                          : Container(
                                                                                              padding: EdgeInsets.all(5),
                                                                                              decoration: BoxDecoration(
                                                                                                shape: BoxShape.circle,
                                                                                                color: Colors.grey.shade200,
                                                                                              ),
                                                                                              child: Image.asset(AppImages.defaultImg, width: 30, height: 30, alignment: Alignment.center),
                                                                                            )),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              width: 15.0,

                                                                              ///edited....
                                                                            ),
                                                                            Expanded(
                                                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Text(
                                                                                      snapshot.data[index].patient.displayName,
                                                                                      style: TextStyle(height: 1.5, fontSize: 15.0, color: Colors.grey.shade600, fontWeight: FontWeight.w700),
                                                                                    ),
                                                                                    AppConstants.parseDate(-1, AppConstants.yyyyMMdd, dateTime: DateTime.parse(snapshot.data[index].appointmentStartDate)) == AppConstants.parseDate(-1, AppConstants.yyyyMMdd, dateTime: DateTime.now())
                                                                                        ? Text(
                                                                                            AppConstants.parseDate(-1, AppConstants.hhmma, dateTime: DateTime.parse(snapshot.data[index].appointmentStartDate)),
                                                                                            style: TextStyle(
                                                                                              height: 1.5,
                                                                                              fontSize: 14.0,
                                                                                              color: Colors.grey.shade500,
                                                                                            ),
                                                                                            textAlign: TextAlign.left,
                                                                                          )
                                                                                        : Text(
                                                                                            AppConstants.parseDate(-1, AppConstants.MMMddyyyy, dateTime: DateTime.parse(snapshot.data[index].appointmentStartDate)),
                                                                                            style: TextStyle(
                                                                                              height: 1.5,
                                                                                              fontSize: 14.0,
                                                                                              color: Colors.grey.shade500,
                                                                                            ),
                                                                                            textAlign: TextAlign.left,
                                                                                          )
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 3,
                                                                                ),
                                                                                Wrap(
                                                                                  children: [
                                                                                    Text(AppStrings.dr_txt + " " + snapshot.data[index].providerName ?? "",
                                                                                      style: TextStyle(
                                                                                        height: 1.5,
                                                                                        fontSize: 14.0,
                                                                                        color: Colors.grey.shade500,
                                                                                      ),
                                                                                    ),
                                                                                    Text(', ',
                                                                                      style: TextStyle(
                                                                                        height: 1.5,
                                                                                        fontSize: 14.0,
                                                                                        color: Colors.grey.shade500,
                                                                                      ),
                                                                                    ),
                                                                                    Text(snapshot.data[index].caseType ?? "",
                                                                                      style: TextStyle(
                                                                                        height: 1.5,
                                                                                        fontSize: 14.0,
                                                                                        color: Colors.grey.shade500,
                                                                                      ),
                                                                                    ),
                                                                                    Text(', ',
                                                                                      style: TextStyle(
                                                                                        height: 1.5,
                                                                                        fontSize: 14.0,
                                                                                        color: Colors.grey.shade500,
                                                                                      ),
                                                                                    ),
                                                                                    Text(snapshot.data[index].appointmentType ?? "",
                                                                                      style: TextStyle(
                                                                                        height: 1.5,
                                                                                        fontSize: 14.0,
                                                                                        color: Colors.grey.shade500,
                                                                                      ),
                                                                                    ),
                                                                                    Text(', ',
                                                                                      style: TextStyle(
                                                                                        height: 1.5,
                                                                                        fontSize: 14.0,
                                                                                        color: Colors.grey.shade500,
                                                                                      ),
                                                                                    ),
                                                                                    Text(snapshot.data[index].appointmentStatus ?? "",
                                                                                      style: TextStyle(
                                                                                        height: 1.5,
                                                                                        fontSize: 14.0,
                                                                                        color: Colors.grey.shade500,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 3,
                                                                                ),
                                                                                snapshot.data[index].dictationStatusId == 17
                                                                                    ? Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.circle,
                                                                                            color: CustomizedColors.yellowDotColor,
                                                                                            size: 8,
                                                                                          ),
                                                                                          SizedBox(width: 5),
                                                                                          Text(
                                                                                            snapshot.data[index].dictationStatus ?? "",
                                                                                            style: TextStyle(
                                                                                              height: 1.5,
                                                                                              fontSize: 14.0,
                                                                                              color: Colors.grey.shade500,
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(width: 5),
                                                                                          SizedBox(
                                                                                            height: 30,
                                                                                            width: 40,
                                                                                            child: AudioMicButtons(
                                                                                              patientFName: snapshot.data[index].patient.firstName,
                                                                                              patientLName: snapshot.data[index].patient.lastName,
                                                                                              caseId: snapshot.data[index].lynxId,
                                                                                              patientDob: snapshot.data[index].patient.dob,
                                                                                              practiceId: snapshot.data[index].practiceId,
                                                                                              statusId: snapshot.data[index].dictationStatusId,
                                                                                              episodeId: snapshot.data[index].episodeId,
                                                                                              episodeAppointmentRequestId: snapshot.data[index].episodeAppointmentRequestId,
                                                                                              appointmentType: snapshot.data[index].appointmentType,
                                                                                              appointmentTypeId: snapshot.data[index].appointmentTypeId,
                                                                                              nbrMemberId: snapshot.data[index].nbrMemberId,
                                                                                              surgeryAssociatedRoles: snapshot.data[index].surgeryAssociatedRoles,
                                                                                              providerId: snapshot.data[index].providerId,
                                                                                              iconColor: CustomizedColors.primaryColor,
                                                                                              bgColor: CustomizedColors.micIconColor,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    : snapshot.data[index].dictationStatusId == 107
                                                                                        ? Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            children: [
                                                                                              Icon(
                                                                                                Icons.circle,
                                                                                                color: CustomizedColors.greenDotColor,
                                                                                                size: 8,
                                                                                              ),
                                                                                              SizedBox(width: 5),
                                                                                              Text(
                                                                                                snapshot.data[index].dictationStatus ?? "",
                                                                                                style: TextStyle(
                                                                                                  height: 1.5,
                                                                                                  fontSize: 14.0,
                                                                                                  color: Colors.grey.shade500,
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: 30,
                                                                                                width: 40,
                                                                                                child: AudioMicButtons(
                                                                                                  patientFName: snapshot.data[index].patient.firstName,
                                                                                                  patientLName: snapshot.data[index].patient.lastName,
                                                                                                  caseId: snapshot.data[index].lynxId,
                                                                                                  patientDob: snapshot.data[index].patient.dob,
                                                                                                  practiceId: snapshot.data[index].practiceId,
                                                                                                  statusId: snapshot.data[index].dictationStatusId,
                                                                                                  episodeId: snapshot.data[index].episodeId,
                                                                                                  episodeAppointmentRequestId: snapshot.data[index].episodeAppointmentRequestId,
                                                                                                  appointmentType: snapshot.data[index].appointmentType,
                                                                                                  appointmentTypeId: snapshot.data[index].appointmentTypeId,
                                                                                                  nbrMemberId: snapshot.data[index].nbrMemberId,
                                                                                                  surgeryAssociatedRoles: snapshot.data[index].surgeryAssociatedRoles,
                                                                                                  providerId: snapshot.data[index].providerId,
                                                                                                  iconColor: CustomizedColors.primaryColor,
                                                                                                  bgColor: CustomizedColors.micIconColor,

                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          )
                                                                                        : Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            children: [
                                                                                              Container(
                                                                                                alignment: Alignment.centerLeft,
                                                                                                // padding: EdgeInsets.only(right:0),
                                                                                                child: Icon(
                                                                                                  Icons.circle,
                                                                                                  color: snapshot.data[index].dictationStatus == "Pending"
                                                                                                      ? CustomizedColors.activeRedColor
                                                                                                      : snapshot.data[index].dictationStatus == "Report Available"
                                                                                                          ? CustomizedColors.greenDotColor
                                                                                                          : CustomizedColors.customeColor,
                                                                                                  size: 8,
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(width: 5),
                                                                                              Text(
                                                                                                snapshot.data[index].dictationStatus ?? "",
                                                                                                style: TextStyle(
                                                                                                  height: 1.5,
                                                                                                  fontSize: 14.0,
                                                                                                  color: Colors.grey.shade500,
                                                                                                ),
                                                                                                textAlign: TextAlign.center,
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: 30,
                                                                                                width: 40,
                                                                                                child: AudioMicButtons(
                                                                                                  patientFName: snapshot.data[index].patient.firstName,
                                                                                                  patientLName: snapshot.data[index].patient.lastName,
                                                                                                  caseId: snapshot.data[index].lynxId,
                                                                                                  patientDob: snapshot.data[index].patient.dob,
                                                                                                  practiceId: snapshot.data[index].practiceId,
                                                                                                  statusId: snapshot.data[index].dictationStatusId,
                                                                                                  episodeId: snapshot.data[index].episodeId,
                                                                                                  episodeAppointmentRequestId: snapshot.data[index].episodeAppointmentRequestId,
                                                                                                  appointmentType: snapshot.data[index].appointmentType,
                                                                                                  appointmentTypeId: snapshot.data[index].appointmentTypeId,
                                                                                                  nbrMemberId: snapshot.data[index].nbrMemberId,
                                                                                                  surgeryAssociatedRoles: snapshot.data[index].surgeryAssociatedRoles,
                                                                                                  providerId: snapshot.data[index].providerId,
                                                                                                  iconColor: CustomizedColors.primaryColor,
                                                                                                  bgColor: CustomizedColors.micIconColor,
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          )
                                                                              ]),
                                                                            ),
                                                                          ],
                                                                        )),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }));
                                              }
                                            })
                                        : Container(),
                                    headerBuilder: (BuildContext context,
                                        bool isExpanded) {
                                      // print("TestIng");
                                      // print(patients[index].isExpanded);
                                      return Container(
                                        padding: EdgeInsets.all(10),
                                        child: patients[index]
                                                    .practiceLocation !=
                                                null
                                            ? Text(
                                                patients[index]
                                                        .practiceLocation +
                                                    " " +
                                                    '(${patients[index].appointmentCount})',
                                                style: TextStyle(
                                                    color: CustomizedColors
                                                        .clrCyanBlueColor,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Text(
                                                patients[index]
                                                        .practiceLocation ??
                                                    "" +
                                                        " " +
                                                        '(${patients[index].appointmentCount})',
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                      );
                                    },
                                    isExpanded: expandedPanel
                                        ? true
                                        : patients[index].isExpanded)
                              ],
                              expansionCallback: (int item, bool status) {
                                setState(() {
                                  practiceLocationId = null;
                                  patients[index].isExpanded =
                                      !patients[index].isExpanded;
                                  //  isExpanded = true;
                                  expandedPanel = false;
                                  practiceLocationId =
                                      patients[index].practiceLocationId;
                                });
                              },
                            );
                          },
                        )
                      : Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(padding: EdgeInsets.only(top: 100)),
                              Center(
                                child: Text(
                                  AppStrings.noresultsfoundrelatedsearch,
                                  style: TextStyle(
                                      fontFamily: AppFonts.regular,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: CustomizedColors.buttonTitleColor),
                                ),
                              )
                            ],
                          ),
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //filterDialog related code//
  _filterDialog(
      BuildContext buildContext, providerId, dictationId, locationId) {
    double width = MediaQuery.of(context).size.width;
    FocusScope.of(context).requestFocus(new FocusNode());
    // _searchFilterController.clear();
    return  showModalBottomSheet(
      isDismissible: false,
        isScrollControlled: true,
        backgroundColor: CustomizedColors.clrCyanBlueColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        )),
        context: context,
        builder: (BuildContext bc) {
          return WillPopScope(
             onWillPop :(){
            return new Future(() => false);
          },
            child: StatefulBuilder(
                builder: (BuildContext bc, StateSetter setModalState) {
              return Container(
                height: 400,
                child: ListView(
                  children: [
                    new Wrap(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                                padding: width > 600
                                    ? EdgeInsets.only(top: 25, left: 350)
                                    : EdgeInsets.only(top: 25, left: 100),
                                child: Text(AppStrings.selectfilter,
                                    style: TextStyle(
                                        fontFamily: AppFonts.regular,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: CustomizedColors.textColor))),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Divider(color: CustomizedColors.divider),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 150,
                              child: BlocProvider(
                                create: (context) => ProviderListCubit(),
                                child: ProviderDropDowns(
                                    selectedProviderId: providerId,
                                    onTapOfProviders: (newValue) {
                                      setState(() {
                                        if (newValue != null) {
                                          selectedProvider = newValue.displayname;
                                          _currentSelectedProviderId =
                                              (newValue as ProviderList)
                                                  .providerId;
                                        }
                                      });
                                      setModalState(() {
                                        okButtonEnabled = true;
                                        clearButtonEnabled = true;
                                      });
                                    }),
                              ),
                            ),
                            Container(
                              width: 150,
                              child: Dictation(
                                  dictationid: dictationId,
                                  onTapOfDictation: (newValue) {
                                    setState(() {
                                      if (newValue != null) {
                                        selectedDictation =
                                            newValue.dictationstatus;
                                        _currentSelectedDictationId =
                                            (newValue as DictationStatus)
                                                .dictationstatusid;
                                      }
                                    });
                                    setModalState(() {
                                      okButtonEnabled = true;
                                      clearButtonEnabled = true;
                                    });
                                  }),
                            )
                          ],
                        ),
                        // SizedBox(width: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 150,
                              child: BlocProvider(
                                create: (context) => LocationListCubit(),
                                child: LocationDropDown(
                                  selectedLocationId: locationId,
                                  onTapOfLocation: (newValue) {
                                    setState(() {
                                      okButtonEnabled = true;
                                      clearButtonEnabled = true;
                                      if (newValue != null) {
                                        selectedLocation = newValue.locationName;
                                        _currentSelectedLocationId =
                                            (newValue as LocationList).locationId;
                                      }
                                    });
                                    setModalState(() {
                                      okButtonEnabled = true;
                                      clearButtonEnabled = true;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Container(
                              height: 55,
                              width: 150,
                              //margin: EdgeInsets.only(top: 5),
                              child: TextButton(
                                autofocus: true,
                                onPressed: () async {
                                  final List<String> result =
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DateFilter()));
                                  if (result != null) {
                                    setModalState(() {
                                      startDate = result.first;
                                      endDate = result.last;
                                      okButtonEnabled = true;
                                      clearButtonEnabled = true;
                                      // selectedDateRange = true;
                                    });
                                  }
                                },
                                child: Text(
                                  AppStrings.datafiltertitle,
                                  style: TextStyle(
                                      fontFamily: AppFonts.regular,
                                      fontSize: 15.0,
                                      color: CustomizedColors.textColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 80),
                        startDate != null && endDate != null
                            ? Center(
                                child: Text(
                               AppStrings.daterangetxt1 +
                                    ":" +
                                    " " +
                                    "${AppConstants.parseDatePattern(this.startDate, AppConstants.MMMddyyyy)}" +
                                    "-" +
                                    "${AppConstants.parseDatePattern(this.endDate, AppConstants.MMMddyyyy)}",
                                style: TextStyle(
                                    color: CustomizedColors.signInButtonTextColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600),
                              ))
                            : Container(width: 5, height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 60,
                              width: width > 600 ? 600 : 300,
                              child: PatientSerach(
                                trailing: patientClearIcon
                                    ? IconButton(
                                        icon: Image.asset(AppImages.clearIcon,
                                            width: 20, height: 20),
                                        onPressed: () {

                                          _searchFilterController.clear();
                                          setModalState(() {
                                            this.patientClearIcon = false;
                                            okButtonEnabled = false;
                                            clearButtonEnabled = false;
                                          });
                                        })
                                    : Icon(Icons.person),
                                width: 250,
                                height: 70,
                                decoration: InputDecoration(
                                    hintText: AppStrings.patientName,
                                    border: InputBorder.none,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always),
                                controller: _searchFilterController,
                                onChanged: (string) {
                                  if (_searchFilterController.text != null) {
                                    setModalState(() {
                                      this.patientClearIcon = true;
                                      okButtonEnabled = true;
                                      clearButtonEnabled = true;
                                    });
                                  } else {
                                    setModalState(() {
                                      this.patientClearIcon = false;
                                      okButtonEnabled = false;
                                      clearButtonEnabled = false;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 90),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 40,
                              width: width * 0.25,
                              margin: width > 600
                                  ? EdgeInsets.only(top: 5, left: 50)
                                  : EdgeInsets.only(top: 5, left: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: CustomizedColors.textColor,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Provider.of<FilterButtonProvider>(context,listen: false).setFilterValue(true);
                                  Navigator.of(context).pop();
                                  setModalState(() {
                                    selectedDateRange = false;
                                    this.patientClearIcon = false;
                                    startDate = null;
                                    endDate = null;
                                    _currentSelectedProviderId = null;
                                    _currentSelectedDictationId = null;
                                    _currentSelectedLocationId = null;
                                    this._searchFilterController.clear();
                                  });
                                },
                                child: Text(AppStrings.cancel,
                                    style: TextStyle(
                                        fontFamily: AppFonts.regular,
                                        color: CustomizedColors.buttonTitleColor,
                                        fontSize: 15.0)),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: width * 0.25,
                              margin: EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                      color: CustomizedColors.homeSubtitleColor)),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: clearButtonEnabled
                                      ? Colors.white
                                      : CustomizedColors.homeSubtitleColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5.0))),
                                ),
                                onPressed: clearButtonEnabled
                                    ? () {
                                //  Provider.of<FilterButtonProvider>(context,listen: false).setFilterValue(false);
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                        _textFieldController.clear();
                                        _searchFilterController.clear();
                                        this.patientClearIcon = false;
                                        setState(() {
                                          datePicker = true;
                                          dateRange = false;
                                        });
                                        setModalState(() {
                                          okButtonEnabled = false;
                                          clearButtonEnabled = false;
                                        });
                                        Future.delayed(
                                            Duration(milliseconds: 500), () {
                                          _controller?.animateToDate(
                                              DateTime.now()
                                                  .subtract(Duration(days: 3)));
                                        });
                                        Navigator.pop(context);
                                        isFilterApplied = false;
                                        page = 1;
                                        startDate = null;
                                        endDate = null;
                                        _currentSelectedProviderId = null;
                                        _currentSelectedDictationId = null;
                                        _currentSelectedLocationId = null;
                                        _filterDialog(
                                            context,
                                            _currentSelectedProviderId,
                                            _currentSelectedDictationId,
                                            _currentSelectedLocationId);
                                        selectedDateRange = false;
                                      }
                                    : null,
                                child: Text(
                                  AppStrings.clearfiltertxt,
                                  style: TextStyle(
                                      fontFamily: AppFonts.regular,
                                      fontSize: 15.0,
                                      color: CustomizedColors.buttonTitleColor),
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: width * 0.25,
                              margin: width > 600
                                  ? EdgeInsets.only(top: 5, right: 50)
                                  : EdgeInsets.only(top: 5, right: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: okButtonEnabled
                                      ? Colors.white
                                      : CustomizedColors.homeSubtitleColor),
                              child: TextButton(
                                onPressed: okButtonEnabled
                                    ? () {
                                  Provider.of<FilterButtonProvider>(context,listen: false).setFilterValue(true);
                                        setModalState(() {
                                          okButtonEnabled = false;
                                          clearButtonEnabled = false;
                                          settingSelectedDateToNull = true;
                                        });
                                        Navigator.of(context).pop();
                                        isFilterApplied = true;
                                        this.patientClearIcon = false;
                                        selectedDate = null;
                                        todayDate = null;
                                        setState(() {
                                          try {
                                            if (startDate != null &&
                                                endDate != null) {
                                              dateRange = true;
                                              datePicker = false;
                                            } else if (_searchFilterController.text !=
                                                    "" ||
                                                _currentSelectedLocationId !=
                                                    null ||
                                                _currentSelectedDictationId !=
                                                    null ||
                                                _currentSelectedProviderId !=
                                                    null) {
                                              dateRange = true;
                                              datePicker = false;
                                            } else {
                                              dateRange = false;
                                              datePicker = true;
                                            }
                                          } catch (e) {
                                            throw Exception(e.toString());
                                          }
                                        });
                                        page = 1;
                                        BlocProvider.of<PatientBloc>(
                                                context)
                                            .add(GetSchedulePatientsList(
                                                keyword1: null,
                                                providerId:
                                                    _currentSelectedProviderId != null
                                                        ? _currentSelectedProviderId
                                                        : null,
                                                locationId:
                                                    _currentSelectedLocationId !=
                                                            null
                                                        ? _currentSelectedLocationId
                                                        : null,
                                                dictationId:
                                                    _currentSelectedDictationId != null
                                                        ? int
                                                            .tryParse(
                                                                _currentSelectedDictationId)
                                                        : null,
                                                startDate: startDate != ""
                                                    ? startDate
                                                    : null,
                                                endDate: endDate != ""
                                                    ? endDate
                                                    : null,
                                                searchString: this
                                                            ._searchFilterController
                                                            .text !=
                                                        null
                                                    ? this
                                                        ._searchFilterController
                                                        .text
                                                    : null,
                                                pageKey: page,
                                                practiceLocationId: null));
                                        isShowToast = false;
                                      }
                                    : null,
                                child: Text(AppStrings.ok,
                                    style: TextStyle(
                                        fontFamily: AppFonts.regular,
                                        color: CustomizedColors.buttonTitleColor,
                                        fontSize: 15.0)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Future<void> _pullToRefresh(dateSelected, providerId, locationId, dictationId,
      pageNo, dateStart, dateEnd) async {
    await Future.delayed(Duration(seconds: 3));
    // setState(() async {});
    page = 1;
    // getSelectedDateAppointments();
    BlocProvider.of<PatientBloc>(context).add(GetSchedulePatientsList(
        keyword1: dateSelected,
        providerId: providerId,
        locationId: locationId,
        dictationId: dictationId,
        pageKey: pageNo,
        startDate: dateStart != "" ? dateStart : null,
        endDate: dateEnd != "" ? dateEnd : null,
        practiceLocationId: null));
  }
}
