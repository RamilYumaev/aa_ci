import 'package:flutter/material.dart';

class CgDetails {
  final int kcp;
  final String specialtyName;
  final String facultyName;
  final String specializationName;
  final String educationFormName;
  final String competitionCount;
  final String passingScore;
  final String educationYearCost;
  final String educationDuration;
  final List examinations;

  CgDetails(
      {@required this.kcp,
      @required this.specialtyName,
      @required this.facultyName,
      @required this.specializationName,
      @required this.educationFormName,
      @required this.competitionCount,
      @required this.passingScore,
      @required this.educationYearCost,
      @required this.educationDuration,
      @required this.examinations});

  factory CgDetails.fromJson(Map<String, dynamic> json) => CgDetails(
      kcp: json['kcp'],
      specialtyName: json['specialty_name'].toString(),
      facultyName: json['faculty_name'].toString(),
      specializationName: json['specialization_name'].toString(),
      educationFormName: json['education_form_name'].toString(),
      competitionCount: json['competition_count'].toString(),
      passingScore: json['passing_score'].toString(),
      educationYearCost: json['education_year_cost'].toString(),
      educationDuration: json['education_duration'].toString(),
      examinations: json['examinations']);
}
