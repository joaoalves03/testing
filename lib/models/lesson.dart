import 'dart:collection';

class Lesson {
  final String shortName;
  final String className;
  final String classType;
  final String start;
  final String end;
  final String id;
  final List<String> teachers;
  final String room;
  final String statusColor;

  Lesson({
    required this.shortName,
    required this.className,
    required this.classType,
    required this.start,
    required this.end,
    required this.id,
    required this.teachers,
    required this.room,
    required this.statusColor,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      shortName: json['shortName'] as String,
      className: json['className'] as String,
      classType: json['classType'] as String,
      start: json['start'] as String,
      end: json['end'] as String,
      id: json['id'] as String,
      teachers: (json['teachers'] as List<dynamic>).cast<String>(),
      room: json['room'] as String,
      statusColor: json['statusColor'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shortName': shortName,
      'className': className,
      'classType': classType,
      'start': start,
      'end': end,
      'id': id,
      'teachers': teachers,
      'room': room,
      'statusColor': statusColor,
    };
  }

  final Map<String, String> _colorMap = HashMap.from({
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

  String getStatusFromColor(String color) {
    return _colorMap[color.toLowerCase()] ?? "Desconhecido";
  }
}