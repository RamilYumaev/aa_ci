import 'package:aa_ci/models/cg_details.dart';
import 'package:flutter/material.dart';

import '../api/competitive_group_api.dart';

class CompetitiveGroupDetailScreen extends StatelessWidget {
  final int competitiveGroupId;

  CompetitiveGroupDetailScreen(this.competitiveGroupId);

  String getExaminationsText(List exam) {
    String text = exam.length > 1
        ? 'Вступительные испытания:\n'
        : 'Вступительное испытание:\n';
    for (var i = 0; i < exam.length; i++) {
      text += "${i + 1}. ${exam[i]}\n";
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final cgDetails = CompetitiveGroupApi.getCgDetails(competitiveGroupId);
    return Scaffold(
        appBar: AppBar(
          title: Text("Детальный просмотр"),
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
                        "${snapshot.data.facultyName}",
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
                            "Образовательная программа:\n${snapshot.data.specializationName}"),
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
                                  color: Colors.brown.shade400,
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
