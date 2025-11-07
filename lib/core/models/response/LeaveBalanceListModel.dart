class LeaveBalanceListModel {
  List<LeaveBalanceResult>? result;
  dynamic targetUrl;
  bool? success;
  dynamic error;
  bool? unAuthorizedRequest;
  bool? bAbp;

  LeaveBalanceListModel(
      {this.result,
      this.targetUrl,
      this.success,
      this.error,
      this.unAuthorizedRequest,
      this.bAbp});

  LeaveBalanceListModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <LeaveBalanceResult>[];
      json['result'].forEach((v) {
        result!.add(new LeaveBalanceResult.fromJson(v));
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

class LeaveBalanceResult {
  dynamic tenantId;
  dynamic employeeId;
  dynamic companyId;
  dynamic companyFk;
  String? fromDate;
  String? toDate;
  dynamic reason;
  dynamic countForLeaves;
  String? attendenceLeaveType;
  String? status;
  dynamic jobHours;
  dynamic leaveHours;
  String? dayType;
  dynamic approverUserId;
  String? approvedBy;
  dynamic id;

  LeaveBalanceResult(
      {this.tenantId,
      this.employeeId,
      this.companyId,
      this.companyFk,
      this.fromDate,
      this.toDate,
      this.reason,
      this.countForLeaves,
      this.attendenceLeaveType,
      this.status,
      this.jobHours,
      this.leaveHours,
      this.dayType,
      this.approverUserId,
      this.approvedBy,
      this.id});

  LeaveBalanceResult.fromJson(Map<String, dynamic> json) {
    tenantId = json['tenantId'];
    employeeId = json['employeeId'];
    companyId = json['companyId'];
    companyFk = json['companyFk'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    reason = json['reason'];
    countForLeaves = json['countForLeaves'];
    attendenceLeaveType = json['attendenceLeaveType'];
    status = json['status'];
    jobHours = json['jobHours'];
    leaveHours = json['leaveHours'];
    dayType = json['dayType'];
    approverUserId = json['approverUserId'];
    approvedBy = json['approvedBy'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tenantId'] = this.tenantId;
    data['employeeId'] = this.employeeId;
    data['companyId'] = this.companyId;
    data['companyFk'] = this.companyFk;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['reason'] = this.reason;
    data['countForLeaves'] = this.countForLeaves;
    data['attendenceLeaveType'] = this.attendenceLeaveType;
    data['status'] = this.status;
    data['jobHours'] = this.jobHours;
    data['leaveHours'] = this.leaveHours;
    data['dayType'] = this.dayType;
    data['approverUserId'] = this.approverUserId;
    data['approvedBy'] = this.approvedBy;
    data['id'] = this.id;
    return data;
  }
}
