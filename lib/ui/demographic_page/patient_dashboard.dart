import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/ui/demographic_page/documents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'appointment_Screen.dart';

class PatientDashboard extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return PatientDashboardState();
  }
}

class PatientDashboardState extends State<PatientDashboard> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomizedColors.clrCyanBlueColor,
        title: Text("Dashboard",style: TextStyle(fontFamily: AppFonts.regular),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Case Details",
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: width * 0.9,
                    height: height * 0.25,
                    // color: Colors.black87,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: CustomizedColors.blueAppBarColor),
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
                                // // color: Colors.amber,
                                width: width * 0.3,
                                height: height * 0.05,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "DOA",
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
                                // color: CustomizedColors.waveBGColor,
                                width: width * 0.5,
                                height: height * 0.05,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "18-06-2018",
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
                                // // color: Colors.amber,
                                width: width * 0.3,
                                height: height * 0.05,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "State",
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
                                // color: CustomizedColors.waveBGColor,
                                width: width * 0.5,
                                height: height * 0.05,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "N/A",
                                      style: TextStyle(
                                        fontFamily: AppFonts.regular,
                                        fontSize: 14.5,
                                        color: Colors.grey.shade600,
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
                                // // color: Colors.amber,
                                width: width * 0.3,
                                height: height * 0.05,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Attorney",
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
                                // color: CustomizedColors.waveBGColor,
                                width: width * 0.5,
                                height: height * 0.05,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Eleftarakis",
                                      style: TextStyle(
                                        fontFamily: AppFonts.regular,
                                        color: Colors.grey.shade600,
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
                          // // color: Colors.red,
                          child: Row(
                            children: [
                              Container(
                                // // color: Colors.amber,
                                width: width * 0.3,
                                height: height * 0.05,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Contact",
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
                                // color: CustomizedColors.waveBGColor,
                                width: width * 0.5,
                                height: height * 0.05,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "(212)532-1116",
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
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 0, left: 20, right: 20, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Insurance",
                    style:Theme.of(context).textTheme.title,
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: width * 0.9,
                    height: height * 0.2,
                    // color: Colors.black87,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: CustomizedColors.blueAppBarColor),
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
                                // // color: Colors.amber,
                                width: width * 0.3,
                                height: height * 0.05,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Claim No",
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
                                // color: CustomizedColors.waveBGColor,
                                width: width * 0.5,
                                height: height * 0.05,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "0506141886",
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
                                // // color: Colors.amber,
                                width: width * 0.3,
                                height: height * 0.05,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Carrier",
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
                                // color: CustomizedColors.waveBGColor,
                                width: width * 0.5,
                                height: height * 0.05,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Allistate/Medlogix",
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
                                // // color: Colors.amber,
                                width: width * 0.3,
                                height: height * 0.05,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Plan",
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
                                // color: CustomizedColors.waveBGColor,
                                width: width * 0.5,
                                height: height * 0.05,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "N/A",
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
                ],
              ),
            ),
            Container(
              // color: Colors.blue,
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              width: width,
              height: height * 0.15,
              // color: Colors.amber,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AppointmentScreen()));
                    },
                    child: Container(
                      // padding: const EdgeInsets.all(5),
                      width: width*0.43,
                      height: height * 0.15,
                      color: CustomizedColors.waveBGColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "69/89",
                            style: TextStyle(
                              fontFamily: AppFonts.regular,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Appointments",
                            style: TextStyle(
                              fontSize: 14.5,
                              fontFamily: AppFonts.regular,
                              fontWeight: FontWeight.bold,
                              color: CustomizedColors.clrCyanBlueColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: width*0.43,
                    height: height * 0.15,
                    color: CustomizedColors.waveBGColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("37",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFonts.regular,
                              fontSize: 30,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Assessments",
                          style: TextStyle(
                            fontSize: 14.5,
                            fontFamily: AppFonts.regular,
                            fontWeight: FontWeight.bold,
                            color: CustomizedColors.clrCyanBlueColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              width: width,
              height: height * 0.15,
              // color: Colors.amber,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Documents()));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      width: width*0.43,                      height: height * 0.15,
                      color: CustomizedColors.waveBGColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("489",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: AppFonts.regular,
                                fontSize: 30,
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Documents",
                            style: TextStyle(
                              fontSize: 14.5,
                              fontFamily: AppFonts.regular,
                              fontWeight: FontWeight.bold,
                              color: CustomizedColors.clrCyanBlueColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: width*0.43,                    height: height * 0.15,
                    color: CustomizedColors.waveBGColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("13",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFonts.regular,
                              fontSize: 30,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Referrals",
                          style: TextStyle(
                            fontSize: 14.5,
                            fontFamily: AppFonts.regular,
                            fontWeight: FontWeight.bold,
                            color: CustomizedColors.clrCyanBlueColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              width: width,
              height: height * 0.15,
              // color: Colors.amber,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: width*0.43,
                    height: height * 0.15,
                    color: CustomizedColors.waveBGColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("7",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFonts.regular,
                              fontSize: 30,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Care Team",
                          style: TextStyle(
                            fontSize: 14.5,
                            fontFamily: AppFonts.regular,
                            fontWeight: FontWeight.bold,
                            color: CustomizedColors.clrCyanBlueColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  // SizedBox(width: 10),
                  // Container(
                  //   padding: const EdgeInsets.all(5),
                  //   width: width / 2.3,
                  //   height: height*0.15,
                  //   color: CustomizedColors.waveBGColor,
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text("69/89",style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 30,
                  //       )),
                  //       SizedBox(height: 10,),
                  //       Text("Appointments",style: TextStyle(
                  //         fontSize: 14.5,
                  //         fontFamily: AppFonts.regular,
                  //         fontWeight: FontWeight.bold,
                  //         color: CustomizedColors.blueAppBarColor,
                  //       ),)],
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
