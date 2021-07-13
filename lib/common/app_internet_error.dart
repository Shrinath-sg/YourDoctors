import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_icons.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:flutter/material.dart';

Future<void> showInternetError(BuildContext context, GlobalKey key) async {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return new WillPopScope(
        onWillPop: () async => true,
        child: SimpleDialog(
          key: key,
          backgroundColor: Colors.white,
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  Container(
                    color: Colors.green,
                    height: height * 0.2,
                    width: height * 0.2,
                    child: Image.asset(
                      AppImages.noInternetImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    AppStrings.no_internet,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    AppStrings.checkConnection,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: CustomizedColors.yourDoctorsTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: width * 0.4,
                      height: height * 0.08,
                      child: Card(
                        color: CustomizedColors.signInButtonColor,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Text(
                            AppStrings.retry,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}
