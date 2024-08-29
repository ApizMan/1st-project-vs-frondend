class SignUpModel {
  String? firstName;
  String? secondName;
  String? idNumber;
  String? phoneNumber;
  String? email;
  String? password;
  String? address1;
  String? address2;
  String? address3;
  String? city;
  int? postcode;
  String? state;

  SignUpModel(
      {this.firstName,
      this.secondName,
      this.idNumber,
      this.phoneNumber,
      this.email,
      this.password,
      this.address1,
      this.address2,
      this.address3,
      this.city,
      this.postcode,
      this.state});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    secondName = json['secondName'];
    idNumber = json['idNumber'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    password = json['password'];
    address1 = json['address1'];
    address2 = json['address2'];
    address3 = json['address3'];
    city = json['city'];
    postcode = json['postcode'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['secondName'] = secondName;
    data['idNumber'] = idNumber;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['password'] = password;
    data['address1'] = address1;
    data['address2'] = address2;
    data['address3'] = address3;
    data['city'] = city;
    data['postcode'] = postcode;
    data['state'] = state;
    return data;
  }
}
