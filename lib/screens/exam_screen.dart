import 'package:aa_ci/models/cse_result.dart';

import '../api/competitive_group_api.dart';
import '../providers/anketa_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExamScreen extends StatefulWidget {
  static const routeName = "/cse_screen";

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  // bool _giveVerse = false;
  List<CseResult> cseList = [];
  final GlobalKey<FormState> _formKey = GlobalKey();
  List data = [];
  Map<String, dynamic> cseValueMap = {
    'subject_id': 0,
    'year': 0,
    'subject_ball': 0
  };

  List<int> yearList() {
    final int currentYear = DateTime.now().year;
    final List<int> yearsList = [];
    for (var i = 0; i < 5; i++) {
      var year = currentYear - i;
      yearsList.add(year);
    }
    return yearsList;
  }

  getData() async {
    var dropData = await CompetitiveGroupApi.getCseSubject();

    setState(() {
      data = dropData;
    });
  }

  _submit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    setState(() {
      String cseName = data
          .where((element) => element['id'] == cseValueMap['subject_id'])
          .first['name'];
      CseResult cseValue = CseResult(
          id: cseValueMap['subject_id'],
          name: cseName,
          year: cseValueMap['year'],
          ball: cseValueMap['subject_ball']);
      Provider.of<AnketaProvider>(context, listen: false).addCseValue(cseValue);
      cseList =
          Provider.of<AnketaProvider>(context, listen: false).cseValueList;
    });

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    cseList = Provider.of<AnketaProvider>(context, listen: false).cseValueList;
    getData();
  }

  // Switch switchInitState() {
  //   _giveVerse = Provider.of<AnketaProvider>(context, listen: false).cseChecker;

  //   return Switch.adaptive(
  //       value: _giveVerse,
  //       onChanged: (bool newValue) {
  //         setState(() {
  //           _giveVerse = newValue;
  //         });
  //         Provider.of<AnketaProvider>(context, listen: false)
  //             .changeCseChecker(newValue);
  //       });
  // }

  void _showForm(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) => GestureDetector(
              child: Form(
                key: _formKey,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    height: 375,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: DropdownButtonFormField(
                              onChanged: (value) {
                                cseValueMap['subject_id'] = value;
                              },
                              decoration: InputDecoration(
                                  labelText: "Выберите предмет"),
                              items: data
                                  .map((model) => DropdownMenuItem(
                                        child: Text(
                                            "${model['name']} (${model['minBall']})"),
                                        value: model['id'],
                                      ))
                                  .toList(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: DropdownButtonFormField(
                                onChanged: (value) {
                                  cseValueMap['year'] = value;
                                },
                                onSaved: (value) {
                                  cseValueMap['year'] = value;
                                },
                                decoration: InputDecoration(
                                    labelText: "Укажите год сдачи"),
                                items: yearList()
                                    .map((year) => DropdownMenuItem(
                                          child: Text(year.toString()),
                                          value: year,
                                        ))
                                    .toList()),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                  onSaved: (value) {
                                    cseValueMap['subject_ball'] =
                                        int.parse(value);
                                  },
                                  validator: (value) {
                                    var intValue = int.parse(value);
                                    var minBall = data
                                        .where((element) =>
                                            element['id'] ==
                                            cseValueMap['subject_id'])
                                        .first['minBall'];

                                    if (value.isEmpty) {
                                      return "Поле не должно быть пустым!";
                                    }

                                    if (intValue < minBall) {
                                      return "Балл не может быть меньше чем ${minBall}";
                                    }

                                    if (intValue > 100) {
                                      return "Балл не может превышать значение 100";
                                    }

                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: "Укажите балл"))),
                          Padding(
                              padding: const EdgeInsets.all(20),
                              child: ElevatedButton(
                                  onPressed: () {
                                    _submit();
                                  },
                                  child: Text("Добавить")))
                        ],
                      ),
                    )),
              ),
              behavior: HitTestBehavior.opaque,
            ));

    // setState(() {
    //   cseList =
    //       Provider.of<AnketaProvider>(context, listen: false).cseValueList;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Результаты ЕГЭ"),
        actions: [],
      ),
      body: cseList.isEmpty
          ? Center(child: Text("Добавьте предметы ЕГЭ"))
          : ListView(
              children: cseList
                  .map((cseValue) => Dismissible(
                      confirmDismiss: (direction) {
                        return showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: Text(
                                      "Вы действительно хотите удалить предмет ${cseValue.name}?"),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Text("Нет")),
                                    TextButton(
                                        onPressed: () {
                                          Provider.of<AnketaProvider>(context,
                                                  listen: false)
                                              .removeCseValue(cseValue);
                                          Navigator.of(context).pop(true);
                                        },
                                        child: Text("Да"))
                                  ],
                                ));
                      },
                      background: Container(
                        alignment: Alignment.center,
                        color: Colors.red[300],
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      key: ValueKey(cseValue.id),
                      child: Card(
                        child: ListTile(
                          title: Text("${cseValue.name}"),
                          subtitle: Row(
                            children: <Widget>[
                              Text("Результат: ${cseValue.ball} балла(-ов), "),
                              Text("год сдачи: ${cseValue.year}"),
                            ],
                          ),
                        ),
                      )))
                  .toList(),
            ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: () => _showForm(context)),
    );
  }
}
