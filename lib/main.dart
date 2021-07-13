import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:YOURDRS_FlutterAPP/provider/filter_button_provider.dart';
import 'package:YOURDRS_FlutterAPP/ui/login/login_screen/splash_screen.dart';
import 'package:YOURDRS_FlutterAPP/ui/login/security_pin_screen/verify_security_pin.dart';
import 'package:YOURDRS_FlutterAPP/utils/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'blocs/dictation_screen/audio_dictation_bloc.dart';
import 'blocs/home/patient_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var login = prefs.getString(Keys.isPINAvailable);
  // StatefulProvider(
  //     valueBuilder: (_) =>  AddPizzaBloc(),
  //     dispose: (_, bloc) => bloc.dispose(),
  //     child: // ...
  // ),
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<PatientBloc>(
        create: (BuildContext context) => PatientBloc(),
      ),
      BlocProvider<AudioDictationBloc>(
        create: (BuildContext context) => AudioDictationBloc(),
      ),
    ],
    child: MultiProvider(
        providers: [
        ChangeNotifierProvider(create: (context) => FilterButtonProvider()),],
      child: MaterialApp(
        theme: ThemeData(textTheme: TextTheme(
          title: TextStyle( fontSize: 15.0, color: Colors.grey.shade600, fontWeight: FontWeight.w700,fontFamily: AppFonts.regular),
        )),
        debugShowCheckedModeBanner: false,
        title: AppStrings.title,
        home: login == null || login == "" ? SplashScreen() : VerifyPinScreen(),
        initialRoute: SplashScreen.routeName,
        onGenerateRoute: RouteGenerator.generateRoute,
        navigatorKey: RouteGenerator.navigatorKey,
      ),
    ),
  ));
}
