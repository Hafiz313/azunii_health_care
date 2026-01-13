class NotesModel {
  final int? id;
  final int patientId;
  final String category;
  final String note;

  NotesModel({
    this.id,
    required this.patientId,
    required this.category,
    required this.note,
  });

  factory NotesModel.fromJson(Map<String, dynamic> json) {
    return NotesModel(
      id: json['id'],
      patientId: int.tryParse(json['patient_id']?.toString() ?? '0') ?? 0,
      category: json['category'] ?? '',
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'patient_id': patientId,
      'category': category,
      'note': note,
    };
  }
}
