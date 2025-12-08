class TimelineResponse {
  final bool status;
  final String message;
  final TimelineData data;

  TimelineResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TimelineResponse.fromJson(Map<String, dynamic> json) {
    return TimelineResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: TimelineData.fromJson(json['data']),
    );
  }
}

class TimelineData {
  final String date;
  final List<MedicineSchedule> schedule;
  final List<TimelineEvent> events;
  final TimelineMeta meta;

  TimelineData({
    required this.date,
    required this.schedule,
    required this.events,
    required this.meta,
  });

  factory TimelineData.fromJson(Map<String, dynamic> json) {
    return TimelineData(
      date: json['date'] ?? '',
      schedule: (json['schedule'] as List<dynamic>?)
              ?.map((item) => MedicineSchedule.fromJson(item))
              .toList() ??
          [],
      events: (json['events'] as List<dynamic>?)
              ?.map((item) => TimelineEvent.fromJson(item))
              .toList() ??
          [],
      meta: TimelineMeta.fromJson(json['meta'] ?? {}),
    );
  }
}

class MedicineSchedule {
  final String type;
  final int medicineId;
  final int frequencyId;
  final String medicineName;
  final String dosage;
  final String frequency;
  final String time;
  final String status;

  MedicineSchedule({
    required this.type,
    required this.medicineId,
    required this.frequencyId,
    required this.medicineName,
    required this.dosage,
    required this.frequency,
    required this.time,
    required this.status,
  });

  factory MedicineSchedule.fromJson(Map<String, dynamic> json) {
    return MedicineSchedule(
      type: json['type'] ?? '',
      medicineId: json['medicine_id'] ?? 0,
      frequencyId: json['frequency_id'] ?? 0,
      medicineName: json['medicine_name'] ?? '',
      dosage: json['dosage'] ?? '',
      frequency: json['frequency'] ?? '',
      time: json['time'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class TimelineEvent {
  final String type;
  final int id;
  final String title;
  final String? subtitle;
  final String timestamp;
  final String? notes;
  final String status;

  TimelineEvent({
    required this.type,
    required this.id,
    required this.title,
    this.subtitle,
    required this.timestamp,
    this.notes,
    required this.status,
  });

  factory TimelineEvent.fromJson(Map<String, dynamic> json) {
    return TimelineEvent(
      type: json['type'] ?? '',
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      timestamp: json['timestamp'] ?? '',
      notes: json['notes'],
      status: json['status'] ?? '',
    );
  }
}

class TimelineMeta {
  final int page;
  final int perPage;
  final int total;

  TimelineMeta({
    required this.page,
    required this.perPage,
    required this.total,
  });

  factory TimelineMeta.fromJson(Map<String, dynamic> json) {
    return TimelineMeta(
      page: json['page'] ?? 1,
      perPage: json['per_page'] ?? 20,
      total: json['total'] ?? 0,
    );
  }
}
