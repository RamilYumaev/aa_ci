import 'package:aa_ci/providers/auth_provider.dart';
import 'package:aa_ci/screens/auth_screen.dart';
import 'package:aa_ci/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        ListTile(
          title: Text("Главная"),
          onTap: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                MainScreen.routeName, (Route<dynamic> route) => false);
          },
        ),
        ListTile(
          onTap: () {
            Provider.of<AuthProvider>(context, listen: false).logout();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => AuthScreen()),
                (Route<dynamic> route) => false);
          },
          title: Text(
            "Выход",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        )
      ],
    ));
  }
}
