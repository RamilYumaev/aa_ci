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
            theme: ThemeData(primarySwatch: Colors.amber), home: AuthScreen()),
      ),
    );
    // return MaterialApp(
    //     title: 'Центр информации',
    //     theme: ThemeData(primarySwatch: Colors.amber),
    //     home: AuthScreen());
  }
}
