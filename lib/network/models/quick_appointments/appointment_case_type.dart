class QuickAppointmentCaseType {
  Header header;
  List<CaseTypes> caseTypes;

  QuickAppointmentCaseType({this.header, this.caseTypes});

  QuickAppointmentCaseType.fromJson(Map<String, dynamic> json) {
    header =
    json['header'] != null ? new Header.fromJson(json['header']) : null;
    if (json['caseTypes'] != null) {
      caseTypes = new List<CaseTypes>();
      json['caseTypes'].forEach((v) {
        caseTypes.add(new CaseTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    if (this.caseTypes != null) {
      data['caseTypes'] = this.caseTypes.map((v) => v.toJson()).toList();
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

class CaseTypes {
  int id;
  String name;

  CaseTypes({this.id, this.name});

  CaseTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
  @override
  String toString() {
    return '$id, $name'.toLowerCase() + '$id, $name'.toUpperCase();
  }
}
