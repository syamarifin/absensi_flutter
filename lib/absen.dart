import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:absensi_siswa/baseurl.dart';
import 'package:absensi_siswa/absen.dart';
import 'package:absensi_siswa/flutter_barcode_scanner.dart';

class Absen extends StatefulWidget{
  static String tag = 'absen';
  
  _AbsenState createState() => new _AbsenState();
}

class _AbsenState extends State<Absen>{
  String Barcode="";
  String NIM="";
  String NamaSiswa="";

  Future<String> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String nis = prefs.getString('NIS');
    final response = await http.post(BaseUrl.absenScan, body: {"NIS": nis});
    setState(() {
      //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
      var content = json.decode(response.body);
      // final data = jsonDecode(response.body);
      NamaSiswa = content['Nama'];
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('NIS', data['NIS']);
      NIM = content['NIS'];
    });
    return 'success!';
  }

  void initState() {
    super.initState();
    this.getData(); //PANGGIL FUNGSI YANG TELAH DIBUAT SEBELUMNYA
  }
  
  check() {
    cekSiswa();
  }

  cekSiswa() async {
    // Getting value from Controller
    final response = await http.post(BaseUrl.absenScan, body: {"NIS": Barcode});
    final data = jsonDecode(response.body);
    NamaSiswa = data['Nama'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('NIS', data['NIS']);
    NIM = data['NIS'];
  }
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Detail Siswa'),
        ),
        body: Center (
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text ('Absen Masuk'),
                onPressed: ()  {},
              ),
              Text(
                'Result: $NIM $NamaSiswa',
                textAlign:TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}