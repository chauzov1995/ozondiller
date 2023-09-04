// To parse this JSON data, do
//
//     final zakaz = zakazFromJson(jsonString);

import 'dart:convert';

import 'package:mysql1/mysql1.dart';

Zakaz zakazFromJson(String str) => Zakaz.fromJson(json.decode(str));

String zakazToJson(Zakaz data) => json.encode(data.toJson());

class Zakaz {
  int? id;
  double? kursdollar;
  double? kurstuanb;
  double? faktves;
  double? faktobrsh;
  double? faktdostkitay;
  double? faktdostagent;
  double? faktdostsdek;
  double? faktpricezakg;

  Zakaz({
    this.id,
    this.kursdollar,
    this.kurstuanb,
    this.faktves,
    this.faktobrsh,
    this.faktdostkitay,
    this.faktdostagent,
    this.faktdostsdek,
    this.faktpricezakg,
  });

  factory Zakaz.fromJson(Map<String, dynamic> json) => Zakaz(
    id: json["id"],
    kursdollar: json["kursdollar"],
    kurstuanb: json["kurstuanb"],
    faktves: json["faktves"],
    faktobrsh: json["faktobrsh"],
    faktdostkitay: json["faktdostkitay"],
    faktdostagent: json["faktdostagent"],
    faktdostsdek: json["faktdostsdek"],
    faktpricezakg: json["faktpricezakg"],
  );

  factory Zakaz.fromMysql(ResultRow json) => Zakaz(
    id: json["id"],
    kursdollar: json["kursdollar"],
    kurstuanb: json["kurstuanb"],
    faktves: json["faktves"],
    faktobrsh: json["faktobrsh"],
    faktdostkitay: json["faktdostkitay"],
    faktdostagent: json["faktdostagent"],
    faktdostsdek: json["faktdostsdek"],
    faktpricezakg: json["faktpricezakg"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "kursdollar": kursdollar,
    "kurstuanb": kurstuanb,
    "faktves": faktves,
    "faktobrsh": faktobrsh,
    "faktdostkitay": faktdostkitay,
    "faktdostagent": faktdostagent,
    "faktdostsdek": faktdostsdek,
    "faktpricezakg": faktpricezakg,
  };
}
