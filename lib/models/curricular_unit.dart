import 'package:goipvc/models/teacher.dart';

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
  final String programContent;
  final String teachMethods;
  final String evaluation;
  final String mainBiblio;
  final String compBiblio;
  final List<dynamic> classType;
  final List<Teacher?> responsible;
  final List<Teacher?> otherTeachers;

  PUC({
    required this.summary,
    required this.objectives,
    required this.programContent,
    required this.teachMethods,
    required this.evaluation,
    required this.mainBiblio,
    required this.compBiblio,
    required this.classType,
    required this.responsible,
    required this.otherTeachers,
  });

  factory PUC.fromJson(Map<String, dynamic> json) {
    return PUC(
      summary: json['summary'],
      objectives: json['objectives'],
      programContent: json['programContent'],
      teachMethods: json['teachMethods'],
      evaluation: json['evaluation'],
      mainBiblio: json['mainBiblio'],
      compBiblio: json['compBiblio'],
      classType: json['classType'],
      responsible: json['responsible'] != null
          ? (json['responsible'] as List<dynamic>)
              .map((t) => Teacher.fromJson(t))
              .toList()
          : [],
      otherTeachers: json['otherTeachers'] != null
          ? (json['otherTeachers'] as List<dynamic>)
              .map((t) => Teacher.fromJson(t))
              .toList()
          : [],
    );
  }
}
