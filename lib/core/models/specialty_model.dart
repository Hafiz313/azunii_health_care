class SpecialtyModel {
  final String category;
  final String name;
  final String description;

  SpecialtyModel({
    required this.category,
    required this.name,
    required this.description,
  });

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyModel(
      category: json['category'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'name': name,
      'description': description,
    };
  }
}
