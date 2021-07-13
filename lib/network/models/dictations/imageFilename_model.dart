import 'dart:convert';

class GetFileNames {
  Header header;
  String content;
  String name;
  String attachmentType;

  GetFileNames({this.header, this.content, this.name, this.attachmentType});

  GetFileNames.fromJson(Map<String, dynamic> json) {
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
  @override
  String toString() {
    // TODO: implement toString
    return json.toString();
  }
}
