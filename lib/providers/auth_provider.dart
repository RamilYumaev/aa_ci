import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class AuthProvider with ChangeNotifier {
  String _tokenSdo;
  String _lastName;
  String _firstName;
  String _patronymic;
  String _email;
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

  String get fullName {
    return _lastName + " " + _firstName + " " + _patronymic;
  }

  String get email {
    return _email;
  }

  String get initials {
    return _lastName.characters.first.toUpperCase() +
        _firstName.characters.first.toUpperCase();
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
    print(r.statusCode); //TODO
    print(r.body); //TODO
    final _responseData = json.decode(r.body);
    if (_responseData == null) {
      _serverErrorMessage = 'Проблемы с интернет соединением';
      return;
    }
    _tokenSdo = _responseData['token'];
    _lastName = _responseData['lastName'];
    _firstName = _responseData['firstName'];
    _patronymic = _responseData['patronymic'];
    _email = _responseData['email'];

    if (_tokenSdo != null) {
      saveToken(_tokenSdo);
    } else {
      _serverErrorMessage = errorMessageHandler(_serverStatus);
    }
    print(_serverErrorMessage); //TODO
    notifyListeners();
  }

  Future<void> saveToken(token) async {
    final preference = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': token,
      'lastName': _lastName,
      'firstName': _firstName,
      'patronymic': _patronymic,
      'email': _email,
    });
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
    _lastName = extractedData['lastName'];
    _firstName = extractedData['firstName'];
    _patronymic = extractedData['patronymic'];
    _email = extractedData['email'];
    notifyListeners();
  }

  // extractedData() async {
  //   final preferrence = await SharedPreferences.getInstance();
  //   return json.decode(preferrence.getString("userData"))
  //       as Map<String, Object>;
  // }

  // String getDataSP(String data) {
  //   final extData = extractedData();
  //   return extData[data];
  // }

  Future<void> logout() async {
    _tokenSdo = null;
    _lastName = null;
    _firstName = null;
    _patronymic = null;
    _email = null;
    final pref = await SharedPreferences.getInstance();
    pref.remove('userData');
    pref.clear();
    notifyListeners();
    exit(0);
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
