// To parse this JSON data, do
//
//     final tovarClass = tovarClassFromJson(jsonString);

import 'dart:convert';

import 'package:mysql1/mysql1.dart';
import 'package:ozondiller/konkurentClass.dart';

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
    this.skolkorob,
    this.konkurentssilka,
    this.konkurentprice,
    this.konkurentoborot,
    this.konkurentcountprod,
    this.fbs,
    this.drugierash,
    this.dostavkayuanbfakt,
    this.faktdostkitay,
    this.kolvokor,
    this.ozid,
    this.ozondann,
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
  String? konkurentssilka;
  double? konkurentprice;
  double? konkurentoborot;
  int? konkurentcountprod;
  List<KonkurentClass>? konkurents;
  double? fbs;
  double? drugierash;
  double? dostavkayuanbfakt;
  double? faktdostkitay;
  int? kolvokor;
  int? ozid;
  dynamic? ozondann;

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
    skolkorob: json["skolkorob"],
    konkurentssilka: json["konkurentssilka"],
    konkurentprice: json["konkurentprice"],
    konkurentoborot: json["konkurentoborot"],
    konkurentcountprod: json["konkurentcountprod"],
    fbs: json["fbs"],
    drugierash: json["drugierash"],
    dostavkayuanbfakt: json["dostavkayuanbfakt"],
    faktdostkitay: json["faktdostkitay"],
    kolvokor: json["kolvokor"],
    ozid: json["ozid"],
    ozondann: json["ozondann"],
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
    skolkorob: json["skolkorob"],
    konkurentssilka: json["konkurentssilka"],
    konkurentprice: json["konkurentprice"],
    konkurentoborot: json["konkurentoborot"],
    konkurentcountprod: json["konkurentcountprod"],
    fbs: json["fbs"],
    drugierash: json["drugierash"],
    dostavkayuanbfakt: json["dostavkayuanbfakt"],
    faktdostkitay: json["faktdostkitay"],
    kolvokor: json["kolvokor"],
    ozid: json["ozid"],
    ozondann: json["ozondann"],
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
    "skolkorob": skolkorob,
    "konkurentssilka": konkurentssilka,
    "konkurentprice": konkurentprice,
    "konkurentoborot": konkurentoborot,
    "konkurentcountprod": konkurentcountprod,
    "fbs": fbs,
    "drugierash": drugierash,
    "dostavkayuanbfakt": dostavkayuanbfakt,
    "faktdostkitay": faktdostkitay,
    "kolvokor": kolvokor,
    "ozid": ozid,
    "ozondann": ozondann,
  };
}
