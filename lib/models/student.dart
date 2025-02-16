class Student {
  Student({
    required this.studentId,
    required this.course,
    required this.courseId,
    required this.courseInitials,
    required this.firstName,
    required this.fullName,
    required this.schoolName,
    required this.schoolInitials,
  });

  int studentId;
  String course;
  int courseId;
  String courseInitials;
  String firstName;
  String fullName;
  String schoolName;
  String schoolInitials;

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['studentId'],
      course: json['course'],
      courseId: json['courseId'],
      courseInitials: json['courseInitials'],
      firstName: json['firstName'],
      fullName: json['fullName'],
      schoolName: json['schoolName'],
      schoolInitials: json['schoolInitials'],
    );
  }
}
