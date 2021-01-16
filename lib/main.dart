import 'list_siswa.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'history_absen.dart';
import 'absen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    Absen.tag: (context) => Absen(),
    ShowSiswaList.tag:(context) => ShowSiswaList(),
    MyHistoryAbsen.tag:(context) => MyHistoryAbsen(),
  };

  @override 
  Widget build(BuildContext context){
    return MaterialApp(
      title:'Absensi Siswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: MyHomePage(),
      routes: routes,
    );
  }
  
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  cekLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('username');
    print(stringValue);
    //cek user sudah login apa belum
    if (stringValue != null){
      //tampilkan halaman home jika user sudah login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute (builder: (_) {
          return HomePage();
        }),
      );
    }else{
      //tampilkan halaman login jika user belum login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute (builder: (_) {
          return LoginPage();
        }),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    cekLogin();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}