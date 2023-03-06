import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
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

  firstinti() async {
    spistovar.clear();

    var userId = 1;
    await tehhclass.initbd();
    var results =
        await tehhclass.conn!.query('SELECT * FROM `tovars` WHERE ?', [userId]);
    results.forEach((json) {
      spistovar.add(TovarClass.fromMysql(json));
    });
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  DataRow widgerere(index) {
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
            child: Text("ссылка 1688"),
          ),
          TextButton(
            onPressed: () {
              launchUrl(Uri.parse(spistovar[index].konkurentssilka ?? ""));
            },
            child: Text("ссылка на конкурента"),
          )
        ],
      )),
      DataCell(Text(spistovar[index].komment ?? "")),
      DataCell(Text(spistovar[index].prioritet.toString())),
      DataCell(Text(spistovar[index].priceuan.toString())),
      DataCell(Text(tehhclass.tostringmoney(spistovar[index].veskorob!))),
      DataCell(Text(spistovar[index].kolvovkorob.toString())),
      DataCell(Text((spistovar[index].priceuan! * spistovar[index].kolvovkorob!)
          .toString())),
      DataCell(Text((spistovar[index].skolkorob ?? "0").toString())),
      DataCell(Text(tehhclass.tostringmoney((spistovar[index].priceuan! *
          spistovar[index].kolvovkorob! *
          tehhclass.kursuuanb)))),
      DataCell(Text(spistovar[index].konkurentprice.toString())),
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
      body: DataTable2(
          dataRowHeight: 120,
          columnSpacing: 12,
          horizontalMargin: 12,
          minWidth: 600,
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
              label: Text('Цена итого'),
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
          ],
          rows: List<DataRow>.generate(
              spistovar.length, (index) => widgerere(index))),
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
