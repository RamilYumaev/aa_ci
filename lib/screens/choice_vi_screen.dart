import 'package:flutter/material.dart';

class ChoiceViScreen extends StatelessWidget {
  static const routeName = "/choice";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Выберите способ сдачи ВИ"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(onPressed: () {}, child: Text("ЕГЭ")),
            ElevatedButton(onPressed: () {}, child: Text("ЦТ")),
            ElevatedButton(onPressed: () {}, child: Text("ВИ")),
            ElevatedButton(onPressed: () {}, child: Text("ЕГЭ/ВИ")),
            ElevatedButton(onPressed: () {}, child: Text("ЦТ/ВИ")),
          ],
        ),
      ),
    );
  }
}
