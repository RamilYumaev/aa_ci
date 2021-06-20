import 'package:aa_ci/providers/anketa_provider.dart';
import 'package:aa_ci/screens/anketa_screen.dart';
import 'package:aa_ci/screens/exam_screen.dart';
import 'package:aa_ci/screens/main_screen.dart';
import 'package:aa_ci/screens/sending_screen.dart';
import 'package:aa_ci/screens/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import './providers/auth_provider.dart';
import './screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
//    if (kReleaseMode) {
//      exit(1);
    //   }
  };
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProvider.value(value: AnketaProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            routes: {
              AnketaScreen.routeName: (ctx) => AnketaScreen(),
              MainScreen.routeName: (ctx) => MainScreen(),
              //  ChoiceViScreen.routeName: (ctx) => ChoiceViScreen(),
              SendingScreen.routeName: (ctx) => SendingScreen(),
              ExamScreen.routeName: (ctx) => ExamScreen(),
            },
            theme: ThemeData(primarySwatch: Colors.amber),
            home: auth.isAuth
                ? MainScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen())),
      ),
    );
  }
}
