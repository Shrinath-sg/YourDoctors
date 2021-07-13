class SaveExternalDictationOrAttachment {
  Header header;
  int id;
  int dictationId;
  int episodeId;
  int episodeAppointmentRequestId;
  String attachmentName;
  String attachmentContent;
  int attachmentSizeBytes;
  String attachmentType;
  int memberId;
  int statusId;
  String fileName;
  int createdBy;
  String createdDate;
  bool uploadedToServer;
  String rejectionComments;
  int memberRoleId;
  int providerId;
  String attachmentPhysicalFileName;
  String patientFirstName;
  String patientLastName;
  String patientDOB;
  String dos;
  int practiceId;
  int locationId;
  String cptCodeIds;
  int appointmentTypeId;
  String displayFileName;
  bool isW9Doc;
  bool consolidatedDocExists;
  List<MemberPhotos> memberPhotos;
  String photoNameList;
  int dictationTypeId;
  int nbrMemberId;
  String nbrMemberName;
  bool isStatFile;
  int externalDocumentUploadId;
  bool isEmergencyAddOn;
  int externalDocumentTypeId;
  String description;
  String appointmentProvider;

  SaveExternalDictationOrAttachment(
      {this.header,
      this.id,
      this.dictationId,
      this.episodeId,
      this.episodeAppointmentRequestId,
      this.attachmentName,
      this.attachmentContent,
      this.attachmentSizeBytes,
      this.attachmentType,
      this.memberId,
      this.statusId,
      this.fileName,
      this.createdBy,
      this.createdDate,
      this.uploadedToServer,
      this.rejectionComments,
      this.memberRoleId,
      this.providerId,
      this.attachmentPhysicalFileName,
      this.patientFirstName,
      this.patientLastName,
      this.patientDOB,
      this.dos,
      this.practiceId,
      this.locationId,
      this.cptCodeIds,
      this.appointmentTypeId,
      this.displayFileName,
      this.isW9Doc,
      this.consolidatedDocExists,
      this.memberPhotos,
      this.photoNameList,
      this.dictationTypeId,
      this.nbrMemberId,
      this.nbrMemberName,
      this.isStatFile,
      this.externalDocumentUploadId,
      this.isEmergencyAddOn,
      this.externalDocumentTypeId,
      this.description,
      this.appointmentProvider});

  SaveExternalDictationOrAttachment.fromJson(Map<String, dynamic> json) {
    header =
        json['header'] != null ? new Header.fromJson(json['header']) : null;
    id = json['id'];
    dictationId = json['dictationId'];
    episodeId = json['episodeId'];
    episodeAppointmentRequestId = json['episodeAppointmentRequestId'];
    attachmentName = json['attachmentName'];
    attachmentContent = json['attachmentContent'];
    attachmentSizeBytes = json['attachmentSizeBytes'];
    attachmentType = json['attachmentType'];
    memberId = json['memberId'];
    statusId = json['statusId'];
    fileName = json['fileName'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    uploadedToServer = json['uploadedToServer'];
    rejectionComments = json['rejectionComments'];
    memberRoleId = json['memberRoleId'];
    providerId = json['providerId'];
    attachmentPhysicalFileName = json['attachmentPhysicalFileName'];
    patientFirstName = json['patientFirstName'];
    patientLastName = json['patientLastName'];
    patientDOB = json['patientDOB'];
    dos = json['dos'];
    practiceId = json['practiceId'];
    locationId = json['locationId'];
    cptCodeIds = json['cptCodeIds'];
    appointmentTypeId = json['appointmentTypeId'];
    displayFileName = json['displayFileName'];
    isW9Doc = json['isW9Doc'];
    consolidatedDocExists = json['consolidatedDocExists'];
    if (json['memberPhotos'] != null) {
      memberPhotos = new List<MemberPhotos>();
      json['memberPhotos'].forEach((v) {
        memberPhotos.add(new MemberPhotos.fromJson(v));
      });
    }
    photoNameList = json['photoNameList'];
    dictationTypeId = json['dictationTypeId'];
    nbrMemberId = json['nbrMemberId'];
    nbrMemberName = json['nbrMemberName'];
    isStatFile = json['isStatFile'];
    externalDocumentUploadId = json['externalDocumentUploadId'];
    isEmergencyAddOn = json['isEmergencyAddOn'];
    externalDocumentTypeId = json['externalDocumentTypeId'];
    description = json['description'];
    appointmentProvider = json['appointmentProvider'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    data['id'] = this.id;
    data['dictationId'] = this.dictationId;
    data['episodeId'] = this.episodeId;
    data['episodeAppointmentRequestId'] = this.episodeAppointmentRequestId;
    data['attachmentName'] = this.attachmentName;
    data['attachmentContent'] = this.attachmentContent;
    data['attachmentSizeBytes'] = this.attachmentSizeBytes;
    data['attachmentType'] = this.attachmentType;
    data['memberId'] = this.memberId;
    data['statusId'] = this.statusId;
    data['fileName'] = this.fileName;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['uploadedToServer'] = this.uploadedToServer;
    data['rejectionComments'] = this.rejectionComments;
    data['memberRoleId'] = this.memberRoleId;
    data['providerId'] = this.providerId;
    data['attachmentPhysicalFileName'] = this.attachmentPhysicalFileName;
    data['patientFirstName'] = this.patientFirstName;
    data['patientLastName'] = this.patientLastName;
    data['patientDOB'] = this.patientDOB;
    data['dos'] = this.dos;
    data['practiceId'] = this.practiceId;
    data['locationId'] = this.locationId;
    data['cptCodeIds'] = this.cptCodeIds;
    data['appointmentTypeId'] = this.appointmentTypeId;
    data['displayFileName'] = this.displayFileName;
    data['isW9Doc'] = this.isW9Doc;
    data['consolidatedDocExists'] = this.consolidatedDocExists;
    if (this.memberPhotos != null) {
      data['memberPhotos'] = this.memberPhotos.map((v) => v.toJson()).toList();
    }
    data['photoNameList'] = this.photoNameList;
    data['dictationTypeId'] = this.dictationTypeId;
    data['nbrMemberId'] = this.nbrMemberId;
    data['nbrMemberName'] = this.nbrMemberName;
    data['isStatFile'] = this.isStatFile;
    data['externalDocumentUploadId'] = this.externalDocumentUploadId;
    data['isEmergencyAddOn'] = this.isEmergencyAddOn;
    data['externalDocumentTypeId'] = this.externalDocumentTypeId;
    data['description'] = this.description;
    data['appointmentProvider'] = this.appointmentProvider;
    return data;
  }
}

class Header {
  String status;
  String statusCode;
  String statusMessage;

  Header({this.status, this.statusCode, this.statusMessage});

  Header.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    data['statusMessage'] = this.statusMessage;
    return data;
  }
}

class MemberPhotos {
  Header header;
  String content;
  String name;
  String attachmentType;

  MemberPhotos({this.header, this.content, this.name, this.attachmentType});

  MemberPhotos.fromJson(Map<String, dynamic> json) {
    header =
        json['header'] != null ? new Header.fromJson(json['header']) : null;
    content = json['content'];
    name = json['name'];
    attachmentType = json['attachmentType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    data['content'] = this.content;
    data['name'] = this.name;
    data['attachmentType'] = this.attachmentType;
    return data;
  }
}
