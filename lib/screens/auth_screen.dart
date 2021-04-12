import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _passwordVisible = true;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: 640,
            child: Column(
              children: [
                //   Image.asset("assets/img/logo.png"),
                Spacer(),
                SvgPicture.asset(
                  "assets/img/mpgu.svg",
                  height: 75.0,
                  width: 75.0,
                ),
                Spacer(),
                SvgPicture.asset(
                  "assets/img/logo_ci.svg",
                ),
                Form(
                    key: _formKey,
                    child: Container(
                        padding: EdgeInsets.all(25),
                        child: Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                    decoration: InputDecoration(
                                        labelText:
                                            "Введите логин или email АИС \"Абитуриент\""))),
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: "Пароль",
                                    suffixIcon: IconButton(
                                      icon: _passwordVisible
                                          ? Icon(Icons.visibility)
                                          : Icon(Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  obscureText: _passwordVisible,
                                )),
                          ],
                        ))),
                Spacer(),
                FlatButton(
                  height: 50.0,
                  minWidth: 250.0,
                  color: Colors.amber,
                  onPressed: () {},
                  child: Text("Начать работу"),
                ),
                Spacer(flex: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
