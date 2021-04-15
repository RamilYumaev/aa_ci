import 'package:aa_ci/screens/main_screen.dart';
import 'package:aa_ci/screens/splash_screen.dart';

import './providers/auth_provider.dart';
import './screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: AuthProvider())],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
            routes: {
              MainScreen.routeName: (ctx) => MainScreen(),
              SplashScreen.routeName: (ctx) => SplashScreen(),
            },
            theme: ThemeData(primarySwatch: Colors.amber),
            home: auth.isAuth
                ? MainScreen()
                : FutureBuilder(
                    builder: (ctx, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen())),
      ),
    );
  }
}
