import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<http.Response> getApi(request) async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response = await http
      .get(Uri.parse('$request'), headers: {"Authorization": "Bearer $token"});
  if (response.statusCode == 200) {
    return (response);
  } else {
    print("response = ");
    print(response.statusCode);
    throw Exception('Failed to get api');
  }
}

Future<http.Response> patchApi(request, body) async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response = await http.patch(Uri.parse('$request'),
      headers: {"Authorization": "Bearer $token"}, body: body);
  if (response.statusCode == 200) {
    return (response);
  } else {
    print("response = ");
    print(response.statusCode);
    throw Exception('Failed to patch api');
  }
}

Future<http.Response> postApi(request) async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response = await http
      .post(Uri.parse('$request'), headers: {"Authorization": "Bearer $token"});
  if (response.statusCode == 200) {
    return (response);
  } else {
    print("response = ");
    print(response.statusCode);
    throw Exception('Failed to post api');
  }
}
