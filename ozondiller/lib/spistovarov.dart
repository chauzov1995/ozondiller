import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ozondiller/addnewtovar.dart';
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
  double vsegozakupitb = 0;
  double vsegoves = 0;

  firstinti() async {
    vsegozakupitb = 0;
    vsegoves = 0;
    spistovar.clear();

    var userId = 1;
    await tehhclass.initbd();
    var results = await tehhclass.conn!
        .query('SELECT * FROM `tovars` WHERE ? order by prioritet', [userId]);
    results.forEach((json) {
      TovarClass ss = TovarClass.fromMysql(json);
      spistovar.add(TovarClass.fromMysql(json));
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
    double konkurentprice = spistovar[index].konkurentprice ?? 0;
    double konkurentoborot = spistovar[index].konkurentoborot ?? 0;
    int konkurentcountprod = spistovar[index].konkurentcountprod ?? 0;

    double dostavka=2;//в юанях китай около 2 юаней за кг
    double oreshotka=15;//в долларах
    double dostavkapricezakg=4.2;//в долларах
    double dostavkasdek=60;//в рубллях за кг

    double sebestoim=((priceuan*kolvovkorob + dostavka*veskorob)*tehhclass.kursuuanb+( oreshotka+dostavkapricezakg* veskorob)*tehhclass.kursdollar+dostavkasdek)/kolvovkorob;



    return DataRow(cells: [
      DataCell(Image.network(
        spistovar[index].image ?? "",
        height: 120,
        fit: BoxFit.fitWidth,
        width: 120,
      )),
      DataCell(Text(spistovar[index].name ?? "")),
      DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () {
              launchUrl(Uri.parse(spistovar[index].ssilka ?? ""));
            },
            child: Text("Купить"),
          ),
          TextButton(
            onPressed: () {
              launchUrl(Uri.parse(spistovar[index].konkurentssilka ?? ""));
            },
            child: Text("Конкурент"),
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
          print("Введенный текст: $text");
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
          print("Введенный текст: $text");
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
          print("Введенный текст: $text");
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
          print("Введенный текст: $text");
        },
      )),
      DataCell(Text(
        (priceuan * tehhclass.kursuuanb).toString() +
            "\n" +
            (priceuan * tehhclass.kursuuanb * kolvovkorob).toString(),
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
          print("Введенный текст: $text");
        },
      )),
      DataCell(Text(tehhclass.tostringmoney(
          priceuan * kolvovkorob * tehhclass.kursuuanb * skolkorob))),
      konkurentcountprod == 0 || konkurentoborot == 0
          ? DataCell(TextFormField(
              textAlign: TextAlign.end,
              inputFormatters: <TextInputFormatter>[
                //  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
              ],
              initialValue: konkurentprice.toString(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              onFieldSubmitted: (text) {
                tehhclass.updatetovar(
                    "konkurentprice", text, spistovar[index].id!);
                print("Введенный текст: $text");
              },
            ))
          : DataCell(Text(
              tehhclass.tostringmoney(konkurentoborot / konkurentcountprod))),
      DataCell(TextFormField(
        textAlign: TextAlign.end,
        inputFormatters: <TextInputFormatter>[
          //  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
        ],
        initialValue: konkurentoborot.toString(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
        onFieldSubmitted: (text) {
          tehhclass.updatetovar("konkurentoborot", text, spistovar[index].id!);
          print("Введенный текст: $text");
        },
      )),
      DataCell(TextFormField(
        textAlign: TextAlign.end,
        inputFormatters: <TextInputFormatter>[
          //  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
        ],
        initialValue: konkurentcountprod.toString(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
        onFieldSubmitted: (text) {
          tehhclass.updatetovar(
              "konkurentcountprod", text, spistovar[index].id!);
          print("Введенный текст: $text");
        },
      )),
    DataCell(Text(tehhclass.tostringmoney(sebestoim.isInfinite?0:sebestoim))),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Список товаров", style: TextStyle(color: Colors.black)),
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
                    label: Text('Ссылка 1688'),
                  ),
                  DataColumn(
                    label: Text('Коментарий'),
                  ),
                  DataColumn(
                    label: Text('Приоритет'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Цена юань'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Вес коробки'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Кол-во в кооробке'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Цена 1шт/\nКоробки'),
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
                    label: Text('Цена конкурента'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Оборот конкурента'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Кол прод конкурента'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Себестоимость'),
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
                        'Доставка 5% ${tehhclass.tostringmoney(vsegozakupitb * 0.05)} р.'),
                    Text('Вес общий ${tehhclass.tostringmoney(vsegoves)} кг.'),
                    Text(
                        'Доставка 4.2 доллара за кг ${tehhclass.tostringmoney(vsegoves * tehhclass.kursdollar * 4.2)} р.'),
                    Text(
                        'Итого с доставкой 5% ${tehhclass.tostringmoney(vsegozakupitb * 0.05 + vsegozakupitb)} р.'),
                    Text(
                        'Итого с доставкой 4.2 доллара за кг ${tehhclass.tostringmoney(vsegoves * tehhclass.kursdollar * 4.2 + vsegozakupitb)} р.'),
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
