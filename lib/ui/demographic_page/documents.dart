import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/network/models/external_dictations/get_all_manual_dictation_model.dart';
import 'package:YOURDRS_FlutterAPP/network/services/dictation/dictation_services.dart';
import 'package:flutter/material.dart';

class Documents extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DocumentState();
  }
}

class DocumentState extends State<Documents> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: CustomizedColors.clrCyanBlueColor,
        title: Text("Documents"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Card(
                child: ExpansionTile(
                  title: Row(children: [
                    Container(
                      width: width * 0.55,
                      child: Text(
                        "Intake",
                        style: TextStyle(
                          fontFamily: AppFonts.regular,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      // color: Colors.blue,
                      width: width * 0.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "5 files",
                            style: TextStyle(
                                fontFamily: AppFonts.regular,
                                color: CustomizedColors.clrCyanBlueColor),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  // trailing: Text("5files"),
                  children: <Widget>[
                    Column(
                      children: [
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          color: CustomizedColors.waveBGColor,
                          width: width * 0.95,
                          height: height * 0.06,
                          child: Row(
                            children: [
                              Container(
                                // color: Colors.black,
                                width: width / 3.18,
                                height: height,
                                child: Center(
                                    child: Text(
                                  "23-07-2018",
                                  style: TextStyle(
                                    fontFamily: AppFonts.regular,
                                    fontSize: 14.5,
                                  ),
                                )),
                              ),
                              Container(
                                // color: Colors.orange,
                                width: width / 3.18,
                                height: height,
                                child: Center(
                                    child: Text(
                                  "12016086938@45889",
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
                                width: width / 3.18,
                                height: height,
                                child: Center(
                                    child: Text(
                                  "kyriakides Chrisness",
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
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          color: CustomizedColors.waveBGColor,
                          width: width * 0.95,
                          height: height * 0.06,
                          child: Row(
                            children: [
                              Container(
                                // color: Colors.black,
                                width: width / 3.18,
                                height: height,
                                child: Center(
                                    child: Text(
                                  "23-07-2018",
                                  style: TextStyle(
                                    fontFamily: AppFonts.regular,
                                    fontSize: 14.5,
                                  ),
                                )),
                              ),
                              Container(
                                // color: Colors.orange,
                                width: width / 3.18,
                                height: height,
                                child: Center(
                                    child: Text(
                                  "12016086938@45889",
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
                                width: width / 3.18,
                                height: height,
                                child: Center(
                                    child: Text(
                                  "kyriakides Chrisness",
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
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          color: CustomizedColors.waveBGColor,
                          width: width * 0.95,
                          height: height * 0.06,
                          child: Row(
                            children: [
                              Container(
                                // color: Colors.black,
                                width: width / 3.18,
                                height: height,
                                child: Center(
                                    child: Text(
                                  "23-07-2018",
                                  style: TextStyle(
                                    fontFamily: AppFonts.regular,
                                    fontSize: 14.5,
                                  ),
                                )),
                              ),
                              Container(
                                // color: Colors.orange,
                                width: width / 3.18,
                                height: height,
                                child: Center(
                                    child: Text(
                                  "12016086938@45889",
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
                                width: width / 3.18,
                                height: height,
                                child: Center(
                                    child: Text(
                                  "kyriakides Chrisness",
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
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          color: CustomizedColors.waveBGColor,
                          width: width * 0.95,
                          height: height * 0.06,
                          child: Row(
                            children: [
                              Container(
                                // color: Colors.black,
                                width: width / 3.18,
                                height: height,
                                child: Center(
                                    child: Text(
                                  "23-07-2018",
                                  style: TextStyle(
                                    fontFamily: AppFonts.regular,
                                    fontSize: 14.5,
                                  ),
                                )),
                              ),
                              Container(
                                // color: Colors.orange,
                                width: width / 3.18,
                                height: height,
                                child: Center(
                                    child: Text(
                                  "12016086938@45889",
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
                                width: width / 3.18,
                                height: height,
                                child: Center(
                                    child: Text(
                                  "kyriakides Chrisness",
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
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          color: CustomizedColors.waveBGColor,
                          width: width * 0.95,
                          height: height * 0.06,
                          child: Row(
                            children: [
                              Container(
                                // color: Colors.black,
                                width: width / 3.18,
                                height: height,
                                child: Center(
                                    child: Text(
                                  "23-07-2018",
                                  style: TextStyle(
                                    fontFamily: AppFonts.regular,
                                    fontSize: 14.5,
                                  ),
                                )),
                              ),
                              Container(
                                // color: Colors.orange,
                                width: width / 3.18,
                                height: height,
                                child: Center(
                                    child: Text(
                                  "12016086938@45889",
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
                                width: width / 3.18,
                                height: height,
                                child: Center(
                                    child: Text(
                                  "kyriakides Chrisness",
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
                        SizedBox(
                          height: height * 0.01,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Card(
                child: ExpansionTile(
                  title: Row(children: [
                    Container(
                      width: width * 0.55,
                      child: Text(
                        "Billing",
                        style: TextStyle(
                          fontFamily: AppFonts.regular,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      width: width * 0.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "5 files",
                            style: TextStyle(
                                fontFamily: AppFonts.regular,
                                color: CustomizedColors.clrCyanBlueColor),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "items.description",
                        style:
                            TextStyle(color: CustomizedColors.clrCyanBlueColor),
                      ),
                    )
                  ],
                ),
              ),
              Card(
                child: ExpansionTile(
                  title: Row(children: [
                    Container(
                      width: width * 0.55,
                      child: Text(
                        "Diagnostic Testing",
                        style: TextStyle(
                          fontFamily: AppFonts.regular,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      width: width * 0.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "5 files",
                            style: TextStyle(
                                fontFamily: AppFonts.regular,
                                color: CustomizedColors.clrCyanBlueColor),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "items.description",
                        style:
                            TextStyle(color: CustomizedColors.clrCyanBlueColor),
                      ),
                    )
                  ],
                ),
              ),
              Card(
                child: ExpansionTile(
                  title: Row(children: [
                    Container(
                      // color: Colors.,
                      width: width * 0.55,
                      child: Text(
                        "Insurance Correspondence",
                        style: TextStyle(
                          fontFamily: AppFonts.regular,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      // color: Colors.blue,
                      width: width * 0.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "5 files",
                            style: TextStyle(
                                fontFamily: AppFonts.regular,
                                color: CustomizedColors.clrCyanBlueColor),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "items.description",
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                child: ExpansionTile(
                  title: Row(children: [
                    Container(
                      width: width * 0.55,
                      child: Text(
                        "Medical Records",
                        style: TextStyle(
                          fontFamily: AppFonts.regular,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      width: width * 0.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "5 files",
                            style: TextStyle(
                                fontFamily: AppFonts.regular,
                                color: CustomizedColors.clrCyanBlueColor),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "items.description",
                        style:
                            TextStyle(
                                color: CustomizedColors.clrCyanBlueColor),
                      ),
                    )
                  ],
                ),
              ),
              Card(
                child: ExpansionTile(
                  title: Row(children: [
                    Container(
                      width: width * 0.55,
                      child: Text(
                        "Referals (Rx)",
                        style: TextStyle(
                          fontFamily: AppFonts.regular,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      width: width * 0.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "5 files",
                            style: TextStyle(
                                fontFamily: AppFonts.regular,
                                color: CustomizedColors.clrCyanBlueColor),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "items.description",
                        style:
                            TextStyle(
                                color: CustomizedColors.clrCyanBlueColor),
                      ),
                    )
                  ],
                ),
              ),
              Card(
                child: ExpansionTile(
                  title: Row(children: [
                    Container(
                      width: width * 0.55,
                      child: Text(
                        "Pre - Surgical Charts",
                        style: TextStyle(
                          fontFamily: AppFonts.regular,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      width: width * 0.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "5 files",
                            style: TextStyle(
                                fontFamily: AppFonts.regular,
                                color: CustomizedColors.clrCyanBlueColor),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "items.description",
                        style:
                            TextStyle(
                                color: CustomizedColors.clrCyanBlueColor),
                      ),
                    )
                  ],
                ),
              ),
              Card(
                child: ExpansionTile(
                  title: Row(children: [
                    Container(
                      width: width * 0.55,
                      child: Text(
                        "Physical Therapy",
                        style: TextStyle(
                          fontFamily: AppFonts.regular,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      width: width * 0.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "5 files",
                            style: TextStyle(
                                fontFamily: AppFonts.regular,
                                color: CustomizedColors.clrCyanBlueColor),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "items.description",
                        style:
                            TextStyle(color: CustomizedColors.clrCyanBlueColor),
                      ),
                    )
                  ],
                ),
              ),
              Card(
                child: ExpansionTile(
                  title: Row(children: [
                    Container(
                      width: width * 0.55,
                      child: Text(
                        "Surgical Charts",
                        style: TextStyle(
                          fontFamily: AppFonts.regular,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      width: width * 0.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "5 files",
                            style: TextStyle(
                                fontFamily: AppFonts.regular,
                                color: CustomizedColors.clrCyanBlueColor),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "items.description",
                        style:
                            TextStyle(color: CustomizedColors.clrCyanBlueColor),
                      ),
                    )
                  ],
                ),
              ),
              Card(
                child: ExpansionTile(
                  title: Row(children: [
                    Container(
                      width: width * 0.55,
                      child: Text(
                        "Attorney Correspondence",
                        style: TextStyle(
                          fontFamily: AppFonts.regular,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      width: width * 0.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "5 files",
                            style: TextStyle(
                              color: CustomizedColors.primaryColor,
                              fontFamily: AppFonts.regular,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "items.description",
                        style:
                            TextStyle(color: CustomizedColors.clrCyanBlueColor),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
