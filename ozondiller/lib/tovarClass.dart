// To parse this JSON data, do
//
//     final tovarClass = tovarClassFromJson(jsonString);

import 'dart:convert';

import 'package:mysql1/mysql1.dart';

TovarClass tovarClassFromJson(String str) => TovarClass.fromJson(json.decode(str));

String tovarClassToJson(TovarClass data) => json.encode(data.toJson());

class TovarClass {
  TovarClass({
    this.id,
    this.name,
    this.ssilka,
    this.image,
    this.komment,
    this.prioritet,
    this.priceuan,
    this.veskorob,
    this.kolvovkorob,
  });

  int? id;
  String? name;
  String? ssilka;
  String? image;
  String? komment;
  int? prioritet;
  double? priceuan;
  double? veskorob;
  int? kolvovkorob;
  int? skolkorob;

  factory TovarClass.fromJson(Map<String, dynamic> json) => TovarClass(
    id: json["id"],
    name: json["name"],
    ssilka: json["ssilka"],
    image: json["image"],
    komment: json["komment"],
    prioritet: json["prioritet"],
    priceuan: json["priceuan"],
    veskorob: json["veskorob"],
    kolvovkorob: json["kolvovkorob"],
  );

  factory TovarClass.fromMysql(ResultRow json) => TovarClass(
    id: json["id"],
    name: json["name"],
    ssilka: json["ssilka"],
    image: json["image"],
    komment: json["komment"],
    prioritet: json["prioritet"],
    priceuan: json["priceuan"],
    veskorob: json["veskorob"],
    kolvovkorob: json["kolvovkorob"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "ssilka": ssilka,
    "image": image,
    "komment": komment,
    "prioritet": prioritet,
    "priceuan": priceuan,
    "veskorob": veskorob,
    "kolvovkorob": kolvovkorob,
  };
}
