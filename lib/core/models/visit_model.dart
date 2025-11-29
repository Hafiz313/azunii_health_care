import 'dart:io';
import 'Auth_model.dart';

class StoreVisitRequest {
  final String providerName;
  final String specialty;
  final String visitDate;
  final String notes;
  final File? attachment;

  StoreVisitRequest({
    required this.providerName,
    required this.specialty,
    required this.visitDate,
    required this.notes,
    this.attachment,
  });

  Map<String, dynamic> toJson() {
    return {
      'provider_name': providerName,
      'specialty': specialty,
      'visit_date': visitDate,
      'notes': notes,
      if (attachment != null) 'attachment': attachment,
    };
  }
}

class UpdateVisitRequest {
  final int id;
  final String providerName;
  final String specialty;
  final String visitDate;
  final String notes;
  final File? attachment;

  UpdateVisitRequest({
    required this.id,
    required this.providerName,
    required this.specialty,
    required this.visitDate,
    required this.notes,
    this.attachment,
  });

  Map<String, dynamic> toJson() {
    return {
      '_method': 'PUT', // For Laravel to treat POST as PUT
      'provider_name': providerName,
      'specialty': specialty,
      'visit_date': visitDate,
      'notes': notes,
      if (attachment != null) 'attachment': attachment,
    };
  }
}

class VisitModel {
  final int id;
  final String userId;
  final String providerName;
  final String specialty;
  final String visitDate;
  final String notes;
  final String? attachment;
  final UserModel? createdBy;
  final UserModel? updatedBy;
  final String createdAt;
  final String updatedAt;
  final UserModel? user;

  VisitModel({
    required this.id,
    required this.userId,
    required this.providerName,
    required this.specialty,
    required this.visitDate,
    required this.notes,
    this.attachment,
    this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    return VisitModel(
      id: json['id'] ?? 0,
      userId: json['user_id']?.toString() ?? '',
      providerName: json['provider_name'] ?? '',
      specialty: json['specialty'] ?? '',
      visitDate: json['visit_date'] ?? '',
      notes: json['notes'] ?? '',
      attachment: json['attachment'],
      createdBy: json['created_by'] != null
          ? UserModel.fromJson(json['created_by'])
          : null,
      updatedBy: json['updated_by'] != null
          ? UserModel.fromJson(json['updated_by'])
          : null,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}
