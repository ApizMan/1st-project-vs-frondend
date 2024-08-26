import 'dart:convert';

List<Infouser> infouserFromJson(String str) => List<Infouser>.from(json.decode(str).map((x) => Infouser.fromJson(x)));

String infouserToJson(List<Infouser> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Infouser {
    String id;
    String name;
    String icNumber;
    String numPhone;
    String numPlate;
    String username;
    String password;
    String conPassword;

    Infouser({
        required this.id,
        required this.name,
        required this.icNumber,
        required this.numPhone,
        required this.numPlate,
        required this.username,
        required this.password,
        required this.conPassword,
    });

    factory Infouser.fromJson(Map<String, dynamic> json) => Infouser(
        id: json["Id"],
        name: json["Name"],
        icNumber: json["IcNumber"],
        numPhone: json["NumPhone"],
        numPlate: json["NumPlate"],
        username: json["Username"],
        password: json["Password"],
        conPassword: json["ConPassword"],
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "IcNumber": icNumber,
        "NumPhone": numPhone,
        "NumPlate": numPlate,
        "Username": username,
        "Password": password,
        "ConPassword": conPassword,
    };
}
