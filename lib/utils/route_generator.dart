import 'package:YOURDRS_FlutterAPP/blocs/home/patient_bloc.dart';
import 'package:YOURDRS_FlutterAPP/blocs/login/login/login_bloc.dart';
import 'package:YOURDRS_FlutterAPP/cubit/pateint_details/get_image_files_cubit.dart';
import 'package:YOURDRS_FlutterAPP/cubit/quick_appointment/matching_patient_cubit.dart';
import 'package:YOURDRS_FlutterAPP/network/services/login/login_service.dart';
import 'package:YOURDRS_FlutterAPP/ui/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:YOURDRS_FlutterAPP/ui/external_attachment/allattachment/external_localfile/externalattachment_details.dart';
import 'package:YOURDRS_FlutterAPP/ui/external_attachment/allattachment/external_serverfile/externalattachment_lists.dart';
import 'package:YOURDRS_FlutterAPP/ui/external_attachment/external_attachment.dart';
import 'package:YOURDRS_FlutterAPP/ui/home/home_screen.dart';
import 'package:YOURDRS_FlutterAPP/ui/home/patient_details.dart';
import 'package:YOURDRS_FlutterAPP/ui/home/view_images.dart';
import 'package:YOURDRS_FlutterAPP/ui/login/login_screen/loginscreen.dart';
import 'package:YOURDRS_FlutterAPP/ui/login/login_screen/splash_screen.dart';
import 'package:YOURDRS_FlutterAPP/ui/login/security_pin_screen/verify_security_pin.dart';
import 'package:YOURDRS_FlutterAPP/ui/login/user_profile/Successfullmessage.dart';
import 'package:YOURDRS_FlutterAPP/ui/login/user_profile/change_password.dart';
import 'package:YOURDRS_FlutterAPP/ui/login/user_profile/change_pin.dart';
import 'package:YOURDRS_FlutterAPP/ui/login/user_profile/conform_change_pin.dart';
import 'package:YOURDRS_FlutterAPP/ui/manual_dictaions/manual_dictations.dart';
import 'package:YOURDRS_FlutterAPP/ui/patient_dictation/dictation_type.dart';
import 'package:YOURDRS_FlutterAPP/ui/patient_dictation/dictations_list.dart';
import 'package:YOURDRS_FlutterAPP/ui/patient_dictation/offline_dictation_list.dart';
import 'package:YOURDRS_FlutterAPP/ui/quick_appointment/quick_appointment_screen.dart';
import 'package:YOURDRS_FlutterAPP/ui/quick_appointment/quick_appointments_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:YOURDRS_FlutterAPP/ui/login/security_pin_screen/create_security_pin.dart';
import 'package:YOURDRS_FlutterAPP/ui/login/security_pin_screen/confirm_pin.dart';

class RouteGenerator {
  static final navigatorKey = new GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // print("RouteGenerator->name=${settings.name}");
    switch (settings.name) {
      case CustomBottomNavigationBar.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CustomBottomNavigationBar(),
        );
      case SplashScreen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SplashScreen(),
        );

      case LoginScreen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (context) => LoginBloc(LoginApiServices()),
            child: LoginScreen(),
          ),
        );

      case PatientAppointment.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (context) => PatientBloc(),
            child: PatientAppointment(),
          ),
        );

      case VerifyPinScreen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => VerifyPinScreen(),
        );
      case CreatePinScreen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CreatePinScreen(),
        );
      case ConfirmPinScreen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ConfirmPinScreen(),
        );
      case ManualDictations.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ManualDictations(),
        );
      case ViewImages.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ViewImages(),
        );
      case ExternalAttachments.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ExternalAttachments(),
        );
      case ExternalAttachmentScreen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ExternalAttachmentScreen(),
        );
      case ExternalattachmentType.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ExternalattachmentType(),
        );

      case DictationType.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => DictationType(),
        );

      case DictationsList.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => DictationsList(),
        );

      case OfflineDictationsList.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => OfflineDictationsList(),
        );

      case QuickAppointmentScreen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (context) => MatchingPatientCubit(),
            child: QuickAppointmentScreen(),
          ),
        );

      case QuickAppointmentList.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => QuickAppointmentList(),
        );

      case PatientDetail.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<GetImageFilesCubit>(
            create: (context) => GetImageFilesCubit(),
            child: PatientDetail(),
          ),
        );

      case ChangeUserPassword.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SuccessMessage(),
        );

      case ConfirmUserPin.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CustomBottomNavigationBar(),
        );

      // case ChangeUserPIN.routeName:
      //   return MaterialPageRoute(
      //     settings: settings,
      //     builder: (_) => ChangeUserPIN(),
      //   );

      default:
        return null;
    }
  }
}
