class GetPayperiodsModels {
  List<GetPayperiodsResult>? result;
  dynamic targetUrl;
  bool? success;
  dynamic error;
  bool? unAuthorizedRequest;
  bool? bAbp;

  GetPayperiodsModels(
      {this.result,
      this.targetUrl,
      this.success,
      this.error,
      this.unAuthorizedRequest,
      this.bAbp});

  GetPayperiodsModels.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <GetPayperiodsResult>[];
      json['result'].forEach((v) {
        result!.add(new GetPayperiodsResult.fromJson(v));
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

class GetPayperiodsResult {
  String? name;
  int? periodNumber;
  String? periodType;
  bool? payrollRunStatus;
  String? status;
  dynamic elementSetID;
  dynamic year;
  bool? publishPayStub;
  int? payrollCalendarId;
  dynamic companyId;
  dynamic tenantId;
  String? startDate;
  String? endDate;
  dynamic paymentDate;
  dynamic fiscalYearStartDate;
  bool? active;
  dynamic quarter;
  int? paymentStatus;
  bool? isPaid;
  int? payDayGap;
  int? id;

  GetPayperiodsResult(
      {this.name,
      this.periodNumber,
      this.periodType,
      this.payrollRunStatus,
      this.status,
      this.elementSetID,
      this.year,
      this.publishPayStub,
      this.payrollCalendarId,
      this.companyId,
      this.tenantId,
      this.startDate,
      this.endDate,
      this.paymentDate,
      this.fiscalYearStartDate,
      this.active,
      this.quarter,
      this.paymentStatus,
      this.isPaid,
      this.payDayGap,
      this.id});

  GetPayperiodsResult.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    periodNumber = json['periodNumber'];
    periodType = json['periodType'];
    payrollRunStatus = json['payrollRunStatus'];
    status = json['status'];
    elementSetID = json['elementSetID'];
    year = json['year'];
    publishPayStub = json['publishPayStub'];
    payrollCalendarId = json['payrollCalendarId'];
    companyId = json['companyId'];
    tenantId = json['tenantId'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    paymentDate = json['paymentDate'];
    fiscalYearStartDate = json['fiscalYearStartDate'];
    active = json['active'];
    quarter = json['quarter'];
    paymentStatus = json['paymentStatus'];
    isPaid = json['isPaid'];
    payDayGap = json['payDayGap'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['periodNumber'] = this.periodNumber;
    data['periodType'] = this.periodType;
    data['payrollRunStatus'] = this.payrollRunStatus;
    data['status'] = this.status;
    data['elementSetID'] = this.elementSetID;
    data['year'] = this.year;
    data['publishPayStub'] = this.publishPayStub;
    data['payrollCalendarId'] = this.payrollCalendarId;
    data['companyId'] = this.companyId;
    data['tenantId'] = this.tenantId;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['paymentDate'] = this.paymentDate;
    data['fiscalYearStartDate'] = this.fiscalYearStartDate;
    data['active'] = this.active;
    data['quarter'] = this.quarter;
    data['paymentStatus'] = this.paymentStatus;
    data['isPaid'] = this.isPaid;
    data['payDayGap'] = this.payDayGap;
    data['id'] = this.id;
    return data;
  }
}
