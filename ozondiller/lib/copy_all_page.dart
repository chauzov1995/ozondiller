import 'package:flutter/material.dart';
import 'package:ozondiller/tehhclass.dart';

// Define a custom Form widget.
class timacopy extends StatefulWidget {

  timacopy();


  @override
  _timacopyState createState() => _timacopyState();
}


class _timacopyState extends State<timacopy> {

  _timacopyState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(brightness: Brightness.dark,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Настройка кнопок", style: TextStyle(color: Colors.black)),
      ),
      body: Container(
          child: Column(
        children: <Widget>[

        ],
      )),
    );
  }
}
