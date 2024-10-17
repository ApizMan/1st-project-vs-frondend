class PromotionMonthlyPassHistoryModel {
  String? id;
  String? userId;
  String? promotionId;
  int? timeUse;
  String? createdAt;
  String? updatedAt;

  PromotionMonthlyPassHistoryModel(
      {this.id,
      this.userId,
      this.promotionId,
      this.timeUse,
      this.createdAt,
      this.updatedAt});

  PromotionMonthlyPassHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    promotionId = json['promotionId'];
    timeUse = json['timeUse'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['promotionId'] = promotionId;
    data['timeUse'] = timeUse;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
