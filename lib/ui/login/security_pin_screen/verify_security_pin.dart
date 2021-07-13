import 'package:YOURDRS_FlutterAPP/blocs/login/pin_validation/pin_screen_validate_bloc.dart';
import 'package:YOURDRS_FlutterAPP/common/app_alertbox.dart';
import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_icons.dart';
import 'package:YOURDRS_FlutterAPP/common/app_internet_error.dart';
import 'package:YOURDRS_FlutterAPP/common/app_loader.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/common/app_toast_message.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:YOURDRS_FlutterAPP/network/services/login/pin_validate_api.dart';
import 'package:YOURDRS_FlutterAPP/ui/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:YOURDRS_FlutterAPP/ui/home/home_screen.dart';
import 'package:YOURDRS_FlutterAPP/ui/login/login_screen/loginscreen.dart';
import 'package:YOURDRS_FlutterAPP/utils/route_generator.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
final GlobalKey<State> _keyLoader = new GlobalKey<State>();

class VerifyPinScreen extends StatelessWidget {
  static const String routeName = '/VerifyPinScreen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PinScreenBloc>(
      create: (context) => PinScreenBloc(PinRepo()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: PinPutView(),
        ),
      ),
    );
  }
}

class PinPutView extends StatefulWidget {
  @override
  PinPutViewState createState() => PinPutViewState();
}

class PinPutViewState extends State<PinPutView> {
  AppToast appToast = AppToast();
  var name;
  var img;
  bool isInternetAvailable = false;
  final _formKey = GlobalKey<FormState>();
  final pinPutController = TextEditingController();
  var isItFirstTime;
  var storePin;
  var storedMemberPin;
  String isPreferenceFinger;
  List<BiometricType> listOfBiometrics;
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool isAuthenticated = false;

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isItFirstTime = (prefs.getString(Keys.isItFirstTime) ?? '');
      storedMemberPin = (prefs.getString(Keys.storedMemberPin) ?? '');
      isPreferenceFinger=(prefs.getString(Keys.isPreferenceFinger) ?? '');
    });
  }
  void  _awaitLoadData()async{
    await _loadData();
    if(isPreferenceFinger=='true'){
      _authenticateUser();
    }
  }
  @override
  void initState() {
    super.initState();
     _awaitLoadData();
  }

  clearTextInput() {
    pinPutController.clear();
  }

  ///....... checking internet connection available or not.
  Future<void> _checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isInternetAvailable = true;
      });
    } else {
      //...... I am connected to a wifi network.
      setState(() {
        isInternetAvailable = false;
      });
    }
  }

  Future<bool> _isBiometricAvailable() async {
    bool isAvailable = false;
    try {
      isAvailable = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      // print(e);
    }
    if (!mounted) return isAvailable;
    return isAvailable;
  }

  ///....... To retrieve the list of biometric types
  /// (if available).
  Future<void> _getListOfBiometricTypes() async {
    try {
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      //print(e);
    }
    if (!mounted) return;
  }

  /// Process of authentication user using
  /// biometrics.
  Future<void> _authenticateUser() async {
    try {
      isAuthenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "authenticate to access",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      // print(e);
    }
    if (!mounted) return;

    if (isAuthenticated) {
      RouteGenerator.navigatorKey.currentState
          .pushReplacementNamed(CustomBottomNavigationBar.routeName);
    }
  }

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

  void setIsItFirstTime() async {
    await MySharedPreferences.instance.setStringValue(Keys.isItFirstTime, "no");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: _mobileDisplay()),
    );
  }

  storePinInSharePref() async {
    await MySharedPreferences.instance
        .setStringValue(Keys.storedMemberPin, storePin);
  }

  Widget _mobileDisplay() {
    // TODO: implement build
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: Colors.grey[350],
      borderRadius: BorderRadius.circular(12.0),
    );
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      color: Colors.white,
      child: BlocListener<PinScreenBloc, PinScreenState>(
        listener: (context, state) {
          setState(() {
            img = state.displayPic;
            name = state.name;
          });
          if (state.timeOutMsg != null) {
            Navigator.of(context, rootNavigator: true).pop();

            customAlertMessage("server error", context);

            clearTextInput();
          } else if (state.isTrue == true) {
            setIsItFirstTime();
            storePinInSharePref();

            ///here if the response code is 200 based on that we are storing user entered pin in shared preference.
            Navigator.of(context, rootNavigator: true).pop();
            RouteGenerator.navigatorKey.currentState
                .pushReplacementNamed(CustomBottomNavigationBar.routeName);
            clearTextInput();
          } else {
            Navigator.of(context, rootNavigator: true).pop();
            customAlertMessage(AppStrings.enterValidPin, context);
            clearTextInput();
          }
        },
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
            AppStrings.enterPin,
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
                    setState(() {
                      storePin = pin;
                    });
                    FocusScope.of(context).unfocus();
                    ///after submitting pin keyboard will automatically destroy.
                    if (_formKey.currentState.validate()) {
                      var verify;
                      await _checkInternet();

                      switch (isItFirstTime) {

                        ///we are checking, is this users first time to pin screen.if it is first time then verification is done through api else it is trough sharedPref.
                        case "yes":
                          {
                            if (isInternetAvailable == true) {
                              showLoaderDialog(context,
                                  text: AppStrings.loading);
                              BlocProvider.of<PinScreenBloc>(context)
                                  .add(PinScreenEvent(
                                pin,
                                verify,
                              ));
                            } else {
                              showInternetError(context, _keyLoader);
                              clearTextInput();
                            }
                          }
                          break;
                        case "no":
                          {
                            if(!isInternetAvailable){
                            if (pin == storedMemberPin) {
                              RouteGenerator.navigatorKey.currentState
                                  .pushReplacementNamed(
                                  CustomBottomNavigationBar.routeName);
                              clearTextInput();
                            } else {
                              customAlertMessage(
                                  AppStrings.enterValidPin, context);
                              clearTextInput();
                            }
                            }else{
                              showLoaderDialog(context,
                                  text: AppStrings.loading);
                              BlocProvider.of<PinScreenBloc>(context)
                                  .add(PinScreenEvent(
                                pin,
                                verify,
                              ));
                            }
                          }
                          break;
                      }
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
          SizedBox(
            height: height * 0.01,
          ),
          GestureDetector(
            onTap: () async {
              if (await _isBiometricAvailable()) {
                await _getListOfBiometricTypes();
                await _authenticateUser();
                await MySharedPreferences.instance
                    .setStringValue(Keys.isPreferenceFinger, "true");
              }
            },
            child: Text(
              AppStrings.userTouchAndFaceId,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          SizedBox(
            height: 25,
          ),
        ]),
      ),
    );
  }
}
