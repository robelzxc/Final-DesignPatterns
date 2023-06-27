import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CallApi {
  final String _url = 'https://ipt-todolist.000webhostapp.com/api/';

  postData(data, apiUrl) async {
    final String fullUrl = _url + apiUrl + await _getToken();
    return await http.post(
      Uri.parse(fullUrl),
      body: convert.jsonEncode(data),
      headers: _setHeaders());
  }
  getData(apiUrl) async {
    var fullUrl = _url + apiUrl + await _getToken();
    return await http.get(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
    );
  }

  updateData(data, apiUrl) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var fullUrl = _url + apiUrl;
    return await http.put(Uri.parse(fullUrl),
      body: convert.jsonEncode(data),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json; charset=UTF-8'
      }
    );
  }

  _setHeaders() => {
      'Content-type': 'application/json',
      'Accept': 'application/json; charset=UTF-8'
  };
  _getToken() async {
    SharedPreferences localStoage = await SharedPreferences.getInstance();
    var token = localStoage.getString('token');
    return '?token = $token';
  }

  Future<void> verifyEmail(String token) async {
    final response = await http.get(Uri.parse(_url + token));
    if(response.statusCode == 200) {

    }else {
      print('error');
    }
  }

  addNote(data, apiUrl) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var fullUrl = _url + apiUrl;
    return await http.post(
      Uri.parse(fullUrl),
      body: convert.jsonEncode(data),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json; charset=UTF-8'
      },
    );
  }

  updateNote(data, apiUrl)async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var fullUrl = _url + apiUrl;
    return await http.put(Uri.parse(fullUrl),
        body: convert.jsonEncode(data),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'application/json; charset=UTF-8'
        }
    );
  }
  deleteNote(apiUrl, id) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var fullUrl = _url + apiUrl + id;
    return await http.delete(Uri.parse(
        fullUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'application/json; charset=UTF-8'
        }
    );
  }
}