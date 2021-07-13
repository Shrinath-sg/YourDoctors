import 'package:YOURDRS_FlutterAPP/network/repo/local/preference/local_storage.dart';

class ProvidersForPracticeLocations {
  Header header;
  List<MemberList> memberList;

  ProvidersForPracticeLocations({this.header, this.memberList});

  ProvidersForPracticeLocations.fromJson(Map<String, dynamic> json) {
    header =
    json['header'] != null ? new Header.fromJson(json['header']) : null;
    if (json['memberList'] != null) {
      memberList = new List<MemberList>();
      json['memberList'].forEach((v) {
        memberList.add(new MemberList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    if (this.memberList != null) {
      data['memberList'] = this.memberList.map((v) => v.toJson()).toList();
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

class MemberList {
  Header header;
  int memberId;
  String loginName;
  String loginPassword;
  String firstName;
  String middleName;
  String lastName;
  String gender;
  String dob;
  String address;
  String city;
  String state;
  String zipCode;
  String email;
  bool isActive;
  int statusId;
  String displayName;
  String profilePhoto;
  String fullName;
  String specialityName;
  List<MemberRoles> memberRoles;
  String appPhoneNo;
  String otp;
  int countryId;
  String countrycode;
  int locationId;
  String locationName;
  int patientId;
  bool isErxMember;
  String directEmailAddress;
  String title;

  MemberList(
      {this.header,
        this.memberId,
        this.loginName,
        this.loginPassword,
        this.firstName,
        this.middleName,
        this.lastName,
        this.gender,
        this.dob,
        this.address,
        this.city,
        this.state,
        this.zipCode,
        this.email,
        this.isActive,
        this.statusId,
        this.displayName,
        this.profilePhoto,
        this.fullName,
        this.specialityName,
        this.memberRoles,
        this.appPhoneNo,
        this.otp,
        this.countryId,
        this.countrycode,
        this.locationId,
        this.locationName,
        this.patientId,
        this.isErxMember,
        this.directEmailAddress,
        this.title});

  MemberList.fromJson(Map<String, dynamic> json) {
    header =
    json['header'] != null ? new Header.fromJson(json['header']) : null;
    memberId = json['memberId'];
    loginName = json['loginName'];
    loginPassword = json['loginPassword'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    gender = json['gender'];
    dob = json['dob'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zipCode'];
    email = json['email'];
    isActive = json['isActive'];
    statusId = json['statusId'];
    displayName = json['displayName'];
    profilePhoto = json['profilePhoto'];
    fullName = json['fullName'];
    specialityName = json['specialityName'];
    if (json['memberRoles'] != null) {
      memberRoles = new List<MemberRoles>();
      json['memberRoles'].forEach((v) {
        memberRoles.add(new MemberRoles.fromJson(v));
      });
    }
    appPhoneNo = json['appPhoneNo'];
    otp = json['otp'];
    countryId = json['countryId'];
    countrycode = json['countrycode'];
    locationId = json['locationId'];
    locationName = json['locationName'];
    patientId = json['patientId'];
    isErxMember = json['isErxMember'];
    directEmailAddress = json['directEmailAddress'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    data['memberId'] = this.memberId;
    data['loginName'] = this.loginName;
    data['loginPassword'] = this.loginPassword;
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zipCode'] = this.zipCode;
    data['email'] = this.email;
    data['isActive'] = this.isActive;
    data['statusId'] = this.statusId;
    data['displayName'] = this.displayName;
    data['profilePhoto'] = this.profilePhoto;
    data['fullName'] = this.fullName;
    data['specialityName'] = this.specialityName;
    if (this.memberRoles != null) {
      data['memberRoles'] = this.memberRoles.map((v) => v.toJson()).toList();
    }
    data['appPhoneNo'] = this.appPhoneNo;
    data['otp'] = this.otp;
    data['countryId'] = this.countryId;
    data['countrycode'] = this.countrycode;
    data['locationId'] = this.locationId;
    data['locationName'] = this.locationName;
    data['patientId'] = this.patientId;
    data['isErxMember'] = this.isErxMember;
    data['directEmailAddress'] = this.directEmailAddress;
    data['title'] = this.title;
    return data;
  }
  @override
  String toString() {
    return '$memberId, $displayName'.toLowerCase() + '$memberId, $displayName'.toUpperCase();
  }
}

class MemberRoles {
  int memberId;
  int roleId;
  String roleName;

  MemberRoles({this.memberId, this.roleId, this.roleName});

  MemberRoles.fromJson(Map<String, dynamic> json) {
    memberId = json['memberId'];
    roleId = json['roleId'];
    roleName = json['roleName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['memberId'] = this.memberId;
    data['roleId'] = this.roleId;
    data['roleName'] = this.roleName;
    return data;
  }
}