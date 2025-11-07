class GetEmpModels {
  Result? result;
  dynamic targetUrl;
  bool? success;
  dynamic error;
  bool? unAuthorizedRequest;
  bool? bAbp;

  GetEmpModels(
      {this.result,
      this.targetUrl,
      this.success,
      this.error,
      this.unAuthorizedRequest,
      this.bAbp});

  GetEmpModels.fromJson(Map<String, dynamic> json) {
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
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

class Result {
  dynamic totalCount;
  List<ItemsEpm>? items;

  Result({this.totalCount, this.items});

  Result.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    if (json['items'] != null) {
      items = <ItemsEpm>[];
      json['items'].forEach((v) {
        items!.add(new ItemsEpm.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemsEpm {
  String? firstName;
  dynamic middleInitial;
  String? lastName;
  dynamic stage;
  String? status;
  bool? isInvitedviaEmail;
  dynamic calenderName;
  bool? isDeleted;
  bool? isEmployeePortal;
  String? fullName;
  dynamic jobTitle;
  dynamic id;

  ItemsEpm(
      {this.firstName,
      this.middleInitial,
      this.lastName,
      this.stage,
      this.status,
      this.isInvitedviaEmail,
      this.calenderName,
      this.isDeleted,
      this.isEmployeePortal,
      this.fullName,
      this.jobTitle,
      this.id});

  ItemsEpm.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    middleInitial = json['middleInitial'];
    lastName = json['lastName'];
    stage = json['stage'];
    status = json['status'];
    isInvitedviaEmail = json['isInvitedviaEmail'];
    calenderName = json['calenderName'];
    isDeleted = json['isDeleted'];
    isEmployeePortal = json['isEmployeePortal'];
    fullName = json['fullName'];
    jobTitle = json['jobTitle'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['middleInitial'] = this.middleInitial;
    data['lastName'] = this.lastName;
    data['stage'] = this.stage;
    data['status'] = this.status;
    data['isInvitedviaEmail'] = this.isInvitedviaEmail;
    data['calenderName'] = this.calenderName;
    data['isDeleted'] = this.isDeleted;
    data['isEmployeePortal'] = this.isEmployeePortal;
    data['fullName'] = this.fullName;
    data['jobTitle'] = this.jobTitle;
    data['id'] = this.id;
    return data;
  }
}
