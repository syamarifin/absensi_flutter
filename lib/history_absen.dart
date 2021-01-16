
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'baseurl.dart';

class MyHistoryAbsen extends StatefulWidget {
  static String tag = 'history_absen';
  @override
  _MyHistoryAbsenState createState() => _MyHistoryAbsenState();
}

class _MyHistoryAbsenState extends State<MyHistoryAbsen> {
  var loading = false;
  List data;
  List unFilterData;
  String jk;
  Future<String> getData() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('Token');
    var res = await http.get(BaseUrl.history, headers: { 'accept':'application/json','Content-Type':'application/json'});

    setState(() {
      //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
      var content = json.decode(res.body);
        print(content);
        //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data, 
        //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
        if(content['data']!='error'){
          data = content['data'];
        }
        loading = false;
    });
    this.unFilterData = data;
    return 'success!';
  }
  void initState() {
    super.initState();
    this.getData(); //PANGGIL FUNGSI YANG TELAH DIBUAT SEBELUMNYA
  } 

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
                title: Text('history'),
              ),
          body: Container(
            margin: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0, bottom: 10.0),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ListView.builder( //MEMBUAT LISTVIEW
                    padding: EdgeInsets.only(bottom: 60.0),
                    itemCount: data == null ? 0:data.length, //KETIKA DATANYA KOSONG KITA ISI DENGAN 0 DAN APABILA ADA MAKA KITA COUNT JUMLAH DATA YANG ADA
                    itemBuilder: (BuildContext context, int index) { 
                      return Container(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min, children: <Widget>[
                              ListTile(
                                leading: new Container(
                                  width: 55.0,
                                  height: 55.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage("assets/user.png")
                                    )
                                  )
                                ),
                                  
                                title: 
                                  Row(
                                      children: <Widget>[
                                        Text(data[index]['Nama'].toString(), style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                                        Text(" ("),
                                        Text(data[index]['NIS'].toString(), style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                                        Text(")"),
                                      ],
                                    ),
                                subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[ //MENGGUNAKAN COLUMN
                                    //DIMANA MASING-MASING COLUMN TERDAPAT ROW
                                     Row(
                                      children: <Widget>[
                                        // Text('Rp. ', style: TextStyle(fontWeight: FontWeight.bold),),
                                        Text('Kelas '),
                                        //DARI INDEX ayat
                                        Text(data[index]['Kelas'].toString())
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        // Text('Rp. ', style: TextStyle(fontWeight: FontWeight.bold),),
                                        Text('Jurusan '),
                                        //DARI INDEX ayat
                                        Text(data[index]['Jurusan'].toString())
                                      ],
                                    ),
                                  ],),
                                ),
                                
                              ],),
                            )
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
  }