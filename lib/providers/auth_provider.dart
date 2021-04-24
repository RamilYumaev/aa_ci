import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _tokenSdo;
  String _serverErrorMessage;
  int _serverStatus;
  Uri _loginUrl = Uri.https("api.sdo.mpgu.org", "auth");

  String get serverError => _serverErrorMessage;

  // set serverError(String message) {
  //   _serverErrorMessage = message;
  //   notifyListeners();
  // }

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
    _serverErrorMessage = null;
    http.Response r = await http
        .get(_loginUrl, headers: <String, String>{'authorization': basicAuth});
    _serverStatus = r.statusCode;
    print(r.statusCode); //@TODO
    print(r.body); //@TODO
    final _responseData = json.decode(r.body);
    if (_responseData == null) {
      _serverErrorMessage = 'Проблемы с интернет соединением';
      return;
    }
    _tokenSdo = _responseData['token'];

    if (_tokenSdo != null) {
      saveToken(_tokenSdo);
    } else {
      _serverErrorMessage = errorMessageHandler(_serverStatus);
    }
    print(_serverErrorMessage);
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

  Future<void> logout() async {
    _tokenSdo = null;
    final pref = await SharedPreferences.getInstance();
    pref.remove('userData');
    pref.clear();
    notifyListeners();
  }

  errorMessageHandler(int status) {
    var response;
    switch (status) {
      case 401:
        response = "Неправильный логин или пароль!";
        break;
      case 403:
        response = "Не прав, обратитесь к администратору!";
        break;
      case 500:
        response = "Ошибка сервера";
        break;
      default:
        response = "Неизвестная ошибка";
    }
    return response;
  }
}
