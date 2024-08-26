// To parse this JSON data, do
//
//     final infouser = infouserFromJson(jsonString);

import 'dart:convert';

List<Infouser> infouserFromJson(String str) => List<Infouser>.from(json.decode(str).map((x) => Infouser.fromJson(x)));

String infouserToJson(List<Infouser> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Infouser {
    String terminal;
    String latitude;
    String longtitude;

    Infouser({
        required this.terminal,
        required this.latitude,
        required this.longtitude,
    });

    factory Infouser.fromJson(Map<String, dynamic> json) => Infouser(
        terminal: json["terminal"],
        latitude: json["latitude"],
        longtitude: json["longtitude"],
    );

    Map<String, dynamic> toJson() => {
        "terminal": terminal,
        "latitude": latitude,
        "longtitude": longtitude,
    };
}
