class WalletModel {
  int? amount;

  WalletModel({this.amount});

  WalletModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    return data;
  }
}
