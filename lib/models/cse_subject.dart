import 'package:flutter/foundation.dart';

class CseSubject {
  final int id;
  final String name;
  final int minBall;

  const CseSubject(
      {@required this.id, @required this.name, @required this.minBall});

  factory CseSubject.fromJson(Map<String, dynamic> json) =>
      CseSubject(id: json['id'], name: json['name'], minBall: json['minBall']);
}
