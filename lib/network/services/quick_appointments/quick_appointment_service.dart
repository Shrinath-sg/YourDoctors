import 'dart:convert';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/appointment_case_type.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/book_appointment.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/case_type_states.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/matching_patient.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/practice_locations.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/providers_for_practice_locations.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/quick_appointment_type.dart';
import 'package:YOURDRS_FlutterAPP/network/models/quick_appointments/time_slots.dart';
import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';
import 'package:http/http.dart' as http;
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';

class QuickAppointmentService{
  ///get quick appointment case type
  Future<QuickAppointmentCaseType> getQuickAppointmentCaseType() async {
    try {
      var endpointUrl = ApiUrlConstants.getQuickAppointmentCaseType;
      var requestUrl = endpointUrl;
      final response = await http.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        QuickAppointmentCaseType appointment = parseAppointment(response.body);
        return appointment;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
 static QuickAppointmentCaseType parseAppointment(String responsebody) {
    final QuickAppointmentCaseType appointment =
    QuickAppointmentCaseType.fromJson(json.decode(responsebody));
    return appointment;
  }

  ///get quick appointment types
  Future<QuickAppointmentType> getQuickAppointmentType() async {
    try {
      var endpointUrl = ApiUrlConstants.getQuickAppointmentTypeList;
      var requestUrl = endpointUrl;
      final response = await http.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        QuickAppointmentType appointmentList = parseAppointmentList(response.body);
        return appointmentList;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  static QuickAppointmentType parseAppointmentList(String responsebody) {
    final QuickAppointmentType appointmentTypeList =
    QuickAppointmentType.fromJson(json.decode(responsebody));
    return appointmentTypeList;
  }

  ///get quick appointment time slots
  Future<TimeSlots> getAppointmentTimeSlots() async {
    try {
      var endpointUrl = ApiUrlConstants.getQuickAppointmentTimeSlots;
      var requestUrl = endpointUrl;
      final response = await http.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        TimeSlots timeSlots = parseTimeSlots(response.body);
        return timeSlots;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  static TimeSlots parseTimeSlots(String responsebody) {
    final TimeSlots quickTimeSlots =
    TimeSlots.fromJson(json.decode(responsebody));
    return quickTimeSlots;
  }

  ///get quick appointment practice locations
   Future<PracticeLocations> getPracticeLocations() async {
    try {
      var endpointUrl = ApiUrlConstants.getPracticeLocations;
      var memberId =
      await MySharedPreferences.instance.getStringValue(Keys.memberId);

      Map<String, String> queryParams = {
        'MemberId': memberId,
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = endpointUrl + '?' + queryString;
      final response = await http.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        PracticeLocations practiceLocations = parsePracticeLocations(response.body);

        return practiceLocations;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static PracticeLocations parsePracticeLocations(String responseBody) {
    final PracticeLocations practiceLocations = PracticeLocations.fromJson(json.decode(responseBody));
    return practiceLocations;
  }

  ///get quick appointment providers
  Future<ProvidersForPracticeLocations> getProviders(
      int practiceLocationId) async {
    if (practiceLocationId != null) {
      try {
        var endpointUrl =
            ApiUrlConstants.getProvidersForPracticeLocations;
        var memberId =
        await MySharedPreferences.instance.getStringValue(Keys.memberId);

        Map<String, dynamic> queryParams = {
          'MemberId': memberId,
          'PracticeLocationId': '$practiceLocationId',
        };
        String queryString = Uri(queryParameters: queryParams).query;
        var requestUrl = endpointUrl + '?' + queryString;
        final response = await http.get(Uri.encodeFull(requestUrl),
            headers: {"Accept": "application/json"});
        if (response.statusCode == 200) {
          ProvidersForPracticeLocations providersForPracticeLocations =
          parseProvidersForPracticeLocations(response.body);
          return providersForPracticeLocations;
        } else {
          throw Exception("Error");
        }
      } catch (e) {
        throw Exception(e.toString());
      }
    }

    return null;
  }

  static ProvidersForPracticeLocations parseProvidersForPracticeLocations(String responseBody) {
    final ProvidersForPracticeLocations providersForPracticeLocations =
    ProvidersForPracticeLocations.fromJson(json.decode(responseBody));
    return providersForPracticeLocations;
  }

  /// Get matching patients
  Future<MatchingPatients> getMatchingPatients(String firstName, String lastName, String gender, String dob, int pageNumber) async {
    String apiUrl = ApiUrlConstants.getMatchingPatients;
    var client = http.Client();
    final json = {
      "firstName": "$firstName",
      "lastName": "$lastName",
      "sex": "$gender" ?? null,
      "dob": "$dob"=="" ? null : dob,
      "page": pageNumber ?? 1
    };
    try {
      http.Response response = await client.post(
        apiUrl,
        body: jsonEncode(json),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      return MatchingPatients.fromJson(jsonResponse);
    } catch (e) {
      throw Exception(e.toString());
    }
    finally{
      client.close();
    }
  }

  /// book appointment for the patient
  Future<BookAppointment> bookAppointment(
      String firstName,
      String lastName,
      String dob,
      String gender,
      int caseTypeId,
      String dateOfAccident,
      int appointmentTypeId,
      int practiceLocationId,
      int providerId,
      String dateOfService,
      String timeSlot,
      String reasonForPatient,
      int caseTypeStateId,
      bool isNewPatient,
      int episodeId,
      int patientId,
      bool isNewCase,
      ) async {
    String apiUrl = ApiUrlConstants.bookAppointment;
    var memberId =
    await MySharedPreferences.instance.getStringValue(Keys.memberId);
    var client = http.Client();
    final json = {
      "header": {
        "status": "string",
        "statusCode": "string",
        "statusMessage": "string"
      },
      "firstName": "$firstName",
      "lastName": "$lastName",
      "gender": "$gender",
      "dob": "$dob",
      "dateOfBirth": "$dob",
      "isNewPatient": isNewPatient,
      "reasonForNewPatient": "$reasonForPatient"=="" ? null : "$reasonForPatient",
      "patientId": patientId ?? null,
      "episodeId": episodeId ?? null,
      "caseTypeId": caseTypeId,
      "caseTypeStateId": caseTypeStateId ?? null,
      "dateOfAccident": "$dateOfAccident"==""?null : "$dateOfAccident",
      "isNewCase": isNewCase,
      "providerId": providerId ?? null,
      "practiceLocationId": practiceLocationId ?? null,
      "appointmentTypeId": appointmentTypeId ?? null,
      "appointmentDate": "$dateOfService" ?? null,
      "createdBy": int.tryParse(memberId),
      "appointmentId": null,
      "appointmentStatusId": null,
      "doa": "$dateOfAccident"==""?null : "$dateOfAccident",
      "startDateTime": null,
      "endDateTime": null,
      "appointmentTimeSlotXML": "$timeSlot" ?? null,
      "episodeAuthorizationId": null,
      "authorisationStatusId": null,
      "practiceId": null,
      "locationId": null
    };
    try {
      http.Response response = await client.post(
        apiUrl,
        body: jsonEncode(json),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      return BookAppointment.fromJson(jsonResponse);
    } catch (e) {
      throw Exception(e.toString());
    }
    finally{
      client.close();
    }
  }

  ///get quick appointment case type state
  Future<CaseTypeStates> getCaseTypeState() async {
    try {
      var endpointUrl = ApiUrlConstants.getCaseTypeState;
      var requestUrl = endpointUrl;
      final response = await http.get(Uri.encodeFull(requestUrl),
          headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        CaseTypeStates caseTypeState = parseCaseTypeState(response.body);
        return caseTypeState;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  static CaseTypeStates parseCaseTypeState(String responseBody) {
    final CaseTypeStates caseTypeState =
    CaseTypeStates.fromJson(json.decode(responseBody));
    return caseTypeState;
  }
}

