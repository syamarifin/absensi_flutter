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

class _HomePageState extends State<HomePage> {
  String Barcode = "";
  String NIM = "";
  String NamaSiswa = "";

  Widget build(BuildContext context) {
    // final alucard = Hero(
    //   tag: 'hero',
    //   child: Padding(
    //     padding: EdgeInsets.all(16.0),
    //     child: CircleAvatar(
    //       radius: 72.0,
    //       backgroundColor: Colors.transparent,
    //       backgroundImage: AssetImage('assets/mutu.png'),
    //     ),
    //   ),
    // );

    final alucard = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/mutu.png'),
      ),
    );

    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'PROFILE',
        style: TextStyle(fontSize: 16.0, color: Colors.lightBlue),
      ),
    );

    final lorem = Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            'PROFILE',
            style: TextStyle(fontSize: 16.0, color: Colors.lightBlue),
          ),
          SizedBox(height: 48.0),
          Text(
            'SMK Muhammadiyah 7 Gondanglegi Malang (SMK MUTU) berdiri pada tahun 1994 atas prakarsa tokoh dan Pimpinan Cabang Muhammadiyah Gondanglegi Kabupaten Malang. Pada awalnya SMK MUTU mengelola 2 kompetensi keahlian : Teknik Kendaraan Ringan dan Teknik Instalasi Tenaga Listrik. Dan sekarang sudah menjadi 11 kompetensi keahlian.',
            style: TextStyle(fontSize: 16.0, color: Colors.lightBlue),
          ),
          SizedBox(height: 48.0),
          Text(
            'Visi.',
            style: TextStyle(fontSize: 16.0, color: Colors.lightBlue),
          ),
          Text(
            'Mewujudkan Sumber Daya Manusia yang Berakhlak Mulia yang Mampu Bersaing Secara Global.',
            style: TextStyle(fontSize: 16.0, color: Colors.lightBlue),
          ),
          SizedBox(height: 48.0),
          Text(
            'Misi.',
            style: TextStyle(fontSize: 16.0, color: Colors.lightBlue),
          ),
          SizedBox(height: 10.0),
          Text(
            '1. Menciptakan suasana yang kondusif untuk mengembangkan potensi siswa melalui penekanan pada penguasaan kompetensi bidang ilmu pengetahuan dan teknologi serta Bahasa Inggris.',
            style: TextStyle(fontSize: 16.0, color: Colors.lightBlue),
          ),
          SizedBox(height: 5.0),
          Text(
            '2. Meningkatkan penguasaan Bahasa Inggris sebagai alat komunikasi dan alat untuk mempelajari pengetahuan yang lebih luas.',
            style: TextStyle(fontSize: 16.0, color: Colors.lightBlue),
          ),
          SizedBox(height: 5.0),
          Text(
            '3. Meningkatkan frekuensi dan kualitas kegiatan siswa yang lebih menekankan pada pengembangan ilmu pengetahuan dan teknologi serta keimanan dan ketakwaan yang menunjang proses belajar mengajar dan menumbuhkembangkan disiplin pribadi siswa.',
            style: TextStyle(fontSize: 16.0, color: Colors.lightBlue),
          ),
          SizedBox(height: 5.0),
          Text(
            '4. Menerapkan manajemen partisipatif dengan melibatkan seluruh warga sekolah, Lembaga Swadaya Masyarakat, stake holders dan instansi serta institusi pendukung pendidikan lainnya.',
            style: TextStyle(fontSize: 16.0, color: Colors.lightBlue),
          ),
          SizedBox(height: 5.0),
          Text(
            '5. Meningkatkan penguasaan Bahasa Inggris sebagai alat komunikasi dan alat untuk mempelajari pengetahuan yang lebih luas.',
            style: TextStyle(fontSize: 16.0, color: Colors.lightBlue),
          ),
        ],
      ),
      // child: Text(
      //   'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec hendrerit condimentum mauris id tempor. Praesent eu commodo lacus. Praesent eget mi sed libero eleifend tempor. Sed at fringilla ipsum. Duis malesuada feugiat urna vitae convallis. Aliquam eu libero arcu.',
      //   style: TextStyle(fontSize: 16.0, color: Colors.lightBlue),
      // ),
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Colors.white,
        Colors.white30,
      ])),
      child: ListView(
        children: <Widget>[alucard, lorem],
      ),
    );

    // return Scaffold(
    //   body: body,
    // );
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      body: body,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.qr_code_scanner),
        // onPressed: () {
        //   Navigator.of(context).pushNamed(Absen.tag);
        // },
        onPressed: () async {
          try {
            String barcode = await FlutterBarcodeScanner.scanBarcode(
                "#ff6666", "Cancel", true, ScanMode.QR);
            // String barcode = await BarcodeScanner.scan();
            setState(() async {
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
            IconButton(
              icon: Icon(Icons.how_to_reg),
              onPressed: () {
                Navigator.of(context).pushNamed(MyHistoryAbsen.tag);
              },
            ),
          ],
        ),
      ),
    );
  }
}
