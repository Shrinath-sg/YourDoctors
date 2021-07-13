class GetAllExternalAttachments {
  GetAllExternalAttachments({
    this.header,
    this.externalDocumentList,
    this.pagingInfo,
  });

  Header header;
  List<ExternalDocumentList> externalDocumentList;
  PagingInfo pagingInfo;

  factory GetAllExternalAttachments.fromJson(Map<String, dynamic> json) =>
      GetAllExternalAttachments(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        externalDocumentList: json["externalDocumentList"] == null
            ? null
            : List<ExternalDocumentList>.from(json["externalDocumentList"]
                .map((x) => ExternalDocumentList.fromJson(x))),
        pagingInfo: json["pagingInfo"] == null
            ? null
            : PagingInfo.fromJson(json["pagingInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "header": header == null ? null : header.toJson(),
        "externalDocumentList": externalDocumentList == null
            ? null
            : List<dynamic>.from(externalDocumentList.map((x) => x.toJson())),
        "pagingInfo": pagingInfo == null ? null : pagingInfo.toJson(),
      };
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

class ExternalDocumentList {
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
  List<Attachments> attachments;
  String description;
  String displayFileName;
  String createdDate;
  String practiceName;
  String locationName;
  String providerName;
  String externalDocumentTypeName;
  bool uploadedToServer;
  int externalAttachmentId;

  ExternalDocumentList(
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

  ExternalDocumentList.fromJson(Map<String, dynamic> json) {
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
      attachments = new List<Attachments>();
      json['attachments'].forEach((v) {
        attachments.add(new Attachments.fromJson(v));
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

class Attachments {
  Header header;
  String content;
  String name;
  String attachmentType;

  Attachments({this.header, this.content, this.name, this.attachmentType});

  Attachments.fromJson(Map<String, dynamic> json) {
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

class PagingInfo {
  PagingInfo({
    this.totalItems,
    this.itemsPerPage,
    this.currentPage,
  });

  int totalItems;
  int itemsPerPage;
  int currentPage;

  factory PagingInfo.fromJson(Map<String, dynamic> json) => PagingInfo(
    totalItems: json["totalItems"] == null ? null : json["totalItems"],
    itemsPerPage: json["itemsPerPage"] == null ? null : json["itemsPerPage"],
    currentPage: json["currentPage"] == null ? null : json["currentPage"],
  );

  Map<String, dynamic> toJson() => {
    "totalItems": totalItems == null ? null : totalItems,
    "itemsPerPage": itemsPerPage == null ? null : itemsPerPage,
    "currentPage": currentPage == null ? null : currentPage,
  };
}

