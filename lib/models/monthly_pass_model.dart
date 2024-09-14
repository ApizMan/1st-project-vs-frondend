class MonthlyPassModel {
  String? id;
  String? userId;
  String? plateNumber;
  String? pbt;
  String? location;
  String? amount;
  String? duration;
  String? createdAt;
  String? updatedAt;

  MonthlyPassModel(
      {this.id,
      this.userId,
      this.plateNumber,
      this.pbt,
      this.location,
      this.amount,
      this.duration,
      this.createdAt,
      this.updatedAt});

  MonthlyPassModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    plateNumber = json['plateNumber'];
    pbt = json['pbt'];
    location = json['location'];
    amount = json['amount'];
    duration = json['duration'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['plateNumber'] = plateNumber;
    data['pbt'] = pbt;
    data['location'] = location;
    data['amount'] = amount;
    data['duration'] = duration;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
