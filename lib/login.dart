import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future login() async {
    var response = await http.post(
        'http://10.0.2.2/coding-talk-signup-withemailverify/login.php/',
        body: {"username": user.text, "password": pass.text});
    var msg = json.decode(response.body);
    if (msg == "OK") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      showToast("Username and password invalid!", duration: 4,gravity: Toast.CENTER);
    }
    print(msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: user,
                decoration: InputDecoration(hintText: 'Username'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: pass,
                decoration: InputDecoration(hintText: 'Password'),
              ),
            ),
            MaterialButton(
              color: Colors.lime,
              child: Text(
                'Login',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                login();
              },
            ),
          ],
        ),
      ),
    );
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
