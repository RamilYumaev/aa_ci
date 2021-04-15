import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/splash';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset("/assets/img/single_logo.png")),
    );
  }
}
