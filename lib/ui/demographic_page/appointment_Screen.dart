import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:flutter/material.dart';

import 'appointment_past.dart';
import 'appointment_upcoming.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppointmentScreenState();
  }
}

class AppointmentScreenState extends State<AppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomizedColors.clrCyanBlueColor,
        title: Text("Appointment",style: TextStyle(fontFamily: AppFonts.regular),),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 60,
              child: Container(
                child: TabBar(
                  tabs: [
                    Tab(
                        child: Text(
                      "Upcoming",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.regular,
                          color: CustomizedColors.clrCyanBlueColor),
                    )),
                    Tab(
                      child: Text(
                        "Past",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.regular,
                            color: CustomizedColors.clrCyanBlueColor),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(boxShadow: [
                  new BoxShadow(
                    color: Colors.white,
                  ),
                ]),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // AppointmnetUpcoming(),
                  UpComingAppointments(),
                  AppointmentPast(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
// import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'appointment_past.dart';
// import 'appointment_upcoming.dart';
//
// class AppointmentScreen extends StatefulWidget {
//   static const String routeName = '/AppointmentScreen';
//   @override
//   _AppointmentScreenState createState() => _AppointmentScreenState();
// }
//
// class _AppointmentScreenState extends State<AppointmentScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Appointment"),
//         ),
//         body: DefaultTabController(
//           length: 2,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Container(
//                 height: 65,
//                 child: Container(
//                   child: TabBar(
//                     tabs: [
//                       Tab(
//                           child: Text(
//                         "Upcoming",
//                         style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: AppFonts.regular,
//                             color: CustomizedColors.blueAppBarColor),
//                       )),
//                       Tab(
//                         child: Text(
//                           "Past",
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               fontFamily: AppFonts.regular,
//                               color: CustomizedColors.blueAppBarColor),
//                         ),
//                       ),
//                     ],
//                   ),
//                   decoration: BoxDecoration(boxShadow: [
//                     new BoxShadow(
//                       color: Colors.white,
//                     ),
//                   ]),
//                 ),
//               ),
//               Expanded(
//                 child: TabBarView(
//                   children: [
//                     //
//                     AppointmnetUpcoming(),
//                     AppointmentPast(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//     );
//   }
// }
