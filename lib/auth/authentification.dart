import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:redditech/auth/header.dart';
import 'package:redditech/auth/inputWrapper.dart';
import 'package:http/http.dart' as http;

import 'package:uni_links/uni_links.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:redditech/home/home.dart';

String _redirectUri = "https://redditech.tamere.com/login-callback";
String _clientId = "0WCBcey-BL37Bb2p9Zh1xg";

var isLoading = true;

class MyLoginPage extends StatefulWidget {
  MyLoginPage({Key? key}) : super(key: key);

  final String title = "Login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<MyLoginPage> {
  @override
  void initState() {
    super.initState();
    initUniLinks();
    checkLogin();
  }

  void checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('token');
    var token = prefs.getString('token');

    print('token $token');
    if (token != null) {
      print("User already logged in!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: "Redditech")),
      );
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  late StreamSubscription _sub;

  Future<void> initUniLinks() async {
    _sub = uriLinkStream.listen((Uri? link) async {
      String linkStr = link.toString();
      if (linkStr.contains('code') && link.toString().contains(_redirectUri)) {
        var code = linkStr.split('code=')[1].split('&')[0];
        print('accessCode $code');
        var auth = 'Basic ' + base64Encode(utf8.encode('$_clientId:'));
        final response = await http.post(
            Uri.parse('https://www.reddit.com/api/v1/access_token'),
            headers: {
              "Authorization": auth
            },
            body: {
              "grant_type": "authorization_code",
              "code": code.replaceAll("#_", ""),
              "redirect_uri": _redirectUri
            });
        var token = jsonDecode(response.body)['access_token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        _sub.cancel();
        print('accessToken $token');

        print("User logged in!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(title: "Redditech")),
        );
      }
    }, onError: (err) {
      throw 'error : $err';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [Colors.cyan, Colors.cyan, Colors.cyan]),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Header(),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    )),
                child: InputWrapper(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
