class Teacher {
  final String? name;
  final String? email;

  Teacher({
    required this.name,
    required this.email,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      name: json['name'],
      email: json['email'],
    );
  }
}
