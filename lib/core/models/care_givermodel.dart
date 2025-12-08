class CaregiverUser {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final String? phone;

  CaregiverUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.phone,
  });

  factory CaregiverUser.fromJson(Map<String, dynamic> json) {
    return CaregiverUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      phone: json['phone'],
    );
  }
}

class Caregiver {
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
  final CaregiverUser caregiver;

  Caregiver({
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
    required this.caregiver,
  });

  factory Caregiver.fromJson(Map<String, dynamic> json) {
    return Caregiver(
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
      caregiver: CaregiverUser.fromJson(json['caregiver'] ?? {}),
    );
  }
}

class CaregiverDetail {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final String? phone;
  final String? dob;
  final String? gender;
  final String relationship;
  final String canView;
  final String canAddNotes;
  final String status;
  final String createdAt;

  CaregiverDetail({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.phone,
    this.dob,
    this.gender,
    required this.relationship,
    required this.canView,
    required this.canAddNotes,
    required this.status,
    required this.createdAt,
  });

  factory CaregiverDetail.fromJson(Map<String, dynamic> json) {
    return CaregiverDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      phone: json['phone'],
      dob: json['dob'],
      gender: json['gender'],
      relationship: json['relationship'] ?? '',
      canView: json['can_view']?.toString() ?? '0',
      canAddNotes: json['can_add_notes']?.toString() ?? '0',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class CaregiverDetailResponse {
  final bool status;
  final String message;
  final CaregiverDetail caregiver;

  CaregiverDetailResponse({
    required this.status,
    required this.message,
    required this.caregiver,
  });

  factory CaregiverDetailResponse.fromJson(Map<String, dynamic> json) {
    return CaregiverDetailResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      caregiver: CaregiverDetail.fromJson(json['caregiver'] ?? {}),
    );
  }
}

class CaregiverListResponse {
  final bool status;
  final String message;
  final List<Caregiver> caregivers;

  CaregiverListResponse({
    required this.status,
    required this.message,
    required this.caregivers,
  });

  factory CaregiverListResponse.fromJson(Map<String, dynamic> json) {
    return CaregiverListResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      caregivers: (json['caregivers'] as List<dynamic>?)
              ?.map((item) => Caregiver.fromJson(item))
              .toList() ??
          [],
    );
  }
}
