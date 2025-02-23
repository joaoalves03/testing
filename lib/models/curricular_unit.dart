class CurricularUnit {
  CurricularUnit({
    required this.id,
    required this.name,
    this.finalGrade,
    required this.academicYear,
    required this.studyYear,
    required this.semester,
    required this.ects,
  });

  int id;
  String name;
  int? finalGrade;
  String academicYear;
  int studyYear;
  int semester;
  int ects;

  factory CurricularUnit.fromJson(Map<String, dynamic> json) {
    return CurricularUnit(
      id: json['id'].toInt(),
      name: json['name'] as String,
      finalGrade: _parseFinalGrade(json['finalGrade']),
      academicYear: json['academicYear'] as String,
      studyYear: json['studyYear'].toInt(),
      semester: json['semester'].toInt(),
      ects: json['ects'].toInt(),
    );
  }

  static int? _parseFinalGrade(dynamic value) {
    if (value is num) return value.toInt();
    return null;
  }
}