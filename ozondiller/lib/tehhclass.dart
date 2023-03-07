

import 'package:mysql1/mysql1.dart';



class tehhclass {
  static MySqlConnection? conn;
  static double kursuuanb=9.7;
  static double kursdollar=75;

  static initbd() async {
    conn?.close();
    var settings = new ConnectionSettings(
        host: 'b96300p8.beget.tech',
        port: 3306,
        user: 'b96300p8_ozond',
        password: 'User1234',
        db: 'b96300p8_ozond');
    conn = await MySqlConnection.connect(settings);
  }
  static String tostringmoney(double price){
    return ((price*100).round()/100).toString();
  }

  static updatetovar(String param, String value, int whereid) async {
    await  initbd();
    await conn!.query(
        'update tovars set '+param+'=? where id=?',
        [value, whereid]);


  }


}