import 'dart:async';
import 'dart:io';

import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/network/models/login/pin_validate_model.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:YOURDRS_FlutterAPP/network/services/login/pin_validate_api.dart';
import 'package:bloc/bloc.dart';

part 'pin_screen_validate_event.dart';

part 'pin_screen_validate_state.dart';

class PinScreenBloc extends Bloc<PinScreenEvent, PinScreenState> {
  PinRepo pinRepo;

  ///creating object of model class for pin generation
  PinScreenBloc(this.pinRepo) : super(PinScreenState(isTrue: true));
  var timeOutMessage;

  @override
  Stream<PinScreenState> mapEventToState(
    PinScreenEvent event,
  ) async* {
    try {
      if (event is PinScreenEvent) {
        var memberId =
            await MySharedPreferences.instance.getStringValue(Keys.memberId);

        ///here we are accessing shared preference.
        PinResponse pinResponse = await pinRepo
            .pinVerifyPostApiMethod(memberId.toString(), event.pin)
            .catchError((onError) {
          if (onError is SocketException) {
            // print("internet not available");
          } else if (onError is TimeoutException) {
            timeOutMessage = AppStrings.timeOutError;
          } else
            return null;
        });

        ///passing member id and pin as request to API.
        var displayName = pinResponse.displayName;
        var profilePic = pinResponse.profilePhoto;

        if (pinResponse.header.statusCode == "200") {
          ///if response code is 200 user will be navigated to next screen.
          var username = pinResponse.userName;
          yield PinScreenState(
              isTrue: true,
              name: username,
              displayName: displayName,
              displayPic: profilePic.toString());
        } else if (pinResponse.header.statusCode == "401") {
          yield PinScreenState(isTrue: false);
        } else {
          // print('Unknown Error');
        }
      }
    } catch (exception) {
      // print('Event not fond:Error!!! => $exception');
      yield PinScreenState(
        timeOutMsg: timeOutMessage,
      );
    }
  }
}
