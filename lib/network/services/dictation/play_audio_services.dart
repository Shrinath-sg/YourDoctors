import 'dart:convert';

import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/network/models/dictations/dictations_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/dictations/play_dictations.dart';

import 'package:http/http.dart' as http;

/// play audios api service class
class PlayAllAudioDictations {
  var client = http.Client();
  Future<PlayDictations> getDictationsPlayAudio(String physicalFileName) async {
    try {
      var endpointUrl = ApiUrlConstants.playAudios;
      Map<String, dynamic> queryParams = {
        'PhysicalFileName': '$physicalFileName',
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = endpointUrl + '?' + queryString;
      final response = await client.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        PlayDictations playDictations = parsePlayDictations(response.body);
        return playDictations;
      }
    } catch (e) {
      print(e.toString());
    }
    finally{
      client.close();
    }
  }

  static PlayDictations parsePlayDictations(String responseBody) {
    final PlayDictations playDictations =
    PlayDictations.fromJson(json.decode(responseBody));
    return playDictations;
  }
}