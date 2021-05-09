import 'package:aa_ci/models/cg_details.dart';
import 'package:aa_ci/providers/anketa_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/competitive_group_api.dart';

class CompetitiveGroupDetailScreen extends StatefulWidget {
  final int competitiveGroupId;

  CompetitiveGroupDetailScreen(this.competitiveGroupId);

  @override
  _CompetitiveGroupDetailScreenState createState() =>
      _CompetitiveGroupDetailScreenState();
}

class _CompetitiveGroupDetailScreenState
    extends State<CompetitiveGroupDetailScreen> {
  bool removeButton;

  @override
  void initState() {
    super.initState();
  }

  String getExaminationsText(List exam) {
    String text = exam.length > 1
        ? 'Вступительные испытания:\n'
        : 'Вступительное испытание:\n';
    for (var i = 0; i < exam.length; i++) {
      text += "${i + 1}. ${exam[i]}\n";
    }
    return text;
  }

  String getAdditionalTextButton(String type) {
    switch (type) {
      case 'budget':
        {
          return " бюджет";
        }
      case 'special':
        {
          return ' особую квоту';
        }
      case 'target':
        {
          return ' целевое обучение';
        }
      case 'contract':
        {
          return ' с оплатой';
        }
      default:
        {
          return ' ошибка';
        }
    }
  }

  ElevatedButton getButton(cgId, String cgName, String type) {
    Color buttonColor =
        Provider.of<AnketaProvider>(context, listen: false).colorButtonCg(cgId);
    String textButton =
        Provider.of<AnketaProvider>(context, listen: false).textButtonCg(cgId) +
            getAdditionalTextButton(type);
    bool removeButton = Provider.of<AnketaProvider>(context).containsCg(cgId);

    if (removeButton) {
      buttonColor = Colors.red[300];
      textButton = 'Удалить' + getAdditionalTextButton(type);
    } else {
      buttonColor = Colors.grey[300];
      textButton = 'Добавить' + getAdditionalTextButton(type);
    }

    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(buttonColor)),
        onPressed: () {
          Provider.of<AnketaProvider>(context, listen: false)
              .nessesaryMetod(cgId, cgName);
          setState(() {
            removeButton = !removeButton;
          });
        },
        child: Text(textButton));
  }

  @override
  Widget build(BuildContext context) {
    final cgDetails =
        CompetitiveGroupApi.getCgDetails(widget.competitiveGroupId);
    return Scaffold(
        appBar: AppBar(
          title: Text("Просмотр"),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: FutureBuilder(
          future: cgDetails,
          builder: (BuildContext context, AsyncSnapshot<CgDetails> snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Образовательная программа: \"${snapshot.data.specializationName}\"",
                        style: TextStyle(fontSize: 21.0),
                      ),
                      Divider(),
                      Text(
                        "Направление подготовки:\n${snapshot.data.specialtyName}",
                        style: TextStyle(fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                            "Институт/факультет, реализующий программу: ${snapshot.data.facultyName}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                            "Форма обучения: ${snapshot.data.educationFormName}"),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 140,
                                padding: const EdgeInsets.all(10),
                                color: snapshot.data.kcp > 0
                                    ? Colors.lightGreen
                                    : Colors.grey,
                                child: Column(
                                  children: [
                                    Text(
                                      "Бюджетных мест:",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      snapshot.data.kcp.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 167,
                                padding: const EdgeInsets.all(10),
                                color: Colors.blueGrey,
                                child: Column(
                                  children: [
                                    Text(
                                      "Проходной балл 2020:",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(snapshot.data.passingScore,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: 140,
                                  padding: const EdgeInsets.all(10),
                                  color: Colors.brown[200],
                                  child: Column(
                                    children: [
                                      Text(
                                        "Срок обучения \n(лет/года)",
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        snapshot.data.educationDuration,
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      )
                                    ],
                                  )),
                              Container(
                                  width: 167,
                                  padding: const EdgeInsets.all(10),
                                  color: Colors.amber,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Стоимость обучения\n(руб. в год)",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        snapshot.data.educationYearCost,
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            children: [
                              Text(
                                getExaminationsText(snapshot.data.examinations),
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ],
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (snapshot.data.budgetId != null)
                            getButton(snapshot.data.budgetId,
                                snapshot.data.budgetName, 'budget'),
                          if (snapshot.data.specialId != null)
                            getButton(snapshot.data.specialId,
                                snapshot.data.specialName, 'special'),
                          if (snapshot.data.targetId != null)
                            getButton(snapshot.data.targetId,
                                snapshot.data.targetName, 'target'),
                          if (snapshot.data.contractId != null)
                            getButton(snapshot.data.contractId,
                                snapshot.data.contractName, 'contract'),
                        ],
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
