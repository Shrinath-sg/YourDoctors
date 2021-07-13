import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';
import 'package:YOURDRS_FlutterAPP/common/app_icons.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:YOURDRS_FlutterAPP/ui/login/login_screen/loginscreen.dart';
import 'package:YOURDRS_FlutterAPP/ui/login/security_pin_screen/confirm_pin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:YOURDRS_FlutterAPP/utils/route_generator.dart';

final _formKey = GlobalKey<FormState>();
final scaffoldKey = GlobalKey<ScaffoldState>();

class CreatePinScreen extends StatelessWidget {
  static const String routeName = '/CreatePinScreen';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: PinPutView()),
    );
  }
}

class PinPutView extends StatefulWidget {
  @override
  PinPutViewState createState() => PinPutViewState();
}

class PinPutViewState extends State<PinPutView> {
  final pinPutController = TextEditingController();
  ///...... validating the pin put value
  String _validatePinPut(String value) {
    Pattern pattern = r'^[0-9]*$';
    RegExp regex = new RegExp(pattern);
    try {
      if (value.isEmpty) {
        return AppStrings.cannot_be_empty;
      } else {
        if (!regex.hasMatch(value))
          return AppStrings.enterValidPin;
        else {
          return null;
        }
      }
    } catch (Exception) {
      // print(Exception);
    }
    return "";
  }
  @override
  Widget build(BuildContext context) {
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: Colors.grey[350],
      borderRadius: BorderRadius.circular(12.0),
    );

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    Widget _smallDisplay() {
      return Container(
        height: height,
        color: Colors.white,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              AppImages.logo,
              width: width * 0.70,
            ),
          ]),
          SizedBox(
            height: height * 0.05,
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Text(
            AppStrings.createPin,
            style: TextStyle(
                fontFamily: AppFonts.regular,
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: height * 0.05),
          Container(
            width: width * 0.60,
            child: Form(
              key: _formKey,
              child: GestureDetector(
                child: PinPut(
                  controller: pinPutController,
                  validator: _validatePinPut,
                  autovalidateMode: AutovalidateMode.disabled,
                  withCursor: true,
                  fieldsCount: 4,
                  fieldsAlignment: MainAxisAlignment.spaceAround,
                  textStyle: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey,
                  ),
                  eachFieldWidth: width <= 350 ? 45 : 50,
                  eachFieldHeight: width <= 350 ? 45 : 50,
                  onSubmit: (String pin) async {
                    FocusScope.of(context).unfocus();
                    ///....... after submitting pin keyboard will automatically destroy.
                    if (_formKey.currentState.validate()) {
                      await MySharedPreferences.instance
                          .setStringValue(Keys.pin, pin);
                      RouteGenerator.navigatorKey.currentState
                          .pushReplacementNamed(
                        ConfirmPinScreen.routeName,
                      );
                    } else {
// ignore: deprecated_member_use
                      scaffoldKey.currentState.showSnackBar(
                        new SnackBar(
                          content: Container(
                            height: 40.0,
                            child: Center(
                              child: Text(
                                AppStrings.valid_credentials,
                                style: const TextStyle(fontFamily: AppFonts.regular,fontSize: 15.0),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  submittedFieldDecoration: pinPutDecoration,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  selectedFieldDecoration: pinPutDecoration.copyWith(
                    color: CustomizedColors.textFieldBackground,
                    border: Border.all(
                      width: 2,
                      color: const Color.fromRGBO(160, 215, 220, 1),
                    ),
                  ),
                  followingFieldDecoration: pinPutDecoration,
                  pinAnimationType: PinAnimationType.slide,
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.10,
          ),
          GestureDetector(
            onTap: () async {
              SharedPreferences preferences =
              await SharedPreferences.getInstance();
              await preferences.clear();
              MySharedPreferences.instance.removeAll();
              RouteGenerator.navigatorKey.currentState
                  .pushReplacementNamed(LoginScreen.routeName);
            },
            child: Text(
              AppStrings.loginWithDiffAcc,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ]),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(child: _smallDisplay()),
    );
  }
}

//
