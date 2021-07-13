class GetExternalDocumentDetails {
  Header header;
  int id;
  int practiceId;
  int locationId;
  int providerId;
  String patientFirstName;
  String patientLastName;
  String dob;
  bool isEmergencyAddOn;
  int externalDocumentTypeId;
  int createdBy;
  List<ExternalAttachmentsDoc> attachments;
  String description;
  String displayFileName;
  String createdDate;
  String practiceName;
  String locationName;
  String providerName;
  String externalDocumentTypeName;
  bool uploadedToServer;
  int externalAttachmentId;

  GetExternalDocumentDetails(
      {this.header,
        this.id,
        this.practiceId,
        this.locationId,
        this.providerId,
        this.patientFirstName,
        this.patientLastName,
        this.dob,
        this.isEmergencyAddOn,
        this.externalDocumentTypeId,
        this.createdBy,
        this.attachments,
        this.description,
        this.displayFileName,
        this.createdDate,
        this.practiceName,
        this.locationName,
        this.providerName,
        this.externalDocumentTypeName,
        this.uploadedToServer,
        this.externalAttachmentId});

  GetExternalDocumentDetails.fromJson(Map<String, dynamic> json) {
    header =
    json['header'] != null ? new Header.fromJson(json['header']) : null;
    id = json['id'];
    practiceId = json['practiceId'];
    locationId = json['locationId'];
    providerId = json['providerId'];
    patientFirstName = json['patientFirstName'];
    patientLastName = json['patientLastName'];
    dob = json['dob'];
    isEmergencyAddOn = json['isEmergencyAddOn'];
    externalDocumentTypeId = json['externalDocumentTypeId'];
    createdBy = json['createdBy'];
    if (json['attachments'] != null) {
      attachments = new List<ExternalAttachmentsDoc>();
      json['attachments'].forEach((v) {
        attachments.add(new ExternalAttachmentsDoc.fromJson(v));
      });
    }
    description = json['description'];
    displayFileName = json['displayFileName'];
    createdDate = json['createdDate'];
    practiceName = json['practiceName'];
    locationName = json['locationName'];
    providerName = json['providerName'];
    externalDocumentTypeName = json['externalDocumentTypeName'];
    uploadedToServer = json['uploadedToServer'];
    externalAttachmentId = json['externalAttachmentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    data['id'] = this.id;
    data['practiceId'] = this.practiceId;
    data['locationId'] = this.locationId;
    data['providerId'] = this.providerId;
    data['patientFirstName'] = this.patientFirstName;
    data['patientLastName'] = this.patientLastName;
    data['dob'] = this.dob;
    data['isEmergencyAddOn'] = this.isEmergencyAddOn;
    data['externalDocumentTypeId'] = this.externalDocumentTypeId;
    data['createdBy'] = this.createdBy;
    if (this.attachments != null) {
      data['attachments'] = this.attachments.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    data['displayFileName'] = this.displayFileName;
    data['createdDate'] = this.createdDate;
    data['practiceName'] = this.practiceName;
    data['locationName'] = this.locationName;
    data['providerName'] = this.providerName;
    data['externalDocumentTypeName'] = this.externalDocumentTypeName;
    data['uploadedToServer'] = this.uploadedToServer;
    data['externalAttachmentId'] = this.externalAttachmentId;
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

class ExternalAttachmentsDoc {
  Header header;
  String content;
  String name;
  String attachmentType;

  ExternalAttachmentsDoc({this.header, this.content, this.name, this.attachmentType});

  ExternalAttachmentsDoc.fromJson(Map<String, dynamic> json) {
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
  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}