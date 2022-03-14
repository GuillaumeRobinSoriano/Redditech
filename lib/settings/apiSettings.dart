import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:redditech/api/api.dart';

class SettingsApi {
  var data;

  SettingsApi();

  fetchSettings() async {
    var response = await getApi("https://oauth.reddit.com/api/v1/me/prefs");
    data = jsonDecode(response.body);
  }

  patchSetEnaFol(bool value) async {
    final products = {"enable_followers": value};
    var body = json.encode(products);
    await patchApi("https://oauth.reddit.com/api/v1/me/prefs", body);
  }

  patchSetSearchOver(bool value) async {
    final products = {"over_18": value};
    var body = json.encode(products);
    await patchApi("https://oauth.reddit.com/api/v1/me/prefs", body);
  }

  patchSetVideoAuto(bool value) async {
    final products = {"video_autoplay": value};
    var body = json.encode(products);
    await patchApi("https://oauth.reddit.com/api/v1/me/prefs", body);
  }

  patchSetEmailPrivMess(bool value) async {
    final products = {"email_private_message": value};
    var body = json.encode(products);
    await patchApi("https://oauth.reddit.com/api/v1/me/prefs", body);
  }

  patchSetEmailChatRequ(bool value) async {
    final products = {"email_chat_request": value};
    var body = json.encode(products);
    await patchApi("https://oauth.reddit.com/api/v1/me/prefs", body);
  }

  patchSetEmailNewUserWel(bool value) async {
    final products = {"email_new_user_welcome": value};
    var body = json.encode(products);
    await patchApi("https://oauth.reddit.com/api/v1/me/prefs", body);
  }

  getSetEnaFol() {
    return data["enable_followers"];
  }

  getSetSearchOver() {
    return data["over_18"];
  }

  getSetVideoAuto() {
    return data["video_autoplay"];
  }

  getSetEmailPrivMess() {
    return data["email_private_message"];
  }

  getSetEmailChatRequ() {
    return data["email_chat_request"];
  }

  getSetEmailNewUserWel() {
    return data["email_new_user_welcome"];
  }
}
