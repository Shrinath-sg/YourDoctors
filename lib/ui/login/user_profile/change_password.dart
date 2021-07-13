import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/network/models/user_profile/change_password.dart';
import 'package:YOURDRS_FlutterAPP/network/services/user_profile/changepssword_service.dart';
import 'package:YOURDRS_FlutterAPP/utils/route_generator.dart';
import 'package:flutter/material.dart';
// import 'Successfullmessage.dart';

class ChangeUserPassword extends StatefulWidget {
  static const String routeName = '/ChangeUserPassword';

  @override
  State<StatefulWidget> createState() {
    return ChangeUserPasswordState();
  }
}

class ChangeUserPasswordState extends State<ChangeUserPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _reenterController = TextEditingController();
  ResetUserPassword _resetUserPassword = ResetUserPassword();
  ChangePassword _changePassword = ChangePassword();
  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _passwordVisible1 = false;

  // Play Animation on click of SignInButton
  void _playLoginAnimation() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    try {} on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          color: Colors.white,
          padding: const EdgeInsets.only(top: 20, left: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    AppStrings.resetPassword,
                    style: TextStyle(
                        fontFamily: AppFonts.regular,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: width * 0.9,
                  height: height * 0.08,
                  child: TextFormField(
                    controller: _nameController,
                    obscureText: !_passwordVisible,
                    validator: (value) {
                      if (value.isEmpty) {
                        return AppStrings.enterNewPassword;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey.shade500),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        // hintText: "enter new password",
                        labelText: AppStrings.enterNewPassword,
                        contentPadding: new EdgeInsets.only(bottom: 5)),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: width * 0.9,
                  height: height * 0.08,
                  child: TextFormField(
                    controller: _reenterController,
                    obscureText: !_passwordVisible1,
                    validator: (value) {
                      if (value.isEmpty) {
                        return AppStrings.reEnterNewPassword;
                      }
                      return null;
                    },

                    decoration: InputDecoration(

                      suffixIcon: IconButton(
                        icon: Icon(
                            _passwordVisible1
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey.shade500),
                        onPressed: () {
                          setState(() {
                            _passwordVisible1 = !_passwordVisible1;
                          });
                        },
                      ),
                      labelText: AppStrings.reEnterNewPassword,
                      contentPadding: new EdgeInsets.only(bottom: 5),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                InkWell(
                  onTap: () async {
                    if (_formKey.currentState.validate()) {
                      if (_nameController.text != _reenterController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(AppStrings.passwordDoNotMatch),
                          backgroundColor: CustomizedColors.signInButtonColor,
                        ));
                      } else {
                        _playLoginAnimation();
                        _changePassword = await _resetUserPassword
                            .reSetPassword(_reenterController.text);
                        if (_changePassword.header.statusCode == '200') {
                          RouteGenerator.navigatorKey.currentState.pushReplacementNamed(
                            ChangeUserPassword.routeName,);
                        } else {
                          return null;
                        }
                      }
                    }
                  },
                  child: Card(
                    color: CustomizedColors.signInButtonColor,
                    child: Container(
                      width: width * 0.9,
                      height: height * 0.065,
                      child: Center(
                        child: !_isLoading
                            ? Text(
                                AppStrings.updatePassword,
                                style: TextStyle(
                                    color:
                                        CustomizedColors.signInButtonTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: AppFonts.regular),
                              )
                            : CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
