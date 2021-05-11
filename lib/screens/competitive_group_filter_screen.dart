import 'package:aa_ci/screens/sending_screen.dart';

import '../api/competitive_group_api.dart';
import '../models/competitive_group.dart';
import '../providers/anketa_provider.dart';
import '../screens/competitive_group_detail_screen.dart';
import '../widgets/badge_widget.dart';
import '../widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class CompetitiveGroupFilterScreen extends StatefulWidget {
  static const routeName = "/competitive_group";
  final educationLevelId;

  CompetitiveGroupFilterScreen(this.educationLevelId);
  @override
  _CompetitiveGroupFilterScreenState createState() =>
      _CompetitiveGroupFilterScreenState(educationLevelId);
}

class _CompetitiveGroupFilterScreenState
    extends State<CompetitiveGroupFilterScreen> {
  final educationLevelId;
  List<CompetitiveGroup> comptitiveGroups = [];
  String query = '';
  Timer debouncer;
  _CompetitiveGroupFilterScreenState(this.educationLevelId);

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    // debouncer!.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      // debouncer.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future init() async {
    final cg = await CompetitiveGroupApi.getCompetitiveGroupFromServer(
        educationLevelId, query);
    setState(() => this.comptitiveGroups = cg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text("Выбор конкурсов"),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            if (educationLevelId == 1)
              IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: Colors.blueGrey,
                  ),
                  onPressed: () {}),
            Consumer<AnketaProvider>(
              builder: (_, anketa, ch) =>
                  Badge(child: ch, value: anketa.cgLength.toString()),
              child: IconButton(
                  icon: Icon(
                    Icons.account_tree,
                    color: Colors.blueGrey,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(SendingScreen.routeName);
                  }),
            )
          ],
        ),
        body: comptitiveGroups.isEmpty && query.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(children: <Widget>[
                buildSearch(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child:
                      Text("Найдено ${comptitiveGroups.length} конкурса(-ов)"),
                ),
                Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.all(5),
                        itemCount: comptitiveGroups.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.all(5),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CompetitiveGroupDetailScreen(
                                                  comptitiveGroups[index]
                                                      .competitiveGroupId)));
                                },
                                tileColor: Colors.white,
                                title: Text(
                                  comptitiveGroups[index].specializationName,
                                  style: TextStyle(fontSize: 19.0),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(comptitiveGroups[index].specialtyName),
                                    Text(
                                      comptitiveGroups[index].facultyName,
                                    ),
                                    Text(comptitiveGroups[index]
                                        .educationFormName),
                                  ],
                                ),
                                trailing: Icon(Icons.arrow_right),
                              ));
                        }))
              ]));
  }

  Widget buildSearch() => SearchWidget(
      text: query, onChanged: searchCg, hintText: "Введите ключевое слово");

  Future searchCg(String query) async => debounce(() async {
        final cg = await CompetitiveGroupApi.getCompetitiveGroupFromServer(
            educationLevelId, query);
        if (!mounted) return;
        setState(() {
          this.query = query;
          this.comptitiveGroups = cg;
        });
      });
}
