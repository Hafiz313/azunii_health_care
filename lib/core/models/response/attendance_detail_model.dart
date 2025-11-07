class AttendanceDetailModel {
  AttendanceDetailResult? result;
  dynamic targetUrl;
  dynamic success;
  dynamic error;
  dynamic unAuthorizedRequest;
  dynamic bAbp;

  AttendanceDetailModel(
      {this.result,
      this.targetUrl,
      this.success,
      this.error,
      this.unAuthorizedRequest,
      this.bAbp});

  AttendanceDetailModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null
        ? new AttendanceDetailResult.fromJson(json['result'])
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

class AttendanceDetailResult {
  dynamic attendancePercentage;
  dynamic workedHours;
  dynamic leaveCount;
  dynamic overTime;
  dynamic late;
  dynamic id;

  AttendanceDetailResult(
      {this.attendancePercentage,
      this.workedHours,
      this.leaveCount,
      this.overTime,
      this.late,
      this.id});

  AttendanceDetailResult.fromJson(Map<String, dynamic> json) {
    attendancePercentage = json['attendancePercentage'];
    workedHours = json['workedHours'];
    leaveCount = json['leaveCount'];
    overTime = json['overTime'];
    late = json['late'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attendancePercentage'] = this.attendancePercentage;
    data['workedHours'] = this.workedHours;
    data['leaveCount'] = this.leaveCount;
    data['overTime'] = this.overTime;
    data['late'] = this.late;
    data['id'] = this.id;
    return data;
  }
}
