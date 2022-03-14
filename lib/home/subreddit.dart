import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:redditech/auth/authentification.dart';
import 'package:redditech/home/home.dart';
import 'package:redditech/profile/profile.dart';
import 'package:redditech/search/search.dart';
import 'package:redditech/settings/settings.dart';
import 'package:redditech/home/apiHome.dart';

class MySubredditPage extends StatefulWidget {
  final String name;
  MySubredditPage({Key? key, required this.name}) : super(key: key);

  @override
  _MySubredditPageState createState() => _MySubredditPageState();
}

class _MySubredditPageState extends State<MySubredditPage> {
  HomeApi api = HomeApi();
  var subName = "";
  var subTitle = "";
  var subDesc = "";
  var subSub;
  var subImg = "";
  var subBanner = "";
  var loading = true;
  var cake = "";
  var online = "";
  var userSub = false;

  @override
  void initState() {
    super.initState();
    var name = widget.name;
    loadTop(name);
  }

  void loadTop(String name) async {
    await api.fetchHome(name);
    setState(() {
      subName = api.getSubNamePro();
      subTitle = api.getSubTitlePro();
      subDesc = api.getSubDescPro();
      subSub = api.getSubSubPro();
      subImg = api.getSubImgPro();
      subBanner = api.getSubBannerPro();
      loading = false;
      cake = api.getSubCakePro();
      online = api.getSubOnlinePro();
      userSub = api.getSubUserSub();
    });
  }

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.6,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(subBanner),
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
            image: NetworkImage(subImg),
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
      subTitle,
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
        subName,
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
          _buildstatitem("Followers", subSub),
          _buildstatitem("Online", online),
          _buildstatitem("Cake Day", cake),
        ],
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic,
      color: Colors.black,
      fontSize: 16.0,
    );
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
      child: Text(
        subDesc,
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }

  Widget _buildButtonSub(BuildContext context) {
    // ignore: deprecated_member_use
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.cyan)),
      color: Colors.white,
      textColor: Colors.cyan,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
        setState(() {
          api.postSubSub(subName, "unsub");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MySubredditPage(
                      name: subName,
                    )),
          );
        });
      },
      child: Text(
        "Unsub",
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildButtonUnsub(BuildContext context) {
    // ignore: deprecated_member_use
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.cyan)),
      color: Colors.white,
      textColor: Colors.cyan,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
        setState(() {
          api.postSubSub(subName, "sub");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MySubredditPage(
                      name: subName,
                    )),
          );
        });
      },
      child: Text(
        "Sub",
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
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
            Center(
                child: SingleChildScrollView(
              child: loading
                  ? CircularProgressIndicator()
                  : Column(
                      children: <Widget>[
                        SizedBox(height: screenSize.height / 5.0),
                        _buildProfileImage(),
                        _buildName(),
                        _buildDecription(context),
                        _buildstatContainer(),
                        _buildBio(context),
                        if (userSub == true) _buildButtonSub(context),
                        if (userSub == false) _buildButtonUnsub(context),
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
