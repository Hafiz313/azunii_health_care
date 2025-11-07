class GetJobEmpModels {
  List<GetJobResult>? result;
  dynamic targetUrl;
  bool? success;
  dynamic error;
  bool? unAuthorizedRequest;
  bool? bAbp;

  GetJobEmpModels(
      {this.result,
      this.targetUrl,
      this.success,
      this.error,
      this.unAuthorizedRequest,
      this.bAbp});

  GetJobEmpModels.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <GetJobResult>[];
      json['result'].forEach((v) {
        result!.add(new GetJobResult.fromJson(v));
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

class GetJobResult {
  int? employeeId;
  int? tenantId;
  dynamic jobTitle;
  String? jobDescription;
  dynamic hours;
  dynamic hourlyRate;
  dynamic overTimeHourlyRate;
  bool? isDefaultJob;
  String? positionTitle;
  dynamic id;

  // UI selection state (not serialized)
  bool selected = false;

  GetJobResult({
    this.employeeId,
    this.tenantId,
    this.jobTitle,
    this.jobDescription,
    this.hours,
    this.hourlyRate,
    this.overTimeHourlyRate,
    this.isDefaultJob,
    this.positionTitle,
    this.id,
    this.selected = false,
  });

  GetJobResult.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    tenantId = json['tenantId'];
    jobTitle = json['jobTitle'];
    jobDescription = json['jobDescription'];
    hours = json['hours'];
    hourlyRate = json['hourlyRate'];
    overTimeHourlyRate = json['overTimeHourlyRate'];
    isDefaultJob = json['isDefaultJob'];
    positionTitle = json['positionTitle'];
    id = json['id'];
    // selected is not set from JSON
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['tenantId'] = this.tenantId;
    data['jobTitle'] = this.jobTitle;
    data['jobDescription'] = this.jobDescription;
    data['hours'] = this.hours;
    data['hourlyRate'] = this.hourlyRate;
    data['overTimeHourlyRate'] = this.overTimeHourlyRate;
    data['isDefaultJob'] = this.isDefaultJob;
    data['positionTitle'] = this.positionTitle;
    data['id'] = this.id;
    // selected is not included in JSON
    return data;
  }
}
