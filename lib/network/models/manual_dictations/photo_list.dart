class PhotoList {
  int id;
  int dictationLocalId;
  int externalattachmentlocalid;
  String attachmentname;
  int attachmentsizebytes;
  String attachmenttype;
  String fileName;
  String physicalfilename;
  String createddate;
  int uploadToServer;

  PhotoList(
      {this.id,
      this.dictationLocalId,
      this.externalattachmentlocalid,
      this.attachmentname,
      this.attachmentsizebytes,
      this.attachmenttype,
      this.fileName,
      this.physicalfilename,
      this.createddate,
        this.uploadToServer});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'dictationlocalId': dictationLocalId,
      'externalattachmentlocalId': externalattachmentlocalid,
      'attachmentname': attachmentname,
      'attachmentsizebytes': attachmentsizebytes,
      'attachmenttype': attachmenttype,
      'physicalfilename': physicalfilename,
      'createdDate': createddate,
      'fileName': fileName,
      'uploadedtoserver': uploadToServer
    };
    return map;
  }

  PhotoList.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    dictationLocalId = map['dictationlocalId'];
    externalattachmentlocalid = map['externalattachmentlocalId'];
    attachmentname = map['attachmentname'];
    attachmentsizebytes = map['attachmentsizebytes'];
    attachmenttype = map['attachmenttype'];
    fileName = map['fileName'];
    physicalfilename = map['physicalfilename'];
    createddate = map['createdDate'];
    fileName = map['fileName'];
    uploadToServer=map['uploadedtoserver'];
  }
  String toString() {
    return toMap().toString();
  }
}
