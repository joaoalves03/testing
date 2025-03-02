class CurricularUnit {
  int id;
  String name;
  int year;
  int semester;
  int ects;
  String? evaluationType;
  List<UnitGrade> grades;
  int? finalGrade;

  CurricularUnit({
    required this.id,
    required this.name,
    required this.year,
    required this.semester,
    required this.ects,
    this.evaluationType,
    required this.grades,
    this.finalGrade,
  });

  factory CurricularUnit.fromJson(Map<String, dynamic> json) {
    final gradesJson = json['grade'] as List<dynamic>;
    final grades = gradesJson.map((g) => UnitGrade.fromJson(g)).toList();

    return CurricularUnit(
      id: json['id'],
      name: json['name'] as String,
      year: json['year'],
      semester: json['semester'],
      evaluationType: json['evaluationType'],
      grades: grades,
      finalGrade: json['highestGrade'],
      ects: json['ects'],
    );
  }
}

class UnitGrade {
  final int? value;
  final String status;
  final String? date;
  final String academicYear;

  UnitGrade({
    required this.value,
    required this.status,
    required this.date,
    required this.academicYear,
  });

  factory UnitGrade.fromJson(List<dynamic> json) {
    return UnitGrade(
      value: json[0],
      status: json[1] as String,
      date: json[2],
      academicYear: json[3] as String,
    );
  }
}