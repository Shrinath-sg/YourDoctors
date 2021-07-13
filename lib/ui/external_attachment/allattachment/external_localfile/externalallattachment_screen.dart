import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/common/app_toast_message.dart';
import 'package:YOURDRS_FlutterAPP/helper/db_helper.dart';
import 'package:YOURDRS_FlutterAPP/network/models/external_dictations/external_database_model.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'externalattachment_details.dart';

class ExternalAllattachment extends StatefulWidget {
  @override
  _ExternalAllattachmentState createState() => _ExternalAllattachmentState();
}

class _ExternalAllattachmentState extends State<ExternalAllattachment> {
  List<ExternalAttachmentList> attachments = [];
  int attachmentId;
  String displayName;
  int uploadedToServer;
  var memberId;
  var emergencyAddOn;
  AppToast _tost = AppToast();
  bool togglevalue = true;
  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memberId = (prefs.getString(Keys.memberId) ?? '');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _loadData();
    super.initState();
  }

  // List<PhotoList>
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: FutureBuilder(
            future: DatabaseHelper.db.getAllExtrenalAttachmentList(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CupertinoActivityIndicator(
                    radius: 20,
                  ),
                );
              } else {
                attachments = snapshot.data as List<ExternalAttachmentList>;
                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: attachments.length,
                    itemBuilder: (BuildContext context, int index) {
                      attachmentId = attachments[index].id;
                      emergencyAddOn = attachments[index].isemergencyaddon;
                      if (emergencyAddOn == 0) {
                        togglevalue = false;
                      } else {
                        togglevalue = true;
                      }
                      return InkWell(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExternalattachmentType(
                                      attachmentId: attachments[index].id,
                                      displayfilename:
                                          attachments[index].displayfilename,
                                      practicename:
                                          attachments[index].practicename,
                                      locationname:
                                          attachments[index].locationname,
                                      externaldocumenttype: attachments[index]
                                          .externaldocumenttype,
                                      providername:
                                          attachments[index].providername,
                                      patientfirstname:
                                          attachments[index].patientfirstname,
                                      patientlastname:
                                          attachments[index].patientlastname,
                                      patientdob: attachments[index].patientdob,
                                      isemergencyaddon: togglevalue,
                                      description:
                                          attachments[index].description,
                                      uploadedtoserver:
                                          attachments[index].uploadedtoserver,
                                    )),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          child: Card(
                            child: ListTile(
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                      padding: new EdgeInsets.all(3.0)),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    child: Text(
                                      "${attachments[index].displayfilename}",
                                      style: TextStyle(
                                          fontFamily: AppFonts.regular,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                  icon: Icon(
                                    Icons.cloud_done,
                                    size: 34,
                                    color: Colors.black54,
                                  ),
                                  onPressed: () async {
                                    _tost.showToast("error while uploading!!!");
                                  }),
                            ),
                          ),
                        ),
                      );
                    });
              }
            }));
  }
}
