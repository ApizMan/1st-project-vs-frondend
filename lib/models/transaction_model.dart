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
    pbt = json['pbt'] != null ? new Pbt.fromJson(json['pbt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['amount'] = this.amount;
    data['createdAt'] = this.createdAt;
    if (this.pbt != null) {
      data['pbt'] = this.pbt!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
