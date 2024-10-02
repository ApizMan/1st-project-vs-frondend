class TransactionModel {
  String? description;
  String? amount;
  String? createdAt;
  Pbt? pbt;

  TransactionModel({this.description, this.amount, this.createdAt, this.pbt});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    amount = json['amount'];
    createdAt = json['createdAt'];
    pbt = json['pbt'] != null ? Pbt.fromJson(json['pbt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['amount'] = amount;
    data['createdAt'] = createdAt;
    if (pbt != null) {
      data['pbt'] = pbt!.toJson();
    }
    return data;
  }
}

class Pbt {
  String? name;

  Pbt({this.name});

  Pbt.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}
