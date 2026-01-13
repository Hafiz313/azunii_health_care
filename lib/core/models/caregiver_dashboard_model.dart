class CaregiverDashboardResponse {
  final bool status;
  final String message;
  final List<UpcomingVisit> upcomingVisits;
  final List<MedicineQuery> medicineQueries;

  CaregiverDashboardResponse({
    required this.status,
    required this.message,
    required this.upcomingVisits,
    required this.medicineQueries,
  });

  factory CaregiverDashboardResponse.fromJson(Map<String, dynamic> json) {
    return CaregiverDashboardResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      upcomingVisits: (json['upcoming_visits'] as List?)
              ?.map((v) => UpcomingVisit.fromJson(v))
              .toList() ??
          [],
      medicineQueries: (json['medicine_query'] as List?)
              ?.map((m) => MedicineQuery.fromJson(m))
              .toList() ??
          [],
    );
  }
}

class UpcomingVisit {
  final int id;
  final String userId;
  final String providerName;
  final String specialty;
  final String visitDate;
  final String notes;
  final String? attachment;
  final Creator createdBy;
  final Creator? updatedBy;
  final String createdAt;
  final String updatedAt;

  UpcomingVisit({
    required this.id,
    required this.userId,
    required this.providerName,
    required this.specialty,
    required this.visitDate,
    required this.notes,
    this.attachment,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UpcomingVisit.fromJson(Map<String, dynamic> json) {
    return UpcomingVisit(
      id: json['id'] ?? 0,
      userId: json['user_id']?.toString() ?? '',
      providerName: json['provider_name'] ?? '',
      specialty: json['specialty'] ?? '',
      visitDate: json['visit_date'] ?? '',
      notes: json['notes'] ?? '',
      attachment: json['attachment'],
      createdBy: Creator.fromJson(json['created_by'] ?? {}),
      updatedBy: json['updated_by'] != null ? Creator.fromJson(json['updated_by']) : null,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class MedicineQuery {
  final int id;
  final String userId;
  final String medicineName;
  final String dosage;
  final String status;
  final String interactionFlag;
  final String? interactionMessage;
  final String? interactionDetails;
  final String? attachment;
  final Creator createdBy;
  final Creator? updatedBy;
  final String createdAt;
  final String updatedAt;
  final List<Frequency> frequencies;

  MedicineQuery({
    required this.id,
    required this.userId,
    required this.medicineName,
    required this.dosage,
    required this.status,
    required this.interactionFlag,
    this.interactionMessage,
    this.interactionDetails,
    this.attachment,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.frequencies,
  });

  factory MedicineQuery.fromJson(Map<String, dynamic> json) {
    return MedicineQuery(
      id: json['id'] ?? 0,
      userId: json['user_id']?.toString() ?? '',
      medicineName: json['medicine_name'] ?? '',
      dosage: json['dosage'] ?? '',
      status: json['status'] ?? '',
      interactionFlag: json['interaction_flag']?.toString() ?? '0',
      interactionMessage: json['interaction_message'],
      interactionDetails: json['interaction_details'],
      attachment: json['attachment'],
      createdBy: Creator.fromJson(json['created_by'] ?? {}),
      updatedBy: json['updated_by'] != null ? Creator.fromJson(json['updated_by']) : null,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      frequencies: (json['frequencies'] as List?)
              ?.map((f) => Frequency.fromJson(f))
              .toList() ??
          [],
    );
  }
}

class Frequency {
  final int id;
  final String patientMedicineId;
  final String frequency;
  final String time;
  final String createdAt;
  final String updatedAt;

  Frequency({
    required this.id,
    required this.patientMedicineId,
    required this.frequency,
    required this.time,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Frequency.fromJson(Map<String, dynamic> json) {
    return Frequency(
      id: json['id'] ?? 0,
      patientMedicineId: json['patient_medicine_id']?.toString() ?? '',
      frequency: json['frequency'] ?? '',
      time: json['time'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class Creator {
  final int id;
  final String name;
  final String email;

  Creator({
    required this.id,
    required this.name,
    required this.email,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
