import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

String _clientId = "0WCBcey-BL37Bb2p9Zh1xg";
String _responseType = "code";
String _scope = "identity read submit subscribe edit account";
String _state = "PTDR le Oauth2";
String _redirectUri = "https://redditech.tamere.com/login-callback";

String _url =
    "https://www.reddit.com/api/v1/authorize?client_id=$_clientId&response_type=$_responseType&scope=$_scope&state=$_state&redirect_uri=$_redirectUri";

class Button extends StatelessWidget {
  void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        color: Colors.cyan,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        // ignore: deprecated_member_use
        child: RaisedButton(
          color: Colors.cyan,
          elevation: 0,
          onPressed: _launchURL,
          child: Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
