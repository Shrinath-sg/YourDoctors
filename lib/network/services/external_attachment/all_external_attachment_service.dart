import 'dart:async';

import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/helper/db_helper.dart';
import 'package:YOURDRS_FlutterAPP/network/models/external_dictations/get_all_external_attachments_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/external_dictations/get_external_document_details.dart';
import 'package:YOURDRS_FlutterAPP/network/models/external_dictations/get_external_photos.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/appointment_type.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/document_type.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/location_field_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/practice.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/provider_model.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllMyExternalAttachments {
  var client1 = http.Client();
  //-------------------External display name api
  Future<GetAllExternalAttachments> getMyAllExternalAttachemnts(_pageNumber) async {
    // print('getMyAllExternalAttachemnts _pageNumber $_pageNumber');
    var memberId =
        await MySharedPreferences.instance.getStringValue(Keys.memberId);
    try {
      var endpointUrl = ApiUrlConstants.allMyExternalAttachmentUrl;
      Map<String, dynamic> queryParams = {
        'MemberId': '$memberId',
        'PageIndex': '$_pageNumber',
      };
      String querryString = Uri(queryParameters: queryParams).query;
      var requestUrl = endpointUrl + '?' + querryString;
      // print('requestUrl $requestUrl');
      final response = await client1.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
      // print('response' + response.body);
      if (response.statusCode == 200) {
        GetAllExternalAttachments allExternalAttachment =
            parseAllExternalAttachment(response.body);
        //  print(allExternalAttachment);
        return allExternalAttachment;
      }
    } on Exception catch (e) {
      print(e.toString);
    } finally {
      // client1.close();
    }

    return null;
  }

  static GetAllExternalAttachments parseAllExternalAttachment(
      String responseBody) {
    final GetAllExternalAttachments allExternalAttachment =
        GetAllExternalAttachments.fromJson(json.decode(responseBody));
    //print(allExternalAttachment);
    return allExternalAttachment;
  }
}

//------------------------------get external attachment details
class GetExternalDocumentDetailsService {
  var client2 = http.Client();
  Future<GetExternalDocumentDetails> getExternalDocumentDetails(
      int externalAttachmentId) async {
    try {
      var endpointUrl = ApiUrlConstants.getExternalDocumentDetails;
      Map<String, dynamic> queryParams = {
        'ExternalDocumentUploadId': '$externalAttachmentId',
      };
      String querryString = Uri(queryParameters: queryParams).query;
      var requestUrl = endpointUrl + '?' + querryString;
      print('requestUrl $requestUrl');
      final response = await client2.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
      //print('response' + response.body);
      if (response.statusCode == 200) {
        GetExternalDocumentDetails getExternalDocumentDetails =
            parseGetExternalDocumentDetails(response.body);
        // print(getExternalDocumentDetails);
        return getExternalDocumentDetails;
      }
    } on Exception catch (e) {
      print(e.toString);
    }
    // finally{
    //   client2.close();
    // }
  }

  static GetExternalDocumentDetails parseGetExternalDocumentDetails(
      String responseBody) {
    final GetExternalDocumentDetails getExternalDocumentDetails =
        GetExternalDocumentDetails.fromJson(json.decode(responseBody));
    // print(getExternalDocumentDetails);
    return getExternalDocumentDetails;
  }
}

//-----------------------------get external attachment photos
class GetExternalPhotosService {
  //var client3=http.Client();
  Future<GetExternalPhotos> getExternalPhotos(String name) async {
    try {
      var endpointUrl = ApiUrlConstants.getExternalPhotos;
      Map<String, dynamic> queryParams = {
        'PhysicalFileName': '$name',
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
class DropdownService{
  //document type service file in external attachment
  Future<List<ExternalDocumentTypesList>>
  getExternalAttachmnetDocumentType() async {
    try {
      var endpointUrl = ApiUrlConstants.getDocumenttype;

      var requestUrl = endpointUrl;

      Response response = await Dio().get(requestUrl);
      var documentType = Documenttype.fromJson(response.data);

      for (ExternalDocumentTypesList externaldocumentlist
      in documentType.externalDocumentTypesList) {
        await DatabaseHelper.db.insertDocumentType(externaldocumentlist);
      }
      return documentType.externalDocumentTypesList;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

//  document type service file in manual dictation
  Future<Documenttype> getDocumenttype() async {
    var client = http.Client();
    try {
      var endpointUrl = ApiUrlConstants.getDocumenttype;

      var requestUrl = endpointUrl;
      final response = await client.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        Documenttype document = parseDocuments(response.body);

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

  static Documenttype parseDocuments(String responseBody) {
    final Documenttype document =
    Documenttype.fromJson(json.decode(responseBody));
    return document;
  }

  ///-----------------appointment type
  Future<AppointmentType> getAppointmenttype() async {
    try {
      var endpointUrl = ApiUrlConstants.getAppointmenttype;
      var requestUrl = endpointUrl;
      final response = await http.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        AppointmentType appointment = parseAppointment(response.body);
        return appointment;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static AppointmentType parseAppointment(String responsebody) {
    final AppointmentType appointment =
    AppointmentType.fromJson(json.decode(responsebody));
    return appointment;
  }

  ///------------Practice service method

  Future<Practices> getPratices() async {
    try {
      var endpointUrl = ApiUrlConstants.getPractices;
      var memberId =
      await MySharedPreferences.instance.getStringValue(Keys.memberId);

      Map<String, String> queryParams = {
        'LoggedInMemberId': memberId,
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = endpointUrl + '?' + queryString;
      final response = await http.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        Practices practice = parsePractices(response.body);

        return practice;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Practices parsePractices(String responseBody) {
    final Practices practice = Practices.fromJson(json.decode(responseBody));
    return practice;
  }

  ///-------------Location service method
  Future<ExternalLocation> getExternalLocation(String PracticeIdList) async {
    try {
      var endpointUrl = ApiUrlConstants.getExternalLocation;
      var memberId =
      await MySharedPreferences.instance.getStringValue(Keys.memberId);

      Map<String, String> queryParams = {
        'LoggedInMemberId': memberId,
        'PracticeIdList': PracticeIdList,
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = endpointUrl + '?' + queryString;
      final response = await http.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        ExternalLocation externalLocation =
        parseExternalLocation(response.body);

        return externalLocation;
      }
      // else {
      //   throw Exception("Error");
      // }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static ExternalLocation parseExternalLocation(String responseBody) {
    final ExternalLocation externalLocation =
    ExternalLocation.fromJson(json.decode(responseBody));
    return externalLocation;
  }

  //------------------Providers service
  Future<ExternalProvider> getExternalProvider(
      String PracticeLocationId) async {
    // if (PracticeLocationId != null) {
    try {
      var endpointUrl =
          ApiUrlConstants.getProvidersforSelectedPracticeLocation;
      var memberId =
      await MySharedPreferences.instance.getStringValue(Keys.memberId);

      Map<String, String> queryParams = {
        'LoggedInMemberId': memberId,
        'PracticeLocationId': PracticeLocationId,
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = endpointUrl + '?' + queryString;
      final response = await http.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        ExternalProvider externalProvider =
        parseExternalProvider(response.body);
        return externalProvider;
      }
      // else {
      //   throw Exception("Error");
      // }
    } catch (e) {
      print('${e.toString()}');
      // throw Exception(e.toString());
    }
    // }

    return null;
  }

  static ExternalProvider parseExternalProvider(String responseBody) {
    final ExternalProvider externalProvider =
    ExternalProvider.fromJson(json.decode(responseBody));
    return externalProvider;
  }

}
