class GetAllImages {
  String attachmentNamesList;
  Header header;

  GetAllImages({this.attachmentNamesList, this.header});

  GetAllImages.fromJson(Map<String, dynamic> json) {
    attachmentNamesList = json['attachmentNamesList'];
    header =
    json['header'] != null ? new Header.fromJson(json['header']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attachmentNamesList'] = this.attachmentNamesList;
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    return data;
  }
}

class Header {
  String status;
  String statusCode;
  Null statusMessage;

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
