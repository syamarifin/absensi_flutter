import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:absensi_siswa/baseurl.dart';
import 'package:absensi_siswa/home_page.dart';
import 'package:absensi_siswa/absen.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  
  _LoginPageState createState() => new _LoginPageState();
}

  enum LoginStatus { notSignIn, signIn }

class _LoginPageState extends State<LoginPage> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String absensi, password;
  final _key = new GlobalKey<FormState>();
  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    // final form = _key.currentState;
    // if (form.validate()) {
    //   form.save();
    login();
      // Navigator.of(context).pushNamed(HomePage.tag);
    // }
  }

login() async {
  // Getting value from Controller
  String username = txtUsername.text;
  String password = txtPassword.text;
  final response = await http.post(BaseUrl.login, body: {"username": username, "password": password});
  final data = jsonDecode(response.body);
  int value = data['value'];
  String pesan = data['message'];
  String usernameAPI = data['Username'];
  String namaAPI = data['nama'];
  String id = data['id'];
  if (value == 1) {
    setState((){
      _loginStatus = LoginStatus.signIn;
      Navigator.of(context).pushNamed(HomePage.tag);
      savePref(value, usernameAPI, namaAPI, id);
    });
    print(pesan);
  } else {
    print(pesan);
  }
}

savePref(int value, String username, String nama, String id) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    preferences.setInt("value", value);
    preferences.setString("nama", nama);
    preferences.setString("username", username);
    preferences.setString("id", id);
    // preferences.commit();
  });
}

var value;
getPref() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    value = preferences.getInt("value");

    _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
  });
}

signOut() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    value = preferences.getInt("value");

    _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
  });
}

// signOut() async {
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   setState(() {
//     preferences.setInt("value", null);
//     preferences.commit();
//     _loginStatus = LoginStatus.notSignIn;
//   });
// }

@override
void iniState() {
  super.initState();
  getPref();
}
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag:'hero',
      child:CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/mutu.png'),
      ),
      );

      final email =TextFormField(
        keyboardType: TextInputType.emailAddress,
        style: new TextStyle(
          color: Colors.blueGrey.shade800,
          fontSize: 17.0,
        ),
        autofocus: false,
        // initialValue: 'alucard@gmail.com',
        decoration: InputDecoration(
          labelText: 'Username',
          labelStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0)
          ),
        ),
        controller: txtUsername,
      );

      final password = TextFormField(
        autofocus: false,
        style: new TextStyle(
          color: Colors.blueGrey.shade800,
          fontSize: 17.0,
        ),
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0)
          ),
        ),
        controller: txtPassword,
      );

      final loginButton = Container(
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
              check();
            },
            padding: EdgeInsets.all(12),
            color: Colors.blue.shade400,
            child: Center(
              child: Text(
                'Login',
                style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'),
              ),
            ),
          ),
        ),
      );

      final forgotLabel = FlatButton(
        child: Text(
          'Forgot Password?',
          style: TextStyle(color: Colors.black54),
        ),
        onPressed: () {}
      );

      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right:24.0),
            children: <Widget>[
              logo,
              SizedBox(height: 48.0),
              email,
              SizedBox(height: 8.0),
              password,
              SizedBox(height: 24.0),
              loginButton,
              forgotLabel
            ],
          ),
        ),
      );
  }
}