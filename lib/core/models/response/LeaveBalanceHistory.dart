class LeaveBalanceHistory {
  List<Result>? result;
  dynamic targetUrl;
  bool? success;
  dynamic error;
  bool? unAuthorizedRequest;
  bool? bAbp;

  LeaveBalanceHistory(
      {this.result,
      this.targetUrl,
      this.success,
      this.error,
      this.unAuthorizedRequest,
      this.bAbp});

  LeaveBalanceHistory.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
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

class Result {
  dynamic employeeId;
  dynamic companyId;
  dynamic tenantId;
  dynamic totalLeaves;
  dynamic usedLeaves;
  dynamic remainingLeaves;
  dynamic leaveRequest;
  String? employeeLeaveType;
  String? employeeAttendenceType;
  bool? isRemoteAttendance;
  dynamic id;

  Result(
      {this.employeeId,
      this.companyId,
      this.tenantId,
      this.totalLeaves,
      this.usedLeaves,
      this.remainingLeaves,
      this.leaveRequest,
      this.employeeLeaveType,
      this.employeeAttendenceType,
      this.isRemoteAttendance,
      this.id});

  Result.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    companyId = json['companyId'];
    tenantId = json['tenantId'];
    totalLeaves = json['totalLeaves'];
    usedLeaves = json['usedLeaves'];
    remainingLeaves = json['remainingLeaves'];
    leaveRequest = json['leaveRequest'];
    employeeLeaveType = json['employeeLeaveType'];
    employeeAttendenceType = json['employeeAttendenceType'];
    isRemoteAttendance = json['isRemoteAttendance'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['companyId'] = this.companyId;
    data['tenantId'] = this.tenantId;
    data['totalLeaves'] = this.totalLeaves;
    data['usedLeaves'] = this.usedLeaves;
    data['remainingLeaves'] = this.remainingLeaves;
    data['leaveRequest'] = this.leaveRequest;
    data['employeeLeaveType'] = this.employeeLeaveType;
    data['employeeAttendenceType'] = this.employeeAttendenceType;
    data['isRemoteAttendance'] = this.isRemoteAttendance;
    data['id'] = this.id;
    return data;
  }
}
