import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ozondiller/addnewtovar.dart';
import 'package:ozondiller/cart.dart';
import 'package:ozondiller/konkurentClass.dart';
import 'package:ozondiller/tovarClass.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ozondiller/tehhclass.dart';

// Define a custom Form widget.
class spistovarov extends StatefulWidget {
  spistovarov();

  @override
  _spistovarovState createState() => _spistovarovState();
}

class _spistovarovState extends State<spistovarov> {
  _spistovarovState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    firstinti();
  }

  List<TovarClass> spistovar = <TovarClass>[];
  List<KonkurentClass> spiskonkurent = <KonkurentClass>[];
  double vsegozakupitb = 0;
  double vsegoves = 0;

  firstinti() async {
    vsegozakupitb = 0;
    vsegoves = 0;

    await tehhclass.initbd();

    spiskonkurent.clear();
    var results2 = await tehhclass.conn!.query('SELECT * FROM `konkurent`', []);
    results2.forEach((json) {
      KonkurentClass ss = KonkurentClass.fromMysql(json);
      spiskonkurent.add(KonkurentClass.fromMysql(json));
    });

    spistovar.clear();
    var results = await tehhclass.conn!
        .query('SELECT * FROM `tovars` order by prioritet', []);
    results.forEach((json) {
      TovarClass ss = TovarClass.fromMysql(json);
      ss.konkurents =
          spiskonkurent.where((element) => element.tovarid == ss.id).toList();
      ss.konkurents!.add(KonkurentClass(
          id: 0,
          konkurentcountprod: 0,
          konkurentprice: 0,
          konkurentid: 0,
          konkurentoborot: 0,
          konkurentssilka: ""));

      spistovar.add(ss);
      vsegozakupitb +=
          ss.priceuan! * tehhclass.kursuuanb * ss.kolvovkorob! * ss.skolkorob!;
      vsegoves += ss.veskorob! * ss.skolkorob!;
    });

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  DataRow widgerere(index) {
    double priceuan = spistovar[index].priceuan ?? 0;
    double veskorob = spistovar[index].veskorob ?? 0;
    int skolkorob = spistovar[index].skolkorob ?? 0;
    int kolvovkorob = spistovar[index].kolvovkorob ?? 0;

    // double konkurentprice=0;
    double konkurentoborot = 0;
    int konkurentcountprod = 0;
    spistovar[index].konkurents!.forEach((element) {
      //konkurentprice+=  element.konkurentprice!;
      konkurentoborot += element.konkurentoborot!;
      konkurentcountprod += element.konkurentcountprod!;
    });

    double dostavka = 2; //?? ?????????? ?????????? ?????????? 2 ?????????? ???? ????
    double oreshotka = 15; //?? ????????????????
    double dostavkapricezakg = 4.2; //?? ????????????????
    double dostavkasdek = 60; //?? ?????????????? ???? ????

    double sebestoim = ((priceuan * kolvovkorob + dostavka * veskorob) *
                tehhclass.kursuuanb +
            (oreshotka + dostavkapricezakg * veskorob) * tehhclass.kursdollar +
            dostavkasdek) /
        kolvovkorob;

    double konkupricekorrect = 0;
    if (konkurentcountprod != 0) {
      konkupricekorrect = konkurentoborot / konkurentcountprod;
    }
    double reklama = konkupricekorrect * 0.1;
    double fbs = konkupricekorrect * 0.2;
    double drugierash = 20;

    double profit = konkupricekorrect - fbs - reklama - sebestoim - drugierash;
    double profitproc =profit.isInfinite || profit.isNaN ? 0 : profit / konkupricekorrect * 100;

  Color  color= Colors.green;
    if(profitproc<10){
      color=Colors.red;
    }else if(profitproc>=10 && profitproc<20){
      color=Colors.yellow.shade700;
    }

    return DataRow(cells: [
      DataCell(Image.network(
        spistovar[index].image ?? "",
        height: 120,
        fit: BoxFit.fitWidth,
        width: 120,
      )),
      DataCell(
        TextButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => cart(spistovar[index])),
            );
            firstinti();
          },
          child: Text(spistovar[index].name ?? ""),
        ),
      ),
      DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () {
              launchUrl(Uri.parse(spistovar[index].ssilka ?? ""));
            },
            child: Text("1688"),
          ),
          TextButton(
            onPressed: () {
              //launchUrl(Uri.parse(spistovar[index].konkurentssilka ?? ""));
            },
            child:
                Text("?????????????????? (${spistovar[index].konkurents!.length - 1})"),
          ),
          TextButton(
            onPressed: () {
              launchUrl(Uri.parse(
                  "https://www.aliprice.com/Index/searchbyimage.html?plat=1688_lite&image=" +
                      (spistovar[index].image ?? "")));
            },
            child: Text("??????????"),
          )
        ],
      )),
      DataCell(Text(spistovar[index].komment ?? "")),
      DataCell(TextFormField(
        textAlign: TextAlign.end,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          //  FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
        ],
        initialValue: spistovar[index].prioritet.toString(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
        onFieldSubmitted: (text) {
          tehhclass.updatetovar("prioritet", text, spistovar[index].id!);
          print("?????????????????? ??????????: $text");
        },
      )),
      DataCell(TextFormField(
        textAlign: TextAlign.end,
        inputFormatters: <TextInputFormatter>[
          //  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
        ],
        initialValue: priceuan.toString(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
        onFieldSubmitted: (text) {
          tehhclass.updatetovar("priceuan", text, spistovar[index].id!);
          print("?????????????????? ??????????: $text");
        },
      )),
      DataCell(TextFormField(
        textAlign: TextAlign.end,
        inputFormatters: <TextInputFormatter>[
          //  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
        ],
        initialValue: tehhclass.tostringmoney(veskorob),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
        onFieldSubmitted: (text) {
          tehhclass.updatetovar("veskorob", text, spistovar[index].id!);
          print("?????????????????? ??????????: $text");
        },
      )),
      DataCell(TextFormField(
        textAlign: TextAlign.end,
        inputFormatters: <TextInputFormatter>[
          //  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
        ],
        initialValue: kolvovkorob.toString(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
        onFieldSubmitted: (text) {
          tehhclass.updatetovar("kolvovkorob", text, spistovar[index].id!);
          print("?????????????????? ??????????: $text");
        },
      )),
      DataCell(Text(tehhclass.tostringmoney(priceuan * tehhclass.kursuuanb)
         +
            "\n" +
    tehhclass.tostringmoney(priceuan * tehhclass.kursuuanb * kolvovkorob),
        textAlign: TextAlign.right,
      )),
      DataCell(TextFormField(
        textAlign: TextAlign.end,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          //  FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
        ],
        initialValue: skolkorob.toString(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
        onFieldSubmitted: (text) {
          tehhclass.updatetovar("skolkorob", text, spistovar[index].id!);
          print("?????????????????? ??????????: $text");
        },
      )),
      DataCell(Text(tehhclass.tostringmoney(
          priceuan * kolvovkorob * tehhclass.kursuuanb * skolkorob))),
      DataCell(Text(tehhclass.tostringmoney(konkupricekorrect))),
      DataCell(Text(tehhclass.tostringmoney(konkurentoborot))),
      DataCell(Text(konkurentcountprod.toString())),

      DataCell(
          Text(tehhclass.tostringmoney(sebestoim.isInfinite ? 0 : sebestoim))),
      DataCell(Text(
          "${tehhclass.tostringmoney(profit.isInfinite ? 0 : profit)}\n${tehhclass.tostringmoney(profitproc)}%",
      style: TextStyle(color: color, fontWeight: FontWeight.bold),)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("???????????? ??????????????", style: TextStyle(color: Colors.black)),
      ),
      body: Column(children: [
        Expanded(
            child: DataTable2(
                dataRowHeight: 120,
                columnSpacing: 12,
                horizontalMargin: 12,
                minWidth: 1000,
                columns: [
                  DataColumn2(
                    label: Text('????????'),
                    size: ColumnSize.L,
                  ),
                  DataColumn(
                    label: Text('????????????????'),
                  ),
                  DataColumn(
                    label: Text('????????????'),
                  ),
                  DataColumn(
                    label: Text('????????????????????'),
                  ),
                  DataColumn(
                    label: Text('??????????????????'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('???????? ????????'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('?????? ??????????????'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('??????-???? ?? ????????????????'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('???????? 1????/\n??????????????'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('?????????? ??????????'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('?????????? ??????'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('???????? ????????????????????'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('???????????? ????????????????????'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('?????? ???????? ????????????????????'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('??????????????????????????'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('????????????'),
                    numeric: true,
                  ),
                ],
                rows: List<DataRow>.generate(
                    spistovar.length, (index) => widgerere(index)))),
        Container(
            color: Colors.blue.shade50,
            height: 140,
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '?????????????????? ?????????????? ?? ?????????? ${tehhclass.tostringmoney(vsegozakupitb)} ??.'),
                    Text('?????? ?????????? ${tehhclass.tostringmoney(vsegoves)} ????.'),
                    Text(
                        '???????????????? 4.2 ?????????????? ???? ???? ${tehhclass.tostringmoney(vsegoves * tehhclass.kursdollar * 4.2)} ??.'),
                    Text(
                        '?????????? ?? ?????????????????? 4.2 ?????????????? ???? ???? ${tehhclass.tostringmoney(vsegoves * tehhclass.kursdollar * 4.2 + vsegozakupitb)} ??.'),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '?????????????????? ?????????????? ?? ?????????? ${tehhclass.tostringmoney(vsegozakupitb)} ??.'),
                    Text(
                        '???????????????? 5% ${tehhclass.tostringmoney(vsegozakupitb * 0.05)} ??.'),
                    Text(
                        '?????????? ?? ?????????????????? 5% ${tehhclass.tostringmoney(vsegozakupitb * 0.05 + vsegozakupitb)} ??.'),
                  ],
                )
              ],
            ))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => addnewtovar()),
          );
          firstinti();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
