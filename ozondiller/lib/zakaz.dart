import 'dart:convert';
import 'dart:io';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ozondiller/addnewtovar.dart';
import 'package:ozondiller/cart.dart';
import 'package:ozondiller/konkurentClass.dart';
import 'package:ozondiller/settingsClass.dart';
import 'package:ozondiller/tovarClass.dart';
import 'package:ozondiller/zakazClass.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ozondiller/tehhclass.dart';
import 'package:http/http.dart' as http;

// Define a custom Form widget.
class zakaz extends StatefulWidget {
  Zakaz zakaz1;

  zakaz(this.zakaz1);

  @override
  _zakazState createState() => _zakazState();
}

class _zakazState extends State<zakaz> {
  _zakazState();

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
  int vsegokolvo = 0;
  double vsegoprice = 0;

  firstinti() async {
    vsegozakupitb = 0;
    vsegoves = 0;
    vsegokolvo = 0;
    vsegoprice = 0;

    await tehhclass.initbd();

    var results3 = await tehhclass.conn!.query('SELECT * FROM `settings`', []);
    results3.forEach((json) {
      tehhclass.settings = (SettingsClass.fromMysql(json));
    });

    spiskonkurent.clear();
    var results2 = await tehhclass.conn!.query('SELECT * FROM `konkurent`', []);
    results2.forEach((json) {
      KonkurentClass ss = KonkurentClass.fromMysql(json);
      spiskonkurent.add(ss);
    });

    // spistovar.clear();
    List<TovarClass> spistovar_vsp = <TovarClass>[];
    List<String> ozids = [];
    var results = await tehhclass.conn!.query(
        'SELECT tovars.*, zakaz_tovar.faktdostkitay, zakaz_tovar.kolvokor, zakaz_tovar.ozid FROM `tovars` Left join  zakaz_tovar ON tovars.id=zakaz_tovar.tovar where zakaz_tovar.zakaz=? order by tovars.prioritet',
        [widget.zakaz1.id]);
    results.forEach((json) {
      TovarClass ss = TovarClass.fromMysql(json);
      if (ss.ozid! > 0) {
        ozids.add(ss.ozid.toString());
      }
      ss.konkurents =
          spiskonkurent.where((element) => element.tovarid == ss.id).toList();
      ss.konkurents!.add(KonkurentClass(
          id: 0,
          konkurentcountprod: 0,
          konkurentprice: 0,
          konkurentid: 0,
          konkurentoborot: 0,
          konkurentssilka: ""));

      spistovar_vsp.add(ss);
      if (ss.skolkorob! > 0) {
        vsegozakupitb += (ss.priceuan! * ss.kolvovkorob! * ss.skolkorob! +
                1 +
                ss.faktdostkitay!) *
            (tehhclass.settings!.kursuuanb ?? 0) *
            (1 + tehhclass.settings!.uslugidostav!);
      }

      vsegoves += ss.veskorob! * ss.skolkorob!;
      vsegokolvo += ss.skolkorob! * ss.kolvovkorob!;

      double konurobor = 0, konkurprod = 0;
      ss.konkurents!.forEach((element) {
        //    print(element.konkurentcountprod);
        konurobor += element.konkurentoborot ?? 0;
        konkurprod += element.konkurentcountprod ?? 0;
        //  print(konurobor);
      });
      double podschqwe =
          konurobor / konkurprod * ss.kolvovkorob! * ss.skolkorob!;
      vsegoprice += (podschqwe).isNaN ? 0 : podschqwe;
    });

    var responseJson = await ozonzarpos(ozids);

    responseJson['result']['items'].forEach((entitlement) {
      var elem = spistovar_vsp
          .firstWhere((element) => element.ozid == entitlement['product_id']);

      elem.ozondann = entitlement;
    });

    spistovar = spistovar_vsp;

    setState(() {});
  }

  Future<dynamic> ozonzarpos(List<String> ozids) async {
//print(ozids);

    final response = await http.post(
      Uri.parse('https://api-seller.ozon.ru/v4/product/info/prices'),
      // Send authorization headers to the backend.

      headers: {
        "Host": "api-seller.ozon.ru",
        "Client-Id": "788625",
        "Api-Key": "00a963ea-0110-4122-a5fc-e84a3c7b8b01",
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "filter": {
          "product_id": ozids,
        },
        "last_id": "",
        "limit": 100
      }),
    );
    return jsonDecode(response.body);
  }

  @override
  void dispose() {
    super.dispose();
  }

  DataRow widgerere(index) {
    double priceuan = spistovar[index].priceuan ?? 0;
    double veskorob = spistovar[index].veskorob ?? 0;
    int skolkorob = spistovar[index].kolvokor ?? 0;
    int kolvovkorob = spistovar[index].kolvovkorob ?? 0;

    double konkurentoborot = 0;
    int konkurentcountprod = 0;
    spistovar[index].konkurents!.forEach((element) {
      konkurentoborot += element.konkurentoborot!;
      konkurentcountprod += element.konkurentcountprod!;
    });

    double dostavkapricezakg = widget.zakaz1.faktpricezakg!;

    double faktdostkitay = spistovar[index].faktdostkitay ?? 0;
    double faktdostagent =
        (veskorob * skolkorob / vsegoves) * widget.zakaz1.faktdostagent!;
    double dostavkasdek =
        (veskorob * skolkorob / vsegoves) * widget.zakaz1.faktdostsdek!;

    double itogo = priceuan * kolvovkorob * skolkorob + 1 + faktdostkitay;

    double sebestoim =
        (itogo * widget.zakaz1.kurstuanb! + dostavkasdek + faktdostagent) /
            (kolvovkorob * skolkorob);

    double konkupricekorrect = 0;
    if (konkurentcountprod != 0) {
      konkupricekorrect = konkurentoborot / konkurentcountprod;
    }
    double reklama = konkupricekorrect * (tehhclass.settings!.reklama ?? 0);
    double drugierash = spistovar[index].drugierash ?? 0;
    double eqwaring = konkupricekorrect * (tehhclass.settings!.eqwaring ?? 0);

    double priceozon = 0, fbs = 0, pricemarkozon = 0, marjaoz = 0;
    if (spistovar[index].ozondann != null) {
      var entitlement = spistovar[index].ozondann;

      fbs = (((entitlement['commissions']['sales_percent_fbs']) *
              double.parse(entitlement['price']['price']) /
              100) +
          entitlement['commissions']['fbs_first_mile_max_amount'] +
          entitlement['commissions']['fbs_direct_flow_trans_max_amount'] +
          entitlement['commissions']
              ['fbs_deliv_to_customer_amount']); //23 экваринг


      priceozon = double.parse(entitlement['price']['price']);
      pricemarkozon = double.parse(entitlement['price']['marketing_price']);
      marjaoz = priceozon - fbs - sebestoim - drugierash - eqwaring;
    }

    double profit = konkupricekorrect - fbs - sebestoim - drugierash - eqwaring;

    double profitproc = profit.isInfinite || profit.isNaN
        ? 0
        : profit / konkupricekorrect * 100;

    double mincena0proc = (sebestoim + drugierash + eqwaring)        ;
    double mincena5proc = (sebestoim + drugierash + eqwaring) /
        (1 -
            ((tehhclass.settings!.reklama ?? 0) +
                (spistovar[index].fbs ?? 0) +
                0.05));
    double mincena10proc = (sebestoim + drugierash + eqwaring) /
        (1 -
            ((tehhclass.settings!.reklama ?? 0) +
                (spistovar[index].fbs ?? 0) +
                0.1));
    double mincena15proc = (sebestoim + drugierash + eqwaring) /
        (1 -
            ((tehhclass.settings!.reklama ?? 0) +
                (spistovar[index].fbs ?? 0) +
                0.15));
    double mincena20proc = (sebestoim + drugierash + eqwaring) /
        (1 -
            ((tehhclass.settings!.reklama ?? 0) +
                (spistovar[index].fbs ?? 0) +
                0.2));

    Color color = Colors.green;
    if (profitproc <= 0) {
      color = Colors.grey;
    }
    if (profitproc > 0 && profitproc < 10) {
      color = Colors.red;
    } else if (profitproc >= 10 && profitproc < 20) {
      color = Colors.yellow.shade700;
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
                Text("Конкурент (${spistovar[index].konkurents!.length - 1})"),
          ),
          TextButton(
            onPressed: () {
              launchUrl(Uri.parse(
                  "https://www.aliprice.com/Index/searchbyimage.html?plat=1688_lite&image=" +
                      (spistovar[index].image ?? "")));
            },
            child: Text("Поиск"),
          )
        ],
      )),
      DataCell(Text(spistovar[index].komment ?? "")),
      DataCell(Text(
        "\n1 шт. - ${tehhclass.tostringmoney(veskorob / kolvovkorob)} кг.\n" +
            kolvovkorob.toString() +
            " шт. - " +
            veskorob.toString() +
            " кг.",
        textAlign: TextAlign.right,
      )),
      DataCell(Text(
        tehhclass.tostringmoney(priceuan) +
            " ¥\n" +
            tehhclass.tostringmoney(
                priceuan * (tehhclass.settings!.kursuuanb ?? 0)) +
            " Р\n" +
            tehhclass.tostringmoney(
                priceuan * (tehhclass.settings!.kursuuanb ?? 0) * kolvovkorob) +
            " Р",
        textAlign: TextAlign.right,
      )),
      DataCell(Text(
        '${tehhclass.tostringmoney(faktdostagent)} Р.\n' +
            '${tehhclass.tostringmoney(dostavkasdek)} Р.\n' +
            '${tehhclass.tostringmoney(faktdostagent + dostavkasdek)} Р.',
        textAlign: TextAlign.right,
      )),
      DataCell(Text(skolkorob.toString())),
      DataCell(Text(
        tehhclass.tostringmoney(itogo) +
            " ¥\n" +
            tehhclass
                .tostringmoney(itogo * (tehhclass.settings!.kursuuanb ?? 0)) +
            " ₽",
        textAlign: TextAlign.right,
      )),
      DataCell(Text(
        tehhclass.tostringmoney(konkupricekorrect) +
            " ₽\n" +
            tehhclass.tostringmoney(konkurentoborot) +
            ' ₽\n' +
            konkurentcountprod.toString() +
            ' шт.',
        textAlign: TextAlign.right,
      )),
      DataCell(
          Text(tehhclass.tostringmoney(sebestoim.isInfinite ? 0 : sebestoim))),
      DataCell(Text(
        "${tehhclass.tostringmoney(profit.isInfinite ? 0 : profit)}\n${tehhclass.tostringmoney(profitproc)}%",
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      )),
      DataCell(Text(
          "Цена ${priceozon}\nМарк ${pricemarkozon}\nFBS ${fbs}\nМарж ${tehhclass.tostringmoney(marjaoz)}\nМарж ${tehhclass.tostringmoney(marjaoz / priceozon * 100)}")),
      DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${tehhclass.tostringmoney(mincena0proc.isInfinite ? 0 : mincena0proc)}",
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            "${tehhclass.tostringmoney(mincena5proc.isInfinite ? 0 : mincena5proc)}",
            style: TextStyle(color: Colors.grey),
          ),
          Text(
              "${tehhclass.tostringmoney(mincena10proc.isInfinite ? 0 : mincena10proc)}",
              style: TextStyle(color: Colors.red)),
          Text(
              "${tehhclass.tostringmoney(mincena15proc.isInfinite ? 0 : mincena15proc)}",
              style: TextStyle(color: Colors.yellow.shade700)),
          Text(
              "${tehhclass.tostringmoney(mincena20proc.isInfinite ? 0 : mincena20proc)}",
              style: TextStyle(color: Colors.green)),
        ],
      )),
      DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "0",
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            "${tehhclass.tostringmoney(mincena5proc.isInfinite ? 0 : mincena5proc - mincena0proc)}",
            style: TextStyle(color: Colors.grey),
          ),
          Text(
              "${tehhclass.tostringmoney(mincena10proc.isInfinite ? 0 : mincena10proc - mincena0proc)}",
              style: TextStyle(color: Colors.red)),
          Text(
              "${tehhclass.tostringmoney(mincena15proc.isInfinite ? 0 : mincena15proc - mincena0proc)}",
              style: TextStyle(color: Colors.yellow.shade700)),
          Text(
              "${tehhclass.tostringmoney(mincena20proc.isInfinite ? 0 : mincena20proc - mincena0proc)}",
              style: TextStyle(color: Colors.green)),
        ],
      ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Заказ id${widget.zakaz1.id}",
            style: TextStyle(color: Colors.black)),
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
                    label: Text('Фото'),
                    size: ColumnSize.L,
                  ),
                  DataColumn(
                    label: Text('Название'),
                  ),
                  DataColumn(
                    label: Text('Ссылки'),
                  ),
                  DataColumn(
                    label: Text('Коментарий'),
                  ),
                  DataColumn(
                    label: Text('Вес коробки'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Цена 1шт/\nКоробки'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Доставка короба/\nСдек/\nВсего'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Колво короб'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Итого руб'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Цена конкурента\nОборот'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Себестоимость'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Профит'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Данные Ozon'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Мин цена\n0/5/10/15/20\nпроц'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Профит\n0/5/10/15/20\nпроц'),
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
                        'Стоимость закупки в китае ${tehhclass.tostringmoney(vsegozakupitb)} р.'),
                    Text(
                        'Доставка ${widget.zakaz1.faktpricezakg} доллара за кг (всего  ${widget.zakaz1.faktves} кг ${vsegoves}.) ${widget.zakaz1.faktdostagent} р.'),
                    Text(
                        'Доставка сдек ${tehhclass.tostringmoney(widget.zakaz1.faktdostsdek!)} р.'),
                    Text(
                        'Итого ${tehhclass.tostringmoney(widget.zakaz1.faktdostsdek! + widget.zakaz1.faktdostagent! + vsegozakupitb)} р.'),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //788625
//00a963ea-0110-4122-a5fc-e84a3c7b8b01
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
