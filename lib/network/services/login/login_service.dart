import 'dart:async';
import 'dart:convert';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/network/models/login/login_model.dart';
import 'package:YOURDRS_FlutterAPP/network/services/log_exception/log_exception_api.dart';
import 'package:http/http.dart' as http;

class LoginApiServices {
  LogException _logException = LogException();

  /// passing the controller valued in service
  Future<AuthenticateUser> loginPostApiMethod(
      String name, String password) async {
    var client = http.Client();
    String apiUrl = ApiUrlConstants.getUser;
    final json = {
      "userName": name,
      "password": password,
    };
    try {
      http.Response response = await client.post(
        apiUrl,
        body: jsonEncode(json),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException(AppStrings.timeOutError);
      });

      var jsonResponse = jsonDecode(response.body);
      return AuthenticateUser.fromJson(jsonResponse);
    } catch (e) {
      var source = "Login Screen";
      var message =
          "An Exception occurred in the Login Screen for the LoginApi";
      _logException.logExceptionApi(e, message, source);
      print("${e.toString()}");
      // print("${e.toString()}");
      throw (e);
    } finally {
      client.close();
    }
  }
}
