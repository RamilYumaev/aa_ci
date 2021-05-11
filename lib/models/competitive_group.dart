class CompetitiveGroup {
  final int competitiveGroupId;
  final String facultyName;
  final String specialtyName;
  final String specializationName;
  final String educationFormName;
  final String cgName;
  final List<dynamic> examinationsId;
  const CompetitiveGroup(
      {this.competitiveGroupId,
      this.facultyName,
      this.specialtyName,
      this.specializationName,
      this.educationFormName,
      this.examinationsId,
      this.cgName});

  factory CompetitiveGroup.fromJson(Map<String, dynamic> json) =>
      CompetitiveGroup(
        competitiveGroupId: json['competitive_group_id'],
        facultyName: json['faculty_name'],
        specialtyName: json['specialty_name'],
        specializationName: json['specialization_name'],
        educationFormName: json['education_form_name'],
        examinationsId: json['examinations_id'],
        cgName: json['cg_name'],
      );
  Map<String, dynamic> toJson() => {
        'competitive_group_id': competitiveGroupId,
        'faculty_name': facultyName,
        'specialty_name': specialtyName,
        'specialization_name': specializationName,
        'education_form_name': educationFormName,
        'cg_name': cgName,
      };
}
