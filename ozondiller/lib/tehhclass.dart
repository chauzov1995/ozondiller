

import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ozondiller/settingsClass.dart';



class tehhclass {
  static MySqlConnection? conn;
  //static double kursuuanb=11.5;//9.7;
 // static double kursdollar=80;//75;
  static SettingsClass? settings;

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
    final oCcy = new NumberFormat("#,##0.00");
    return oCcy.format(price);
  }

  static updatetovar(String param, String value, int whereid) async {
    await  initbd();
    await conn!.query(
        'update tovars set '+param+'=? where id=?',
        [value, whereid]);


  }


}