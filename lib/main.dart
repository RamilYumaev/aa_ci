import 'package:aa_ci/screens/auth_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Центр информации',
        theme: ThemeData(primarySwatch: Colors.amber),
        home: AuthScreen());
  }
}
