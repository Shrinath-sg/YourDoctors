import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_icons.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/ui/demographic_page/patient_dashboard.dart';
import 'package:YOURDRS_FlutterAPP/utils/cached_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DemographicPatientProfile extends StatefulWidget {
  var name;

  DemographicPatientProfile({this.name});

  @override
  State<StatefulWidget> createState() {
    return DemographicPatientProfileState();
  }
}

class DemographicPatientProfileState extends State<DemographicPatientProfile> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: CustomizedColors.primaryBgColor),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: width * 0.05),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50)),
                            width: 80,
                            height: 80,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: CachedImage(
                                null,
                                isRound: true,
                                radius: 35.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: width * 0.05),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(height: 0.1),
                        Text(
                          widget.name,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: AppFonts.regular,
                              fontWeight: FontWeight.bold,
                              color: CustomizedColors.clrCyanBlueColor),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Male 04-17-1958(63)",
                          style: TextStyle(
                              fontSize: 14.5, fontFamily: AppFonts.regular),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  width: width,
                  height: height * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: Main,
                    children: [
                      SizedBox(height: 30),
                      Text(
                        "Contact",
                        style: TextStyle(
                            fontFamily: AppFonts.regular,
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 30),
                      Container(
                        width: width * 0.9,
                        height: height * 0.2,
                        // color: Colors.black87,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: CustomizedColors.clrCyanBlueColor),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Container(
                              width: width * 0.8,
                              height: height * 0.05,
                              // // color: Colors.red,
                              child: Row(
                                children: [
                                  Container(
                                    // color: Colors.amber,
                                    width: width * 0.3,
                                    height: height * 0.05,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Phone",
                                          style: TextStyle(
                                            fontFamily: AppFonts.regular,
                                            fontSize: 15,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // color: Colors.blue,
                                    width: width * 0.5,
                                    height: height * 0.05,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "(201)723-2222",
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
                            Container(
                              width: width * 0.8,
                              height: height * 0.05,
                              // color: Colors.red,
                              child: Row(
                                children: [
                                  Container(
                                    // color: Colors.amber,
                                    width: width * 0.3,
                                    height: height * 0.05,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Email",
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontFamily: AppFonts.regular,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // color: Colors.blue,
                                    width: width * 0.5,
                                    height: height * 0.05,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "okm@me,com",
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
                            Container(
                              width: width * 0.8,
                              height: height * 0.05,
                              // color: Colors.red,
                              child: Row(
                                children: [
                                  Container(
                                    // color: Colors.amber,
                                    width: width * 0.3,
                                    height: height * 0.05,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Address",
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontFamily: AppFonts.regular,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // color: Colors.blue,
                                    width: width * 0.5,
                                    height: height * 0.05,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "457 Hillside Ave PO Box 380 \n Alpine NJ 07620-0380",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
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
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Cases",
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontFamily: AppFonts.regular,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Container(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PatientDashboard()));
                              },
                              child: Container(
                                color: CustomizedColors.waveBGColor,
                                width: width * 0.9,
                                height: height * 0.06,
                                child: Row(
                                  children: [
                                    Container(
                                      // color: Colors.black,
                                      width: width / 5,
                                      height: height,
                                      child: Center(
                                          child: Text(
                                        "DOA",
                                        style: TextStyle(
                                          fontFamily: AppFonts.regular,
                                          fontSize: 14.5,
                                        ),
                                      )),
                                    ),
                                    Container(
                                      // color: Colors.orange,
                                      width: width / 5,
                                      height: height,
                                      child: Center(
                                          child: Text(
                                        "06-18-2018",
                                        style: TextStyle(
                                          fontFamily: AppFonts.regular,
                                          fontSize: 14.5,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: true,
                                      )),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 20),
                                      // color: Colors.orange,
                                      width: width / 5,
                                      height: height,
                                      child: Center(
                                          child: Text(
                                        "Case",
                                        style: TextStyle(
                                          fontFamily: AppFonts.regular,
                                          fontSize: 14.5,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: true,
                                      )),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 20),
                                      // color: Colors.orange,
                                      width: width / 5,
                                      height: height,
                                      child: Center(
                                          child: Text(
                                        "Y180618776_1",
                                        style: TextStyle(
                                          fontFamily: AppFonts.regular,
                                          fontSize: 14.5,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: true,
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Container(
                              color: CustomizedColors.waveBGColor,
                              width: width * 0.9,
                              height: height * 0.06,
                              child: Row(
                                children: [
                                  Container(
                                    // color: Colors.black,
                                    width: width / 5,
                                    height: height,
                                    child: Center(
                                        child: Text(
                                      "DOA",
                                      style: TextStyle(
                                        fontFamily: AppFonts.regular,
                                        fontSize: 14.5,
                                      ),
                                    )),
                                  ),
                                  Container(
                                    // color: Colors.orange,
                                    width: width / 5,
                                    height: height,
                                    child: Center(
                                        child: Text(
                                      "06-18-2018",
                                      style: TextStyle(
                                        fontFamily: AppFonts.regular,
                                        fontSize: 14.5,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: true,
                                    )),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 20),
                                    // color: Colors.orange,
                                    width: width / 5,
                                    height: height,
                                    child: Center(
                                        child: Text(
                                      "Case",
                                      style: TextStyle(
                                        fontFamily: AppFonts.regular,
                                        fontSize: 14.5,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: true,
                                    )),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 20),
                                    // color: Colors.orange,
                                    width: width / 5,
                                    height: height,
                                    child: Center(
                                        child: Text(
                                      "Y180618776_1",
                                      style: TextStyle(
                                        fontFamily: AppFonts.regular,
                                        fontSize: 14.5,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: true,
                                    )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
