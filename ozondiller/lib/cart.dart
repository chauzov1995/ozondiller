import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ozondiller/konkurentred.dart';
import 'package:ozondiller/tehhclass.dart';
import 'package:ozondiller/tovarClass.dart';
import 'package:url_launcher/url_launcher.dart';

// Define a custom Form widget.
class cart extends StatefulWidget {
  TovarClass tovar;

  cart(this.tovar);

  @override
  _cartState createState() => _cartState();
}

class _cartState extends State<cart> {
  _cartState();

  TextEditingController controllername = TextEditingController();
  TextEditingController controllerssilk = TextEditingController();
  TextEditingController controllerimage = TextEditingController();
  TextEditingController controllerprice = TextEditingController();
  TextEditingController controllerkomment = TextEditingController();
  TextEditingController controllerves = TextEditingController();
  TextEditingController controllerkolvo = TextEditingController();
  TextEditingController controllerfbs = TextEditingController();
  TextEditingController controllerdrugierash = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllername.text = widget.tovar.name!;
    controllerssilk.text = widget.tovar.ssilka!;
    controllerimage.text = widget.tovar.image!;
    controllerprice.text = widget.tovar.priceuan.toString();
    controllerkomment.text = widget.tovar.komment!;
    controllerves.text = widget.tovar.veskorob.toString();
    controllerkolvo.text = widget.tovar.kolvovkorob.toString();
    controllerfbs.text = widget.tovar.fbs.toString();
    controllerdrugierash.text = widget.tovar.drugierash.toString();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(widget.tovar.name!, style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        //color: Colors.blue,
        child: Row(children: [
          Container(
            width: 300,
            child: Column(
              children: <Widget>[
                Image.network(
                  widget.tovar.image ?? "",
                  height: 300,
                  fit: BoxFit.fitWidth,
                  width: 300,
                )
              ],
            ),
          ),
          Expanded(
              child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Наименование',
                        ),
                        controller: controllername,
                      ),
                      TextFormField(
                        //initialValue: widget.tovar.ssilka ?? "".toString(),
                        decoration: InputDecoration(
                          labelText: 'ссылка 1688',
                        ),
                        controller: controllerssilk,
                      ),
                      TextFormField(
                        //initialValue: widget.tovar.image ?? "".toString(),
                        decoration: InputDecoration(
                          labelText: 'Картинка',
                        ),
                        controller: controllerimage,
                      ),
                      TextFormField(
                        //initialValue: widget.tovar.komment ?? "".toString(),
                        decoration: InputDecoration(
                          labelText: 'Комментарий',
                        ),
                        controller: controllerkomment,
                      ),
                      TextFormField(
                        //initialValue: widget.tovar.priceuan.toString(),
                        decoration: InputDecoration(
                          labelText: 'Стоимость (юань)',
                        ),
                        controller: controllerprice,
                      ),
                      TextFormField(
                        //initialValue: widget.tovar.veskorob.toString(),
                        decoration: InputDecoration(
                          labelText: 'Вес коробки',
                        ),
                        controller: controllerves,
                      ),
                      TextFormField(
                        //initialValue: widget.tovar.kolvovkorob.toString(),
                        decoration: InputDecoration(
                          labelText: 'Колво-в коробке',
                        ),
                        controller: controllerkolvo,
                      ),
                      TextFormField(
                        //initialValue: widget.tovar.kolvovkorob.toString(),
                        decoration: InputDecoration(
                          labelText: 'Расходы FBS',
                        ),
                        controller: controllerfbs,
                      ),
                      TextFormField(
                        //initialValue: widget.tovar.kolvovkorob.toString(),
                        decoration: InputDecoration(
                          labelText: 'Другие расходы (упаковка)',
                        ),
                        controller: controllerdrugierash,
                      ),
                      SizedBox(height: 20,),
                      Wrap(
                        //alignment: WrapAlignment.start,
                        spacing: 8.0, // gap between adjacent chips
                        runSpacing: 4.0, // gap between lines
                        children: List.generate(
                            widget.tovar.konkurents!.length,
                            (index) => widget.tovar.konkurents![index].id == 0
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    height: 50,
                                    width: 50,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        SizedBox(
                                          width: 12,
                                        ),
                                        GestureDetector(
                                          child: Icon(Icons.add),
                                          onTap: () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      konkurentred(
                                                          widget.tovar
                                                                  .konkurents![
                                                              index],
                                                          widget.tovar)),
                                            );
                                          },
                                        ),
                                      ],
                                    ))
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    height: 80,
                                    width: 150,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                            child: Container(
                                                padding: EdgeInsets.all(15),
                                                child: GestureDetector(
                                                  child: Text(
                                                      "${ tehhclass.tostringmoney(widget.tovar.konkurents![index].konkurentoborot! / widget.tovar.konkurents![index].konkurentcountprod!)}\n(${tehhclass.tostringmoney( widget.tovar.konkurents![index].konkurentoborot!)})",style: TextStyle(fontSize: 14),),
                                                  onTap: () {
                                                    print("asdasd");


                                                    launchUrl(Uri.parse(widget.tovar.konkurents![index].konkurentssilka ?? ""));


                                                  },
                                                ))),
                                        GestureDetector(
                                          child: Icon(Icons.edit),
                                          onTap: () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      konkurentred(
                                                          widget.tovar
                                                                  .konkurents![
                                                              index],
                                                          widget.tovar)),
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          width: 15,
                                        )
                                      ],
                                    ))),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        // width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (true) {
                              await tehhclass.initbd();
                              var result = await tehhclass.conn!.query(
                                  'UPDATE `tovars` SET `name`=?, `ssilka`=?,`image`=?, `komment`=?, `priceuan`=?, `veskorob`=?, `kolvovkorob`=?, `fbs`=?, `drugierash`=? WHERE id=?',
                                  [
                                    controllername.text,
                                    controllerssilk.text,
                                    controllerimage.text,
                                    controllerkomment.text,
                                    controllerprice.text,
                                    controllerves.text,
                                    controllerkolvo.text,
                                    controllerfbs.text,
                                    controllerdrugierash.text,
                                    widget.tovar.id!,
                                  ]);

                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Sending Message"),
                              ));
                            }
                          },
                          child: Text("СОХРАНИТЬ ТОВАР"),
                        ),
                      )
                    ],
                  ))),
        ]),
      ),
    );
  }
}
