class AppointmentType {
  Header header;
  List<AppointmentTypeList> appointmentTypeList;

  AppointmentType({this.header, this.appointmentTypeList});

  AppointmentType.fromJson(Map<String, dynamic> json) {
    header =
        json['header'] != null ? new Header.fromJson(json['header']) : null;
    if (json['appointmentTypeList'] != null) {
      appointmentTypeList = new List<AppointmentTypeList>();
      json['appointmentTypeList'].forEach((v) {
        appointmentTypeList.add(new AppointmentTypeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    if (this.appointmentTypeList != null) {
      data['appointmentTypeList'] =
          this.appointmentTypeList.map((v) => v.toJson()).toList();
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

class AppointmentTypeList {
  int id;
  String name;
  String description;
  bool isActive;
  String createdDate;
  String modifiedDate;
  int createdBy;
  int modifiedBy;
  int durationInMinutes;
  int categoryId;
  String cptCode;
  String shortName;

  AppointmentTypeList(
      {this.id,
      this.name,
      this.description,
      this.isActive,
      this.createdDate,
      this.modifiedDate,
      this.createdBy,
      this.modifiedBy,
      this.durationInMinutes,
      this.categoryId,
      this.cptCode,
      this.shortName});

  AppointmentTypeList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isActive = json['isActive'];
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
    durationInMinutes = json['durationInMinutes'];
    categoryId = json['categoryId'];
    cptCode = json['cptCode'];
    shortName = json['shortName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['isActive'] = this.isActive;
    data['createdDate'] = this.createdDate;
    data['modifiedDate'] = this.modifiedDate;
    data['createdBy'] = this.createdBy;
    data['modifiedBy'] = this.modifiedBy;
    data['durationInMinutes'] = this.durationInMinutes;
    data['categoryId'] = this.categoryId;
    data['cptCode'] = this.cptCode;
    data['shortName'] = this.shortName;
    return data;
  }

  @override
  String toString() {
    return '$id, $name';
  }
}
