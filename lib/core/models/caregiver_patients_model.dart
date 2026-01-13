class CaregiverPatientsResponse {
  final bool status;
  final String message;
  final List<CaregiverPatient> data;

  CaregiverPatientsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CaregiverPatientsResponse.fromJson(Map<String, dynamic> json) {
    return CaregiverPatientsResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => CaregiverPatient.fromJson(item))
          .toList(),
    );
  }
}

class CaregiverPatient {
  final int id;
  final String userId;
  final String caregiverId;
  final String relationship;
  final String canView;
  final String canAddNotes;
  final String status;
  final String createdBy;
  final String? updatedBy;
  final String createdAt;
  final String updatedAt;
  final PatientInfo patient;

  CaregiverPatient({
    required this.id,
    required this.userId,
    required this.caregiverId,
    required this.relationship,
    required this.canView,
    required this.canAddNotes,
    required this.status,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.patient,
  });

  factory CaregiverPatient.fromJson(Map<String, dynamic> json) {
    return CaregiverPatient(
      id: json['id'] ?? 0,
      userId: json['user_id']?.toString() ?? '',
      caregiverId: json['caregiver_id']?.toString() ?? '',
      relationship: json['relationship'] ?? '',
      canView: json['can_view']?.toString() ?? '0',
      canAddNotes: json['can_add_notes']?.toString() ?? '0',
      status: json['status'] ?? '',
      createdBy: json['created_by']?.toString() ?? '',
      updatedBy: json['updated_by']?.toString(),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      patient: PatientInfo.fromJson(json['patient'] ?? {}),
    );
  }
}

class PatientInfo {
  final int id;
  final String name;
  final String email;
  final String role;
  final String status;

  PatientInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
  });

  factory PatientInfo.fromJson(Map<String, dynamic> json) {
    return PatientInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
