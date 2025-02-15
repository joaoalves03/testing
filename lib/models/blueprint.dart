class Blueprint {
  Blueprint({
    required this.index,
    required this.school,
    required this.imageUrl,
    required this.legend,
  });

  final int index;
  final String school;
  final String imageUrl;
  final Map<String, String> legend;

  factory Blueprint.fromJson(Map<String, dynamic> json) {
    return Blueprint(
      index: json['index'] as int,
      school: json['school'] as String,
      imageUrl: json['image_url'] as String,
      legend: Map<String, String>.from(json['legend'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'school': school,
      'image_url': imageUrl,
      'legend': legend,
    };
  }
}