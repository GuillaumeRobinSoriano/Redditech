import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:redditech/api/api.dart';

class ProfileApi {
  var data;

  ProfileApi();

  fetchProfile() async {
    var response = await getApi("https://oauth.reddit.com/api/v1/me");
    data = jsonDecode(response.body);
  }

  getProfileName() {
    return data["name"];
  }

  getProfileDescription() {
    return data["subreddit"]["public_description"];
  }

  getProfileBanner() {
    String bannerURL = data["subreddit"]["banner_img"];
    return bannerURL.replaceAll("amp;", "");
  }

  getProfilePicture() {
    String bannerURL = data["subreddit"]["icon_img"];
    return bannerURL.replaceAll("amp;", "");
  }

  getNbFollowers() {
    int nb = data["subreddit"]["subscribers"];
    return nb.toString();
  }

  getNbKarma() {
    var nb = data["total_karma"];
    return nb.toString();
  }

  getDateUtc() {
    double nb = data["created_utc"];
    var date1 = new DateTime.fromMillisecondsSinceEpoch(nb.round() * 1000);
    var date2 = DateFormat('dd-MM-yyyy').format(date1);
    return date2.toString();
  }
}
