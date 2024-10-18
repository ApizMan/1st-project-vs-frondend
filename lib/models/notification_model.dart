class NotificationModel {
  String? id;
  String? userId;
  String? title;
  String? description;
  String? notifyTime;
  int? statusRead;
  String? parkingId;
  String? reserveBayId;
  String? monthlyPassId;
  String? createdAt;
  String? updatedAt;

  NotificationModel(
      {this.id,
      this.userId,
      this.title,
      this.description,
      this.notifyTime,
      this.statusRead,
      this.parkingId,
      this.reserveBayId,
      this.monthlyPassId,
      this.createdAt,
      this.updatedAt});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    title = json['title'];
    description = json['description'];
    notifyTime = json['notifyTime'];
    statusRead = json['statusRead'];
    parkingId = json['parkingId'];
    reserveBayId = json['reserveBayId'];
    monthlyPassId = json['monthlyPassId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['title'] = title;
    data['description'] = description;
    data['notifyTime'] = notifyTime;
    data['statusRead'] = statusRead;
    data['parkingId'] = parkingId;
    data['reserveBayId'] = reserveBayId;
    data['monthlyPassId'] = monthlyPassId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
