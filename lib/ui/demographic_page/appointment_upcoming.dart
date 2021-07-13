import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/network/models/home/location.dart';
import 'package:YOURDRS_FlutterAPP/network/services/schedules/appointment_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class UpComingAppointments extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UpComingAppointmentsState();
  }
}

class UpComingAppointmentsState extends State<UpComingAppointments> {
  List<LocationList> locationList = [];
  Services apiServices = Services();


  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    Locations location = await apiServices.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child:  Container(
        width: width,
        height: height,
        child: _getbody(),
        // ListView.builder(
        //   itemCount: locationList.length,
        //   itemBuilder: (context, index) {
        //     // final AudioDictations audioDictations = _audioDictates[index];
        //     print(locationList[index].locationName);
        //     return _getbody();
        //   },
        // ),
      ),
    );
  }

  Widget _getbody() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          // color: Colors.amber,
          height: height * 0.19,
          width: width,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10, left: 10),
                // color: Colors.blue,
                width: width,
                height: height * 0.11,
                child: Row(
                  children: [
                    Container(
                      // color: Colors.red,
                      width: width * 0.45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "APR 10 2021",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey.shade600,
                              fontFamily: AppFonts.regular,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("RPM",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.5,
                                fontFamily: AppFonts.regular,
                              )),
                          SizedBox(height: 8),
                          Text(
                            "Baynes Json.M.D",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5,
                              fontFamily: AppFonts.regular,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      width: width * 0.5,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "10:00",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5,
                              fontFamily: AppFonts.regular,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 20),
                width: width,
                height: height * 0.03,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FittedBox(child: Icon(Icons.location_on_rounded)),
                    Text(
                      "location",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                        fontFamily: AppFonts.regular,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Divider(
                thickness: 1.0,
                height: 10,
              )
            ],
          ),
        ),
        Container(
          // color: Colors.amber,
          height: height * 0.19,
          width: width,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10, left: 10),
                // color: Colors.blue,
                width: width,
                height: height * 0.11,
                child: Row(
                  children: [
                    Container(
                      // color: Colors.red,
                      width: width * 0.45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "APR 10 2021",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: AppFonts.regular,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("RPM",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.5,
                                fontFamily: AppFonts.regular,
                              )),
                          SizedBox(height: 8),
                          Text(
                            "Baynes Json.M.D",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5,
                              fontFamily: AppFonts.regular,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      width: width * 0.5,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "10:00",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5,
                              fontFamily: AppFonts.regular,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 20),
                width: width,
                height: height * 0.03,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FittedBox(child: Icon(Icons.location_on_rounded)),
                    Text(
                      "location",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                        fontFamily: AppFonts.regular,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Divider(
                thickness: 1.0,
                height: 10,
              )
            ],
          ),
        ),
        Container(
          // color: Colors.amber,
          height: height * 0.19,
          width: width,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10, left: 10),
                // color: Colors.blue,
                width: width,
                height: height * 0.11,
                child: Row(
                  children: [
                    Container(
                      // color: Colors.red,
                      width: width * 0.45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "APR 10 2021",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: AppFonts.regular,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("RPM",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.5,
                                fontFamily: AppFonts.regular,
                              )),
                          SizedBox(height: 8),
                          Text(
                            "Baynes Json.M.D",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5,
                              fontFamily: AppFonts.regular,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      width: width * 0.5,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "10:00",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5,
                              fontFamily: AppFonts.regular,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 20),
                width: width,
                height: height * 0.03,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FittedBox(child: Icon(Icons.location_on_rounded)),
                    Text(
                      "location",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                        fontFamily: AppFonts.regular,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Divider(
                thickness: 1.0,
                height: 10,
              )
            ],
          ),
        ),
      ],
    );
  }
}

























// import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
// import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// // https://ydrsdevapi.yourdrs.com/api/Appointment/GetPracticeLocations?MemberId=10
//
// class AppointmnetUpcoming extends StatefulWidget {
//   @override
//   _AppointmnetUpcomingState createState() => _AppointmnetUpcomingState();
// }
//
// class _AppointmnetUpcomingState extends State<AppointmnetUpcoming> {
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     // TODO: implement build
//     return SingleChildScrollView(
//         child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//             height: height * 0.28,
//             width: width * 20,
//             // // color: Colors.yellow,
//             // child: Card(
//             //     elevation: 6,
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 38, left: 4),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "APR 10 2021",
//                         style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: AppFonts.regular,
//                             color: CustomizedColors.blueAppBarColor),
//                       ),
//                       SizedBox(
//                         height: 12,
//                       ),
//                       Text(
//                         "RPM",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: AppFonts.regular,
//                           color: CustomizedColors.blueAppBarColor,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 11,
//                       ),
//                       Text("Baynes Json,M.D",
//                           style: TextStyle(
//                             fontFamily: AppFonts.regular,
//                             fontSize: 18,
//                             //color: HexColor("#010101")
//                           )),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: 30),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text("10:00 AM",
//                           style: TextStyle(
//                             fontFamily: AppFonts.regular,
//                             fontSize: 18,
//                             color: CustomizedColors.blueAppBarColor,
//                           )),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 60),
//                         child: Row(
//                           children: const <Widget>[
//                             Padding(
//                               padding: EdgeInsets.only(bottom: 25),
//                               child: Icon(
//                                 Icons.location_on_rounded,
//                                 color: Colors.black,
//                                 size: 27.0,
//                                 semanticLabel:
//                                     'Text to announce in accessibility modes',
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(bottom: 25),
//                               child: Text(
//                                 "54 DEAN,54 South Dean street,",
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   fontFamily: AppFonts.regular,
//                                   fontSize: 16,
//                                   color: CustomizedColors
//                                       .blueAppBarColor,
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       )
//
//                       //Icon:Icon(Icons.)
//                     ],
//                   ),
//                 ),
//               ],
//             )),
//         Divider(
//           height: 0,
//           thickness: 1,
//           color: Colors.black,
//         ),
//         Container(
//             height: height * 0.28,
//             width: width * 100,
//             // // color: Colors.yellow,
//             // child: Card(
//             //     elevation: 6,
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 38, left: 4),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "APR 7 2021",
//                         style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: AppFonts.regular,
//                             color: CustomizedColors.blueAppBarColor),
//                       ),
//                       SizedBox(
//                         height: 12,
//                       ),
//                       Text(
//                         "Follow Up Visit",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontFamily: AppFonts.regular,
//                           fontWeight: FontWeight.bold,
//                           color: CustomizedColors.blueAppBarColor,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 11,
//                       ),
//                       Text("Baynes Json,M.D",
//                           style: TextStyle(
//                             fontFamily: AppFonts.regular,
//                             fontSize: 18,
//                             //color: HexColor("#010101")
//                           )),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: 30),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text("8:45 AM",
//                           style: TextStyle(
//                             fontFamily: AppFonts.regular,
//                             fontSize: 18,
//                             color: CustomizedColors.blueAppBarColor,
//                           )),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 60),
//                         child: Row(
//                           children: const <Widget>[
//                             Padding(
//                               padding: EdgeInsets.only(bottom: 25),
//                               child: Icon(
//                                 Icons.location_on_rounded,
//                                 color: Colors.black,
//                                 size: 27.0,
//                                 semanticLabel:
//                                     'Text to announce in accessibility modes',
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(bottom: 25),
//                               child: Text("54 DEAN, 54 South Dean Street,",
//                                   style: TextStyle(
//                                     fontFamily: AppFonts.regular,
//                                     fontSize: 16,
//                                     color: CustomizedColors
//                                         .blueAppBarColor,
//                                   )),
//                             )
//                           ],
//                         ),
//                       )
//
//                       //Icon:Icon(Icons.)
//                     ],
//                   ),
//                 ),
//               ],
//             )),
//         Divider(
//           height: 0,
//           thickness: 1,
//           color: Colors.black,
//         ),
//         Container(
//             height: height * 0.28,
//             width: width * 100,
//             // // color: Colors.yellow,
//             // child: Card(
//             //     elevation: 6,
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 38, left: 4),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "NOV 25 2020",
//                         style: TextStyle(
//                             fontFamily: AppFonts.regular,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: CustomizedColors.blueAppBarColor),
//                       ),
//                       SizedBox(
//                         height: 12,
//                       ),
//                       Text(
//                         "post-Op-Up Visit",
//                         style: TextStyle(
//                           fontFamily: AppFonts.regular,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: CustomizedColors.blueAppBarColor,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 11,
//                       ),
//                       Text("Baynes Json,M.D",
//                           style: TextStyle(
//                             fontFamily: AppFonts.regular,
//                             fontSize: 18,
//                             // color: HexColor("#010101")
//                           )),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: 30),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text("2:00 PM",
//                           style: TextStyle(
//                             fontFamily: AppFonts.regular,
//                             fontSize: 18,
//                             color: CustomizedColors.blueAppBarColor,
//                           )),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 60),
//                         child: Row(
//                           children: const <Widget>[
//                             Padding(
//                               padding: EdgeInsets.only(bottom: 25),
//                               child: Icon(
//                                 Icons.location_on_rounded,
//                                 color: Colors.black,
//                                 size: 27.0,
//                                 semanticLabel:
//                                     'Text to announce in accessibility modes',
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(bottom: 25),
//                               child: Text("54 DEAN, 54 South Dean Street,",
//                                   style: TextStyle(
//                                     fontFamily: AppFonts.regular,
//                                     fontSize: 16,
//                                     color: CustomizedColors
//                                         .blueAppBarColor,
//                                   )),
//                             )
//                           ],
//                         ),
//                       )
//
//                       //Icon:Icon(Icons.)
//                     ],
//                   ),
//                 ),
//               ],
//             )),
//         Divider(
//           height: 0,
//           thickness: 1,
//           color: Colors.black,
//         ),
//         Container(
//             height: height * 0.28,
//             width: width * 100,
//             // // color: Colors.yellow,
//             // child: Card(
//             //     elevation: 6,
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 38, left: 4),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "NOV 25 2020",
//                         style: TextStyle(
//                             fontFamily: AppFonts.regular,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: CustomizedColors.blueAppBarColor),
//                       ),
//                       SizedBox(
//                         height: 12,
//                       ),
//                       Text(
//                         "post-Op-Up Visit",
//                         style: TextStyle(
//                           fontFamily: AppFonts.regular,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: CustomizedColors.blueAppBarColor,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 11,
//                       ),
//                       Text("Baynes Json,M.D",
//                           style: TextStyle(
//                             fontFamily: AppFonts.regular,
//                             fontSize: 18,
//                             //color: HexColor("#010101")
//                           )),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: 30),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text("2:00 PM",
//                           style: TextStyle(
//                             fontFamily: AppFonts.regular,
//                             fontSize: 18,
//                             color: CustomizedColors.blueAppBarColor,
//                           )),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 60),
//                         child: Row(
//                           children: const <Widget>[
//                             Padding(
//                               padding: EdgeInsets.only(bottom: 25),
//                               child: Icon(
//                                 Icons.location_on_rounded,
//                                 color: Colors.black,
//                                 size: 27.0,
//                                 semanticLabel:
//                                     'Text to announce in accessibility modes',
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(bottom: 25),
//                               child: Text("54 DEAN, 54 South Dean Street,",
//                                   style: TextStyle(
//                                     fontFamily: AppFonts.regular,
//                                     fontSize: 16,
//                                     color: CustomizedColors
//                                         .blueAppBarColor,
//                                   )),
//                             )
//                           ],
//                         ),
//                       )
//
//                       //Icon:Icon(Icons.)
//                     ],
//                   ),
//                 ),
//               ],
//             )),
//       ],
//     ));
//   }
// }
