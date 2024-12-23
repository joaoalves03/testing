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
}