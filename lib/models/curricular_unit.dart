class CurricularUnit {
  int id;
  String name;
  int year;
  int semester;
  int ects;
  List<UnitGrade> grades;
  PUC? puc;
  int? finalGrade;

  CurricularUnit({
    required this.id,
    required this.name,
    required this.year,
    required this.semester,
    required this.ects,
    required this.grades,
    this.puc,
    this.finalGrade,
  });

  factory CurricularUnit.fromJson(Map<String, dynamic> json) {
    final gradesJson = json['grade'] as List<dynamic>;
    final grades = gradesJson.map((g) => UnitGrade.fromJson(g)).toList();

    return CurricularUnit(
      id: json['id'],
      name: json['name'],
      year: json['year'],
      semester: json['semester'],
      grades: grades,
      finalGrade: json['highestGrade'],
      ects: json['ects'],
    );
  }
}

class UnitGrade {
  final int? value;
  final String? evaluationType;
  final String status;
  final String? date;
  final String academicYear;

  UnitGrade({
    required this.value,
    required this.evaluationType,
    required this.status,
    required this.date,
    required this.academicYear,
  });

  factory UnitGrade.fromJson(List<dynamic> json) {
    return UnitGrade(
      value: json[0],
      evaluationType: json[1],
      status: json[2],
      date: json[3],
      academicYear: json[4],
    );
  }
}

class PUC {
  final String summary;
  final String objectives;
  final String courseContent;
  final String methodologies;
  final String evaluation;
  final String bibliography;
  final String bibliographyExtra;

  PUC({
    required this.summary,
    required this.objectives,
    required this.courseContent,
    required this.methodologies,
    required this.evaluation,
    required this.bibliography,
    required this.bibliographyExtra,
  });

  factory PUC.fromJson(Map<String, dynamic> json) {
    return PUC(
      summary: json['summary'],
      objectives: json['objectives'],
      courseContent: json['courseContent'],
      methodologies: json['methodologies'],
      evaluation: json['evaluation'],
      bibliography: json['bibliography'],
      bibliographyExtra: json['bibliographyExtra'],
    );
  }
}
