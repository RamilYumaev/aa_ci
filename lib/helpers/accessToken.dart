import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

class AccessToken {
  static Future<String> getToken() async {
    final pref = await SharedPreferences.getInstance();
    String token;
    if (pref.containsKey("userData")) {
      final userData = json.decode(pref.getString("userData"));
      token = userData['token'];
    }
    return token;
  }
}
