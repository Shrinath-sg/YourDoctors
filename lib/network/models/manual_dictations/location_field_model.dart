class ExternalLocation {
  Header header;
  List<LocationList> locationList;

  ExternalLocation({this.header, this.locationList});

  ExternalLocation.fromJson(Map<String, dynamic> json) {
    header =
        json['header'] != null ? new Header.fromJson(json['header']) : null;
    if (json['locationList'] != null) {
      locationList = new List<LocationList>();
      json['locationList'].forEach((v) {
        locationList.add(new LocationList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    if (this.locationList != null) {
      data['locationList'] = this.locationList.map((v) => v.toJson()).toList();
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

class LocationList {
  Header header;
  int id;
  String name;
  bool isActive;
  String createdDate;
  int createdBy;
  String modifiedDate;
  int modifiedBy;
  String address;
  String city;
  String state;
  String zipcode;
  String phoneNumber;
  String workPhone2;
  String fax;
  String image;
  int longitude;
  int lattitude;
  int locationTypeId;
  bool usingTransportation;
  int practiceLocationId;
  int providerId;
  int locationId;
  String locationName;
  int practiceId;
  String country;
  int distanceInMiles;

  LocationList(
      {this.header,
      this.id,
      this.name,
      this.isActive,
      this.createdDate,
      this.createdBy,
      this.modifiedDate,
      this.modifiedBy,
      this.address,
      this.city,
      this.state,
      this.zipcode,
      this.phoneNumber,
      this.workPhone2,
      this.fax,
      this.image,
      this.longitude,
      this.lattitude,
      this.locationTypeId,
      this.usingTransportation,
      this.practiceLocationId,
      this.providerId,
      this.locationId,
      this.locationName,
      this.practiceId,
      this.country,
      this.distanceInMiles});

  LocationList.fromJson(Map<String, dynamic> json) {
    header =
        json['header'] != null ? new Header.fromJson(json['header']) : null;
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    createdDate = json['createdDate'];
    createdBy = json['createdBy'];
    modifiedDate = json['modifiedDate'];
    modifiedBy = json['modifiedBy'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zipcode = json['zipcode'];
    phoneNumber = json['phoneNumber'];
    workPhone2 = json['workPhone2'];
    fax = json['fax'];
    image = json['image'];
    longitude = json['longitude'];
    lattitude = json['lattitude'];
    locationTypeId = json['locationTypeId'];
    usingTransportation = json['usingTransportation'];
    practiceLocationId = json['practiceLocationId'];
    providerId = json['providerId'];
    locationId = json['locationId'];
    locationName = json['locationName'];
    practiceId = json['practiceId'];
    country = json['country'];
    distanceInMiles = json['distanceInMiles'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    data['id'] = this.id;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['createdDate'] = this.createdDate;
    data['createdBy'] = this.createdBy;
    data['modifiedDate'] = this.modifiedDate;
    data['modifiedBy'] = this.modifiedBy;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zipcode'] = this.zipcode;
    data['phoneNumber'] = this.phoneNumber;
    data['workPhone2'] = this.workPhone2;
    data['fax'] = this.fax;
    data['image'] = this.image;
    data['longitude'] = this.longitude;
    data['lattitude'] = this.lattitude;
    data['locationTypeId'] = this.locationTypeId;
    data['usingTransportation'] = this.usingTransportation;
    data['practiceLocationId'] = this.practiceLocationId;
    data['providerId'] = this.providerId;
    data['locationId'] = this.locationId;
    data['locationName'] = this.locationName;
    data['practiceId'] = this.practiceId;
    data['country'] = this.country;
    data['distanceInMiles'] = this.distanceInMiles;
    return data;
  }

  @override
  String toString() {
    return 'PracticeList{name: $name,id: $id';
  }
}
