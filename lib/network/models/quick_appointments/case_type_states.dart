class CaseTypeStates {
  Header header;
  List<StatesList> statesList;

  CaseTypeStates({this.header, this.statesList});

  CaseTypeStates.fromJson(Map<String, dynamic> json) {
    header =
    json['header'] != null ? new Header.fromJson(json['header']) : null;
    if (json['statesList'] != null) {
      statesList = new List<StatesList>();
      json['statesList'].forEach((v) {
        statesList.add(new StatesList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    if (this.statesList != null) {
      data['statesList'] = this.statesList.map((v) => v.toJson()).toList();
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

class StatesList {
  Header header;
  int id;
  int countryId;
  String name;
  String shortName;
  List<Cities> cities;

  StatesList(
      {this.header,
        this.id,
        this.countryId,
        this.name,
        this.shortName,
        this.cities});

  StatesList.fromJson(Map<String, dynamic> json) {
    header =
    json['header'] != null ? new Header.fromJson(json['header']) : null;
    id = json['id'];
    countryId = json['countryId'];
    name = json['name'];
    shortName = json['shortName'];
    if (json['cities'] != null) {
      cities = new List<Cities>();
      json['cities'].forEach((v) {
        cities.add(new Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    data['id'] = this.id;
    data['countryId'] = this.countryId;
    data['name'] = this.name;
    data['shortName'] = this.shortName;
    if (this.cities != null) {
      data['cities'] = this.cities.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return '$id, $name'.toLowerCase() + '$id, $name'.toUpperCase();
  }
}

class Cities {
  Header header;
  int id;
  int stateId;
  String name;
  String zip;

  Cities({this.header, this.id, this.stateId, this.name, this.zip});

  Cities.fromJson(Map<String, dynamic> json) {
    header =
    json['header'] != null ? new Header.fromJson(json['header']) : null;
    id = json['id'];
    stateId = json['stateId'];
    name = json['name'];
    zip = json['zip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    data['id'] = this.id;
    data['stateId'] = this.stateId;
    data['name'] = this.name;
    data['zip'] = this.zip;
    return data;
  }
}