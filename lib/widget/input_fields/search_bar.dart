import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:flutter/material.dart';

class PatientSerach extends StatelessWidget {
  int width;
  double height;
  final onChanged;
  final controller;
  final decoration;
  final onEditingComplete;
  final trailing;
  // ---> Implementing the constructor <----
  PatientSerach(
      {this.onChanged,
      @required this.width,
      @required this.height,
      @required this.controller,
      this.decoration,
      this.onEditingComplete,
      this.trailing});

  @override
  Widget build(BuildContext context) {

    // ---> search bar <---
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: ListTile(
            trailing: trailing,
            title: TextField(
              controller: controller,
              decoration: decoration,
              style: TextStyle(
                  fontSize: 14,
                  color: CustomizedColors.dropdowntxtcolor,
                  fontFamily: AppFonts.regular),
// --> called value is changed <----
              onChanged: onChanged,
              onEditingComplete: onEditingComplete,
            ),
          )),
    );

  }
}
