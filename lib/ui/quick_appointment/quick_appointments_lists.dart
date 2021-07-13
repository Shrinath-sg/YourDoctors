import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/matching_patient.dart';
import 'package:YOURDRS_FlutterAPP/network/services/quick_appointments/quick_appointment_service.dart';
import 'package:YOURDRS_FlutterAPP/ui/quick_appointment/quick_appointment_screen.dart';
import 'package:YOURDRS_FlutterAPP/utils/route_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuickAppointmentList extends StatefulWidget {
  static const String routeName = '/QuickAppointmentList';
  @override
  _QuickAppointmentListState createState() => _QuickAppointmentListState();
}

class _QuickAppointmentListState extends State<QuickAppointmentList> {
  bool _hasMore;
  int _pageNumber;
  bool _error;
  bool _loading;
  List<PatientList> list;
  int thresholdValue = 0;
  final int _defaultDataPerPageCount = 10;

  /// initState
  @override
  void initState() {
    _hasMore = true;
    _pageNumber = 1;
    _error = false;
    _loading = true;
    list = [];
    super.initState();
  }

  QuickAppointmentService apiService = QuickAppointmentService();

  @override
  Future<void> didChangeDependencies() async {
    final Map args = ModalRoute.of(context).settings.arguments;
    List obj = args['object'];
    super.didChangeDependencies();
    MatchingPatients allMyList = await apiService.getMatchingPatients(
        obj[0],obj[1],obj[2],obj[3],
        _pageNumber);
    if (!mounted) return;
    setState(() {
      _hasMore = allMyList.patientList?.length == _defaultDataPerPageCount;
      _loading = false;
      _pageNumber = _pageNumber + 1;
      list.addAll(allMyList?.patientList);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppStrings.quickAppointment,
          style: TextStyle(
            fontFamily: AppFonts.regular,
          ),
        ),
        backgroundColor: CustomizedColors.appBarColor,
      ),
      backgroundColor: CustomizedColors.primaryBgColor,
      body: Container(
        // margin: EdgeInsets.only(top: 15),
        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        child: _getListOfData(),
      ),
    );
  }

  // ignore: missing_return
  Widget _getListOfData() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (list?.isEmpty ?? false) {
      if (_loading) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: CupertinoActivityIndicator(
              radius: 19,
            ),
          ),
        );
      } else if (_error) {
        return Center(
          child: InkWell(
            onTap: () {
              setState(
                    () {
                  _loading = true;
                  _error = false;
                  didChangeDependencies();
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AppStrings.errorLoadingPatient,
                style: TextStyle(
                  fontFamily: AppFonts.regular,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
      }
    } else {
      return ListView(
        children: [
          Card(
            child: Container(
              width: width * 1,
              height: height * 0.87,
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                  itemCount: list.length + (_hasMore ? 1 : 0),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == list.length - thresholdValue) {
                      didChangeDependencies();
                    }
                    if (index == list.length) {
                      if (_error) {
                        return Center(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _loading = true;
                                  _error = false;
                                  didChangeDependencies();
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  AppStrings.errorLoadingData,
                                  style: TextStyle(
                                    fontFamily: AppFonts.regular,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ));
                      } else {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: CupertinoActivityIndicator(
                              radius: 12,
                              // valueColor:
                              //     AlwaysStoppedAnimation(CustomizedColors.primaryColor),
                            ),
                          ),
                        );
                      }
                    }
                    return InkWell(
                      onTap: () {
                        PatientList selectedPatient = list[index];
                        RouteGenerator.navigatorKey.currentState.pushNamed(
                            QuickAppointmentScreen.routeName,
                            arguments: {
                              'selectedPatient': selectedPatient,
                              'showCase': true
                            });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                              "${list[index].firstName}, ${list[index].lastName}(${list[index].sex}${list[index].sex != "" ? " - " : ""}${list[index].dob})",
                              style: TextStyle(
                                  fontFamily: AppFonts.regular,
                                  color: CustomizedColors.submitbuttonColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(AppStrings.caseNumber + ": ${list[index].caseNumber}",
                              style: TextStyle(
                                  fontFamily: AppFonts.regular, fontSize: 14)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(AppStrings.caseType + ": ${list[index].caseType}",
                              style: TextStyle(
                                  fontFamily: AppFonts.regular, fontSize: 14)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(AppStrings.accountNumber + ": ${list[index].accountNumber}",
                              style: TextStyle(
                                  fontFamily: AppFonts.regular, fontSize: 14)),
                          Divider(thickness: 2),
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ],
      );
    }
  }
}
