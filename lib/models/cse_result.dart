class CseResult {
  final int id;
  final String name;
  final int year;
  final int ball;
  CseResult({this.id, this.name, this.year, this.ball});

  factory CseResult.fromJson(Map<String, String> json) => CseResult(
      id: int.parse(json['id']),
      name: json['name'],
      year: int.parse(json['year']),
      ball: int.parse(json['ball']));

  Map<String, dynamic> toJson() => {'id': id, 'year': year, 'ball': ball};
}
