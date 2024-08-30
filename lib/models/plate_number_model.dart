class PlateNumberModel {
  String? id;
  String? plateNumber;
  bool? isMain;

  PlateNumberModel({this.id, this.plateNumber, this.isMain});

  PlateNumberModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    plateNumber = json['plateNumber'];
    isMain = json['isMain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['plateNumber'] = plateNumber;
    data['isMain'] = isMain;
    return data;
  }
}
