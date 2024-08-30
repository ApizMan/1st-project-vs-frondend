import 'package:project/models/models.dart';
import 'package:project/models/reserve_bay_model.dart';

class UserModel {
  String? id;
  String? email;
  String? firstName;
  String? secondName;
  String? idNumber;
  String? phoneNumber;
  String? address1;
  String? address2;
  String? address3;
  String? city;
  String? state;
  int? postcode;
  WalletModel? wallet;
  List<PlateNumberModel>? plateNumbers;
  List<ReserveBayModel>? reserveBays;

  UserModel(
      {this.id,
      this.email,
      this.firstName,
      this.secondName,
      this.idNumber,
      this.phoneNumber,
      this.address1,
      this.address2,
      this.address3,
      this.city,
      this.state,
      this.postcode,
      this.wallet,
      this.plateNumbers,
      this.reserveBays});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['firstName'];
    secondName = json['secondName'];
    idNumber = json['idNumber'];
    phoneNumber = json['phoneNumber'];
    address1 = json['address1'];
    address2 = json['address2'];
    address3 = json['address3'];
    city = json['city'];
    state = json['state'];
    postcode = json['postcode'];
    wallet = json['wallet'] != null
        ? WalletModel.fromJson(json['wallet'])
        : null;
    if (json['plateNumbers'] != null) {
      plateNumbers = <PlateNumberModel>[];
      json['plateNumbers'].forEach((v) {
        plateNumbers!.add(PlateNumberModel.fromJson(v));
      });
    }
    if (json['reserveBays'] != null) {
      reserveBays = <ReserveBayModel>[];
      json['reserveBays'].forEach((v) {
        reserveBays!.add(ReserveBayModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['firstName'] = firstName;
    data['secondName'] = secondName;
    data['idNumber'] = idNumber;
    data['phoneNumber'] = phoneNumber;
    data['address1'] = address1;
    data['address2'] = address2;
    data['address3'] = address3;
    data['city'] = city;
    data['state'] = state;
    data['postcode'] = postcode;
    if (wallet != null) {
      data['wallet'] = wallet!.toJson();
    }
    if (plateNumbers != null) {
      data['plateNumbers'] = plateNumbers!.map((v) => v.toJson()).toList();
    }
    if (reserveBays != null) {
      data['reserveBays'] = reserveBays!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
