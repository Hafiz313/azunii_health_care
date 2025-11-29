import 'Auth_model.dart';
import 'visit_model.dart';

class VisitDetailResponse {
  final bool status;
  final String message;
  final VisitModel data;

  VisitDetailResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory VisitDetailResponse.fromJson(Map<String, dynamic> json) {
    return VisitDetailResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: VisitModel.fromJson(json['data']),
    );
  }
}

class VisitResponse {
  final bool status;
  final String message;
  final VisitPaginationData data;

  VisitResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory VisitResponse.fromJson(Map<String, dynamic> json) {
    return VisitResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: VisitPaginationData.fromJson(json['data']),
    );
  }
}

class VisitPaginationData {
  final int currentPage;
  final List<VisitModel> visits;
  final String? firstPageUrl;
  final int? from;
  final int lastPage;
  final String? lastPageUrl;
  final List<VisitLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;
  final int total;

  VisitPaginationData({
    required this.currentPage,
    required this.visits,
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

  factory VisitPaginationData.fromJson(Map<String, dynamic> json) {
    return VisitPaginationData(
      currentPage: json['current_page'] ?? 1,
      visits: (json['data'] as List<dynamic>?)
              ?.map((visit) => VisitModel.fromJson(visit))
              .toList() ??
          [],
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'] ?? 1,
      lastPageUrl: json['last_page_url'],
      links: (json['links'] as List<dynamic>?)
              ?.map((link) => VisitLink.fromJson(link))
              .toList() ??
          [],
      nextPageUrl: json['next_page_url'],
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 10,
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'] ?? 0,
    );
  }
}

class VisitLink {
  final String? url;
  final String label;
  final int? page;
  final bool active;

  VisitLink({
    this.url,
    required this.label,
    this.page,
    required this.active,
  });

  factory VisitLink.fromJson(Map<String, dynamic> json) {
    return VisitLink(
      url: json['url'],
      label: json['label'] ?? '',
      page: json['page'],
      active: json['active'] ?? false,
    );
  }
}
