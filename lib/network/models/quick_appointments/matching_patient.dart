class MatchingPatients {
  Header header;
  List<PatientList> patientList;
  PagingInfo pagingInfo;

  MatchingPatients({this.header, this.patientList, this.pagingInfo});

  MatchingPatients.fromJson(Map<String, dynamic> json) {
    header =
    json['header'] != null ? new Header.fromJson(json['header']) : null;
    if (json['patientList'] != null) {
      patientList = new List<PatientList>();
      json['patientList'].forEach((v) {
        patientList.add(new PatientList.fromJson(v));
      });
    }
    pagingInfo = json['pagingInfo'] != null
        ? new PagingInfo.fromJson(json['pagingInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    if (this.patientList != null) {
      data['patientList'] = this.patientList.map((v) => v.toJson()).toList();
    }
    if (this.pagingInfo != null) {
      data['pagingInfo'] = this.pagingInfo.toJson();
    }
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

class PatientList {
  int patientId;
  String accountNumber;
  String caseNumber;
  int episodeId;
  String firstName;
  String lastName;
  String middleName;
  String sex;
  String dob;
  String fullName;
  String caseType;
  int caseTypeId;
  int caseTypeStateId;
  String doa;
  String caseTypeStateName;

  PatientList(
      {this.patientId,
        this.accountNumber,
        this.caseNumber,
        this.episodeId,
        this.firstName,
        this.lastName,
        this.middleName,
        this.sex,
        this.dob,
        this.fullName,
        this.caseType,
        this.caseTypeId,
        this.caseTypeStateId,
        this.doa,
        this.caseTypeStateName});

  PatientList.fromJson(Map<String, dynamic> json) {
    patientId = json['patientId'];
    accountNumber = json['accountNumber'];
    caseNumber = json['caseNumber'];
    episodeId = json['episodeId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    middleName = json['middleName'];
    sex = json['sex'];
    dob = json['dob'];
    fullName = json['fullName'];
    caseType = json['caseType'];
    caseTypeId = json['caseTypeId'];
    caseTypeStateId = json['caseTypeStateId'];
    doa = json['doa'];
    caseTypeStateName = json['caseTypeStateName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patientId'] = this.patientId;
    data['accountNumber'] = this.accountNumber;
    data['caseNumber'] = this.caseNumber;
    data['episodeId'] = this.episodeId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['middleName'] = this.middleName;
    data['sex'] = this.sex;
    data['dob'] = this.dob;
    data['fullName'] = this.fullName;
    data['caseType'] = this.caseType;
    data['caseTypeId'] = this.caseTypeId;
    data['caseTypeStateId'] = this.caseTypeStateId;
    data['doa'] = this.doa;
    data['caseTypeStateName'] = this.caseTypeStateName;
    return data;
  }
}

class PagingInfo {
  int totalItems;
  int itemsPerPage;
  int currentPage;

  PagingInfo({this.totalItems, this.itemsPerPage, this.currentPage});

  PagingInfo.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'];
    itemsPerPage = json['itemsPerPage'];
    currentPage = json['currentPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalItems'] = this.totalItems;
    data['itemsPerPage'] = this.itemsPerPage;
    data['currentPage'] = this.currentPage;
    return data;
  }
}