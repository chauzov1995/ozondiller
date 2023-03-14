// To parse this JSON data, do
//
//     final settingsClass = settingsClassFromJson(jsonString);

import 'dart:convert';

import 'package:mysql1/mysql1.dart';

SettingsClass settingsClassFromJson(String str) => SettingsClass.fromJson(json.decode(str));

String settingsClassToJson(SettingsClass data) => json.encode(data.toJson());

class SettingsClass {
  SettingsClass({
    this.id,
    this.dostavkakitay,
    this.oreshotka,
    this.dostavkapricezakg,
    this.dostavkasdek,
    this.uslugidostav,
    this.strahovka,
    this.kursuuanb,
    this.kursdollar,
    this.reklama,
  });

  int? id;
  double? dostavkakitay;
  double? oreshotka;
  double? dostavkapricezakg;
  double? dostavkasdek;
  double? uslugidostav;
  double? strahovka;
  double? kursuuanb;
  double? kursdollar;
  double? reklama;

  factory SettingsClass.fromJson(Map<String, dynamic> json) => SettingsClass(
    id: json["id"],
    dostavkakitay: json["dostavkakitay"],
    oreshotka: json["oreshotka"],
    dostavkapricezakg: json["dostavkapricezakg"],
    dostavkasdek: json["dostavkasdek"],
    uslugidostav: json["uslugidostav"],
    strahovka: json["strahovka"],
    kursuuanb: json["kursuuanb"],
    kursdollar: json["kursdollar"],
    reklama: json["reklama"],
  );

  factory SettingsClass.fromMysql(ResultRow json)  => SettingsClass(
    id: json["id"],
    dostavkakitay: json["dostavkakitay"],
    oreshotka: json["oreshotka"],
    dostavkapricezakg: json["dostavkapricezakg"],
    dostavkasdek: json["dostavkasdek"],
    uslugidostav: json["uslugidostav"],
    strahovka: json["strahovka"],
    kursuuanb: json["kursuuanb"],
    kursdollar: json["kursdollar"],
    reklama: json["reklama"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "dostavkakitay": dostavkakitay,
    "oreshotka": oreshotka,
    "dostavkapricezakg": dostavkapricezakg,
    "dostavkasdek": dostavkasdek,
    "uslugidostav": uslugidostav,
    "strahovka": strahovka,
    "kursuuanb": kursuuanb,
    "kursdollar": kursdollar,
    "reklama": reklama,
  };
}
