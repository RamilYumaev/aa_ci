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
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false).login(_authData);
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error?.toString())));
    }
    final errorServer =
        Provider.of<AuthProvider>(context, listen: false).serverError;
    if (errorServer != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorServer)));
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final diviceSize = MediaQuery.of(context).size;
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 25),
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
                    child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Поле не должно быть пустым";
                              }
                              return null;
                            },
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Поле не должно быть пустым";
                            }
                            return null;
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
                : SizedBox(
                    width: diviceSize.width - 50,
                    child: ElevatedButton(
                      style: ButtonStyle(),
                      onPressed: () {
                        _submit();
                      },
                      child: Text("Начать работу"),
                    ),
                  ),
            Spacer(flex: 4),
          ],
        ),
      ),
    );
  }
}
