import 'dart:async';
import 'dart:convert';

import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';

import 'package:YOURDRS_FlutterAPP/network/models/user_profile/change_password.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:YOURDRS_FlutterAPP/network/services/log_exception/log_exception_api.dart';

import 'package:http/http.dart' as http;

class ResetUserPassword {
  var resetPassword;
  LogException _logException = LogException();

  /// passing the controller valued in service
  Future<ChangePassword> reSetPassword(
    String resetPassword,
  ) async {
    var client = http.Client();
    String apiUrl = ApiUrlConstants.UserPassword;
    var memberId =
        await MySharedPreferences.instance.getStringValue(Keys.memberId);
    print(memberId);
    print(resetPassword);
    final json = {
      "memberId": int.tryParse(memberId),
      "userPassword": resetPassword
    };
    try {
      http.Response response = await client.post(
        apiUrl,
        body: jsonEncode(json),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        // print("Success password updated");
      }
      var jsonResponse = jsonDecode(response.body);
      // print(jsonResponse);
      return ChangePassword.fromJson(jsonResponse);
    } catch (e) {
      var source = "Change Password Screen";
      var message =
          "An Exception occurred while changing user password";
      _logException.logExceptionApi(e, message, source);
      print("${e.toString()}");
      // throw (e);
    } finally {
      client.close();
    }
  }
}
