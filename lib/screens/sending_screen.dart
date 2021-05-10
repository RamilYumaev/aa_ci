import 'package:aa_ci/screens/main_screen.dart';

import '../drawers/main_drawer.dart';
import '../providers/anketa_provider.dart';
import 'package:aa_ci/screens/anketa_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendingScreen extends StatefulWidget {
  static const routeName = '/sending';

  @override
  _SendingScreenState createState() => _SendingScreenState();
}

class _SendingScreenState extends State<SendingScreen> {
  GlobalKey<FormState> _globalKey = GlobalKey();
  bool _isLoading = false;
  String talon = "";

  _submit() {
    if (!_globalKey.currentState.validate()) {
      return;
    }
    _globalKey.currentState.save();
    try {
      setState(() {
        _isLoading = true;
      });

      Provider.of<AnketaProvider>(context, listen: false).setTalon(talon);
      Navigator.of(context).pushNamed(MainScreen.routeName);
    } catch (error) {
      throw Exception(error);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Успешно отправлено!",
        ),
        backgroundColor: Colors.green[900]));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController talonController = TextEditingController(
        text: Provider.of<AnketaProvider>(context, listen: false)
            .defauiltTaloneVolume());
    AnketaProvider anketa = Provider.of<AnketaProvider>(context, listen: false);
    Map<String, String> competitiveGroup = anketa.competitiveGroups;
    print(competitiveGroup); //TODO
    var cgKey = competitiveGroup.keys.toList();
    print(cgKey); //TODO
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Отправить анкету"),
        actions: [
          IconButton(
              icon: _isLoading
                  ? SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
              onPressed: () {
                print("этап 1");
                _submit();
              }) // TODO  Куда отправлять?
        ],
      ),
      drawer: MainDrawer(),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.blue)),
                onPressed: () {
                  Navigator.of(context).pushNamed(AnketaScreen.routeName);
                },
                child: Text("Редактировать"),
              ),
              Text(
                "Фамилия: ${anketa.lastName}",
                style: TextStyle(fontSize: 15),
              ),
              Text("Имя: ${anketa.firstName}", style: TextStyle(fontSize: 15)),
              Text("Отчество: ${anketa.patronymic}",
                  style: TextStyle(fontSize: 15)),
              Text("Номер телефона: ${anketa.phoneNumber}",
                  style: TextStyle(fontSize: 15)),
              Text("Email: ${anketa.email}", style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
        Divider(),
        Column(
          children: <Widget>[
            Text(
              "Талон:",
              style: TextStyle(color: Colors.blue, fontSize: 15),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                  key: _globalKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty && value.length < 2) {
                        return "Длина поля не должна быть меньше 2 символов";
                      }
                      return null;
                    },
                    decoration: InputDecoration(),
                    controller: talonController,
                    onSaved: (value) {
                      talon = value;
                    },
                  )),
            ),
          ],
        ),
        Divider(),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Выбранные конкурсы",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                Text("Удалять конкурсы можно свайпом влево."),
              ],
            )),
        Expanded(
          child: ListView.builder(
              itemCount: competitiveGroup.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey(cgKey[index]),
                  background: Container(
                    color: Colors.red[300],
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 40,
                    ),
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text(competitiveGroup[cgKey[index]]),
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) {
                    return showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: Text(
                                  "Вы действительно хотите удалить конкурс?"),
                              content:
                                  Text("${competitiveGroup[cgKey[index]]}"),
                              actions: <Widget>[
                                TextButton(
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blue)),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text("Нет")),
                                TextButton(
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blue)),
                                    onPressed: () {
                                      Provider.of<AnketaProvider>(context,
                                              listen: false)
                                          .removeCompetitiveGroup(cgKey[index]);
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text("Да"))
                              ],
                            ));
                  },
                );
              }),
        ),
      ]),
    );
  }
}
