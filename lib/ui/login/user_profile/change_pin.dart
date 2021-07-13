import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'conform_change_pin.dart';

class ChangeUserPIN extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChangeUserPasswordState();
  }
}

class ChangeUserPasswordState extends State<ChangeUserPIN> {
  final _formKey = GlobalKey<FormState>();
  final pinPutController = TextEditingController();

  // validate the pinPut value
  String _validatePinPut(String value) {
    Pattern pattern = AppConstants.numberRegExp;
    RegExp regex = RegExp(pattern);
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: Colors.grey[350],
      borderRadius: BorderRadius.circular(12.0),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Container(
        width: width,
        height: height*0.7,
        color: Colors.white,
        // padding: const EdgeInsets.only(top: 20, left: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.enterNewPIN,
                style: TextStyle(
                    fontFamily: AppFonts.regular,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              Container(
                width: width * 0.7,
                height: height * 0.08,
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
                    var pinValue = pinPutController.text;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ConfirmUserPin(
                              pinValue: pinValue.toString(),
                            )));
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
                  // pinAnimationType: PinAnimationType.slide,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
