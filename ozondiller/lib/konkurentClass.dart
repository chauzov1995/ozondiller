// To parse this JSON data, do
//
//     final tovarClass = tovarClassFromJson(jsonString);

import 'dart:convert';

import 'package:mysql1/mysql1.dart';

KonkurentClass tovarClassFromJson(String str) =>
    KonkurentClass.fromJson(json.decode(str));

String tovarClassToJson(KonkurentClass data) => json.encode(data.toJson());

class KonkurentClass {
  KonkurentClass({
    this.id,
    this.konkurentid,
    this.tovarid,
    this.konkurentssilka,
    this.konkurentprice,
    this.konkurentoborot,
    this.konkurentcountprod,
  });

  int? id;
  int? konkurentid;
  int? tovarid;
  String? konkurentssilka;
  double? konkurentprice;
  double? konkurentoborot;
  int? konkurentcountprod;

  factory KonkurentClass.fromJson(Map<String, dynamic> json) => KonkurentClass(
        id: json["id"],
        konkurentid: json["konkurentid"],
        tovarid: json["tovarid"],
        konkurentssilka: json["konkurentssilka"],
        konkurentprice: json["konkurentprice"],
        konkurentoborot: json["konkurentoborot"],
        konkurentcountprod: json["konkurentcountprod"],
      );

  factory KonkurentClass.fromMysql(ResultRow json) => KonkurentClass(
        id: json["id"],
        konkurentid: json["konkurentid"],
        tovarid: json["tovarid"],
        konkurentssilka: json["konkurentssilka"],
        konkurentprice: json["konkurentprice"],
        konkurentoborot: json["konkurentoborot"],
        konkurentcountprod: json["konkurentcountprod"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "konkurentid": konkurentid,
        "tovarid": tovarid,
        "konkurentssilka": konkurentssilka,
        "konkurentprice": konkurentprice,
        "konkurentoborot": konkurentoborot,
        "konkurentcountprod": konkurentcountprod,
      };
}
