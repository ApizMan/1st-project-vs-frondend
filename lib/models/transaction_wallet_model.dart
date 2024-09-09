class TransactionWalletModel {
  double? amount;
  String? status;
  String? createdAt;

  TransactionWalletModel({this.amount, this.status, this.createdAt});

  TransactionWalletModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['status'] = status;
    data['createdAt'] = createdAt;
    return data;
  }
}