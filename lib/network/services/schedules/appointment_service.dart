import 'dart:convert';
import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/helper/db_helper.dart';
import 'package:YOURDRS_FlutterAPP/network/models/home/profilephotos.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/appointment_type.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/document_type.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/location_field_model.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/practice.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/provider_model.dart';
import '../../models/home/appointment.dart';
import '../../models/home/location.dart';
import '../../models/home/provider.dart';
import '../../models/home/schedule.dart';

class Services {
  static const String url = 'https://jsonplaceholder.typicode.com/users';

//------> getUsers service method also maintaining exception handling <---------
  static Future<List<Patients>> getUsers() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<Patients> list = parseUsers(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

// ------> mapping the data come from the model class Patients <---------
  static List<Patients> parseUsers(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Patients>((json) => Patients.fromJson(json)).toList();
  }

// ------> getSchedule service method also maintaining exception handling
  static Future<List<ScheduleList>> getSchedule(
      String date,
      int providerId,
      int locationId,
      int dictationId,
      String startDate,
      String endDate,
      String searchString,
      int memberId,
      int pageKey,
      CancelToken token) async {
    String apiUrl = ApiUrlConstants.getSchedules;
    DateTime defaultDate = DateTime.now();
    var todayDate = AppConstants.parseDate(-1, AppConstants.MMDDYYYY,
        dateTime: defaultDate);
    final json = {
      "memberId": memberId ?? null,
      "appointmentStartDate": startDate != null
          ? startDate
          : date == null
              ?null:date,
      "appointmentEndDate": endDate != null
          ? endDate
          : date == null
              ?null:date,
      "locationId": locationId ?? null,
      "patientSearchString": searchString ?? null,
      "dictationStatusId": dictationId ?? null,
      "providerId": providerId ?? null,
      "page": pageKey ?? 1
    };
    print(json);
    Response response;
    Dio dio = new Dio();
    response = await dio
        .post(apiUrl,
            data: jsonEncode(json),
            options: Options(headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            }))
        .catchError((e) {
      if (CancelToken.isCancel(e)) {
        print('$apiUrl: $e');
      }
    });

// ------> checking the condition statusCode success or not if success get data or throw the error <---------
    try {
      if (response.statusCode == 200) {
        Schedule schedule = Schedule.fromJson(response.data);
        return schedule.scheduleList;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }


// API call for getCountForPracticeLocationLevelOfGrouping

static Future<List<ScheduleGroupList>> getScheduleCountForPracticeLocation(
      String date,
      int providerId,
      int locationId,
      int dictationId,
      String startDate,
      String endDate,
      String searchString,
      int memberId,
      int pageKey,
      CancelToken token) async {
    String apiUrl = ApiUrlConstants.getSchedules;
    DateTime defaultDate = DateTime.now();
    var todayDate = AppConstants.parseDate(-1, AppConstants.MMDDYYYY,
        dateTime: defaultDate);
    final json = {
       "memberId": memberId ?? null,
      "appointmentStartDate": startDate != null
          ? startDate
          : date == null
              ?null:date,
      "appointmentEndDate": endDate != null
          ? endDate
          : date == null
              ?null:date,
      "locationId": locationId ?? null,
      "patientSearchString": searchString ?? null,
      "dictationStatusId": dictationId ?? null,
      "providerId": providerId ?? null,
      "page": pageKey ?? 1
    };
    print(json);
    Response response;
    Dio dio = new Dio();
    response = await dio
        .post(apiUrl,
            data: jsonEncode(json),
            options: Options(headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            }))
        .catchError((e) {
      if (CancelToken.isCancel(e)) {
        print('$apiUrl: $e');
      }
    });

// ------> checking the condition statusCode success or not if success get data or throw the error <---------
    try {
      if (response.statusCode == 200) {
        Schedule schedule = Schedule.fromJson(response.data);
        return schedule.scheduleGroupList;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

// API call for getCountForPracticeLocationLevelOfGrouping


// API call for getGroupByPracticeLocationForAppointments
Future<List<ScheduleList>> getScheduleForPracticeLocations(
      String date,
      int providerId,
      int locationId,
      int dictationId,
      String startDate,
      String endDate,
      String searchString,
      int pageKey,
      // CancelToken token,
      int practiceLocationId) async {
    String apiUrl = ApiUrlConstants.getSchedulesForPracticeLocations;
    DateTime defaultDate = DateTime.now();
    var todayDate = AppConstants.parseDate(-1, AppConstants.MMDDYYYY,
        dateTime: defaultDate);
            var memberId =
        await MySharedPreferences.instance.getStringValue(Keys.memberId);
    final json = {
       "memberId":int.tryParse(memberId)  ?? null,
      "appointmentStartDate": startDate != null
          ? startDate
          : date == null
              ?null:date,
      "appointmentEndDate":endDate != null
          ? endDate
          : date == null
              ?null:date,
      "locationId": locationId ?? null,
      "patientSearchString": searchString ?? null,
      "dictationStatusId": dictationId ?? null,
      "providerId": providerId ?? null,
      "practiceLocationId":practiceLocationId??null,
      "page": pageKey ?? 1
    };
    print(json);
    Response response;
    Dio dio = new Dio();
    response = await dio
        .post(apiUrl,
            data: jsonEncode(json),
            options: Options(headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            }))
        .catchError((e) {
      if (CancelToken.isCancel(e)) {
        print('$apiUrl: $e');
      }
    });

// ------> checking the condition statusCode success or not if success get data or throw the error <---------
    try {
      if (response.statusCode == 200) {
        Schedule schedule = Schedule.fromJson(response.data);
        return schedule.scheduleList;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }


// API call for getGroupByPracticeLocationForAppointments









//get patientProfile photos for appointments//
  Future<PatientProfilePhotos> getPatientProfilePhotos(
      String profilePhotoName) async {
    if (profilePhotoName == null || profilePhotoName == "") {
      return null;
    }
    var client = http.Client();
    try {
      var endpointUrl = ApiUrlConstants.getProfilePhotos;
      Map<String, String> queryParams = {'FileName': profilePhotoName};
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = endpointUrl + '?' + queryString;
      final response = await client.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
      PatientProfilePhotos patientProfilePhotos =
          parseProfilePhotos(response.body);
      if (patientProfilePhotos.header.statusCode == "200") {
        return patientProfilePhotos;
      } else {
        throw Exception(patientProfilePhotos.header.statusMessage);
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      client.close();
    }
  }

  static PatientProfilePhotos parseProfilePhotos(String responseBody) {
    final PatientProfilePhotos patientProfilePhotos =
        PatientProfilePhotos.fromJson(json.decode(responseBody));
    return patientProfilePhotos;
  }

// get patientProfile photos for appointments

// ------> getLocation service method also maintaining exception handling

  Future<Locations> getLocation() async {
    var client = http.Client();
    var memberId =
        await MySharedPreferences.instance.getStringValue(Keys.memberId);
    try {
      var endpointUrl = ApiUrlConstants.getLocation;
      Map<String, String> queryParams = {
        'MemberId': memberId,
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = endpointUrl + '?' + queryString;
      final response = await client.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
//checking the condition statusCode success or not if success get data or throw the error <---------
      if (response.statusCode == 200) {
        Locations location = parseLocation(response.body);

        return location;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      client.close();
    }
  }

// ------> mapping the data come from the model class Locations <---------
  static Locations parseLocation(String responseBody) {
    final Locations location = Locations.fromJson(json.decode(responseBody));
    return location;
  }

// ------> getProviders service also maintaining exception handling
  Future<Providers> getProviders() async {
    var client = http.Client();
    var memberId =
        await MySharedPreferences.instance.getStringValue(Keys.memberId);
    try {
      var endpointUrl = ApiUrlConstants.getProviders;
      Map<String, String> queryParams = {
        'MemberId': memberId,
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = endpointUrl + '?' + queryString;
      final response = await client.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
// ------> checking the condition statusCode success or not if success get data or throw the error <---------
      if (response.statusCode == 200) {
        Providers provider = parseProviders(response.body);

        return provider;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      client.close();
    }
  }

// ------> mapping the data come from the model class Providers <---------
  static Providers parseProviders(String responseBody) {
    final Providers provider = Providers.fromJson(json.decode(responseBody));
    return provider;
  }


}
