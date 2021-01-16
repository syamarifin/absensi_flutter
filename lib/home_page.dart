
import 'package:absensi_siswa/list_siswa.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:absensi_siswa/absen.dart';
import 'package:absensi_siswa/history_absen.dart';
import 'package:absensi_siswa/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  
  static String tag = 'home-page';
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>{
  String Barcode="";
  String NIM="";
  String NamaSiswa="";

  Widget build(BuildContext context) {
    final alucard = Hero(
      tag: 'hero',
      child:Padding(
        padding: EdgeInsets.all(16.0),
        child: CircleAvatar(
          radius: 72.0,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/mutu.png'),
        ),
      ),
    );

    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Absensi Siswa',
        style: TextStyle(fontSize: 16.0, color: Colors.lightBlue),
      ),
    );

    final lorem = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec hendrerit condimentum mauris id tempor. Praesent eu commodo lacus. Praesent eget mi sed libero eleifend tempor. Sed at fringilla ipsum. Duis malesuada feugiat urna vitae convallis. Aliquam eu libero arcu.',
        style: TextStyle(fontSize: 16.0, color: Colors.lightBlue),
      ),
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
        Colors.white,
        Colors.white30,
      ])
    ),
    child: Column(
      children: <Widget>[alucard, welcome, lorem],
    ),
    );

    // return Scaffold(
    //   body: body,
    // );
    return new Scaffold(
      body: body,
      floatingActionButtonLocation: 
        FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.qr_code_scanner), 
          // onPressed: () {
          //   Navigator.of(context).pushNamed(Absen.tag);
          // },
          onPressed: () async {
            try {
              String barcode = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.QR);
              // String barcode = await BarcodeScanner.scan();
              setState (() async {
                this.Barcode = barcode;
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('NIS', barcode);
                Navigator.of(context).pushNamed(Absen.tag);
                // cekSiswa();
              });
            } on PlatformException {
              this.Barcode = 'Izin kamera tidak diizinkan oleh si pengguna';
            }
          },
        ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.supervised_user_circle), 
              onPressed: () {
                Navigator.of(context).pushNamed(ShowSiswaList.tag);
              },
            ),
            IconButton(icon: Icon(Icons.how_to_reg), onPressed: () {
              Navigator.of(context).pushNamed(MyHistoryAbsen.tag);
            },),
          ],
        ),
      ),
    );
  }
}