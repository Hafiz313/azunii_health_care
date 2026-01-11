import 'dart:io';

class CaregiverMedicine {
  final int id;
  final String userId;
  final String medicineName;
  final String dosage;
  final String status;
  final String? attachment;
  final List<CaregiverMedicineFrequency> frequencies;
  final String createdAt;
  final String updatedAt;

  CaregiverMedicine({
    required this.id,
    required this.userId,
    required this.medicineName,
    required this.dosage,
    required this.status,
    this.attachment,
    required this.frequencies,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CaregiverMedicine.fromJson(Map<String, dynamic> json) {
    return CaregiverMedicine(
      id: json['id'] ?? 0,
      userId: json['user_id']?.toString() ?? '',
      medicineName: json['medicine_name'] ?? '',
      dosage: json['dosage'] ?? '',
      status: json['status'] ?? '',
      attachment: json['attachment'],
      frequencies: (json['frequencies'] as List<dynamic>? ?? [])
          .map((freq) => CaregiverMedicineFrequency.fromJson(freq))
          .toList(),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class CaregiverMedicineListResponse {
  final bool status;
  final String message;
  final List<CaregiverMedicine> medicines;

  CaregiverMedicineListResponse({
    required this.status,
    required this.message,
    required this.medicines,
  });

  factory CaregiverMedicineListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    List<CaregiverMedicine> medicinesList = [];
    
    if (data != null && data['data'] != null) {
      medicinesList = (data['data'] as List<dynamic>)
          .map((medicine) => CaregiverMedicine.fromJson(medicine))
          .toList();
    }
    
    return CaregiverMedicineListResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      medicines: medicinesList,
    );
  }
}

class CaregiverMedicineFrequency {
  final int? id;
  final String frequency;
  final String time;

  CaregiverMedicineFrequency({
    this.id,
    required this.frequency,
    required this.time,
  });

  factory CaregiverMedicineFrequency.fromJson(Map<String, dynamic> json) {
    return CaregiverMedicineFrequency(
      id: json['id'],
      frequency: json['frequency'] ?? '',
      time: json['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'frequency': frequency,
      'time': time,
    };
  }
}

class StoreCaregiverMedicineRequest {
  final String medicineName;
  final String dosage;
  final String status;
  final File? attachment;
  final List<CaregiverMedicineFrequency> frequencies;

  StoreCaregiverMedicineRequest({
    required this.medicineName,
    required this.dosage,
    required this.status,
    this.attachment,
    required this.frequencies,
  });
}
