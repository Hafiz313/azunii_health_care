class BankListModel {
  BankResult? result;
  dynamic targetUrl;
  bool? success;
  dynamic error;
  bool? unAuthorizedRequest;
  bool? bAbp;

  BankListModel(
      {this.result,
      this.targetUrl,
      this.success,
      this.error,
      this.unAuthorizedRequest,
      this.bAbp});

  BankListModel.fromJson(Map<String, dynamic> json) {
    result =
        json['result'] != null ? new BankResult.fromJson(json['result']) : null;
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

class BankResult {
  dynamic paymentMethod;
  dynamic routingNumber;
  dynamic accountNumber;
  dynamic accountType;
  dynamic bankName;
  bool? isActive;
  dynamic fromDate;
  dynamic toDate;
  dynamic tenantId;
  dynamic employeeId;
  dynamic contractorId;
  dynamic companyId;
  dynamic emailAddress;
  dynamic id;

  BankResult(
      {this.paymentMethod,
      this.routingNumber,
      this.accountNumber,
      this.accountType,
      this.bankName,
      this.isActive,
      this.fromDate,
      this.toDate,
      this.tenantId,
      this.employeeId,
      this.contractorId,
      this.companyId,
      this.emailAddress,
      this.id});

  BankResult.fromJson(Map<String, dynamic> json) {
    paymentMethod = json['paymentMethod'] ?? '';
    routingNumber = json['routingNumber'] ?? '';
    accountNumber = json['accountNumber'] ?? '';
    accountType = json['accountType'] ?? '';
    bankName = json['bankName'] ?? '';
    isActive = json['isActive'] ?? '';
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    tenantId = json['tenantId'];
    employeeId = json['employeeId'];
    contractorId = json['contractorId'];
    companyId = json['companyId'];
    emailAddress = json['emailAddress'] ?? '';
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paymentMethod'] = this.paymentMethod;
    data['routingNumber'] = this.routingNumber;
    data['accountNumber'] = this.accountNumber;
    data['accountType'] = this.accountType;
    data['bankName'] = this.bankName;
    data['isActive'] = this.isActive;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['tenantId'] = this.tenantId;
    data['employeeId'] = this.employeeId;
    data['contractorId'] = this.contractorId;
    data['companyId'] = this.companyId;
    data['emailAddress'] = this.emailAddress;
    data['id'] = this.id;
    return data;
  }
}
