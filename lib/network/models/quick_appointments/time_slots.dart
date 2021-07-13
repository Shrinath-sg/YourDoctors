class TimeSlots {
  Header header;
  List<AppointmentTimeSlots> appointmentTimeSlots;

  TimeSlots({this.header, this.appointmentTimeSlots});

  TimeSlots.fromJson(Map<String, dynamic> json) {
    header =
    json['header'] != null ? new Header.fromJson(json['header']) : null;
    if (json['appointmentTimeSlots'] != null) {
      appointmentTimeSlots = new List<AppointmentTimeSlots>();
      json['appointmentTimeSlots'].forEach((v) {
        appointmentTimeSlots.add(new AppointmentTimeSlots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    if (this.appointmentTimeSlots != null) {
      data['appointmentTimeSlots'] =
          this.appointmentTimeSlots.map((v) => v.toJson()).toList();
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

class AppointmentTimeSlots {
  Header header;
  int id;
  String time;
  String standardTime;
  String startDateTime;
  String endDateTime;

  AppointmentTimeSlots(
      {this.header,
        this.id,
        this.time,
        this.standardTime,
        this.startDateTime,
        this.endDateTime});

  AppointmentTimeSlots.fromJson(Map<String, dynamic> json) {
    header =
    json['header'] != null ? new Header.fromJson(json['header']) : null;
    id = json['id'];
    time = json['time'];
    standardTime = json['standardTime'];
    startDateTime = json['startDateTime'];
    endDateTime = json['endDateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    data['id'] = this.id;
    data['time'] = this.time;
    data['standardTime'] = this.standardTime;
    data['startDateTime'] = this.startDateTime;
    data['endDateTime'] = this.endDateTime;
    return data;
  }

  @override
  String toString() {
    return '$id, $standardTime'.toLowerCase() + '$id, $standardTime'.toUpperCase();
  }
}