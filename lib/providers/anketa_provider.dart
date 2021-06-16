import 'package:aa_ci/api/competitive_group_api.dart';
import 'package:aa_ci/models/cse_result.dart';
import 'package:flutter/material.dart';

class AnketaProvider with ChangeNotifier {
  String lastName;
  String firstName;
  String patronymic;
  String phoneNumber;
  String email;
  String talonNumber;
  int educationLevelForm;
  bool cseChecker = false;
  Map<String, String> competitiveGroups = {};
  List<CseResult> cseValueList = [];

  int get cgLength {
    return competitiveGroups.length;
  }

  void destruct() {
    this.lastName = null;
    this.firstName = null;
    this.patronymic = null;
    this.phoneNumber = null;
    this.email = null;
    this.educationLevelForm = null;
    this.talonNumber = null;
    this.competitiveGroups = {};
  }

  bool changeCseChecker(bool value) {
    this.cseChecker = value;
    notifyListeners();
  }

  void addCseValue(CseResult cseValue) {
    var cse = cseValueList.where((element) => element.id == cseValue.id);

    if (cse.isEmpty) {
      cseValueList.add(cseValue);
    }

    notifyListeners();
  }

  void removeCseValue(CseResult cseValue) {
    cseValueList.removeWhere((element) => element.id == cseValue.id);
    notifyListeners();
  }

  Future<Map<String, dynamic>> sendAnketa(talon) async {
    this.talonNumber = talon;

    final Map<String, dynamic> anketa = {
      'talon': this.talonNumber,
      'last_name': this.lastName,
      'first_name': this.firstName,
      'patronymic': this.patronymic,
      'phone': this.phoneNumber,
      'email': this.email,
      'competitive_groups': competitiveGroups.keys.toList(),
      'cse_list': cseValueList.map((json) => json.toJson()).toList()
    };
    Map<String, dynamic> response =
        await CompetitiveGroupApi.sendAnketa(anketa);

    return response;
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
    notifyListeners();
  }

  void removeCompetitiveGroup(cgId) {
    competitiveGroups.remove(cgId.toString());
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

    return this.talonNumber == null
        ? this.lastName + " " + this.firstName.characters.first + "." + patro
        : this.talonNumber;
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
