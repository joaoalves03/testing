class Student {
  Student({
    required this.studentId,
    required this.course,
    required this.courseId,
    required this.courseInitials,
    required this.fullName,
    this.email = "",
    required this.schoolName,
    required this.schoolInitials,
  });

  int studentId;
  String course;
  int courseId;
  String courseInitials;
  String fullName;
  String email;
  String schoolName;
  String schoolInitials;

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['studentId'],
      course: json['course'],
      courseId: json['courseId'],
      courseInitials: json['courseInitials'],
      fullName: json['fullName'],
      schoolName: json['schoolName'],
      schoolInitials: json['schoolInitials'],
    );
  }
}
