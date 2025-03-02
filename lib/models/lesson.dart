import 'dart:collection';

class Lesson {
  final String id;
  final int curricularUnitId;
  final String shortName;
  final String className;
  final String classType;
  final String start;
  final String end;
  final List<String> teachers;
  final String room;
  final String statusColor;

  Lesson({
    required this.id,
    required this.curricularUnitId,
    required this.shortName,
    required this.className,
    required this.classType,
    required this.start,
    required this.end,
    required this.teachers,
    required this.room,
    required this.statusColor,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      curricularUnitId: json['curricularUnitId'],
      shortName: json['shortName'],
      className: json['className'],
      classType: json['classType'],
      start: json['start'],
      end: json['end'],
      teachers: (json['teachers'] as List<dynamic>).cast<String>(),
      room: json['room'],
      statusColor: json['statusColor'],
    );
  }

  static String getStatusFromColor(String color) {
    Map<String, String> colorMap = HashMap.from({
      "#cccccc": "Por lecionar/Não elaborado",
      "#78a3ce": "Por lecionar/Elaborado",
      "#f8ddb4": "Lecionada/Não elaborado",
      "#b3ddbf": "Lecionada/Elaborado",
      "#4bb341": "Lecionada/Publicado",
      "#f0a0a0": "Não Lecionada/Anulado",
      "#ff0000": "Anulada/Anulado",
      "#7f5555": "Substituida/Anulado",
      "#f09C01": "Justificada/Anulado",
      "#f05601": "Não Justificada/Anulado",
      "#1f1f1f": "Preparação de Aula",
      "#d9ad29": "Sem estado (erro)",
    });

    return colorMap[color.toLowerCase()] ?? "Desconhecido";
  }
}
