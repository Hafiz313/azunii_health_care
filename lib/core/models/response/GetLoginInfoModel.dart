import 'dart:convert';

GetLoginInfoModel getLoginInfoModelFromJson(String str) =>
    GetLoginInfoModel.fromJson(json.decode(str));
String getLoginModelToJson(GetLoginInfoModel data) =>
    json.encode(data.toJson());

class GetLoginInfoModel {
  Result? result;

  GetLoginInfoModel({this.result});

  GetLoginInfoModel.fromJson(Map<String, dynamic> json) {
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  Application? application;
  User? user;
  Tenant? tenant;

  Result({this.application, this.user, this.tenant});

  Result.fromJson(Map<String, dynamic> json) {
    application = json['application'] != null
        ? new Application.fromJson(json['application'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    tenant =
        json['tenant'] != null ? new Tenant.fromJson(json['tenant']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.application != null) {
      data['application'] = this.application!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.tenant != null) {
      data['tenant'] = this.tenant!.toJson();
    }
    return data;
  }
}

class Application {
  String? version;
  String? releaseDate;

  Application({this.version, this.releaseDate});

  Application.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    releaseDate = json['releaseDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['releaseDate'] = this.releaseDate;
    return data;
  }
}

class User {
  String? name;
  String? surname;
  bool? isAdmin;
  String? userName;
  String? emailAddress;
  int? employeeId;
  Null? employeeSetupStageSeq;
  Null? contractorSetupStageSeq;
  Null? contractorId;
  String? role;
  Null? contractorIsSetupCompleted;
  bool? employeeIsSetupCompleted;
  Null? userLastNavigationViewInfo;
  int? id;

  User(
      {this.name,
      this.surname,
      this.isAdmin,
      this.userName,
      this.emailAddress,
      this.employeeId,
      this.employeeSetupStageSeq,
      this.contractorSetupStageSeq,
      this.contractorId,
      this.role,
      this.contractorIsSetupCompleted,
      this.employeeIsSetupCompleted,
      this.userLastNavigationViewInfo,
      this.id});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    surname = json['surname'];
    isAdmin = json['isAdmin'];
    userName = json['userName'];
    emailAddress = json['emailAddress'];
    employeeId = json['employeeId'];
    employeeSetupStageSeq = json['employeeSetupStageSeq'];
    contractorSetupStageSeq = json['contractorSetupStageSeq'];
    contractorId = json['contractorId'];
    role = json['role'];
    contractorIsSetupCompleted = json['contractorIsSetupCompleted'];
    employeeIsSetupCompleted = json['employeeIsSetupCompleted'];
    userLastNavigationViewInfo = json['userLastNavigationViewInfo'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['isAdmin'] = this.isAdmin;
    data['userName'] = this.userName;
    data['emailAddress'] = this.emailAddress;
    data['employeeId'] = this.employeeId;
    data['employeeSetupStageSeq'] = this.employeeSetupStageSeq;
    data['contractorSetupStageSeq'] = this.contractorSetupStageSeq;
    data['contractorId'] = this.contractorId;
    data['role'] = this.role;
    data['contractorIsSetupCompleted'] = this.contractorIsSetupCompleted;
    data['employeeIsSetupCompleted'] = this.employeeIsSetupCompleted;
    data['userLastNavigationViewInfo'] = this.userLastNavigationViewInfo;
    data['id'] = this.id;
    return data;
  }
}

class Tenant {
  String? tenancyName;
  String? name;
  int? companyId;
  String? companyName;
  String? subscriptionEndDateUtc;
  bool? isInTrialPeriod;
  String? subscriptionPaymentType;
  bool? isCompanySetupComplete;
  bool? paySchedualCount;
  String? creationTime;
  dynamic edition;
  dynamic subscriptionDateString;
  bool? employeeIsSetupCompleted;
  String? clientOnboardingStatus;
  String? pennyVerificationStatus;
  int? pennyVerificationAttempts;
  int? id;

  Tenant(
      {this.tenancyName,
      this.name,
      this.companyId,
      this.companyName,
      this.subscriptionEndDateUtc,
      this.isInTrialPeriod,
      this.subscriptionPaymentType,
      this.isCompanySetupComplete,
      this.paySchedualCount,
      this.creationTime,
      this.edition,
      this.subscriptionDateString,
      this.employeeIsSetupCompleted,
      this.clientOnboardingStatus,
      this.pennyVerificationStatus,
      this.pennyVerificationAttempts,
      this.id});

  Tenant.fromJson(Map<String, dynamic> json) {
    tenancyName = json['tenancyName'];
    name = json['name'];
    companyId = json['companyId'];
    companyName = json['companyName'];
    subscriptionEndDateUtc = json['subscriptionEndDateUtc'];
    isInTrialPeriod = json['isInTrialPeriod'];
    subscriptionPaymentType = json['subscriptionPaymentType'];
    isCompanySetupComplete = json['isCompanySetupComplete'];
    paySchedualCount = json['paySchedualCount'];
    creationTime = json['creationTime'];
    edition = json['edition'];
    subscriptionDateString = json['subscriptionDateString'];
    employeeIsSetupCompleted = json['employeeIsSetupCompleted'];
    clientOnboardingStatus = json['clientOnboardingStatus'];
    pennyVerificationStatus = json['pennyVerificationStatus'];
    pennyVerificationAttempts = json['pennyVerificationAttempts'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tenancyName'] = this.tenancyName;
    data['name'] = this.name;
    data['companyId'] = this.companyId;
    data['companyName'] = this.companyName;
    data['subscriptionEndDateUtc'] = this.subscriptionEndDateUtc;
    data['isInTrialPeriod'] = this.isInTrialPeriod;
    data['subscriptionPaymentType'] = this.subscriptionPaymentType;
    data['isCompanySetupComplete'] = this.isCompanySetupComplete;
    data['paySchedualCount'] = this.paySchedualCount;
    data['creationTime'] = this.creationTime;
    data['edition'] = this.edition;
    data['subscriptionDateString'] = this.subscriptionDateString;
    data['employeeIsSetupCompleted'] = this.employeeIsSetupCompleted;
    data['clientOnboardingStatus'] = this.clientOnboardingStatus;
    data['pennyVerificationStatus'] = this.pennyVerificationStatus;
    data['pennyVerificationAttempts'] = this.pennyVerificationAttempts;
    data['id'] = this.id;
    return data;
  }
}
