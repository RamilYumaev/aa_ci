import 'package:aa_ci/drawers/main_drawer.dart';
import 'package:aa_ci/screens/choice_vi_screen.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AnketaScreen extends StatelessWidget {
  static const routeName = "/anketa";
  GlobalKey<FormState> _anketaFormKey = GlobalKey();
  Map<String, String> _anketaData = {
    'lastName': "",
    'firstName': "",
    'patronymic': "",
    'phone': "",
    'email': "",
  };
  int educationLevelForm;

  Future<void> _submit(ctx) async {
    if (!_anketaFormKey.currentState.validate()) {
      return;
    }
    _anketaFormKey.currentState.save();
    print(_anketaData.toString()); //TODO
    print(educationLevelForm); //TODO

    if (educationLevelForm == 1) {
      Navigator.of(ctx).pushNamed(ChoiceViScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _maskFormatter = MaskTextInputFormatter(
        mask: "+###########", filter: {"#": RegExp(r'[0-9]')});
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  _submit(context);
                })
          ],
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text("Создание анкеты"),
        ),
        drawer: MainDrawer(),
        body: Form(
          key: _anketaFormKey,
          child: ListView(children: [
            Center(
              child: Text(
                  "Последовательно заполните поля,\n представленные ниже и нажмите \n на кнопку в правом верхнем углу!"),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                child: TextFormField(
                  onSaved: (lastName) {
                    _anketaData['lastName'] = lastName;
                  },
                  decoration: InputDecoration(labelText: "Фамилия"),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Поле не может быть пустым";
                    }
                    return null;
                  },
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                child: TextFormField(
                  onSaved: (firstName) {
                    _anketaData['firstName'] = firstName;
                  },
                  decoration: InputDecoration(labelText: "Имя"),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Поле не может быть пустым";
                    }
                    return null;
                  },
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                child: TextFormField(
                  onSaved: (patronymic) {
                    _anketaData['patronymic'] = patronymic;
                  },
                  decoration: InputDecoration(labelText: "Отчество"),
                  textCapitalization: TextCapitalization.sentences,
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                child: TextFormField(
                  onSaved: (phone) {
                    _anketaData['phone'] = phone;
                  },
                  keyboardType: TextInputType.phone,
                  inputFormatters: [_maskFormatter],
                  decoration: InputDecoration(labelText: "Телефон"),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Поле не может быть пустым";
                    }
                    return null;
                  },
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                child: TextFormField(
                  onSaved: (email) {
                    _anketaData['email'] = email;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration:
                      InputDecoration(labelText: "Адрес электронной почты"),
                  validator: (value) {
                    if (value.isEmpty && !value.contains("@")) {
                      return "Неправильный email";
                    }
                    return null;
                  },
                )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
              child: DropdownButtonFormField(
                onSaved: (educationLevel) {
                  educationLevelForm = educationLevel;
                },
                decoration: InputDecoration(labelText: "Уровень образования"),
                validator: (value) {
                  if (value == null) {
                    return "Список не может быть пустым";
                  }
                  return null;
                },
                onChanged: (value) {},
                items: [
                  DropdownMenuItem(
                    child: Text("Бакалавриат"),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Text("Магистратура"),
                    value: 2,
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}
