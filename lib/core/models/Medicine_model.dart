import 'dart:io';

class MedicineFrequency {
  final String frequency;
  final String time; // HH:mm format

  MedicineFrequency({
    required this.frequency,
    required this.time,
  });

  factory MedicineFrequency.fromJson(Map<String, dynamic> json) {
    return MedicineFrequency(
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
      '_method': 'PUT', // For Laravel to treat POST as PUT
      'medicine_name': medicineName,
      'dosage': dosage,
      'status': status,
      if (attachment != null) 'attachment': attachment,
      'frequencies': frequencies.map((freq) => freq.toJson()).toList(),
    };
  }
}
