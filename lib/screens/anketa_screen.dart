import 'package:aa_ci/drawers/main_drawer.dart';
import 'package:aa_ci/providers/anketa_provider.dart';
import 'package:aa_ci/screens/competitive_group_filter_screen.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AnketaScreen extends StatelessWidget {
  static const routeName = "/anketa";
  GlobalKey<FormState> _anketaFormKey = GlobalKey();
  Map<String, Object> _anketaData = {
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
    Provider.of<AnketaProvider>(ctx, listen: false)
        .addPersonalData(_anketaData, educationLevelForm);

    Navigator.push(
        ctx,
        MaterialPageRoute(
            builder: (ctx) => CompetitiveGroupFilterScreen(
                  educationLevelForm,
                )));
  }

  @override
  Widget build(BuildContext context) {
    AnketaProvider anketa = Provider.of<AnketaProvider>(context);
    TextEditingController lastNameController =
        TextEditingController(text: anketa.lastName);
    TextEditingController firstNameController =
        TextEditingController(text: anketa.firstName);
    TextEditingController patronymicController =
        TextEditingController(text: anketa.patronymic);
    TextEditingController phoneController =
        TextEditingController(text: anketa.phoneNumber);
    TextEditingController emailController =
        TextEditingController(text: anketa.email);
    var _maskFormatter = MaskTextInputFormatter(
        mask: "7##########", filter: {"#": RegExp(r'[0-9]')});
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
          title: Text("???????????????? ????????????"),
        ),
        drawer: MainDrawer(),
        body: Form(
          key: _anketaFormKey,
          child: ListView(children: [
            Center(
              child: Text(
                  "?????????????????????????????? ?????????????????? ????????,\n ???????????????????????????? ???????? ?? ?????????????? \n ???? ???????????? ?? ???????????? ?????????????? ????????!"),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                child: TextFormField(
                  controller: lastNameController,
                  onSaved: (lastName) {
                    _anketaData['lastName'] = lastName;
                  },
                  decoration: InputDecoration(labelText: "??????????????"),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "???????? ???? ?????????? ???????? ????????????";
                    }
                    return null;
                  },
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                child: TextFormField(
                  controller: firstNameController,
                  onSaved: (firstName) {
                    _anketaData['firstName'] = firstName;
                  },
                  decoration: InputDecoration(labelText: "??????"),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "???????? ???? ?????????? ???????? ????????????";
                    }
                    return null;
                  },
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                child: TextFormField(
                  controller: patronymicController,
                  onSaved: (patronymic) {
                    _anketaData['patronymic'] = patronymic;
                  },
                  decoration: InputDecoration(labelText: "????????????????"),
                  textCapitalization: TextCapitalization.sentences,
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                child: TextFormField(
                  controller: phoneController,
                  onSaved: (phone) {
                    _anketaData['phone'] = phone;
                  },
                  keyboardType: TextInputType.phone,
                  inputFormatters: [_maskFormatter],
                  decoration: InputDecoration(labelText: "??????????????"),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value.isEmpty || value.length < 11) {
                      return "???????????????????????? ????????????";
                    }
                    return null;
                  },
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                child: TextFormField(
                  controller: emailController,
                  onSaved: (email) {
                    _anketaData['email'] = email;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration:
                      InputDecoration(labelText: "?????????? ?????????????????????? ??????????"),
                  validator: (value) {
                    if (value.isEmpty &&
                        !value.contains("@") &&
                        value.length < 5) {
                      return "???????????????????????? email";
                    }
                    return null;
                  },
                )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
              child: DropdownButtonFormField(
                // value: educationLevelForm,
                onSaved: (educationLevel) {
                  educationLevelForm = educationLevel;
                },
                onChanged: (value) {},
                decoration: InputDecoration(labelText: "?????????????? ??????????????????????"),
                validator: (value) {
                  if (value == null) {
                    return "???????????? ???? ?????????? ???????? ????????????";
                  }
                  return null;
                },
                items: [
                  DropdownMenuItem(
                    child: Text("??????????????????????"),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Text("????????????????????????"),
                    value: 2,
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}
