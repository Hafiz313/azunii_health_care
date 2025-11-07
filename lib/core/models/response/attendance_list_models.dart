class AttendanceListModels {
  List<AttendanceListResult>? attendanceResultList;
  dynamic targetUrl;
  bool? success;
  dynamic error;
  bool? unAuthorizedRequest;
  bool? bAbp;

  AttendanceListModels(
      {this.attendanceResultList,
      this.targetUrl,
      this.success,
      this.error,
      this.unAuthorizedRequest,
      this.bAbp});

  AttendanceListModels.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      attendanceResultList = <AttendanceListResult>[];
      json['result'].forEach((v) {
        attendanceResultList!.add(new AttendanceListResult.fromJson(v));
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
    if (this.attendanceResultList != null) {
      data['result'] =
          this.attendanceResultList!.map((v) => v.toJson()).toList();
    }
    data['targetUrl'] = this.targetUrl;
    data['success'] = this.success;
    data['error'] = this.error;
    data['unAuthorizedRequest'] = this.unAuthorizedRequest;
    data['__abp'] = this.bAbp;
    return data;
  }
}

class AttendanceListResult {
  dynamic employeeId;
  dynamic companyId;
  dynamic tenantId;
  String? date;
  dynamic frontDate;
  dynamic firstPunchIn;
  dynamic frontPunchIn;
  dynamic lastPunchOut;
  dynamic frontPunchOut;
  dynamic breakValue;
  dynamic overTime;
  dynamic workedHour;
  dynamic workedHoursStr;
  String? empAttendenceStatus;
  bool? isEnable;
  bool? buttonEnable;
  dynamic breakInHours;
  dynamic empScheduleStartTime;
  dynamic empScheduleEndTime;
  dynamic empScheduleWorkedHours;
  dynamic late;
  dynamic punctuality;
  dynamic attendancePercentage;
  bool? isLate;
  dynamic latitude;
  dynamic longitude;
  bool? overTimeApproved;
  dynamic jobId;
  dynamic dayType;
  dynamic id;

  AttendanceListResult(
      {this.employeeId,
      this.companyId,
      this.tenantId,
      this.date,
      this.frontDate,
      this.firstPunchIn,
      this.frontPunchIn,
      this.lastPunchOut,
      this.frontPunchOut,
      this.breakValue,
      this.overTime,
      this.workedHour,
      this.workedHoursStr,
      this.empAttendenceStatus,
      this.isEnable,
      this.buttonEnable,
      this.breakInHours,
      this.empScheduleStartTime,
      this.empScheduleEndTime,
      this.empScheduleWorkedHours,
      this.late,
      this.punctuality,
      this.attendancePercentage,
      this.isLate,
      this.latitude,
      this.longitude,
      this.overTimeApproved,
      this.jobId,
      this.dayType,
      this.id});

  AttendanceListResult.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    companyId = json['companyId'];
    tenantId = json['tenantId'];
    date = json['date'];
    frontDate = json['frontDate'];
    firstPunchIn = json['firstPunchIn'];
    frontPunchIn = json['frontPunchIn'];
    lastPunchOut = json['lastPunchOut'];
    frontPunchOut = json['frontPunchOut'];
    breakValue = json['break'];
    overTime = json['overTime'];
    workedHour = json['workedHour'];
    workedHoursStr = json['workedHoursStr'];
    empAttendenceStatus = json['empAttendenceStatus'];
    isEnable = json['isEnable'];
    buttonEnable = json['buttonEnable'];
    breakInHours = json['breakInHours'];
    empScheduleStartTime = json['empScheduleStartTime'];
    empScheduleEndTime = json['empScheduleEndTime'];
    empScheduleWorkedHours = json['empScheduleWorkedHours'];
    late = json['late'];
    punctuality = json['punctuality'];
    attendancePercentage = json['attendancePercentage'];
    isLate = json['isLate'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    overTimeApproved = json['overTimeApproved'];
    jobId = json['jobId'];
    dayType = json['dayType'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['companyId'] = this.companyId;
    data['tenantId'] = this.tenantId;
    data['date'] = this.date;
    data['frontDate'] = this.frontDate;
    data['firstPunchIn'] = this.firstPunchIn;
    data['frontPunchIn'] = this.frontPunchIn;
    data['lastPunchOut'] = this.lastPunchOut;
    data['frontPunchOut'] = this.frontPunchOut;
    data['break'] = this.breakValue;
    data['overTime'] = this.overTime;
    data['workedHour'] = this.workedHour;
    data['workedHoursStr'] = this.workedHoursStr;
    data['empAttendenceStatus'] = this.empAttendenceStatus;
    data['isEnable'] = this.isEnable;
    data['buttonEnable'] = this.buttonEnable;
    data['breakInHours'] = this.breakInHours;
    data['empScheduleStartTime'] = this.empScheduleStartTime;
    data['empScheduleEndTime'] = this.empScheduleEndTime;
    data['empScheduleWorkedHours'] = this.empScheduleWorkedHours;
    data['late'] = this.late;
    data['punctuality'] = this.punctuality;
    data['attendancePercentage'] = this.attendancePercentage;
    data['isLate'] = this.isLate;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['overTimeApproved'] = this.overTimeApproved;
    data['jobId'] = this.jobId;
    data['dayType'] = this.dayType;
    data['id'] = this.id;
    return data;
  }
}
