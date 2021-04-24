import 'dart:convert';
import 'package:codingtalk_signup_emailverify_forget_password/forget_password.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:toast/toast.dart';
import 'login.dart';
import 'credential.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coding Talk',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  bool verifyButton = false;
  String verifyLink;

  Future SignUp() async {
    var response = await http.post(
        'http://10.0.2.2/coding-talk-signup-withemailverify/signup.php/',
        body: {
          "username": user.text,
          "password": pass.text,
        });
    var link = json.decode(response.body);
    sendMail();
    setState(() {
      verifyLink = link;
      verifyButton = true;
      showToast("Thanks for signup! go to mail and verify your account",
          duration: 4, gravity: Toast.CENTER);
    });
    print(link);
  }

  Future verify() async {
    var response = await http.post(verifyLink);
    var link = json.decode(response.body);
    setState(() {
      verifyButton = false;
    });
    print(link);
  }

  sendMail() async {
    String username = EMAIL;
    String password = PASS;

    final SmtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username)
      ..recipients.add('natan.venus.id@gmail.com')
      ..subject = 'SignUp verification link from venus.id : ${DateTime.now()}'
      ..html =
          "<h3>Thanks for registering with localhost. Please Click this link to complete this registration </h3>\n<p> <a href='$verifyLink'>Click me to verify</a></p>";
    try {
      final sendReport = await send(message, SmtpServer);
      print('Message Sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. \n' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        title: Text("Register Page"),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  color: Colors.cyan,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      SignUp();
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  color: Colors.lime,
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Forget Password?"),
              GestureDetector(
                child: Text(
                  " Click Here",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgetPassWord(),
                    ),
                  );
                },
              )
            ],
          ),
          verifyButton
              ? MaterialButton(
                  color: Colors.amber,
                  child: Text(
                    'Verify',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    verify();
                  },
                )
              : Container(),
        ],
      )),
    );
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
