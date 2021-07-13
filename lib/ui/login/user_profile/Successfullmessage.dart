import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_icons.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:flutter/material.dart';

class SuccessMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // SizedBox(height: 30),
              Container(
                width: width,
                height: height * 0.93,
                child: Column(
                  children: [
                    Image.asset(AppImages.changePassword,width: 140,height: 300,),
                    SizedBox(height: 30),
                    Text(
                      AppStrings.PasswordUpdated,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: CustomizedColors.signInButtonColor,
                        fontFamily: AppFonts.regular,
                      ),
                    ),
                    SizedBox(height: 50),
                    Text(
                      AppStrings.passwordUpdateSuccess,
                      style: TextStyle(
                        fontFamily: AppFonts.regular,
                        fontSize: 16.5,
                        // color: CustomizedColors.signInButtonColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  color: CustomizedColors.signInButtonColor,
                  width: width,
                  height: height * 0.07,
                  child: Center(
                    child: Text(
                      AppStrings.done,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: AppFonts.regular,
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}