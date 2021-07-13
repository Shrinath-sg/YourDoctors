import 'dart:async';
import 'dart:io';

import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/network/models/login/login_model.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:YOURDRS_FlutterAPP/network/services/login/login_service.dart';
import 'package:bloc/bloc.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<FormScreenEvent, FormScreenState> {
  LoginApiServices services;

  /// creating object of service class.
  LoginBloc(this.services) : super(FormScreenState(isTrue: true));

  var errorTimeOutMsg;
  var errorSocketMsg;
  var unHandledException;
  bool isPinAvailable;
  bool isAdmin;

  ///Receiving service class instance from main.dart
  @override
  Stream<FormScreenState> mapEventToState(
    FormScreenEvent event,
  ) async* {
    try {
      if (event is FormScreenEvent) {
        AuthenticateUser authenticateUser = await services
            .loginPostApiMethod(event.email, event.password)
            .catchError((onError) {
          if (onError is SocketException) {
            errorSocketMsg = AppStrings.serverError;
          } else if (onError is TimeoutException) {
            errorTimeOutMsg = AppStrings.timeOutError;
          } else
            unHandledException = AppStrings.serverError;
        });

        /// check if the status value is 200 in response body.
        if (authenticateUser.header.statusCode == "200") {
          var memberId = authenticateUser.memberRole[0].memberId.toString();
          var displayUserName = authenticateUser.displayName;
          var userEmail = authenticateUser.userEmail;
          var profilePic = authenticateUser.profilePhoto;
          var isPINAvailable = authenticateUser.memberPin;
          var roleName = authenticateUser.memberRole[0].roleName.toString();
          for (var i = 0; i < authenticateUser.memberRole.length; i++) {
            var memberRoleId = authenticateUser.memberRole[i].roleId.toString();
            if (memberRoleId == "1") {
              isAdmin = true;
              // print(isAdmin);
              await MySharedPreferences.instance
                  .setStringValue(Keys.memberRoleId, memberRoleId);
            } else if (memberRoleId == "2") {
              isAdmin = false;
              // print(isAdmin);
              await MySharedPreferences.instance
                  .setStringValue(Keys.memberRoleId, memberRoleId);
            }
          }
          //storing member id, memberRoleId, display_pic, displayName, pin in shared preference
          await MySharedPreferences.instance
              .setStringValue(Keys.memberId, memberId);

          await MySharedPreferences.instance
              .setStringValue(Keys.displayPic, profilePic);
          await MySharedPreferences.instance
              .setStringValue(Keys.displayName, displayUserName);
          await MySharedPreferences.instance
              .setStringValue(Keys.userEmail, userEmail);
          await MySharedPreferences.instance
              .setStringValue(Keys.isPINAvailable, isPINAvailable);
          await MySharedPreferences.instance
              .setStringValue(Keys.isPINAvailable, roleName);

          if (authenticateUser.memberPin == "") {
            //here we are checking if user is having member pin or not
            //based on that we are returning true/false value to Bloc listener.
            yield FormScreenState(
              isTrue: true,
              memberId: memberId,
              isPinAvailable: isPinAvailable = false,
            );
          } else {
            yield FormScreenState(
              isTrue: true,
              memberId: memberId,
              isPinAvailable: isPinAvailable = true,
            );
          }

          /// if the status value is not true return as false
        } else {
          yield FormScreenState(isTrue: false);
        }
      }
    } catch (Exception) {
      // print(Exception);
      yield FormScreenState(
        errorMsg: errorTimeOutMsg,
        isExceptionError: errorSocketMsg,
        unHandledException: unHandledException,
      );
      // print("Exception Error");
    }
  }
}
