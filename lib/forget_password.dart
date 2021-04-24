import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:toast/toast.dart';

import 'credential.dart';

class ForgetPassWord extends StatefulWidget {
  @override
  _ForgetPassWordState createState() => _ForgetPassWordState();
}

class _ForgetPassWordState extends State<ForgetPassWord> {
  TextEditingController user = TextEditingController();

  bool verifyButton = false;
  String verifyLinkPass;
  Future checkUser() async {
    var response = await http.post(
        'http://10.0.2.2/coding-talk-signup-withemailverify/check.php',
        body: {
          "username": user.text,
        });
    var linkPass = json.decode(response.body);
    if (linkPass == "INVALIDUSER") {
      showToast('This user not in our database',
          gravity: Toast.CENTER, duration: 4);
    } else {
      sendMail();
      setState(() {
        verifyLinkPass = linkPass;
        verifyButton = true;
      });
      showToast('Click Verify Button To  Reset Password',
          gravity: Toast.CENTER, duration: 4);
    }
    print(linkPass);
  }

  int newPass = 0;
  Future resetPassword(String verifyLinkPass) async {
    var response = await http.post(verifyLinkPass);
    var linkPass = json.decode(response.body);
    setState(() {
      newPass = linkPass;
      verifyButton = false;
    });
    print(linkPass);
    showToast("Your Password has been reset : $newPass",
        gravity: Toast.CENTER, duration: 4);
  }

  sendMail() async {
    String username = EMAIL;
    String password = PASS;

    final SmtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username)
      ..recipients.add('natan.venus.id@gmail.com')
      ..subject = 'password recover link from venus.id : ${DateTime.now()}'
      ..html =
         "<h3>You have been recovery your password. Please Click this link to complete this password recovery </h3>\n<p> <a href='$verifyLinkPass'>Click me to verify</a></p>";
    try {
      final sendReport = await send(message, SmtpServer);
      print('Message Sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. \n' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        title: Text("Forget Password Recover"),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: user,
                decoration: InputDecoration(hintText: "User Email"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                color: Colors.amber,
                child: Text("Recover Password"),
                onPressed: () {
                  checkUser();
                },
              ),
            ),
            verifyButton
                ? MaterialButton(
                    color: Colors.amber,
                    child: Text("Verify"),
                    onPressed: () {
                      resetPassword(verifyLinkPass);
                    },
                  )
                : Container(),
            newPass == 0 ? Container() : Text("New Password is: $newPass"),
          ],
        ),
      ),
    );
  }

  showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
