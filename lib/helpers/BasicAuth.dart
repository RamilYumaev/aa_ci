import 'dart:convert';

class BasicAuth {
  static getAuthData() {
    return 'Basic ' + base64Encode(utf8.encode('adminsdotest:Fjjj76654ghhd43'));
  }
}
