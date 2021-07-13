import 'dart:convert';

import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/network/models/dictations/imageFilename_model.dart';
import 'package:http/http.dart' as http;

class GetImage {
  var client = http.Client();
  Future<GetFileNames> getImageFile(String physicalFileName) async {
    try {
      var endpointUrl = ApiUrlConstants.getImageFile;
      Map<String, dynamic> queryParams = {
        'FileName': '$physicalFileName',
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = endpointUrl + '?' + queryString;
      final response = await client.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        GetFileNames getFileNames = parsePlayDictations(response.body);
        return getFileNames;
      }
    } catch (e) {
      // print(e.toString());
    }
    // finally{
    //   client.close();
    // }
  }

  static GetFileNames parsePlayDictations(String responseBody) {
    final GetFileNames getFileName =
    GetFileNames.fromJson(json.decode(responseBody));
    return getFileName;
  }
}