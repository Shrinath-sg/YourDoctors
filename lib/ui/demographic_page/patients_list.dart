import 'dart:async';
import 'dart:io';

import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_icons.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/network/models/external_dictations/get_all_manual_dictation_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/home/appointment.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:YOURDRS_FlutterAPP/network/services/dictation/dictation_services.dart';
import 'package:YOURDRS_FlutterAPP/network/services/schedules/appointment_service.dart';
import 'package:YOURDRS_FlutterAPP/ui/home/drawer.dart';
import 'package:YOURDRS_FlutterAPP/utils/cached_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'patient_profile.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DemographicPage extends StatefulWidget {
  // final Function openSettings;
  // const DemographicPage({Key key, this.openSettings}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return DemographicPageState();
  }
}

class DemographicPageState extends State<DemographicPage> {
  var displayName = "";
  var profilePic = "";
  final _debouncer = Debouncer(milliseconds: 500);
  List<Patients> users = List();
  List<Patients> filteredUsers = List();
  bool patientSearchIcon = true;
  TextEditingController textEditingController = TextEditingController();
  bool contains = false;

  @override
  void initState() {
    _loadData();
    super.initState();
    Services.getUsers().then((usersFromServer) {
      setState(() {
        users = usersFromServer;
        filteredUsers = users;
      });
    });
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = (prefs.getString(Keys.displayName) ?? '');
      profilePic = (prefs.getString(Keys.displayPic) ?? '');
    });
    contains = profilePic.contains('https');
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DemographicPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomizedColors.primaryBgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomizedColors.clrCyanBlueColor,
        //Colors.white, //CustomizedColors.primaryBgColor,

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
      ),
      drawer: DrawerScreen(),
      body: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: Container(
              padding: const EdgeInsets.all(4),
              color: CustomizedColors.primaryBgColor,
              child: Column(children: [
                _searchbar(),
                filteredUsers.length == null || filteredUsers.isEmpty
                    ? _loader(AppStrings.loading)
                    : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: filteredUsers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _cardWidget(index);
                  },
                ),
                //)
              ])),
        ),
      ),
    );
  }

  _searchbar() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 10, top: 15),
          enabledBorder: InputBorder.none,
          hintText: "Search....",
          suffixIcon: patientSearchIcon
              ? Icon(Icons.search)
              : IconButton(
            // padding: EdgeInsets.all(0),
              alignment: Alignment.centerRight,
              icon: Image.asset(AppImages.clearIcon, width: 20, height: 20),
              onPressed: () {
                // users = usersFromServer;
                filteredUsers = users;
                setState(() {
                  this.patientSearchIcon = true;
                });
                textEditingController.clear();
              }),
        ),
        onChanged: (string) {
          this.patientSearchIcon = false;
          _debouncer.run(() {
            setState(() {
              filteredUsers = users
                  .where((u) =>
              (u.name.toLowerCase().contains(string.toLowerCase()) ||
                  u.email.toLowerCase().contains(string.toLowerCase())))
                  .toList();
            });
          });
        },
      ), //),
    );
  }

  _cardWidget(index) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final Patients patients = filteredUsers[index];

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                DemographicPatientProfile(name: patients.name)));
      },
      child: Card(
        elevation: 1,
        child: Container(
          // color: Colors.amber,
          width: width,
          height: height * 0.1,
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  //  color: Colors.yellowAccent,
                  width: width * 0.45,
                  height: height * 0.1,
                  child: FittedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          patients.name,
                          // "33, Test Othon 3",
                          style: Theme.of(context).textTheme.title,
                        ),
                        SizedBox(height: 10),
                        Text(
                          // audioDictations.patientDOB,
                          "04-21-1976",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontFamily: AppFonts.regular,
                            fontSize: 14.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // SizedBox(width: width * 0.3),
                Container(
                  //  color: Colors.blueAccent,
                  width: width * 0.45,
                  height: height * 0.1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Y180311898",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontFamily: AppFonts.regular,
                          fontSize: 14.5,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "1 Case",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontFamily: AppFonts.regular,
                          fontSize: 14.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loader(String msg) {
    return Center(
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
          width: 25,
        ),
        CupertinoActivityIndicator(
          radius: 20,
        ),
        SizedBox(
          width: 35,
        ),
        Text(
          msg,
          style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.regular),
        )
      ]),
    );
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
