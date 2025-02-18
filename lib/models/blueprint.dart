class Blueprint {
  Blueprint({
    required this.index,
    required this.imageUrl,
    required this.legend,
  });

  final int index;
  final String imageUrl;
  final Map<String, String> legend;

  factory Blueprint.fromJson(Map<String, dynamic> json) {
    return Blueprint(
      index: json['index'],
      imageUrl: json['image_url'],
      legend: Map<String, String>.from(json['legend'] as Map),
    );
  }
}