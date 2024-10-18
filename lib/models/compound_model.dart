import 'package:project/models/models.dart';

class CompoundModel {
  String? actionCode;
  String? responseCode;
  String? responseMessage;
  List<SummonModel>? summonses;

  CompoundModel(
      {this.actionCode,
      this.responseCode,
      this.responseMessage,
      this.summonses});

  CompoundModel.fromJson(Map<String, dynamic> json) {
    actionCode = json['actionCode'];
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    if (json['summonses'] != null) {
      summonses = <SummonModel>[];
      json['summonses'].forEach((v) {
        summonses!.add(SummonModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['actionCode'] = actionCode;
    data['responseCode'] = responseCode;
    data['responseMessage'] = responseMessage;
    if (summonses != null) {
      data['summonses'] = summonses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}