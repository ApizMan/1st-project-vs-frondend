class CarPlateNumberModel {
  String? id;
  String? userId;
  String? plateNumber;
  bool? isMain;
  String? createdAt;
  String? updatedAt;

  CarPlateNumberModel(
      {this.id,
      this.userId,
      this.plateNumber,
      this.isMain,
      this.createdAt,
      this.updatedAt});

  CarPlateNumberModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    plateNumber = json['plateNumber'];
    isMain = json['isMain'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['plateNumber'] = plateNumber;
    data['isMain'] = isMain;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
