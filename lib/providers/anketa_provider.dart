import 'package:flutter/material.dart';

class AnketaProvider extends ChangeNotifier {
  String lastName;
  String firstName;
  String patronymic;
  String phoneNumber;
  String email;
  String talonNumber;
  int educationLevelForm;
  List<int> cgIdArray = [];
  Map<String, String> competitiveGroups = {};

  int get cgLength {
    return competitiveGroups.length;
  }

  void setTalon(talon) {
    this.talonNumber = talon;

    print(talonNumber);
    notifyListeners();
  }

  void addPersonalData(Map<String, Object> _anketaData, educationLevelForm) {
    this.lastName = _anketaData['lastName'];
    this.firstName = _anketaData['firstName'];
    this.patronymic = _anketaData['patronymic'];
    this.phoneNumber = _anketaData['phone'];
    this.email = _anketaData['email'];
    this.educationLevelForm = educationLevelForm;
    notifyListeners();
  }

  void addCompetitiveGroup(cgId, cgName) {
    competitiveGroups.putIfAbsent(cgId.toString(), () => cgName);
    print(competitiveGroups); //TODO
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

  String defauiltTaloneVolume() {
    var patro = "";

    if (this.lastName == null && this.firstName == null) {
      return "";
    }
    if (this.patronymic != null) {
      patro = this.patronymic.characters.first + ".";
    }

    return this.lastName + " " + this.firstName.characters.first + "." + patro;
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
