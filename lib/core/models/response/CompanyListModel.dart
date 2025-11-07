class CompanyListModel {
  List<CompanyResult>? result;
  dynamic targetUrl;
  bool? success;
  dynamic error;
  bool? unAuthorizedRequest;
  bool? bAbp;

  CompanyListModel({
    this.result,
    this.targetUrl,
    this.success,
    this.error,
    this.unAuthorizedRequest,
    this.bAbp,
  });

  CompanyListModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <CompanyResult>[];
      json['result'].forEach((v) {
        result!.add(CompanyResult.fromJson(v));
      });
    }
    targetUrl = json['targetUrl'];
    success = json['success'];
    error = json['error'];
    unAuthorizedRequest = json['unAuthorizedRequest'];
    bAbp = json['__abp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    data['targetUrl'] = targetUrl;
    data['success'] = success;
    data['error'] = error;
    data['unAuthorizedRequest'] = unAuthorizedRequest;
    data['__abp'] = bAbp;
    return data;
  }
}

class CompanyResult {
  int? userId;
  String? companyName;

  CompanyResult({
    this.userId,
    this.companyName,
  });

  CompanyResult.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    companyName = json['companyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['companyName'] = companyName;
    return data;
  }
}

