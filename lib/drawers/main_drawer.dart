import 'package:aa_ci/providers/auth_provider.dart';
import 'package:aa_ci/screens/auth_screen.dart';
import 'package:aa_ci/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fullName = Provider.of<AuthProvider>(context, listen: false).fullName;
    final accountEmail =
        Provider.of<AuthProvider>(context, listen: false).email;
    final initials = Provider.of<AuthProvider>(context, listen: false).initials;
    return Drawer(
        child: ListView(
      children: [
        UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(initials),
            ),
            accountName: Text(fullName),
            accountEmail: Text(accountEmail)),
        ListTile(
          title: Text("Главная"),
          onTap: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                MainScreen.routeName, (Route<dynamic> route) => false);
          },
        ),
        ListTile(
          title: Text("Перезагрузка"),
          onTap: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                MainScreen.routeName, (Route<dynamic> route) => false);
            Phoenix.rebirth(context);
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
