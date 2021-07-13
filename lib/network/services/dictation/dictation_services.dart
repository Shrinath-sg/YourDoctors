import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/network/models/dictations/dictations_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/dictations/view_doc_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/external_dictations/get_all_manual_dictation_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/external_dictations/get_external_photos.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Get all dictations api service class
class AllDictationService {
  var client = http.Client();
  Future<Dictations> getDictations(int appointmentId) async {
    try {
      var endpointUrl = ApiUrlConstants.dictations;
      Map<String, dynamic> queryParams = {
        'AppointmentId': '$appointmentId',
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = endpointUrl + '?' + queryString;
      final response = await client.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        Dictations allDictations = parseAllDictations(response.body);
        return allDictations;
      }
    } catch (e) {
      // print(e.toString());
    } finally {
      client.close();
    }
    return null;
  }

  static Dictations parseAllDictations(String responseBody) {
    final Dictations allDictations =
        Dictations.fromJson(json.decode(responseBody));
    return allDictations;
  }
}

/// Get all previous dictations api service class
class AllPreviousDictationService {
  var client = http.Client();
  Future<Dictations> getAllPreviousDictations(
      int episodeId, int appointmentId) async {
    try {
      var endpointUrl = ApiUrlConstants.allPreviousDictations;
      Map<String, dynamic> queryParams = {
        'EpisodeID': '$episodeId',
        'AppointmentId': '$appointmentId',
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = endpointUrl + '?' + queryString;
      final response = await client.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        Dictations allPreviousDictations =
            parseAllPreviousDictations(response.body);
        return allPreviousDictations;
      }
    } catch (e) {
      // print(e.toString());
    } finally {
      client.close();
    }
    return null;
  }

  static Dictations parseAllPreviousDictations(String responseBody) {
    final Dictations allPreviousDictations =
        Dictations.fromJson(json.decode(responseBody));
    return allPreviousDictations;
  }
}

class GetManualPhotosService {
  //var client3=http.Client();
  Future<GetExternalPhotos> getManualPhotos(String photoNameList) async {
    try {
      var endpointUrl = ApiUrlConstants.getExternalPhotos;
      Map<String, dynamic> queryParams = {
        'PhysicalFileName': '$photoNameList',
      };
      String querryString = Uri(queryParameters: queryParams).query;
      var requestUrl = endpointUrl + '?' + querryString;
      // print('requestUrl $requestUrl');
      final response = await http.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
      // print('response' + response.body);
      if (response.statusCode == 200) {
        GetExternalPhotos getExternalPhotos =
            parseGetExternalPhotos(response.body);
        // print(getExternalPhotos);
        return getExternalPhotos;
      }
    } on Exception catch (e) {
      print(e.toString);
    }
    // finally{
    //   client3.close();
    // }
  }

  static GetExternalPhotos parseGetExternalPhotos(String responseBody) {
    final GetExternalPhotos getExternalPhotos =
        GetExternalPhotos.fromJson(json.decode(responseBody));
    // print(getExternalPhotos);
    return getExternalPhotos;
  }
}

/// Get my previous dictations api service class
class MyPreviousDictationService {
  var client = http.Client();
  Future<Dictations> getMyPreviousDictations(
      int episodeId, int appointmentId) async {
    try {
      var memberId =
          await MySharedPreferences.instance.getStringValue(Keys.memberId);
      var endpointUrl = ApiUrlConstants.myPreviousDictations;
      Map<String, dynamic> queryParams = {
        'EpisodeId': '$episodeId',
        'AppointmentId': '$appointmentId',
        'LoggedInMemberId': '$memberId',
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = endpointUrl + '?' + queryString;
      final response = await client.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        Dictations myPreviousDictations =
            parseMyPreviousDictations(response.body);
        return myPreviousDictations;
      }
    } catch (e) {
      // print(e.toString());
    } finally {
      client.close();
    }
    return null;
  }

  static Dictations parseMyPreviousDictations(String responseBody) {
    final Dictations myPreviousDictations =
        Dictations.fromJson(json.decode(responseBody));
    return myPreviousDictations;
  }
}

// Get All My Manual Dictations Get api
class AllMyManualDictations {
  Future<GetAllMyManualDictation> getMyManualDictations(_pageNumber) async {
    var client = http.Client();
    var memberId =
        await MySharedPreferences.instance.getStringValue(Keys.memberId);
    try {
      var endpointUrl = ApiUrlConstants.allMyManualDictationUrl;
      Map<String, dynamic> queryParams = {
        'MemberId': '$memberId',
        'PageIndex': '$_pageNumber',
      };
      String querryString = Uri(queryParameters: queryParams).query;
      var requestUrl = endpointUrl + '?' + querryString;
      final response = await client.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
      // print(requestUrl);
      if (response.statusCode == 200) {
        GetAllMyManualDictation allManualDictations =
            parseMyManualDictations(response.body);
        return allManualDictations;
      }
    } on Exception catch (e) {
      // print(e.toString);
    }
    // finally {
    //   client.close();
    // }
    return null;
  }

  static GetAllMyManualDictation parseMyManualDictations(String responseBody) {
    final GetAllMyManualDictation allManualDictations =
        GetAllMyManualDictation.fromJson(json.decode(responseBody));

    return allManualDictations;
  }
}

class ViewDocumentService {
  Future<ViewDocument> getDocument(String fileName) async {
    var client = http.Client();
    try {
      var endpointUrl = ApiUrlConstants.getTranscriptionFile;
      Map<String, String> queryParams = {
        'PhysicalFileName': fileName,
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = endpointUrl + '?' + queryString;
      final response = await client.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
//checking the condition statusCode success or not if success get data or throw the error <---------
      if (response.statusCode == 200) {
        ViewDocument document = parseLocation(response.body);
        return document;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      client.close();
    }
  }

  static ViewDocument parseLocation(String responseBody) {
    final ViewDocument document =
        ViewDocument.fromJson(json.decode(responseBody));
    return document;
  }
}
