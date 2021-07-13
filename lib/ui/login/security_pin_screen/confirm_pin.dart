import 'package:YOURDRS_FlutterAPP/blocs/login/pin_generation/pin_screen_generate_bloc.dart';
import 'package:YOURDRS_FlutterAPP/common/app_alertbox.dart';
import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';
import 'package:YOURDRS_FlutterAPP/common/app_icons.dart';
import 'package:YOURDRS_FlutterAPP/common/app_internet_error.dart';
import 'package:YOURDRS_FlutterAPP/common/app_loader.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/common/app_toast_message.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:YOURDRS_FlutterAPP/network/services/login/pin_generation_api.dart';
import 'package:YOURDRS_FlutterAPP/ui/login/login_screen/loginscreen.dart';
import 'package:YOURDRS_FlutterAPP/ui/login/security_pin_screen/create_security_pin.dart';
import 'package:YOURDRS_FlutterAPP/ui/login/security_pin_screen/verify_security_pin.dart';
import 'package:YOURDRS_FlutterAPP/utils/route_generator.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'create_security_pin.dart';

var _pin;
final GlobalKey<State> _keyLoader = GlobalKey<State>();
class ConfirmPinScreen extends StatelessWidget {
  static const String routeName = '/ConfirmPinScreen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PinScreenGenerateBloc>(
      create: (context) => PinScreenGenerateBloc(PinGenerateResponse()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: PinPutView()),
      ),
    );
  }
}

class PinPutView extends StatefulWidget {
  @override
  PinPutViewState createState() => PinPutViewState();
}

class PinPutViewState extends State<PinPutView> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isInternetAvailable = false;
  var _memberId;
  final pinPutController = TextEditingController();
  AppToast appToast=AppToast();
  ///...... checking internet connection available or not.
  Future<void> _checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a mobile network.
      setState(() {
        isInternetAvailable = true;
      });
    } else {
      setState(() {
        isInternetAvailable = false;
      });
      showInternetError(context, _keyLoader);
      clearTextInput();
    }
  }

  clearTextInput() {
    pinPutController.clear();
  }

  ///...... validating the pin put value
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
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _memberId = (prefs.getString(Keys.memberId) ?? '');
      _pin = (prefs.getString(Keys.pin) ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    var storedPin = _pin;
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: Colors.grey[350],
      borderRadius: BorderRadius.circular(12.0),
    );

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    Widget _portrait() {
      return BlocListener<PinScreenGenerateBloc, PinGenerateScreenState>(
          listener: (context, state) {
            if (state.isTrue == true) {
              Navigator.of(context, rootNavigator: true)
                  .pop();
              RouteGenerator.navigatorKey.currentState
                  .pushReplacementNamed(VerifyPinScreen.routeName);
            } else {
              Navigator.of(context, rootNavigator: true)
                  .pop();
              customAlertMessage(state.statusMsg,context);
              clearTextInput();
            }
          },
          child: Container(
            height: height,
            color: Colors.white,
            child: Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                    AppStrings.confirmPin,
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
                            ///...... after submitting pin keyboard will automatically destroy.
                            await _checkInternet();
                            if (pin == storedPin) {
                              ///....... here we are checking if Previously entered pin is same as confirm pin.
                              ///....... if pin is incorrect we are are navigating user back to create pin screen.else we are saving generated pin in API.
                              var _generate;
                              if (isInternetAvailable == true) {
                                showLoaderDialog(context, text: AppStrings.loading);
                                BlocProvider.of<PinScreenGenerateBloc>(context)
                                    .add(PinGenerateScreenEvent(
                                    pin, _generate, int.parse(_memberId)));
                              }
                            } else {
                              appToast.showToast(AppStrings.pinNotMatched);
                              RouteGenerator.navigatorKey.currentState
                                  .pushReplacementNamed(
                                CreatePinScreen.routeName,
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
              ],
            ),
          ));
    }
    return Scaffold(
      body: SingleChildScrollView(child: _portrait()),
    );
  }
}
