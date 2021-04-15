import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _tokenSdo;
  String _serverError;
  Uri _loginUrl = Uri.https("api.sdo.mpgu.org", "auth");

  String get serverError {
    notifyListeners();
    return _serverError;
  }

  String get token {
    return _tokenSdo;
  }

  bool get isAuth {
    return _tokenSdo != null;
  }

  Future login(Map<String, String> _authData) async {
    String userName = _authData['userName'];
    String password = _authData['password'];
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$userName:$password'));
    http.Response r = await http
        .get(_loginUrl, headers: <String, String>{'authorization': basicAuth});
    print(r.statusCode);
    print(r.body);
    final _responseData = json.decode(r.body);
    if (_responseData == null) {
      _serverError = 'Проблемы с интернет соединением';
      return;
    }
    _tokenSdo = _responseData['token'];

    if (_tokenSdo != null) {
      saveToken(_tokenSdo);
    } else {
      _serverError = _responseData['error'];
    }
    notifyListeners();
  }

  Future<void> saveToken(token) async {
    final preference = await SharedPreferences.getInstance();
    final userData = json.encode({'token': token});
    preference.setString('userData', userData);
    notifyListeners();
  }

  tryAutoLogin() async {
    final preferrence = await SharedPreferences.getInstance();
    if (!preferrence.containsKey('userData')) {
      return;
    }
    final extractedData =
        json.decode(preferrence.getString("userData")) as Map<String, Object>;
    _tokenSdo = extractedData['token'];
    notifyListeners();
  }
}
