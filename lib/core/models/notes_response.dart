import 'notes_model.dart';

class NoteDetailResponse {
  final bool status;
  final String message;
  final NotesModel data;

  NoteDetailResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory NoteDetailResponse.fromJson(Map<String, dynamic> json) {
    return NoteDetailResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: NotesModel.fromJson(json['data']),
    );
  }
}

class NotesResponse {
  final bool status;
  final String message;
  final NotesPaginationData data;

  NotesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory NotesResponse.fromJson(Map<String, dynamic> json) {
    return NotesResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: NotesPaginationData.fromJson(json),
    );
  }
}

class NotesPaginationData {
  final int currentPage;
  final List<NotesModel> notes;
  final int lastPage;
  final int total;
  final int perPage;

  NotesPaginationData({
    required this.currentPage,
    required this.notes,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  factory NotesPaginationData.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      // Laravel standard pagination wrapper: { data: { current_page: ..., data: [...] } }
      final list = (data['data'] as List<dynamic>?)
              ?.map((n) => NotesModel.fromJson(n))
              .toList() ??
          [];
      return NotesPaginationData(
        currentPage: data['current_page'] ?? 1,
        notes: list,
        lastPage: data['last_page'] ?? 1,
        total: data['total'] ?? 0,
        perPage: data['per_page'] ?? 15,
      );
    } else if (data is List<dynamic>) {
      // Direct array mapping wrapper: { data: [...] }
      final list = data.map((n) => NotesModel.fromJson(n)).toList();
      return NotesPaginationData(
        currentPage: 1,
        notes: list,
        lastPage: 1,
        total: list.length,
        perPage: 15,
      );
    } else {
      // Fallback
      return NotesPaginationData(
        currentPage: 1,
        notes: [],
        lastPage: 1,
        total: 0,
        perPage: 15,
      );
    }
  }
}
