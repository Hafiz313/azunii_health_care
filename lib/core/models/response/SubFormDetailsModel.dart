class SubFormDetailsModel {
  List<SubFormResult>? result;
  dynamic targetUrl;
  bool? success;
  dynamic error;
  bool? unAuthorizedRequest;
  bool? bAbp;

  SubFormDetailsModel(
      {this.result,
      this.targetUrl,
      this.success,
      this.error,
      this.unAuthorizedRequest,
      this.bAbp});

  SubFormDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <SubFormResult>[];
      json['result'].forEach((v) {
        result!.add(new SubFormResult.fromJson(v));
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

class SubFormResult {
  dynamic tenantId;
  dynamic companyId;
  dynamic senderEmployeeId;
  dynamic receiverEmployeeId;
  String? fromDate;
  String? toDate;
  dynamic description;
  dynamic substituteDay;
  dynamic companyLocationId;
  dynamic jobHour;
  dynamic substituteHours;
  dynamic leaveHour;
  dynamic attendenceLeaveType;
  dynamic substituteStatus;
  String? fromTime;
  String? toTime;
  dynamic approverUserId;
  String? approvedBy;
  dynamic departmentId;
  String? departmentName;
  String? name;
  List<dynamic>? multipleSubstituteRequest;
  dynamic id;

  SubFormResult(
      {this.tenantId,
      this.companyId,
      this.senderEmployeeId,
      this.receiverEmployeeId,
      this.fromDate,
      this.toDate,
      this.description,
      this.substituteDay,
      this.companyLocationId,
      this.jobHour,
      this.substituteHours,
      this.leaveHour,
      this.attendenceLeaveType,
      this.substituteStatus,
      this.fromTime,
      this.toTime,
      this.approverUserId,
      this.approvedBy,
      this.departmentId,
      this.departmentName,
      this.name,
      this.multipleSubstituteRequest,
      this.id});

  SubFormResult.fromJson(Map<String, dynamic> json) {
    tenantId = json['tenantId'];
    companyId = json['companyId'];
    senderEmployeeId = json['senderEmployeeId'];
    receiverEmployeeId = json['receiverEmployeeId'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    description = json['description'];
    substituteDay = json['substituteDay'];
    companyLocationId = json['companyLocationId'];
    jobHour = json['jobHour'];
    substituteHours = json['substituteHours'];
    leaveHour = json['leaveHour'];
    attendenceLeaveType = json['attendenceLeaveType'];
    substituteStatus = json['substituteStatus'];
    fromTime = json['fromTime'];
    toTime = json['toTime'];
    approverUserId = json['approverUserId'];
    approvedBy = json['approvedBy'];
    departmentId = json['departmentId'];
    departmentName = json['departmentName'];
    name = json['name'];
    // if (json['multipleSubstituteRequest'] != null) {
    //   multipleSubstituteRequest = <Null>[];
    //   json['multipleSubstituteRequest'].forEach((v) {
    //     multipleSubstituteRequest!.add(new dynamic.fromJson(v));
    //   });
    // }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tenantId'] = this.tenantId;
    data['companyId'] = this.companyId;
    data['senderEmployeeId'] = this.senderEmployeeId;
    data['receiverEmployeeId'] = this.receiverEmployeeId;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['description'] = this.description;
    data['substituteDay'] = this.substituteDay;
    data['companyLocationId'] = this.companyLocationId;
    data['jobHour'] = this.jobHour;
    data['substituteHours'] = this.substituteHours;
    data['leaveHour'] = this.leaveHour;
    data['attendenceLeaveType'] = this.attendenceLeaveType;
    data['substituteStatus'] = this.substituteStatus;
    data['fromTime'] = this.fromTime;
    data['toTime'] = this.toTime;
    data['approverUserId'] = this.approverUserId;
    data['approvedBy'] = this.approvedBy;
    data['departmentId'] = this.departmentId;
    data['departmentName'] = this.departmentName;
    data['name'] = this.name;
    if (this.multipleSubstituteRequest != null) {
      data['multipleSubstituteRequest'] =
          this.multipleSubstituteRequest!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
  }
}
