class Caregiver {
  final int? id;
  final String email;
  final String fullName;
  final String relationship;
  final int canView;
  final int canAddNotes;
  final String? addedDate;

  Caregiver({
    this.id,
    required this.email,
    required this.fullName,
    required this.relationship,
    required this.canView,
    required this.canAddNotes,
    this.addedDate,
  });

  factory Caregiver.fromJson(Map<String, dynamic> json) {
    return Caregiver(
      id: json['id'] as int?,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      relationship: json['relationship'] as String,
      canView: json['can_view'] as int,
      canAddNotes: json['can_add_notes'] as int,
      addedDate: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'full_name': fullName,
      'relationship': relationship,
      'can_view': canView,
      'can_add_notes': canAddNotes,
    };
  }
}

class CaregiverListResponse {
  final List<Caregiver> caregivers;

  CaregiverListResponse({required this.caregivers});

  factory CaregiverListResponse.fromJson(Map<String, dynamic> json) {
    return CaregiverListResponse(
      caregivers: (json['data'] as List)
          .map((item) => Caregiver.fromJson(item))
          .toList(),
    );
  }
}
