class ReserveBayModel {
  String? id;
  String? userId;
  String? companyName;
  String? companyRegistration;
  String? businessType;
  String? address1;
  String? address2;
  String? address3;
  String? postcode;
  String? city;
  String? state;
  String? picFirstName;
  String? picLastName;
  String? phoneNumber;
  String? email;
  String? idNumber;
  int? totalLotRequired;
  String? reason;
  String? lotNumber;
  String? location;
  String? designatedBayPicture;
  String? registerNumberPicture;
  String? idCardPicture;
  String? createdAt;
  String? updatedAt;

  ReserveBayModel(
      {this.id,
      this.userId,
      this.companyName,
      this.companyRegistration,
      this.businessType,
      this.address1,
      this.address2,
      this.address3,
      this.postcode,
      this.city,
      this.state,
      this.picFirstName,
      this.picLastName,
      this.phoneNumber,
      this.email,
      this.idNumber,
      this.totalLotRequired,
      this.reason,
      this.lotNumber,
      this.location,
      this.designatedBayPicture,
      this.registerNumberPicture,
      this.idCardPicture,
      this.createdAt,
      this.updatedAt});

  ReserveBayModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    companyName = json['companyName'];
    companyRegistration = json['companyRegistration'];
    businessType = json['businessType'];
    address1 = json['address1'];
    address2 = json['address2'];
    address3 = json['address3'];
    postcode = json['postcode'];
    city = json['city'];
    state = json['state'];
    picFirstName = json['picFirstName'];
    picLastName = json['picLastName'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    idNumber = json['idNumber'];
    totalLotRequired = json['totalLotRequired'];
    reason = json['reason'];
    lotNumber = json['lotNumber'];
    location = json['location'];
    designatedBayPicture = json['designatedBayPicture'];
    registerNumberPicture = json['registerNumberPicture'];
    idCardPicture = json['idCardPicture'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['companyName'] = companyName;
    data['companyRegistration'] = companyRegistration;
    data['businessType'] = businessType;
    data['address1'] = address1;
    data['address2'] = address2;
    data['address3'] = address3;
    data['postcode'] = postcode;
    data['city'] = city;
    data['state'] = state;
    data['picFirstName'] = picFirstName;
    data['picLastName'] = picLastName;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['idNumber'] = idNumber;
    data['totalLotRequired'] = totalLotRequired;
    data['reason'] = reason;
    data['lotNumber'] = lotNumber;
    data['location'] = location;
    data['designatedBayPicture'] = designatedBayPicture;
    data['registerNumberPicture'] = registerNumberPicture;
    data['idCardPicture'] = idCardPicture;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
