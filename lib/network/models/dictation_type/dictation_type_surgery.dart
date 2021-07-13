class DictationTypeSurgery {
  DictationTypeSurgery({
    this.dictationTypeId,
    this.dictationType,
    this.appointmentType,
  });
  String dictationTypeId;
  String dictationType;
  String appointmentType;
  factory DictationTypeSurgery.fromJson(Map<String, dynamic> json) =>
      DictationTypeSurgery(
        dictationTypeId:
            json["dictationTypeId"] == null ? null : json["dictationTypeId"],
        dictationType:
            json["dictationType"] == null ? null : json["dictationType"],
        appointmentType:
            json["appointmentType"] == null ? null : json["appointmentType"],
      );

  Map<String, dynamic> toJson() => {
        "dictationTypeId": dictationTypeId == null ? null : dictationTypeId,
        "dictationType": dictationType == null ? null : dictationType,
        "appointmentType": appointmentType == null ? null : appointmentType,
      };

  @override
  String toString() {
    return 'DictationTypeSurgery{dictationType: $dictationType, dictationTypeId: $dictationTypeId';
  }
}
