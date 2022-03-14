import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redditech/home/apiHome.dart';
import 'package:redditech/search/search.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:redditech/main.dart';
import 'package:redditech/home/home.dart';
import 'package:redditech/auth/authentification.dart';
import 'package:redditech/profile/profile.dart';

import 'apiSettings.dart';

class MySettingsPage extends StatefulWidget {
  MySettingsPage({Key? key}) : super(key: key);

  final String title = "Login";

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<MySettingsPage> {
  SettingsApi api = SettingsApi();
  bool setEnaFol = false;
  bool setSearchOver = false;
  bool setVideoAuto = false;
  bool setEmailPrivMess = false;
  bool setEmailChatRequ = false;
  bool setEmailNewUserWel = false;
  var loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    await api.fetchSettings();
    setState(() {
      setEnaFol = api.getSetEnaFol();
      setSearchOver = api.getSetSearchOver();
      setVideoAuto = api.getSetVideoAuto();
      setEmailPrivMess = api.getSetEmailPrivMess();
      setEmailChatRequ = api.getSetEmailChatRequ();
      setEmailNewUserWel = api.getSetEmailNewUserWel();
    });
    loading = false;
  }

  onChangeFonction1(bool newValue1) {
    setState(() {
      setEnaFol = newValue1;
      api.patchSetEnaFol(newValue1);
    });
  }

  onChangeFonction2(bool newValue2) {
    setState(() {
      setSearchOver = newValue2;
      api.patchSetSearchOver(newValue2);
    });
  }

  onChangeFonction3(bool newValue3) {
    setState(() {
      setVideoAuto = newValue3;
      api.patchSetVideoAuto(newValue3);
    });
  }

  onChangeFonction4(bool newValue4) {
    setState(() {
      setEmailPrivMess = newValue4;
      api.patchSetEmailPrivMess(newValue4);
    });
  }

  onChangeFonction5(bool newValue5) {
    setState(() {
      setEmailChatRequ = newValue5;
      api.patchSetEmailChatRequ(newValue5);
    });
  }

  onChangeFonction6(bool newValue6) {
    setState(() {
      setEmailNewUserWel = newValue6;
      api.patchSetEmailNewUserWel(newValue6);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings Page'),
          backgroundColor: Colors.cyan,
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              SizedBox(height: 40),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.cyan,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Account",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Divider(height: 20, thickness: 1),
              SizedBox(height: 20),
              buildSettingOption(
                  "Allow people to follow you", setEnaFol, onChangeFonction1),
              buildSettingOption(
                  "Adult content", setSearchOver, onChangeFonction2),
              buildSettingOption(
                  "Autoplay media", setVideoAuto, onChangeFonction3),
              buildSettingOption(
                  "Inbox messages", setEmailPrivMess, onChangeFonction4),
              buildSettingOption("Request for discussion", setEmailChatRequ,
                  onChangeFonction5),
              buildSettingOption(
                  "New User welcome", setEmailNewUserWel, onChangeFonction6),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(title: "Redditech")),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyProfilePage()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MySearchPage()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MySettingsPage()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.remove('token');
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => MyLoginPage()),
                      (Route<dynamic> route) => false);
                },
              ),
            ],
          ),
        ));
  }

  Padding buildSettingOption(
      String title, bool value, Function onChangeMethod) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600])),
          Transform.scale(
            scale: 1,
            child: CupertinoSwitch(
              activeColor: Colors.cyan,
              trackColor: Colors.grey,
              value: value,
              onChanged: (bool newValue) {
                onChangeMethod(newValue);
              },
            ),
          )
        ],
      ),
    );
  }
}
