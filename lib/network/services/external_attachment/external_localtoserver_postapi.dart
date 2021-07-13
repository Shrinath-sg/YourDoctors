
import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';
import 'package:YOURDRS_FlutterAPP/common/app_strings.dart';
import 'package:YOURDRS_FlutterAPP/network/models/manual_dictations/external_dictation_attachment_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class ExternalAttachmentDataApi {
  //var client=http.Client();
  Future<SaveExternalDictationOrAttachment> postApiServiceMethod(
      int selectedPracticeId,
      int locationId,
      int providerId,
      String patientFname,
      String patientLname,
      String patientDob,
      String memberId,
      int externalDocTypeId,
      bool isEmergencyAddOn,
      String description,
      String content,
      String name,
      String attacmentType,
      var photoListOfGallery
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
      "attachmentName": null,
      "attachmentContent": null,
      "attachmentSizeBytes": null,
      "attachmentType": null,
      "memberId":int.parse(memberId)??null,
      "statusId": null,
      "fileName": null,
      "createdBy": null,
      "createdDate": AppConstants.parseDate(-1, AppConstants.MMDDYYYY,
          dateTime: defaultDate) ?? null,
      "uploadedToServer": true,
      "rejectionComments": null,
      "memberRoleId": null,
      "providerId": providerId ?? null,
      "attachmentPhysicalFileName": null,
      "patientFirstName": patientFname ?? null,
      "patientLastName": patientLname ?? null,
      "patientDOB": patientDob ?? null,
      "dos":  null,
      "practiceId": selectedPracticeId ?? null,
      "locationId": locationId ?? null,
      "cptCodeIds": null,
      "appointmentTypeId": null,
      "displayFileName": null,
      "isW9Doc": true,
      "consolidatedDocExists": true,
      "memberPhotos":photoListOfGallery ??null,
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
   //print(json);
    //--------checking  response status of Api if it is success or failure
    try {
      http.Response response = await http.post(
        apiUrl,
        body: jsonEncode(json),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var jsonResponsee = jsonDecode(response.body);
    // print(jsonResponsee);

      if (response.statusCode == 200) {
        // print("service success");
      } else {
        // print(response.statusCode);
        // print("service fail");
      }
      return SaveExternalDictationOrAttachment.fromJson(jsonResponsee);
    } catch (e) {
      // print("This Is => $e");
    }
    // finally{
    //   client.close();
    // }
  }
}