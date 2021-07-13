class ChangePassword {
  Header header;
  int memberId;
  String userPassword;

  ChangePassword({this.header, this.memberId, this.userPassword});

  ChangePassword.fromJson(Map<String, dynamic> json) {
    header =
    json['header'] != null ? new Header.fromJson(json['header']) : null;
    memberId = json['memberId'];
    userPassword = json['userPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    data['memberId'] = this.memberId;
    data['userPassword'] = this.userPassword;
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