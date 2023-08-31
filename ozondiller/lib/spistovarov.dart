import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ozondiller/addnewtovar.dart';
import 'package:ozondiller/cart.dart';
import 'package:ozondiller/konkurentClass.dart';
import 'package:ozondiller/settingsClass.dart';
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
          ss.priceuan! * (tehhclass.settings!.kursuuanb??0) * ss.kolvovkorob! * ss.skolkorob!;
      vsegoves += ss.veskorob! * ss.skolkorob!;
      vsegokolvo += ss.skolkorob! * ss.kolvovkorob!;

      double konurobor=0,konkurprod=0;
      ss.konkurents!.forEach((element) {

    //    print(element.konkurentcountprod);
        konurobor+=element.konkurentoborot??0;
        konkurprod+=element.konkurentcountprod??0;
      //  print(konurobor);

      });
      double podschqwe=konurobor/konkurprod*ss.kolvovkorob!*ss.skolkorob!;
      vsegoprice+=(podschqwe).isNaN?0:podschqwe;

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

    double dostavka = tehhclass.settings!.dostavkakitay ??        0; //2; //в юанях китай около 2 юаней за кг
    double oreshotka =        tehhclass.settings!.oreshotka ?? 0; // 15/30; //в долларах
    double dostavkapricezakg =        tehhclass.settings!.dostavkapricezakg ?? 0; // 4.2; //в долларах
    double dostavkasdek =        tehhclass.settings!.dostavkasdek ?? 0; //60; //в рубллях за кг
    double uslugidostav = tehhclass.settings!.uslugidostav ?? 0; //0.05;//
    double strahovka = tehhclass.settings!.strahovka ?? 0; //0.02;



    double sebestoim = ((priceuan * kolvovkorob + priceuan * kolvovkorob * uslugidostav +dostavka * veskorob) *     (tehhclass.settings!.kursuuanb??0) +
            (oreshotka * veskorob + dostavkapricezakg * veskorob) *     (tehhclass.settings!.kursdollar??0) +
            dostavkasdek*veskorob) /        kolvovkorob;


    double konkupricekorrect = 0;
    if (konkurentcountprod != 0) {
      konkupricekorrect = konkurentoborot / konkurentcountprod;
    }
    double reklama = konkupricekorrect * (tehhclass.settings!.reklama??0);
    double fbs = konkupricekorrect * (spistovar[index].fbs??0);
    double drugierash = spistovar[index].drugierash??0;
    double eqwaring = konkupricekorrect * (tehhclass.settings!.eqwaring??0);


    double profit = konkupricekorrect - fbs - reklama - sebestoim - drugierash -eqwaring;
    double profitproc = profit.isInfinite || profit.isNaN
        ? 0
        : profit / konkupricekorrect * 100;


    double mincena0proc=(sebestoim+drugierash+eqwaring) /(1-((tehhclass.settings!.reklama??0)+(spistovar[index].fbs??0) ));
    double mincena5proc=(sebestoim+drugierash+eqwaring) /(1-((tehhclass.settings!.reklama??0)+(spistovar[index].fbs??0)+0.05 ));
    double mincena10proc=(sebestoim+drugierash+eqwaring) /(1-((tehhclass.settings!.reklama??0)+(spistovar[index].fbs??0)+0.1 ));
    double mincena15proc=(sebestoim+drugierash+eqwaring) /(1-((tehhclass.settings!.reklama??0)+(spistovar[index].fbs??0)+0.15 ));
    double mincena20proc=(sebestoim+drugierash+eqwaring) /(1-((tehhclass.settings!.reklama??0)+(spistovar[index].fbs??0)+0.2 ));

    Color color = Colors.green;
    if (profitproc <=0) {
      color = Colors.grey;
    }
    if (profitproc >0 && profitproc < 10) {
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

      DataCell(Text( "\n1 шт. - ${tehhclass.tostringmoney(veskorob/kolvovkorob)} кг.\n"+kolvovkorob.toString()+" шт. - "+veskorob.toString()+" кг.",textAlign: TextAlign.right,) ),


      DataCell(Text(

    tehhclass.tostringmoney(priceuan) +
    " ¥\n" +
        tehhclass.tostringmoney(priceuan * (tehhclass.settings!.kursuuanb??0)) +
            " Р\n" +
            tehhclass
                .tostringmoney(priceuan * (tehhclass.settings!.kursuuanb??0) * kolvovkorob)+" Р",
        textAlign: TextAlign.right,
      )),
      DataCell(Text(
        '${tehhclass.tostringmoney(dostavka*veskorob*(tehhclass.settings!.kursuuanb??0))} Р.\n'+
            '${tehhclass.tostringmoney( (oreshotka * veskorob + dostavkapricezakg * veskorob) *     (tehhclass.settings!.kursdollar??0))} Р.\n'+
            '${tehhclass.tostringmoney( dostavkasdek*veskorob)} Р.\n'+
            '${tehhclass.tostringmoney(dostavka*veskorob*(tehhclass.settings!.kursuuanb??0)+(oreshotka * veskorob + dostavkapricezakg * veskorob) *     (tehhclass.settings!.kursdollar??0)+ dostavkasdek*veskorob)} Р.',
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
          priceuan * kolvovkorob * (tehhclass.settings!.kursuuanb??0)* skolkorob))),

      DataCell(Text(tehhclass.tostringmoney(konkupricekorrect)+" Р.\n"+tehhclass.tostringmoney(konkurentoborot)+' Р.\n'+konkurentcountprod.toString()+' шт.',
        textAlign: TextAlign.right,)),

      DataCell(
          Text(tehhclass.tostringmoney(sebestoim.isInfinite ? 0 : sebestoim))),
      DataCell(Text(
        "${tehhclass.tostringmoney(profit.isInfinite ? 0 : profit)}\n${tehhclass.tostringmoney(profitproc)}%",
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      )),
      DataCell(
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text("${tehhclass.tostringmoney(mincena0proc.isInfinite ? 0 : mincena0proc)}", style: TextStyle(color: Colors.grey),),
          Text("${tehhclass.tostringmoney(mincena5proc.isInfinite ? 0 : mincena5proc)}", style: TextStyle(color: Colors.grey),),
          Text("${tehhclass.tostringmoney(mincena10proc.isInfinite ? 0 : mincena10proc)}", style: TextStyle(color: Colors.red)),
          Text("${tehhclass.tostringmoney(mincena15proc.isInfinite ? 0 : mincena15proc)}", style: TextStyle(color: Colors.yellow.shade700)),
          Text("${tehhclass.tostringmoney(mincena20proc.isInfinite ? 0 : mincena20proc)}", style: TextStyle(color: Colors.green)),
    ],)),
      DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("0", style: TextStyle(color: Colors.grey),),
              Text("${tehhclass.tostringmoney(mincena5proc.isInfinite ? 0 : mincena5proc-mincena0proc)}", style: TextStyle(color: Colors.grey),),
              Text("${tehhclass.tostringmoney(mincena10proc.isInfinite ? 0 : mincena10proc-mincena0proc)}", style: TextStyle(color: Colors.red)),
              Text("${tehhclass.tostringmoney(mincena15proc.isInfinite ? 0 : mincena15proc-mincena0proc)}", style: TextStyle(color: Colors.yellow.shade700)),
              Text("${tehhclass.tostringmoney(mincena20proc.isInfinite ? 0 : mincena20proc-mincena0proc)}", style: TextStyle(color: Colors.green)),
            ],))
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
                    label: Text('Ссылки'),
                  ),
                  DataColumn(
                    label: Text('Коментарий'),
                  ),
                  DataColumn(
                    label: Text('Приоритет'),
                    numeric: true,
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
                    label: Text('Доставка короба'),
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
                        'Доставка китай ${vsegokolvo} шт. ${tehhclass.tostringmoney(vsegoves * (tehhclass.settings!.dostavkakitay ?? 0) * (tehhclass.settings!.kursuuanb??0))} р.'),
                    Text(
                        'Услуги 5% ${tehhclass.tostringmoney(vsegozakupitb * (tehhclass.settings!.uslugidostav ?? 0))} р.'),
                    Text(
                        'Доставка ${tehhclass.settings!.dostavkapricezakg} доллара за кг (всего  ${tehhclass.tostringmoney(vsegoves)} кг.) ${tehhclass.tostringmoney(vsegoves * ((tehhclass.settings!.dostavkapricezakg ?? 0)+(tehhclass.settings!.oreshotka ?? 0)) * (tehhclass.settings!.kursdollar??0))} р.'),
                    Text(
                        'Доставка сдек ${tehhclass.tostringmoney(vsegoves * (tehhclass.settings!.dostavkasdek ?? 0))} р.'),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Подитог ${tehhclass.tostringmoney(vsegozakupitb)} р.'),
                    Text(
                        'Подитог ${tehhclass.tostringmoney(vsegozakupitb + vsegoves * (tehhclass.settings!.dostavkakitay ?? 0) * (tehhclass.settings!.kursuuanb??0))} р.'),
                    Text(
                        'Подитог ${tehhclass.tostringmoney(vsegozakupitb + vsegoves * (tehhclass.settings!.dostavkakitay ?? 0) * (tehhclass.settings!.kursuuanb??0)+vsegozakupitb * (tehhclass.settings!.uslugidostav ?? 0))} р.'),
                    Text(
                        'Подитог ${tehhclass.tostringmoney(vsegozakupitb + vsegoves * (tehhclass.settings!.dostavkakitay ?? 0) * (tehhclass.settings!.kursuuanb??0)+vsegozakupitb * (tehhclass.settings!.uslugidostav ?? 0)+vsegoves * ((tehhclass.settings!.dostavkapricezakg ?? 0)+(tehhclass.settings!.oreshotka ?? 0)) * (tehhclass.settings!.kursdollar??0))} р.'),
                    Text(
                        'Итог ${tehhclass.tostringmoney(vsegozakupitb + vsegoves * (tehhclass.settings!.dostavkakitay ?? 0) * (tehhclass.settings!.kursuuanb??0)+vsegozakupitb * (tehhclass.settings!.uslugidostav ?? 0)+vsegoves * ((tehhclass.settings!.dostavkapricezakg ?? 0)+(tehhclass.settings!.oreshotka ?? 0)) * (tehhclass.settings!.kursdollar??0)+vsegoves * (tehhclass.settings!.dostavkasdek ?? 0))} р.'),

                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Подитог ${tehhclass.tostringmoney(vsegoprice)} р.'),

                  ],
                ),
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
