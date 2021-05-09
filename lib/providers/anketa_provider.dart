import 'package:flutter/material.dart';

class AnketaProvider extends ChangeNotifier {
  String lastName;
  String firstName;
  String patronymic;
  String phoneNumber;
  String email;
  bool _allreadyAdded = false;
  List<int> cgIdArray = [];
  Map<String, String> competitiveGroups = {};

  int get cgLength {
    return competitiveGroups.length;
  }

  bool get allreadyAdded {
    return _allreadyAdded;
  }

  void addPersonalData(String lastName, String firstName, String patronymic,
      String phoneNumber, String email) {
    this.lastName = lastName;
    this.firstName = firstName;
    this.patronymic = patronymic;
    this.phoneNumber = phoneNumber;
    this.email = email;
    notifyListeners();
  }

  void addCompetitiveGroup(cgId, cgName) {
    competitiveGroups.putIfAbsent(cgId.toString(), () => cgName);
    print(competitiveGroups);
    notifyListeners();
  }

  void removeCompetitiveGroup(cgId) {
    competitiveGroups.remove(cgId.toString());
    print(competitiveGroups);
    notifyListeners();
  }

  bool containsCg(cgId) {
    return competitiveGroups.containsKey(cgId.toString());
  }

  String textButtonCg(cgId) {
    return this.containsCg(cgId) ? "Удалить" : "Добавить";
  }

  Color colorButtonCg(cgId) {
    return this.containsCg(cgId) ? Colors.red[300] : Colors.grey[300];
  }

  nessesaryMetod(cgId, cgName) {
    if (this.containsCg(cgId)) {
      removeCompetitiveGroup(cgId);
    } else {
      addCompetitiveGroup(cgId, cgName);
    }
  }
}
