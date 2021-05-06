import 'package:aa_ci/api/competitive_group_api.dart';
import 'package:aa_ci/models/competitive_group.dart';
import 'package:aa_ci/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'dart:async';

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    init();
    _isLoading = false;
  }

  @override
  void dispose() {
    debouncer.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer.cancel();
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
          title: Text("Выбор конкурсных групп"),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: comptitiveGroups.isEmpty && query.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(children: <Widget>[
                buildSearch(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text("Найдено ${comptitiveGroups.length}"),
                ),
                Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.all(5),
                        itemCount: comptitiveGroups.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.all(5),
                              child: ListTile(
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
