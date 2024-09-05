class CompoundModel {
  int? compoundAmount;
  String? noticeNo;
  String? vehicleMakeModel;
  String? vehicleNo;
  String? vehicleType;

  CompoundModel(
      {this.compoundAmount,
      this.noticeNo,
      this.vehicleMakeModel,
      this.vehicleNo,
      this.vehicleType});

  CompoundModel.fromJson(Map<String, dynamic> json) {
    compoundAmount = json['CompoundAmount'];
    noticeNo = json['NoticeNo'];
    vehicleMakeModel = json['VehicleMakeModel'];
    vehicleNo = json['VehicleNo'];
    vehicleType = json['VehicleType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CompoundAmount'] = compoundAmount;
    data['NoticeNo'] = noticeNo;
    data['VehicleMakeModel'] = vehicleMakeModel;
    data['VehicleNo'] = vehicleNo;
    data['VehicleType'] = vehicleType;
    return data;
  }
}
