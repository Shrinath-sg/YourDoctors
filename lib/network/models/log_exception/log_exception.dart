
class LogExceptionError {
  String helpLink;
  String source;
  int hResult;

  LogExceptionError({this.helpLink, this.source, this.hResult});

  LogExceptionError.fromJson(Map<String, dynamic> json) {
    helpLink = json['helpLink'];
    source = json['source'];
    hResult = json['hResult'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['helpLink'] = this.helpLink;
    data['source'] = this.source;
    data['hResult'] = this.hResult;
    return data;
  }
}