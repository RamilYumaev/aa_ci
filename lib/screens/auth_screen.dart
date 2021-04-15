import 'package:aa_ci/models/login.dart';
import 'package:aa_ci/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {'userName': " ", 'password': " "};
  bool _passwordVisible = true;
  final _login = TextEditingController();
  final _password = TextEditingController();

  Future<void> _submit() async {
    // if (!_formKey.currentState.validate()) {
    //   return; //@todo
    // }
    print("press_button_into_submit");

    print(_authData['userName']);
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false).login(_authData);
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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
                                controller: _login,
                                onSaved: (value) {
                                  _authData['userName'] = value;
                                },
                                decoration: InputDecoration(
                                    labelText:
                                        "Введите логин или email АИС \"Абитуриент\""))),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              controller: _password,
                              onSaved: (value) {
                                _authData['password'] = value;
                              },
                              decoration: InputDecoration(
                                labelText: "Пароль",
                                suffixIcon: IconButton(
                                  icon: _passwordVisible
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
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
            _isLoading
                ? CircularProgressIndicator()
                : RaisedButton(
                    color: Colors.amber,
                    onPressed: () {
                      _submit();
                      print(_authData['userName']);
                    },
                    child: Text("Начать работу"),
                  ),
            Spacer(flex: 4),
          ],
        ),
      ),
    );
  }
}
