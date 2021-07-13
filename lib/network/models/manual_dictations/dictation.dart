// import 'dart:typed_data';

class PatientDictation {
  int id;
  // Uint8List audioFile;
  String dictationId;
  int episodeId;
  String attachmentName;
  int attachmentSizeBytes;
  String attachmentType;
  int memberId;
  int statusId;
  int uploadedToServer;
  String createdDate;
  String displayFileName;
  String fileName; //name of the audio file
  String physicalFileName; //path
  String patientFirstName;
  String patientLastName;
  String patientDOB;
  String dos;
  int practiceId;
  String practiceName;
  int locationId;
  String locationName;
  int providerId;
  String providerName;
  int appointmentTypeId;
  int appointmentId;
  // String CPTCodeIds;
  int dictationTypeId;
  int isEmergencyAddOn;
  int externalDocumentTypeId;
  String description;
  String appointmentProvider;
  bool isSelected;

  PatientDictation(
      {this.id,
      // this.audioFile,
      this.dictationId,
      this.episodeId,
      this.attachmentName,
      this.attachmentSizeBytes,
      this.attachmentType,
      this.memberId,
      this.statusId,
      this.uploadedToServer,
      this.createdDate,
      this.displayFileName,
      this.fileName,
      this.physicalFileName,
      this.patientFirstName,
      this.patientLastName,
      this.patientDOB,
      this.dos,
      this.practiceId,
      this.practiceName,
      this.locationId,
      this.locationName,
      this.providerId,
      this.providerName,
      this.appointmentTypeId,
      this.appointmentId,
      this.dictationTypeId,
      this.isEmergencyAddOn,
      this.externalDocumentTypeId,
      this.description,
      this.appointmentProvider,
      this.isSelected});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      // 'audioFile': audioFile,
      'dictationId': dictationId,
      'episodeId': episodeId,
      'attachmentName': attachmentName,
      'attachmentSizeBytes': attachmentSizeBytes,
      'attachmentType': attachmentType,
      'memberId': memberId,
      'statusId': statusId,
      'uploadedToServer': uploadedToServer,
      'createdDate': createdDate,
      'displayFileName': displayFileName,
      'fileName': fileName,
      'physicalFileName': physicalFileName,
      'patientFirstName': patientFirstName,
      'patientLastName': patientLastName,
      'patientDOB': patientDOB,
      'dos': dos,
      'practiceId': practiceId,
      'practiceName': practiceName,
      'locationId': locationId,
      'locationName': locationName,
      'providerId': providerId,
      'providerName': providerName,
      'appointmentTypeId': appointmentTypeId,
      // 'CPTCodeIds':CPTCodeIds,
      'dictationTypeId': dictationTypeId,
      'isEmergencyAddOn': isEmergencyAddOn,
      'externalDocumentTypeId': externalDocumentTypeId,
      'appointmentId': appointmentId,
      'description': description,
      'appointmentProvider': appointmentProvider,
      'isSelected': isSelected
    };
    return map;
  }

  PatientDictation.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    // audioFile = map['audioFile'];
    dictationId = map['dictationId'];
    episodeId = map['episodeId'];
    attachmentName = map['attachmentname'];
    attachmentSizeBytes = map['attachmentSizeBytes'];
    attachmentType = map['attachmentType'];
    memberId = map['memberid'];
    statusId = map['statusId'];
    uploadedToServer = map['uploadedtoserver'];
    createdDate = map['createddate'];
    displayFileName = map['displayfilename'];
    fileName = map['fileName'];
    physicalFileName = map['physicalfilename'];
    patientFirstName = map['patientfirstname'];
    patientLastName = map['patientlastname'];
    patientDOB = map['patientdob'];
    dos = map['dos'];
    practiceId = map['practiceId'];
    practiceName = map['practiceName'];
    locationId = map['locationId'];
    locationName = map['locationName'];
    providerId = map['providerId'];
    providerName = map['providerName'];
    appointmentTypeId = map['appointmentTypeId'];
    // CPTCodeIds = map['CPTCodeIds'];
    dictationTypeId = map['dictationtypeid'];
    isEmergencyAddOn = map['isemergencyaddon'];
    externalDocumentTypeId = map['externalDocumentTypeId'];
    description = map['description'];
    appointmentProvider = map['appointmentProvider'];
    isSelected = map['isSelected'];
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
