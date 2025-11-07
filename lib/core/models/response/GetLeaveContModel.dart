import 'dart:convert';

GetLeaveContModel getLeaveContModelFromJson(String str) =>
    GetLeaveContModel.fromJson(json.decode(str));
String getLeaveContModelToJson(GetLeaveContModel data) =>
    json.encode(data.toJson());

class GetLeaveContModel {
  LeaveContResult? result;

  GetLeaveContModel({this.result});

  GetLeaveContModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null
        ? new LeaveContResult.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class LeaveContResult {
  dynamic employeeId;
  dynamic companyId;
  dynamic tenantId;
  dynamic totalLeaves;
  dynamic usedLeaves;
  dynamic remainingLeaves;
  dynamic employeeLeaveType;
  dynamic employeeAttendenceType;
  dynamic id;

  LeaveContResult(
      {this.employeeId,
      this.companyId,
      this.tenantId,
      this.totalLeaves,
      this.usedLeaves,
      this.remainingLeaves,
      this.employeeLeaveType,
      this.employeeAttendenceType,
      this.id});

  LeaveContResult.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    companyId = json['companyId'];
    tenantId = json['tenantId'];
    totalLeaves = json['totalLeaves'];
    usedLeaves = json['usedLeaves'];
    remainingLeaves = json['remainingLeaves'];
    employeeLeaveType = json['employeeLeaveType'];
    employeeAttendenceType = json['employeeAttendenceType'];
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
    data['employeeLeaveType'] = this.employeeLeaveType;
    data['employeeAttendenceType'] = this.employeeAttendenceType;
    data['id'] = this.id;
    return data;
  }
}
