import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ozondiller/konkurentClass.dart';
import 'package:ozondiller/tehhclass.dart';
import 'package:ozondiller/tovarClass.dart';

// Define a custom Form widget.
class konkurentred extends StatefulWidget {
  KonkurentClass konkurent;
  TovarClass tovar;


  konkurentred(this.konkurent, this.tovar);

  @override
  _konkurentredState createState() => _konkurentredState();
}

class _konkurentredState extends State<konkurentred> {
  _konkurentredState();

  TextEditingController controllerkonkssilka = TextEditingController();
  TextEditingController controllerkonkurobor = TextEditingController();
  TextEditingController controllerkonkurcountprod = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controllerkonkssilka.text = widget.konkurent.konkurentssilka!;
    controllerkonkurobor.text = widget.konkurent.konkurentoborot.toString();
    controllerkonkurcountprod.text = widget.konkurent.konkurentcountprod.toString();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Конкурент", style: TextStyle(color: Colors.black)),
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
                        //initialValue:                            widget.tovar.konkurentssilka ?? "".toString(),
                        decoration: InputDecoration(
                          labelText: 'Ссылка на конкурента',
                        ),
                        controller: controllerkonkssilka,
                      ),
                      TextFormField(
                        //initialValue: widget.tovar.konkurentprice.toString(),
                        decoration: InputDecoration(
                          labelText: 'Оборот конкурента',
                        ),
                        controller: controllerkonkurobor,
                      ),
                      TextFormField(
                        //initialValue: widget.tovar.konkurentprice.toString(),
                        decoration: InputDecoration(
                          labelText: 'Кол прод конкурента',
                        ),
                        controller: controllerkonkurcountprod,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        // width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: ElevatedButton(
                          onPressed: () async {
                            String idlonkurenta = controllerkonkssilka.text
                                .split('/')[4]
                                .split('-')
                                .last;

                            print(idlonkurenta);

                            if (true) {
                              await tehhclass.initbd();
                              var result = await tehhclass.conn!.query(
                                  'INSERT INTO konkurent ( konkurentid, tovarid, konkurentssilka, konkurentoborot, konkurentcountprod) VALUES(?,?,?,?,?) ON DUPLICATE KEY UPDATE konkurentssilka=?, konkurentoborot=?, konkurentcountprod=?, tovarid=?',
                                  [
                                    idlonkurenta,
                                    widget.tovar.id,
                                    controllerkonkssilka.text,

                                    controllerkonkurobor.text.replaceAll(' ', ''),
                                    controllerkonkurcountprod.text.replaceAll(' ', ''),
                                    controllerkonkssilka.text,

                                    controllerkonkurobor.text.replaceAll(' ', ''),
                                    controllerkonkurcountprod.text.replaceAll(' ', ''),
                                    widget.tovar.id,
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
