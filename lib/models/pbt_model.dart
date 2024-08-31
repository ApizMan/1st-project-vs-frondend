class PBTModel {
  String? id;
  String? name;
  String? description;
  String? createdAt;
  String? updatedAt;

  PBTModel(
      {this.id, this.name, this.description, this.createdAt, this.updatedAt});

  PBTModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
