import 'dart:math';

import 'package:flutter/material.dart';
import 'package:redditech/api/api.dart';
import 'package:redditech/home/subreddit.dart';
import 'package:redditech/search/search.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:redditech/auth/authentification.dart';
import 'package:redditech/profile/profile.dart';
import 'package:redditech/settings/settings.dart';
import 'package:redditech/home/apiHome.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var subTitle = [];
  var subName = [];
  var loading = true;
  int filter = 0;

  @override
  void initState() {
    super.initState();
    loadTop();
  }

  void loadTop() async {
    subTitle = [];
    subName = [];
    if (filter == 0) {
      HomeApi api = HomeApi();
      await api.fetchHomeTop();
      setState(() {
        for (int inc = 0; inc < 25; inc++) {
          subTitle.add(api.getSubTitle(inc));
          subName.add(api.getSubName(inc));
        }
        loading = false;
      });
    }
  }

  void loadHot() async {
    subTitle = [];
    subName = [];
    if (filter == 1) {
      HomeApi api = HomeApi();
      await api.fetchHomeHot();
      setState(() {
        for (int inc = 0; inc < 25; inc++) {
          subTitle.add(api.getSubTitle(inc));
          subName.add(api.getSubName(inc));
        }
        loading = false;
      });
    }
  }

  void loadNew() async {
    subTitle = [];
    subName = [];
    if (filter == 2) {
      HomeApi api = HomeApi();
      await api.fetchHomeNew();
      setState(() {
        for (int inc = 0; inc < 25; inc++) {
          subTitle.add(api.getSubTitle(inc));
          subName.add(api.getSubName(inc));
        }
        loading = false;
      });
    }
  }

  Widget _buildSub() {
    var title = "";
    var name = "";
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              title = subTitle.elementAt(index).toString();
              name = subName.elementAt(index).toString();
              return (Padding(
                  padding: EdgeInsets.all(12.0),
                  child: GestureDetector(
                      onTap: () {
                        name = subName.elementAt(index).toString();
                        print("Tapped a Container : $index with name : $name");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MySubredditPage(
                                    name: name,
                                  )),
                        );
                      },
                      child: Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.cyan,
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(40))),
                          child: Center(
                            child: Text('$name\n\n$title',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                )),
                          )))));
            },
            childCount: subTitle.length,
          ),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_upward),
              onPressed: () {
                filter = 0;
                setState(() {
                  loading = true;
                });
                loadTop();
              },
            ),
            IconButton(
              icon: Icon(Icons.local_fire_department),
              onPressed: () {
                filter = 1;
                setState(() {
                  loading = true;
                });
                loadHot();
              },
            ),
            IconButton(
              icon: Icon(Icons.star),
              onPressed: () {
                filter = 2;
                setState(() {
                  loading = true;
                });
                loadNew();
              },
            ),
          ],
          backgroundColor: Colors.cyan,
        ),
        body: Center(
          child: loading
              ? CircularProgressIndicator()
              : Stack(children: <Widget>[
                  if (filter == 0) _buildSub(),
                  if (filter == 1) _buildSub(),
                  if (filter == 2) _buildSub(),
                ]),
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
