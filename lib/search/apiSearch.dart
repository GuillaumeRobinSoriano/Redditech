import 'dart:convert';
import 'package:redditech/api/api.dart';

class SearchApi {
  var data;

  SearchApi();

  fetchSearch(String search) async {
    var response = await getApi(
        "https://oauth.reddit.com/api/search_reddit_names.json?query=$search");
    data = jsonDecode(response.body);
    print(data["names"]);
  }

  getResultData() {
    return data["names"];
  }
}
