class Documenttype {
  Header header;
  List<ExternalDocumentTypesList> externalDocumentTypesList;
  Documenttype({this.header, this.externalDocumentTypesList});

  Documenttype.fromJson(Map<String, dynamic> json) {
    header =
        json['header'] != null ? new Header.fromJson(json['header']) : null;
    if (json['externalDocumentTypesList'] != null) {
      externalDocumentTypesList = new List<ExternalDocumentTypesList>();
      json['externalDocumentTypesList'].forEach((v) {
        externalDocumentTypesList
            .add(new ExternalDocumentTypesList.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    if (this.externalDocumentTypesList != null) {
      data['externalDocumentTypesList'] =
          this.externalDocumentTypesList.map((v) => v.toJson()).toList();
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

class ExternalDocumentTypesList {
  int id;
  String externalDocumentTypeName;

  ExternalDocumentTypesList({this.id, this.externalDocumentTypeName});

  ExternalDocumentTypesList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    externalDocumentTypeName = json['externalDocumentTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['externalDocumentTypeName'] = this.externalDocumentTypeName;
    return data;
  }

  @override
  String toString() {
    return '$id, $externalDocumentTypeName';
  }
}
