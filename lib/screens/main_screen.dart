import 'package:aa_ci/drawers/main_drawer.dart';
import 'package:aa_ci/screens/anketa_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  static const routeName = "/main";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text("Центр информации"),
        ),
        body: ListView(
          padding: EdgeInsets.all(10),
          children: [
            ListTile(
              leading: Icon(Icons.badge),
              trailing: Icon(Icons.arrow_right),
              tileColor: Colors.white,
              title: Text(
                "Создать анкету",
                style: TextStyle(fontSize: 20.0),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(AnketaScreen.routeName);
              },
              subtitle: Text("создание новой анкеты для поступающего в МПГУ"),
            )
          ],
        ));
  }
}
