import 'dart:io';

class CaregiverMedicineItem {
  final int id;
  final String userId;
  final String medicineName;
  final String dosage;
  final String? startDate;
  final String? endDate;
  final String status;
  final String interactionFlag;
  final String? interactionMessage;
  final String? interactionDetails;
  final String? attachment;
  final String createdBy;
  final String? updatedBy;
  final String createdAt;
  final String updatedAt;
  final List<MedicineFrequency> frequencies;

  CaregiverMedicineItem({
    required this.id,
    required this.userId,
    required this.medicineName,
    required this.dosage,
    this.startDate,
    this.endDate,
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

  factory CaregiverMedicineItem.fromJson(Map<String, dynamic> json) {
    return CaregiverMedicineItem(
      id: json['id'] ?? 0,
      userId: json['user_id']?.toString() ?? '',
      medicineName: json['medicine_name'] ?? '',
      dosage: json['dosage'] ?? '',
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: json['status'] ?? '',
      interactionFlag: json['interaction_flag']?.toString() ?? '0',
      interactionMessage: json['interaction_message'],
      interactionDetails: json['interaction_details'],
      attachment: json['attachment'],
      createdBy: json['created_by']?.toString() ?? '',
      updatedBy: json['updated_by']?.toString(),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      frequencies: (json['frequencies'] as List<dynamic>? ?? [])
          .map((freq) => MedicineFrequency.fromJson(freq))
          .toList(),
    );
  }
}

class MedicineFrequency {
  final int id;
  final String patientMedicineId;
  final String frequency;
  final String time;
  final String createdAt;
  final String updatedAt;

  MedicineFrequency({
    required this.id,
    required this.patientMedicineId,
    required this.frequency,
    required this.time,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MedicineFrequency.fromJson(Map<String, dynamic> json) {
    return MedicineFrequency(
      id: json['id'] ?? 0,
      patientMedicineId: json['patient_medicine_id']?.toString() ?? '',
      frequency: json['frequency'] ?? '',
      time: json['time'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class CaregiverMedicineListApiResponse {
  final bool status;
  final String message;
  final MedicineData data;

  CaregiverMedicineListApiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CaregiverMedicineListApiResponse.fromJson(Map<String, dynamic> json) {
    return CaregiverMedicineListApiResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: MedicineData.fromJson(json['data'] ?? {}),
    );
  }
}

class MedicineData {
  final int currentPage;
  final List<CaregiverMedicineItem> medicines;
  final String? firstPageUrl;
  final int from;
  final int lastPage;
  final String? lastPageUrl;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  MedicineData({
    required this.currentPage,
    required this.medicines,
    this.firstPageUrl,
    required this.from,
    required this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory MedicineData.fromJson(Map<String, dynamic> json) {
    return MedicineData(
      currentPage: json['current_page'] ?? 1,
      medicines: (json['data'] as List<dynamic>? ?? [])
          .map((medicine) => CaregiverMedicineItem.fromJson(medicine))
          .toList(),
      firstPageUrl: json['first_page_url'],
      from: json['from'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      lastPageUrl: json['last_page_url'],
      nextPageUrl: json['next_page_url'],
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 10,
      prevPageUrl: json['prev_page_url'],
      to: json['to'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}