import 'dart:convert';
import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/external_dictation_attachment_model.dart';
import 'package:http/http.dart' as http;

class ExternalDictationAttachment {
  var client = http.Client();
  // ignore: missing_return
  Future<SaveExternalDictationOrAttachment> postApiServiceMethod(
    int selectedPracticeId,
    int locationId,
    int providerId,
    String patientFname,
    String patientLname,
    String patientDob,
    String dos,
    String memberId,
    int externalDocTypeId,
    int appointmentTypeId,
    bool isEmergencyAddOn,
    String description,
    String attachmentTypeMp4,
    String mp4Base64,
    String attachmentNameMp4,
    var memberPhotos,
  ) async {
    DateTime defaultDate = DateTime.now();
    String apiUrl = ApiUrlConstants.allDictationsAttachment;

    // print(apiUrl);
//-------------------passing data to the api
    final json = {
      "header": {
        "status": "string",
        "statusCode": "string",
        "statusMessage": "string"
      },
      "id": null,
      "dictationId": null,
      "episodeId": null,
      "episodeAppointmentRequestId": null,
      "attachmentName": attachmentNameMp4 ?? null,
      "attachmentContent": mp4Base64 ?? null,
      "attachmentSizeBytes": null,

      "attachmentType": attachmentTypeMp4,
      "memberId": int.parse(memberId) ?? null,      "statusId": null,
      "fileName": attachmentNameMp4 ?? null,
      "createdBy": null,
      "createdDate": AppConstants.parseDate(-1, AppConstants.MMDDYYYY,
              dateTime: defaultDate) ??
          null,
      "uploadedToServer": true,
      "rejectionComments": null,
      "memberRoleId": null,
      "providerId": providerId ?? null,
      "attachmentPhysicalFileName": attachmentNameMp4,
      "patientFirstName": patientFname ?? null,
      "patientLastName": patientLname ?? null,
      "patientDOB": patientDob ?? null,
      "dos": dos ?? null,
      "practiceId": selectedPracticeId ?? null,
      "locationId": locationId ?? null,
      "cptCodeIds": null,
      "appointmentTypeId": appointmentTypeId ?? null,
      "displayFileName": attachmentNameMp4,
      "isW9Doc": null,
      "consolidatedDocExists": null,
      "memberPhotos": memberPhotos,
      "photoNameList": null,
      "dictationTypeId": null,
      "nbrMemberId": null,
      "nbrMemberName": null,
      "isStatFile": null,
      "externalDocumentUploadId": null,
      "isEmergencyAddOn": isEmergencyAddOn ?? null,
      "externalDocumentTypeId": externalDocTypeId ?? null,
      "description": description ?? null,
      "appointmentProvider": null
    };

    //--------checking  response status of Api if it is success or failure
    try {
      http.Response response = await client.post(
        apiUrl,
        body: jsonEncode(json),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var jsonResponsee = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // print(jsonResponsee);

        // print("service success");
      } else {
        // print(response.statusCode);
        // print("service fail");
      }
      return SaveExternalDictationOrAttachment.fromJson(jsonResponsee);
    } catch (e) {
      // print("This Is => $e");
    } finally {
      client.close();
    }
  }
}
