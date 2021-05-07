import 'package:aa_ci/helpers/accessToken.dart';
import 'package:aa_ci/models/cg_details.dart';
import 'package:aa_ci/models/competitive_group.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../helpers/accessToken.dart';

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

    final response = await http.get(url);
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

  static Future<CgDetails> getCgDetails(competitiveGroupId) async {
    final String accessToken = await AccessToken.getToken();
    final Map<String, Object> queryParameters = {
      'access-token': accessToken,
      'competitiveGroupId': competitiveGroupId.toString(),
    };
    final Uri url = Uri.https(
        'api.sdo.mpgu.org', 'mobile-ci/get-cg-details', queryParameters);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final detailData = json.decode(response.body) as Map<String, dynamic>;
      final cg = CgDetails.fromJson(detailData);
      return cg;
    }
  }
}
