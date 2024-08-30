class PlateNumberModel {
  bool? isMain;
  String? plateNumber;

  PlateNumberModel({this.isMain, this.plateNumber});

  PlateNumberModel.fromJson(Map<String, dynamic> json) {
    isMain = json['isMain'];
    plateNumber = json['plateNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isMain'] = isMain;
    data['plateNumber'] = plateNumber;
    return data;
  }
}
