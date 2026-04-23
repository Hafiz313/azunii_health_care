class SpecialtyModel {
  final int id;
  final String category;
  final String name;
  final String description;

  SpecialtyModel({
    required this.id,
    required this.category,
    required this.name,
    required this.description,
  });

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyModel(
      id: json['id'] ?? 0,
      category: json['category'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'name': name,
      'description': description,
    };
  }
}
