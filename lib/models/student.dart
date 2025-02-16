class Student {
  Student({
    required this.studentId,
    required this.firstName,
    required this.fullName,
    required this.schoolName,
    required this.schoolInitials,
    required this.course,
    required this.courseInitials,
  });

  int studentId;
  String firstName;
  String fullName;
  String schoolName;
  String schoolInitials;
  String course;
  String courseInitials;

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['studentId'],
      firstName: json['firstName'],
      fullName: json['fullName'],
      schoolName: json['schoolName'],
      schoolInitials: json['schoolInitials'],
      course: json['course'],
      courseInitials: json['courseInitials'],
    );
  }
}
