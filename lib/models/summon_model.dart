class SummonModel {
  String? noticeNo;
  String? vehicleRegistrationNo;
  String? offenceAct;
  String? offenceSection;
  String? offenceDescription;
  String? offenceLocation;
  String? offenceDate;
  String? noticeStatus;
  String? amount;

  SummonModel(
      {this.noticeNo,
      this.vehicleRegistrationNo,
      this.offenceAct,
      this.offenceSection,
      this.offenceDescription,
      this.offenceLocation,
      this.offenceDate,
      this.noticeStatus,
      this.amount});

  SummonModel.fromJson(Map<String, dynamic> json) {
    noticeNo = json['noticeNo'];
    vehicleRegistrationNo = json['vehicleRegistrationNo'];
    offenceAct = json['offenceAct'];
    offenceSection = json['offenceSection'];
    offenceDescription = json['offenceDescription'];
    offenceLocation = json['offenceLocation'];
    offenceDate = json['offenceDate'];
    noticeStatus = json['noticeStatus'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['noticeNo'] = noticeNo;
    data['vehicleRegistrationNo'] = vehicleRegistrationNo;
    data['offenceAct'] = offenceAct;
    data['offenceSection'] = offenceSection;
    data['offenceDescription'] = offenceDescription;
    data['offenceLocation'] = offenceLocation;
    data['offenceDate'] = offenceDate;
    data['noticeStatus'] = noticeStatus;
    data['amount'] = amount;
    return data;
  }
}
