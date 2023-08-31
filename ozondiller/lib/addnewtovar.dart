import 'package:flutter/material.dart';
import 'package:ozondiller/tehhclass.dart';

// Define a custom Form widget.
class addnewtovar extends StatefulWidget {
  addnewtovar();

  @override
  _addnewtovarState createState() => _addnewtovarState();
}

class _addnewtovarState extends State<addnewtovar> {
  _addnewtovarState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  TextEditingController controllername = TextEditingController();
  TextEditingController controllerssilk = TextEditingController();
  TextEditingController controllerimage = TextEditingController();
  TextEditingController controllerprice = TextEditingController();
  TextEditingController controllerkomment = TextEditingController();
  TextEditingController controllerves = TextEditingController();
  TextEditingController controllerkolvo = TextEditingController();
  TextEditingController controllerfbs = TextEditingController(text: '0.2');
  TextEditingController controllerdrugireash = TextEditingController(text: '20');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Добавление товара", style: TextStyle(color: Colors.black)),
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Наименование',
                ),
                controller: controllername,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'ссылка 1688',
                ),
                controller: controllerssilk,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Картинка',
                ),
                controller: controllerimage,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Комментарий',
                ),
                controller: controllerkomment,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Стоимость (юань)',
                ),
                controller: controllerprice,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Вес коробки',
                ),
                controller: controllerves,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Колво-в коробке',
                ),
                controller: controllerkolvo,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Расходы FBS',
                ),

                controller: controllerfbs,
              ),      TextField(
                decoration: InputDecoration(
                  labelText: 'Другие расходы (упаковка)',
                ),
                controller: controllerdrugireash,
              ),


              Container(
                alignment: Alignment.centerLeft,
                // width: double.infinity,
                padding: EdgeInsets.all(20),
                child: TextButton(
                  onPressed: () async {
                    if(true) {
                      await  tehhclass.initbd();
                      var result = await tehhclass.conn!.query(
                          'INSERT INTO `tovars`( `name`, `ssilka`, `image`, `komment`, `priceuan`, `veskorob`, `kolvovkorob`, fbs, drugierash) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
                          [
                            controllername.text,
                            controllerssilk.text,
                            controllerimage.text,
                            controllerkomment.text,
                            controllerprice.text,
                            controllerves.text,
                            controllerkolvo.text,
                            controllerfbs.text,
                            controllerdrugireash.text,

                          ]);

                      Navigator.pop(context);
                    }else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Sending Message"),
                      ));
                    }
                  },
                  child: Text("ДОБАВИТЬ ТОВАР"),
                ),
              )
            ],
          )),
    );
  }
}
