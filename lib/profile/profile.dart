// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:redditech/search/search.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:redditech/home/home.dart';
import 'package:redditech/main.dart';
import 'package:redditech/auth/authentification.dart';
import 'package:redditech/settings/settings.dart';
import 'package:redditech/profile/apiProfile.dart';

class MyProfilePage extends StatefulWidget {
  MyProfilePage({Key? key}) : super(key: key);

  final String title = "Login";

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<MyProfilePage> {
  String profileName = "";
  String profileDescription = "";
  String profileBanner = "";
  String profilePicture = "";
  String followers = "";
  String totalKarma = "";
  String dateOfBirth = "";

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    ProfileApi api = ProfileApi();
    await api.fetchProfile();
    setState(() {
      profileName = api.getProfileName();
      profileDescription = api.getProfileDescription();
      profileBanner = api.getProfileBanner();
      profilePicture = api.getProfilePicture();
      followers = api.getNbFollowers();
      totalKarma = api.getNbKarma();
      dateOfBirth = api.getDateUtc();
    });
  }

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.6,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(profileBanner),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(profilePicture),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _buildName() {
    TextStyle _nameStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
    );

    return Text(
      profileName,
      style: _nameStyle,
    );
  }

  Widget _buildDecription(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        profileDescription,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'Spectral',
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.w300),
      ),
    );
  }

  Widget _buildstatitem(String label, String count) {
    TextStyle _nameLabel = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 18.0,
      fontWeight: FontWeight.w300,
    );

    TextStyle _nameCount = TextStyle(
      color: Colors.black,
      fontSize: 23.0,
      fontWeight: FontWeight.bold,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _nameCount,
        ),
        Text(
          label,
          style: _nameLabel,
        )
      ],
    );
  }

  Widget _buildstatContainer() {
    return Container(
      height: 60.0,
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFFCE4EC),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildstatitem("Followers", followers),
          _buildstatitem("Karma", totalKarma),
          _buildstatitem("Cake Day", dateOfBirth),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
          children: <Widget>[
            _buildCoverImage(screenSize),
            SafeArea(
                child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height / 5.0),
                  _buildProfileImage(),
                  _buildName(),
                  _buildDecription(context),
                  _buildstatContainer(),
                ],
              ),
            )),
          ],
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
}
