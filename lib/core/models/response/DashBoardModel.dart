import 'dart:convert';

DashBoardModel dashBoardModelFromJson(String str) =>
    DashBoardModel.fromJson(json.decode(str));
String dashBoardModelToJson(DashBoardModel data) => json.encode(data.toJson());

class DashBoardModel {
  DashBoardResult? result;
  dynamic targetUrl;
  bool? success;
  dynamic error;
  bool? unAuthorizedRequest;
  bool? bAbp;

  DashBoardModel(
      {this.result,
      this.targetUrl,
      this.success,
      this.error,
      this.unAuthorizedRequest,
      this.bAbp});

  DashBoardModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null
        ? new DashBoardResult.fromJson(json['result'])
        : null;
    targetUrl = json['targetUrl'];
    success = json['success'];
    error = json['error'];
    unAuthorizedRequest = json['unAuthorizedRequest'];
    bAbp = json['__abp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    data['targetUrl'] = this.targetUrl;
    data['success'] = this.success;
    data['error'] = this.error;
    data['unAuthorizedRequest'] = this.unAuthorizedRequest;
    data['__abp'] = this.bAbp;
    return data;
  }
}

class DashBoardResult {
  String? name;
  String? designation;
  String? punchInTime;
  WorkHoursDetails? workHoursDetails;
  Leaves? leaves;
  List<Announcements>? announcements;
  List<TodayActivities>? todayActivities;
  int? id;

  DashBoardResult(
      {this.name,
      this.designation,
      this.punchInTime,
      this.workHoursDetails,
      this.leaves,
      this.announcements,
      this.todayActivities,
      this.id});

  DashBoardResult.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    designation = json['designation'];
    punchInTime = json['punchInTime'];
    workHoursDetails = json['workHoursDetails'] != null
        ? new WorkHoursDetails.fromJson(json['workHoursDetails'])
        : null;
    leaves =
        json['leaves'] != null ? new Leaves.fromJson(json['leaves']) : null;
    if (json['announcements'] != null) {
      announcements = <Announcements>[];
      json['announcements'].forEach((v) {
        announcements!.add(new Announcements.fromJson(v));
      });
    }
    if (json['todayActivities'] != null) {
      todayActivities = <TodayActivities>[];
      json['todayActivities'].forEach((v) {
        todayActivities!.add(new TodayActivities.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['designation'] = this.designation;
    data['punchInTime'] = this.punchInTime;
    if (this.workHoursDetails != null) {
      data['workHoursDetails'] = this.workHoursDetails!.toJson();
    }
    if (this.leaves != null) {
      data['leaves'] = this.leaves!.toJson();
    }
    if (this.announcements != null) {
      data['announcements'] =
          this.announcements!.map((v) => v.toJson()).toList();
    }
    if (this.todayActivities != null) {
      data['todayActivities'] =
          this.todayActivities!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
  }
}

class WorkHoursDetails {
  dynamic totalHours;
  double? remaining;
  double? workedHours;
  dynamic overTime;
  double? late;
  dynamic today;
  dynamic breakTime;
  dynamic week;
  dynamic monthlyWorkedHours;
  dynamic monthlyRemainingHours;
  dynamic overtime;
  dynamic jobId;
  dynamic id;

  WorkHoursDetails(
      {this.totalHours,
      this.remaining,
      this.workedHours,
      this.overTime,
      this.late,
      this.today,
      this.breakTime,
      this.week,
      this.monthlyWorkedHours,
      this.monthlyRemainingHours,
      this.overtime,
      this.jobId,
      this.id});

  WorkHoursDetails.fromJson(Map<String, dynamic> json) {
    totalHours = json['totalHours'];
    remaining = json['remaining'];
    workedHours = json['workedHours'];
    overTime = json['overTime'];
    late = json['late'];
    today = json['today'];
    breakTime = json['break'];
    week = json['week'];
    monthlyWorkedHours = json['monthlyWorkedHours'];
    monthlyRemainingHours = json['monthlyRemainingHours'];
    overtime = json['overtime'];
    jobId = json['jobId'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalHours'] = this.totalHours;
    data['remaining'] = this.remaining;
    data['workedHours'] = this.workedHours;
    data['overTime'] = this.overTime;
    data['late'] = this.late;
    data['today'] = this.today;
    data['break'] = this.breakTime;
    data['week'] = this.week;
    data['monthlyWorkedHours'] = this.monthlyWorkedHours;
    data['monthlyRemainingHours'] = this.monthlyRemainingHours;
    data['overtime'] = this.overtime;
    data['jobId'] = this.jobId;
    data['id'] = this.id;
    return data;
  }
}

class Leaves {
  dynamic employeeId;
  dynamic companyId;
  dynamic tenantId;
  dynamic totalLeaves;
  dynamic usedLeaves;
  dynamic remainingLeaves;
  dynamic leaveRequest;
  dynamic employeeLeaveType;
  dynamic employeeAttendenceType;
  dynamic id;

  Leaves(
      {this.employeeId,
      this.companyId,
      this.tenantId,
      this.totalLeaves,
      this.usedLeaves,
      this.remainingLeaves,
      this.leaveRequest,
      this.employeeLeaveType,
      this.employeeAttendenceType,
      this.id});

  Leaves.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    companyId = json['companyId'];
    tenantId = json['tenantId'];
    totalLeaves = json['totalLeaves'];
    usedLeaves = json['usedLeaves'];
    remainingLeaves = json['remainingLeaves'];
    leaveRequest = json['leaveRequest'];
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
    data['leaveRequest'] = this.leaveRequest;
    data['employeeLeaveType'] = this.employeeLeaveType;
    data['employeeAttendenceType'] = this.employeeAttendenceType;
    data['id'] = this.id;
    return data;
  }
}

class Announcements {
  String? name;
  String? subject;
  String? description;
  String? date;
  dynamic id;

  Announcements(
      {this.name, this.subject, this.description, this.date, this.id});

  Announcements.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    subject = json['subject'];
    description = json['description'];
    date = json['date'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['subject'] = this.subject;
    data['description'] = this.description;
    data['date'] = this.date;
    data['id'] = this.id;
    return data;
  }
}

class TodayActivities {
  dynamic employeeId;
  dynamic companyId;
  dynamic tenantId;
  String? date;
  String? empAttendencePunchType;
  bool? isCheckIn;
  bool? isCheckOut;
  dynamic breakTime;
  dynamic duration;
  dynamic jobId;
  dynamic id;

  TodayActivities(
      {this.employeeId,
      this.companyId,
      this.tenantId,
      this.date,
      this.empAttendencePunchType,
      this.isCheckIn,
      this.isCheckOut,
      this.breakTime,
      this.duration,
      this.jobId,
      this.id});

  TodayActivities.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    companyId = json['companyId'];
    tenantId = json['tenantId'];
    date = json['date'];
    empAttendencePunchType = json['empAttendencePunchType'];
    isCheckIn = json['isCheckIn'];
    isCheckOut = json['isCheckOut'];
    breakTime = json['break'];
    duration = json['duration'];
    jobId = json['jobId'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['companyId'] = this.companyId;
    data['tenantId'] = this.tenantId;
    data['date'] = this.date;
    data['empAttendencePunchType'] = this.empAttendencePunchType;
    data['isCheckIn'] = this.isCheckIn;
    data['isCheckOut'] = this.isCheckOut;
    data['break'] = this.breakTime;
    data['duration'] = this.duration;
    data['jobId'] = this.jobId;
    data['id'] = this.id;
    return data;
  }
}
