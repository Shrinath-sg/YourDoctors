import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../common/app_text.dart';

class CustomTile extends StatelessWidget {
  var text1;
  var text2;
  CustomTile({this.text1, this.text2});
  @override
  Widget build(BuildContext context) {
// TODO: implement build
    return Container(
      color: CustomizedColors.customeTextColor,
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            color: CustomizedColors.primaryBgColor,
            width: 120,
            height: 60,
            child: Padding(
              padding: const EdgeInsets.only(left: 23.0),
              child: Text(
                text1,
                style: TextStyle(
                    color: CustomizedColors.customeColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.regular,
                    fontSize: 12),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  text2,
                  style: TextStyle(fontFamily: AppFonts.regular, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
