class PromotionMonthlyPassModel {
  String? id;
  String? title;
  String? description;
  String? type;
  int? timeUse;
  String? rate;
  String? date;
  String? expiredDate;
  String? image;
  String? createdAt;
  String? updatedAt;

  PromotionMonthlyPassModel(
      {this.id,
      this.title,
      this.description,
      this.type,
      this.timeUse,
      this.rate,
      this.date,
      this.expiredDate,
      this.image,
      this.createdAt,
      this.updatedAt});

  PromotionMonthlyPassModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    type = json['type'];
    timeUse = json['timeUse'];
    rate = json['rate'];
    date = json['date'];
    expiredDate = json['expiredDate'];
    image = json['image'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['type'] = type;
    data['timeUse'] = timeUse;
    data['rate'] = rate;
    data['date'] = date;
    data['expiredDate'] = expiredDate;
    data['image'] = image;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
