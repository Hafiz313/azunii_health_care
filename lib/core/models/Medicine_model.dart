import 'dart:io';

class Medicine {
  final int id;
  final String userId;
  final String medicineName;
  final String dosage;
  final String status;
  final String interactionFlag;
  final String? interactionMessage;
  final String? interactionDetails;
  final String? attachment;
  final String createdBy;
  final String? updatedBy;
  final List<MedicineFrequency> frequencies;
  final String createdAt;
  final String updatedAt;

  Medicine({
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
    required this.frequencies,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'] ?? 0,
      userId: json['user_id']?.toString() ?? '',
      medicineName: json['medicine_name'] ?? '',
      dosage: json['dosage'] ?? '',
      status: json['status'] ?? '',
      interactionFlag: json['interaction_flag']?.toString() ?? '0',
      interactionMessage: json['interaction_message'],
      interactionDetails: json['interaction_details'],
      attachment: json['attachment'],
      createdBy: json['created_by']?.toString() ?? '',
      updatedBy: json['updated_by']?.toString(),
      frequencies: (json['frequencies'] as List<dynamic>? ?? [])
          .map((freq) => MedicineFrequency.fromJson(freq))
          .toList(),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class PaginationLink {
  final String? url;
  final String label;
  final int? page;
  final bool active;

  PaginationLink({
    this.url,
    required this.label,
    this.page,
    required this.active,
  });

  factory PaginationLink.fromJson(Map<String, dynamic> json) {
    return PaginationLink(
      url: json['url'],
      label: json['label'] ?? '',
      page: json['page'],
      active: json['active'] ?? false,
    );
  }
}

class MedicineListResponse {
  final bool status;
  final String message;
  final int currentPage;
  final List<Medicine> medicines;
  final String? firstPageUrl;
  final int? from;
  final int lastPage;
  final String? lastPageUrl;
  final List<PaginationLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;
  final int total;

  MedicineListResponse({
    required this.status,
    required this.message,
    required this.currentPage,
    required this.medicines,
    this.firstPageUrl,
    this.from,
    required this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  factory MedicineListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return MedicineListResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      currentPage: data['current_page'] ?? 1,
      medicines: (data['data'] as List<dynamic>? ?? [])
          .map((medicine) => Medicine.fromJson(medicine))
          .toList(),
      firstPageUrl: data['first_page_url'],
      from: data['from'],
      lastPage: data['last_page'] ?? 1,
      lastPageUrl: data['last_page_url'],
      links: (data['links'] as List<dynamic>? ?? [])
          .map((link) => PaginationLink.fromJson(link))
          .toList(),
      nextPageUrl: data['next_page_url'],
      path: data['path'] ?? '',
      perPage: data['per_page'] ?? 10,
      prevPageUrl: data['prev_page_url'],
      to: data['to'],
      total: data['total'] ?? 0,
    );
  }
}

class MedicineFrequency {
  final int? id;
  final String? patientMedicineId;
  final String frequency;
  final String time; // HH:mm:ss format from API
  final String? createdAt;
  final String? updatedAt;

  MedicineFrequency({
    this.id,
    this.patientMedicineId,
    required this.frequency,
    required this.time,
    this.createdAt,
    this.updatedAt,
  });

  factory MedicineFrequency.fromJson(Map<String, dynamic> json) {
    return MedicineFrequency(
      id: json['id'],
      patientMedicineId: json['patient_medicine_id']?.toString(),
      frequency: json['frequency'] ?? '',
      time: json['time'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'frequency': frequency,
      'time': time,
    };
  }
}

class StoreMedicineRequest {
  final String medicineName;
  final String dosage;
  final String status;
  final File? attachment;
  final List<MedicineFrequency> frequencies;

  StoreMedicineRequest({
    required this.medicineName,
    required this.dosage,
    required this.status,
    this.attachment,
    required this.frequencies,
  });

  Map<String, dynamic> toJson() {
    return {
      'medicine_name': medicineName,
      'dosage': dosage,
      'status': status,
      if (attachment != null) 'attachment': attachment,
      'frequencies': frequencies.map((freq) => freq.toJson()).toList(),
    };
  }
}

class UpdateMedicineRequest {
  final int id;
  final String medicineName;
  final String dosage;
  final String status;
  final File? attachment;
  final List<MedicineFrequency> frequencies;

  UpdateMedicineRequest({
    required this.id,
    required this.medicineName,
    required this.dosage,
    required this.status,
    this.attachment,
    required this.frequencies,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicine_name': medicineName,
      'dosage': dosage,
      'status': status,
      if (attachment != null) 'attachment': attachment,
      'frequencies': frequencies.map((freq) => freq.toJson()).toList(),
    };
  }
}
