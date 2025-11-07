class SignUpModels {
  SignUpResult? result;
  dynamic targetUrl;
  bool? success;
  dynamic error;
  bool? unAuthorizedRequest;
  bool? bAbp;

  SignUpModels(
      {this.result,
      this.targetUrl,
      this.success,
      this.error,
      this.unAuthorizedRequest,
      this.bAbp});

  SignUpModels.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null
        ? new SignUpResult.fromJson(json['result'])
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

class SignUpResult {
  String? fullName;
  String? registeredPhoneNumber;
  String? ssn;
  String? companyEmailAddress;
  String? employeeEmailAddress;
  String? password;
  dynamic otpCode;
  int? tenantId;
  int? employeeId;
  int? id;

  SignUpResult(
      {this.fullName,
      this.registeredPhoneNumber,
      this.ssn,
      this.companyEmailAddress,
      this.employeeEmailAddress,
      this.password,
      this.otpCode,
      this.tenantId,
      this.employeeId,
      this.id});

  SignUpResult.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    registeredPhoneNumber = json['registeredPhoneNumber'];
    ssn = json['ssn'];
    companyEmailAddress = json['companyEmailAddress'];
    employeeEmailAddress = json['employeeEmailAddress'];
    password = json['password'];
    otpCode = json['otpCode'];
    tenantId = json['tenantId'];
    employeeId = json['employeeId'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['registeredPhoneNumber'] = this.registeredPhoneNumber;
    data['ssn'] = this.ssn;
    data['companyEmailAddress'] = this.companyEmailAddress;
    data['employeeEmailAddress'] = this.employeeEmailAddress;
    data['password'] = this.password;
    data['otpCode'] = this.otpCode;
    data['tenantId'] = this.tenantId;
    data['employeeId'] = this.employeeId;
    data['id'] = this.id;
    return data;
  }
}
