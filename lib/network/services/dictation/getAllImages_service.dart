import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/network/models/dictations/allImages_models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetAllDictationImages {
  var client = http.Client();
  Future<GetAllImages> getImages(int dictationId) async {
    try {
      var endpointUrl = ApiUrlConstants.getAllImages;
      Map<String, dynamic> queryParams = {
        'DictationId': '$dictationId',
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = endpointUrl + '?' + queryString;
      final response = await client.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        GetAllImages allPreviousDictations =
        parseAllImages(response.body);
        return allPreviousDictations;
      }
    } catch (e) {
      // print(e.toString());
    }
    // finally {
    //   client.close();
    // }
  }
    static GetAllImages parseAllImages(String responseBody) {
      final GetAllImages allDictations =
      GetAllImages.fromJson(json.decode(responseBody));
      return allDictations;
    }

}
