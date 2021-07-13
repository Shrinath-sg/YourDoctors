import 'dart:async';
import 'dart:convert';

import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/common/app_toast_message.dart';
import 'package:YOURDRS_FlutterAPP/network/models/user_profile/change_profile_photo.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:YOURDRS_FlutterAPP/network/services/log_exception/log_exception_api.dart';
import 'package:YOURDRS_FlutterAPP/ui/home/home_screen.dart';
import 'package:YOURDRS_FlutterAPP/utils/route_generator.dart';

import 'package:http/http.dart' as http;

class UserProfile {
  LogException _logException = LogException();

  // passing the controller valued in service
  Future<ChangeUserProfile> getChangeProfilePhoto(_img, String name) async {
    var client = http.Client();
    String apiUrl = ApiUrlConstants.UserProfile;
    String ext = (name.split(".").last);
    var memberId =
        await MySharedPreferences.instance.getStringValue(Keys.memberId);
    int nowDate = DateTime.now().millisecondsSinceEpoch;
    String fileName = memberId + '_' + nowDate.toString() + '.' + ext;
    final json = {
      "memberId": int.tryParse(memberId),
      "content": _img,
      "fileName": fileName
    };
    try {
      http.Response response = await client.post(
        apiUrl,
        body: jsonEncode(json),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {}
      var jsonResponse = jsonDecode(response.body);
      return ChangeUserProfile.fromJson(jsonResponse);
    } catch (e) {
      var source = "Change Profile Screen";
      var message = "An Exception occurred while changing user profile photo";
      _logException.logExceptionApi(e, message, source);
      // print("error ChangeUserProfile");
      throw (e);
    } finally {
      client.close();
    }
  }
}
