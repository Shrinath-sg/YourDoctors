class Practices {
  Header header;
  List<PracticeList> practiceList;

  Practices({this.header, this.practiceList});

  Practices.fromJson(Map<String, dynamic> json) {
    header =
        json['header'] != null ? new Header.fromJson(json['header']) : null;
    if (json['practiceList'] != null) {
      practiceList = new List<PracticeList>();
      json['practiceList'].forEach((v) {
        practiceList.add(new PracticeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    if (this.practiceList != null) {
      data['practiceList'] = this.practiceList.map((v) => v.toJson()).toList();
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

class PracticeList {
  Header header;
  int id;
  String name;
  String zipcode;
  String phoneNumber;
  String fax;
  String email;
  String practiceLogo;

  PracticeList(
      {this.header,
      this.id,
      this.name,
      this.zipcode,
      this.phoneNumber,
      this.fax,
      this.email,
      this.practiceLogo});

  PracticeList.fromJson(Map<String, dynamic> json) {
    header =
        json['header'] != null ? new Header.fromJson(json['header']) : null;
    id = json['id'];
    name = json['name'];
    zipcode = json['zipcode'];
    phoneNumber = json['phoneNumber'];
    fax = json['fax'];
    email = json['email'];
    practiceLogo = json['practiceLogo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    data['id'] = this.id;
    data['name'] = this.name;
    data['zipcode'] = this.zipcode;
    data['phoneNumber'] = this.phoneNumber;
    data['fax'] = this.fax;
    data['email'] = this.email;
    data['practiceLogo'] = this.practiceLogo;
    return data;
  }

  @override
  String toString() {
    return 'PracticeList{name: $name,id: $id}';
  }
}
