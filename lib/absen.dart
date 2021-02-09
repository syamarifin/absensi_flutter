import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:absensi_siswa/baseurl.dart';
import 'package:absensi_siswa/absen.dart';
import 'package:absensi_siswa/flutter_barcode_scanner.dart';
import 'home_page.dart';

class Absen extends StatefulWidget {
  static String tag = 'absen';

  _AbsenState createState() => new _AbsenState();
}

class _AbsenState extends State<Absen> {
  String Barcode = "";
  String NIS = "";
  String NamaSiswa = "";
  String Kelas = "";
  String Jurusan = "";

  Future<String> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String nis = prefs.getString('NIS');
    // String nis = '16201211';
    final response = await http.post(BaseUrl.absenScan, body: {"NIS": nis});
    setState(() {
      //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
      var content = json.decode(response.body);
      NamaSiswa = content['Nama'];
      NIS = content['NIS'];
      Kelas = content['Kelas'];
      Jurusan = content['Jurusan'];
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
    NIS = data['NIS'];
  }

  absenMasuk() async {
    //proses absen masuk siswa
    final response = await http.post(BaseUrl.absenMasuk, body: {"NIS": NIS});
    final data = jsonDecode(response.body);
    NamaSiswa = data['Nama'];
    absenDatang();
    setState(() {
      // Navigator.of(context).pushNamed(HomePage.tag);
      Navigator.pop(context);
    });
  }

  absenKeluar() async {
    //proses absen pulang siswa
    final response = await http.post(BaseUrl.absenKeluar, body: {"NIS": NIS});
    final data = jsonDecode(response.body);
    NamaSiswa = data['Nama'];
    absenPulang();
    setState(() {
      // Navigator.of(context).pushNamed(HomePage.tag);
      Navigator.pop(context);
    });
  }

  void absenPulang() {
    Fluttertoast.showToast(
        msg: 'Absen Pulang Berhasil',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  void absenDatang() {
    Fluttertoast.showToast(
        msg: 'Absen Masuk Berhasil',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white);
  }

  Widget build(BuildContext context) {
    final masukButton = Container(
      height: 55.0,
      child: Material(
        borderRadius: BorderRadius.circular(32.0),
        shadowColor: Colors.blue.shade400,
        color: Colors.blue.shade400,
        elevation: 7.0,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () {
            absenMasuk();
          },
          padding: EdgeInsets.all(12),
          color: Colors.blue.shade400,
          child: Center(
            child: Text(
              'Masuk',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'),
            ),
          ),
        ),
      ),
    );
    final keluarButton = Container(
      height: 55.0,
      child: Material(
        borderRadius: BorderRadius.circular(32.0),
        shadowColor: Colors.red.shade800,
        color: Colors.red.shade800,
        elevation: 7.0,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () {
            absenKeluar();
          },
          padding: EdgeInsets.all(12),
          color: Colors.red.shade800,
          child: Center(
            child: Text(
              'Keluar',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'),
            ),
          ),
        ),
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Detail Siswa'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    child: new Image.asset(
                      'assets/user.png',
                      height: 100.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'NIS : ',
                        textAlign: TextAlign.right,
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ' $NIS',
                        textAlign: TextAlign.center,
                      )
                    ],
                  )
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Nama : ',
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ' $NamaSiswa',
                        textAlign: TextAlign.center,
                      )
                    ],
                  )
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Kelas : ',
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ' $Kelas',
                        textAlign: TextAlign.center,
                      )
                    ],
                  )
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Jurusan : ',
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ' $Jurusan',
                        textAlign: TextAlign.center,
                      )
                    ],
                  )
                ],
              ),
              SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      masukButton,
                    ],
                  ),
                  SizedBox(width: 15.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      keluarButton,
                    ],
                  )
                ],
              ),
            ],
          ),
          // Column (
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     RaisedButton(
          //       child: Text ('Absen Masuk'),
          //       onPressed: ()  {},
          //     ),
          //     Text(
          //       'Result: $NIM $NamaSiswa',
          //       textAlign:TextAlign.center,
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
