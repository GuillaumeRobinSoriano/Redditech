import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redditech/auth/authentification.dart';
import 'package:redditech/home/home.dart';
import 'package:redditech/home/subreddit.dart';
import 'package:redditech/profile/profile.dart';
import 'package:redditech/search/apiSearch.dart';
import 'package:redditech/settings/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

TextEditingController research = new TextEditingController();

class MySearchPage extends StatefulWidget {
  MySearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<MySearchPage> {
  var resultData = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    SearchApi api = SearchApi();
    await api.fetchSearch(research.text);
    setState(() {
      resultData = api.getResultData();
      print(resultData);
    });
  }

  Widget _buildresult() {
    var input = "";
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                input = resultData[index];
                return Padding(
                    padding: EdgeInsets.all(12.0),
                    child: GestureDetector(
                        onTap: () {
                          input = resultData[index];
                          print("Tapped a Container : $index");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MySubredditPage(
                                      name: "r/$input",
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
                              child: Text("r/$input",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ))));
              },
              childCount: resultData.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
      child: TextField(
        controller: research,
        decoration: InputDecoration(
            hintText: "Search...",
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search Page'),
          backgroundColor: Colors.cyan,
        ),
        body: Column(
          children: <Widget>[
            _buildSearch(),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MySearchPage()),
                );
              },
            ),
            Expanded(child: _buildresult())
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
