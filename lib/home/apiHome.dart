import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:redditech/api/api.dart';

class HomeApi {
  var data;

  HomeApi();

  fetchHomeTop() async {
    var response = await getApi("https://oauth.reddit.com/best");
    data = jsonDecode(response.body);
  }

  fetchHomeHot() async {
    var response = await getApi("https://oauth.reddit.com/hot");
    data = jsonDecode(response.body);
  }

  fetchHomeNew() async {
    var response = await getApi("https://oauth.reddit.com/new");
    data = jsonDecode(response.body);
  }

  fetchHome(String name) async {
    var response = await getApi("https://oauth.reddit.com/$name/about");
    data = jsonDecode(response.body);
  }

  getSubTitle(int i) {
    return data["data"]["children"][i]["data"]["title"];
  }

  getSubName(int i) {
    return data["data"]["children"][i]["data"]["subreddit_name_prefixed"];
  }

  getSubSub(int i) {
    return data["data"]["children"][i]["data"]["subreddit_subscribers"];
  }

  getSubNamePro() {
    return data["data"]["display_name_prefixed"];
  }

  getSubTitlePro() {
    return data["data"]["title"];
  }

  getSubSubPro() {
    int nb = data["data"]["subscribers"];
    return nb.toString();
  }

  getSubDescPro() {
    return data["data"]["public_description"];
  }

  getSubImgPro() {
    String imgURL = data["data"]["icon_img"];
    if (imgURL == "") {
      var imgURL2 = data["data"]["community_icon"];
      if (imgURL2 == "")
        return "https://pcdn.sharethis.com/wp-content/uploads/2019/08/FeatureImage-Reddit-2-2.jpg";
      var lenght = imgURL2.indexOf('?');
      return imgURL2.substring(0, lenght);
    }
    return imgURL;
  }

  getSubBannerPro() {
    String bannerURL = data["data"]["banner_background_image"];
    if (bannerURL == "") {
      var bannerURL2 = data["data"]["header_img"];
      if (bannerURL2 == null)
        return "https://pcdn.sharethis.com/wp-content/uploads/2019/08/FeatureImage-Reddit-2-2.jpg";
      return data["data"]["header_img"];
    }
    var lenght = bannerURL.indexOf('?');
    return bannerURL.substring(0, lenght);
  }

  getSubCakePro() {
    double nb = data["data"]["created"];
    var date1 = new DateTime.fromMillisecondsSinceEpoch(nb.round() * 1000);
    var date2 = DateFormat('dd-MM-yyyy').format(date1);
    return date2.toString();
  }

  getSubOnlinePro() {
    int nb = data["data"]["active_user_count"];
    return nb.toString();
  }

  getSubUserSub() {
    return data["data"]["user_is_subscriber"];
  }

  postSubSub(String name, String value) async {
    await postApi(
        "https://oauth.reddit.com/api/subscribe?action=$value&sr_name=$name");
  }
}
