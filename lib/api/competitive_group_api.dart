import 'package:aa_ci/helpers/accessToken.dart';
import 'package:aa_ci/models/cg_details.dart';
import 'package:aa_ci/models/competitive_group.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class CompetitiveGroupApi {
  static Future<List<CompetitiveGroup>> getCompetitiveGroupFromServer(
      educationLevelId, String query) async {
    final String accessToken = await AccessToken.getToken();
    final Map<String, Object> queryParameters = {
      'access-token': accessToken,
      'educationLevelId': educationLevelId.toString(),
    };
    final Uri url =
        Uri.https('api.sdo.mpgu.org', 'mobile-ci/get-cgs', queryParameters);

    final response = await http.get(url).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      final List competitiveGroup = json.decode(response.body);

      return competitiveGroup
          .map((json) => CompetitiveGroup.fromJson(json))
          .where((competitiveGroup) {
        final facultyNameLower = competitiveGroup.facultyName.toLowerCase();
        final specialtyNameLower = competitiveGroup.specialtyName.toLowerCase();
        final specializationNameLower =
            competitiveGroup.specializationName.toLowerCase();
        final educationFormNameLower =
            competitiveGroup.educationFormName.toLowerCase();
        final searchLower = query.toLowerCase();
        return facultyNameLower.contains(searchLower) ||
            specialtyNameLower.contains(searchLower) ||
            specializationNameLower.contains(searchLower) ||
            educationFormNameLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }

  static Future<List<CompetitiveGroup>> getCompetitiveGroupFilteredBySubjectCse(
      List subjectId) async {
    final String accessToken = await AccessToken.getToken();
    final Map<String, Object> queryParameters = {
      'access-token': accessToken,
      'educationLevelId': '1',
    };
    final Uri url =
        Uri.https('api.sdo.mpgu.org', 'mobile-ci/get-cgs', queryParameters);

    final response = await http.get(url).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      final List competitiveGroup = json.decode(response.body);

      final List mergedSubjectIds = [
        ...subjectId,
        16,
        17,
        18,
        22,
        24,
        25,
        380,
        383
      ];

      return competitiveGroup
          .map((json) => CompetitiveGroup.fromJson(json))
          .where((competitiveGroup) {
        List array = [];
        competitiveGroup.examinationsId.forEach((element) {
          bool value = mergedSubjectIds.contains(element);
          array.add(value);
        });

        return !array.contains(false);
      }).toList();
    } else {
      throw Exception();
    }
  }

  static Future<CgDetails> getCgDetails(competitiveGroupId) async {
    final String accessToken = await AccessToken.getToken();
    final Map<String, Object> queryParameters = {
      'access-token': accessToken,
      'competitiveGroupId': competitiveGroupId.toString(),
    };
    final Uri url = Uri.https(
        'api.sdo.mpgu.org', 'mobile-ci/get-cg-details', queryParameters);
    final response = await http.get(url).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      final detailData = json.decode(response.body) as Map<String, dynamic>;
      final cg = CgDetails.fromJson(detailData);
      return cg;
    }
    throw Exception();
  }

  static Future<Map<String, dynamic>> sendAnketa(
      Map<String, dynamic> anketa) async {
    final String accessToken = await AccessToken.getToken();
    final Uri url = Uri.https('api.sdo.mpgu.org', 'mobile-ci/get-anketa',
        {'access-token': accessToken});

    final response = await http
        .post(
          url,
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
            'Accept': 'application/json',
          },
          body: json.encode(anketa),
        )
        .timeout(Duration(seconds: 15));

    return json.decode(response.body) as Map<String, dynamic>;
  }

  static getCseSubject() async {
    final String accessToken = await AccessToken.getToken();
    final Uri url = Uri.https('api.sdo.mpgu.org', 'mobile-ci/get-dict-cse',
        {'access-token': accessToken});
    final response = await http.get(url).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      var cseSubjectList = json.decode(response.body);
      return cseSubjectList;
    } else {
      throw Exception('Failed to load CSE subjects');
    }
  }
}
