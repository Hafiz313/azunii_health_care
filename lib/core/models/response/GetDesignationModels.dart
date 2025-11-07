class GetDesignationModels {
  List<ResultDesignation>? result;
  dynamic targetUrl;
  bool? success;
  dynamic error;
  bool? unAuthorizedRequest;
  bool? bAbp;

  GetDesignationModels(
      {this.result,
      this.targetUrl,
      this.success,
      this.error,
      this.unAuthorizedRequest,
      this.bAbp});

  GetDesignationModels.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <ResultDesignation>[];
      json['result'].forEach((v) {
        result!.add(new ResultDesignation.fromJson(v));
      });
    }
    targetUrl = json['targetUrl'];
    success = json['success'];
    error = json['error'];
    unAuthorizedRequest = json['unAuthorizedRequest'];
    bAbp = json['__abp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    data['targetUrl'] = this.targetUrl;
    data['success'] = this.success;
    data['error'] = this.error;
    data['unAuthorizedRequest'] = this.unAuthorizedRequest;
    data['__abp'] = this.bAbp;
    return data;
  }
}

class ResultDesignation {
  String? displayName;
  String? jobTitle;
  dynamic description;
  bool? isActive;
  dynamic companyId;
  dynamic employeeCount;
  dynamic id;

  ResultDesignation(
      {this.displayName,
      this.jobTitle,
      this.description,
      this.isActive,
      this.companyId,
      this.employeeCount,
      this.id});

  ResultDesignation.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];
    jobTitle = json['jobTitle'];
    description = json['description'];
    isActive = json['isActive'];
    companyId = json['companyId'];
    employeeCount = json['employeeCount'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayName'] = this.displayName;
    data['jobTitle'] = this.jobTitle;
    data['description'] = this.description;
    data['isActive'] = this.isActive;
    data['companyId'] = this.companyId;
    data['employeeCount'] = this.employeeCount;
    data['id'] = this.id;
    return data;
  }
}
