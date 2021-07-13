import 'dart:io';

import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_icons.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:YOURDRS_FlutterAPP/ui/login/login_screen/loginscreen.dart';
import 'package:YOURDRS_FlutterAPP/ui/login/user_profile/change_profile.dart';
import 'package:YOURDRS_FlutterAPP/utils/cached_image.dart';
import 'package:YOURDRS_FlutterAPP/utils/route_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerScreen extends StatefulWidget {
  static const String routeName = '/DrawerScreen';

  @override
  State<StatefulWidget> createState() {
    return DrawerState();
  }
}

class DrawerState extends State<DrawerScreen> {
  var displayName = "";
  var profilePic = "";
  var userEmail = "";
  bool contains = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

//loading the data for users profile
  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = (prefs.getString(Keys.displayName) ?? '');
      profilePic = (prefs.getString(Keys.displayPic) ?? '');
      userEmail = (prefs.getString(Keys.userEmail) ?? '');
    });
    contains = profilePic.contains('https');
    print('contains');
    print(contains);
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.60,
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: CustomizedColors.clrCyanBlueColor,
              ),
              accountName: Text(
                displayName ?? "",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: CustomizedColors.textColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.regular),
              ),
              accountEmail: Text(
                userEmail ?? "",
                style: TextStyle(fontFamily: AppFonts.regular),
              ),
              currentAccountPicture: CircleAvatar(
                child:
                    profilePic != null && profilePic != "" && contains == true
                        ? CachedImage(
                            profilePic,
                            isRound: true,
                            radius: 75.0,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.file(
                              File(profilePic),
                              fit: BoxFit.fill,
                              width: 200,
                              height: 200,
                            ),
                          ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.account_circle,
                color: CustomizedColors.clrCyanBlueColor,
              ),
              title: Text(
                AppStrings.myProfile,
                style: TextStyle(fontFamily: AppFonts.regular),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Profile()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: CustomizedColors.clrCyanBlueColor,
              ),
              title: Text(
                AppStrings.logout,
                style: TextStyle(fontFamily: AppFonts.regular),
              ),
              onTap: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear();
                RouteGenerator.navigatorKey.currentState
                    .pushReplacementNamed(LoginScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
