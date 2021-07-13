import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PatientListShimmer extends StatelessWidget {
  const PatientListShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        enabled: true,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FittedBox(
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        width: width * 0.95,
                        //color: Colors.yellow,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Hero(
                                  transitionOnUserGestures: true,
                                  tag: 'element',
                                  child: Transform.scale(
                                      scale: 1.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                CustomizedColors.greenDotColor),
                                        child: Image.asset(AppImages.defaultImg,
                                            width: 40,
                                            height: 40,
                                            alignment: Alignment.center),
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 15.0,

                              ///edited....
                            ),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: width * 0.50,
                                          height: 15,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Wrap(
                                      children: [
                                        Container(
                                          width: width * 0.75,
                                          height: 15,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: CustomizedColors.yellowDotColor,
                                          size: 8,
                                        ),
                                        SizedBox(width: 5),
                                        Container(
                                          width: 50,
                                          height: 15,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                          ],
                        )),
                    // SizedBox(width: 10,),  ///edited
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        width: width * 0.95,
                        //color: Colors.yellow,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Hero(
                                  transitionOnUserGestures: true,
                                  tag: 'element',
                                  child: Transform.scale(
                                      scale: 1.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                CustomizedColors.greenDotColor),
                                        child: Image.asset(AppImages.defaultImg,
                                            width: 40,
                                            height: 40,
                                            alignment: Alignment.center),
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 15.0,

                              ///edited....
                            ),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: width * 0.50,
                                          height: 15,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Wrap(
                                      children: [
                                        Container(
                                          width: width * 0.75,
                                          height: 15,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: CustomizedColors.yellowDotColor,
                                          size: 8,
                                        ),
                                        SizedBox(width: 5),
                                        Container(
                                          width: 50,
                                          height: 15,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                          ],
                        )),
                    // SizedBox(width: 10,),  ///edited
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        width: width * 0.95,
                        //color: Colors.yellow,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Hero(
                                  transitionOnUserGestures: true,
                                  tag: 'element',
                                  child: Transform.scale(
                                      scale: 1.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                CustomizedColors.greenDotColor),
                                        child: Image.asset(AppImages.defaultImg,
                                            width: 40,
                                            height: 40,
                                            alignment: Alignment.center),
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 15.0,

                              ///edited....
                            ),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: width * 0.50,
                                          height: 15,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Wrap(
                                      children: [
                                        Container(
                                          width: width * 0.75,
                                          height: 15,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: CustomizedColors.yellowDotColor,
                                          size: 8,
                                        ),
                                        SizedBox(width: 5),
                                        Container(
                                          width: 50,
                                          height: 15,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                          ],
                        )),
                    // SizedBox(width: 10,),  ///edited
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        width: width * 0.95,
                        //color: Colors.yellow,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Hero(
                                  transitionOnUserGestures: true,
                                  tag: 'element',
                                  child: Transform.scale(
                                      scale: 1.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                CustomizedColors.greenDotColor),
                                        child: Image.asset(AppImages.defaultImg,
                                            width: 40,
                                            height: 40,
                                            alignment: Alignment.center),
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 15.0,

                              ///edited....
                            ),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: width * 0.50,
                                          height: 15,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Wrap(
                                      children: [
                                        Container(
                                          width: width * 0.75,
                                          height: 15,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: CustomizedColors.yellowDotColor,
                                          size: 8,
                                        ),
                                        SizedBox(width: 5),
                                        Container(
                                          width: 50,
                                          height: 15,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                          ],
                        )),
                    // SizedBox(width: 10,),  ///edited
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        width: width * 0.95,
                        //color: Colors.yellow,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Hero(
                                  transitionOnUserGestures: true,
                                  tag: 'element',
                                  child: Transform.scale(
                                      scale: 1.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                CustomizedColors.greenDotColor),
                                        child: Image.asset(AppImages.defaultImg,
                                            width: 40,
                                            height: 40,
                                            alignment: Alignment.center),
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 15.0,

                              ///edited....
                            ),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: width * 0.50,
                                          height: 15,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Wrap(
                                      children: [
                                        Container(
                                          width: width * 0.75,
                                          height: 15,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: CustomizedColors.yellowDotColor,
                                          size: 8,
                                        ),
                                        SizedBox(width: 5),
                                        Container(
                                          width: 50,
                                          height: 15,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                          ],
                        )),
                    // SizedBox(width: 10,),  ///edited
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        width: width * 0.95,
                        //color: Colors.yellow,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Hero(
                                  transitionOnUserGestures: true,
                                  tag: 'element',
                                  child: Transform.scale(
                                      scale: 1.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                CustomizedColors.greenDotColor),
                                        child: Image.asset(AppImages.defaultImg,
                                            width: 40,
                                            height: 40,
                                            alignment: Alignment.center),
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 15.0,

                              ///edited....
                            ),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: width * 0.50,
                                          height: 15,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Wrap(
                                      children: [
                                        Container(
                                          width: width * 0.75,
                                          height: 15,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: CustomizedColors.yellowDotColor,
                                          size: 8,
                                        ),
                                        SizedBox(width: 5),
                                        Container(
                                          width: 50,
                                          height: 15,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                          ],
                        )),
                    // SizedBox(width: 10,),  ///edited
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
