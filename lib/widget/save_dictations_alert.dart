import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/ui/home/patient_details.dart';
import 'package:YOURDRS_FlutterAPP/ui/patient_dictation/dictation_type.dart';
import 'package:YOURDRS_FlutterAPP/utils/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import '../common/app_text.dart';

// ignore: must_be_immutable
class SaveDictationsAlert extends StatefulWidget {
  String title;
  var clr;
  int count;

  SaveDictationsAlert({@required this.title, @required this.clr, @required this.count});
  @override
  _SaveDictationsAlertState createState() => _SaveDictationsAlertState();
}

class _SaveDictationsAlertState extends State<SaveDictationsAlert> {
  bool isInternetAvailable;
  Future<bool> checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }
  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    isInternetAvailable = await checkNetwork();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        content: Row(
          children: [
            Expanded(child: Text(widget.title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: widget.clr,
              fontFamily: AppFonts.regular,),textAlign: TextAlign.center,)),
          ],
        ),
        actions: [
          // ignore: deprecated_member_use
          TextButton(
            child: Text(AppStrings.ok,style: TextStyle(fontFamily: AppFonts.regular,),),
            onPressed: () {
              int count = isInternetAvailable ? 0 : 1;
              Navigator.of(context).popUntil((_) => count++ >= widget.count);    
            },
          ),
        ],
      ),
    );
  }
}


