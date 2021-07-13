import 'dart:convert';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:YOURDRS_FlutterAPP/network/models/log_exception/log_exception.dart';

class LogException {
  // ignore: missing_return
  Future<LogExceptionError> logExceptionApi(error, message,source) async {
    // var
    // client = http.Client();
    String apiUrl = ApiUrlConstants.logException;
    final json = {
      "exMessage": message,
      "exSource": source,
      "exStackTrace": error.toString(),
      "exTargetSite": "string"
    };
    print(json);
    Response response;
    Dio dio = new Dio();
    response = await dio.post(apiUrl,
        data: jsonEncode(json),
        options: Options(headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        }));
    try {
      if (response.statusCode == 200) {
        print("success");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

}
