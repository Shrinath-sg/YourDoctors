import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/network/models/login/pin_generation_model.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:YOURDRS_FlutterAPP/network/services/login/pin_generation_api.dart';
import 'package:YOURDRS_FlutterAPP/utils/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ConfirmUserPin extends StatefulWidget {
  static const String routeName = '/ConfirmUserPin';
  var pinValue;

  ConfirmUserPin({this.pinValue});

  @override
  State<StatefulWidget> createState() {
    return ChangeUserPasswordState();
  }
}

class ChangeUserPasswordState extends State<ConfirmUserPin> {
  final _formKey = GlobalKey<FormState>();
  PinGenerateResponse _generateResponse = PinGenerateResponse();
  PinGenerateModel _generateModel = PinGenerateModel();
  final pinPutController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  // Play Animation on click of UpdatePIN
  void _playLoginAnimation() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    try {} on TickerCanceled {}
  }

  // Show Dialog validation of PIN
  Future<void> _showMyDialogValidation(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
             text,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontFamily: AppFonts.regular),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(AppStrings.ok),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppStrings.pinUpdated,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontFamily: AppFonts.regular),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  AppStrings.pinUpdateSuccessful,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.regular,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(AppStrings.ok),
              onPressed: () async {
                await MySharedPreferences.instance.setStringValue(
                    Keys.storedMemberPin, pinPutController.text);
                Navigator.of(context).pop();
                RouteGenerator.navigatorKey.currentState.pushReplacementNamed(
                  ConfirmUserPin.routeName,);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: _getBody(),
      ),
    );
  }

  Widget _getBody() {
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: Colors.grey[350],
      borderRadius: BorderRadius.circular(12.0),
    );
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height*0.7,
      color: Colors.white,
      // padding: const EdgeInsets.only(top: 20, left: 20),
      child: Form(
        key: _formKey,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.reEnterPN,
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
                  if (widget.pinValue.toString() != pinPutController.text) {
                    _showMyDialogValidation(AppStrings.pinDoNotMatch);
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
              ),
            ),
            SizedBox(height: 50),
            InkWell(
              onTap: () async {
                var memberId = await MySharedPreferences.instance
                    .getStringValue(Keys.memberId);
                if (_formKey.currentState.validate()) {
                  if (widget.pinValue.toString() != pinPutController.text) {
                    _showMyDialogValidation(AppStrings.pinDoNotMatch);
                  } else {
                    _playLoginAnimation();
                    _generateModel =
                    await _generateResponse.pinGeneratePostApiMethod(
                        int.tryParse(memberId), pinPutController.text);
                  }

                  if (_generateModel.header.statusCode == '200') {
                    setState(() {
                      _isLoading = false;
                    });
                    _showMyDialog();

                    SharedPreferences myPrefs =
                        await SharedPreferences.getInstance();
                    print(Keys.storedMemberPin.toString());
                     myPrefs.remove(Keys.storedMemberPin);


                    await MySharedPreferences.instance.setStringValue(
                        Keys.storedMemberPin, pinPutController.text);


                  } else if (_generateModel.header.statusCode == "406") {
                    setState(() {
                      _isLoading = false;
                    });
                    _showMyDialogValidation(AppStrings.samePin);
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
                            AppStrings.updatePin,
                            style: TextStyle(
                                color: CustomizedColors.signInButtonTextColor,
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
    );
  }
}
