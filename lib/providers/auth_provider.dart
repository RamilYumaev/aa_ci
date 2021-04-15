import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  String _tokenSdo;
  String _serverError;
  Uri _loginUrl = Uri.https("api.sdo.mpgu.org", "auth");

  String get serverError {
    return _serverError;
  }

  String get token {
    return _tokenSdo;
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

    notifyListeners();
  }
}
