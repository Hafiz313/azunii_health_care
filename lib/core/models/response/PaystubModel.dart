class PaystubModel {
  List<PaystubResult>? result;
  dynamic targetUrl;
  bool? success;
  dynamic error;
  bool? unAuthorizedRequest;
  bool? bAbp;

  PaystubModel({
    this.result,
    this.targetUrl,
    this.success,
    this.error,
    this.unAuthorizedRequest,
    this.bAbp,
  });

  PaystubModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <PaystubResult>[];
      json['result'].forEach((v) {
        result!.add(PaystubResult.fromJson(v));
      });
    }
    targetUrl = json['targetUrl'];
    success = json['success'];
    error = json['error'];
    unAuthorizedRequest = json['unAuthorizedRequest'];
    bAbp = json['__abp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    data['targetUrl'] = targetUrl;
    data['success'] = success;
    data['error'] = error;
    data['unAuthorizedRequest'] = unAuthorizedRequest;
    data['__abp'] = bAbp;
    return data;
  }
}

class PaystubResult {
  String? companyName;
  String? companyAddress;
  String? employeeName;
  String? employeeAddress;
  String? payDate;
  String? payPeriod;
  String? grossPay;
  String? netPay;
  String? deductions;
  String? taxStatus;
  String? ssn;
  String? paymentMethod;
  String? checkIssueDate;
  PaystubPayments? payments;
  PaystubDeductions? deductionsData;
  PaystubYearToDate? yearToDate;
  int? id;
  String? address;
  String? federalFillingStatus;
  String? socialSecurity;
  List<dynamic>? earningtList;
  List<dynamic>? deductionList;
  List<dynamic>? ytdList;

  PaystubResult({
    this.companyName,
    this.companyAddress,
    this.employeeName,
    this.employeeAddress,
    this.payDate,
    this.payPeriod,
    this.grossPay,
    this.netPay,
    this.deductions,
    this.taxStatus,
    this.ssn,
    this.paymentMethod,
    this.checkIssueDate,
    this.payments,
    this.deductionsData,
    this.yearToDate,
    this.id,
    this.address,
    this.federalFillingStatus,
    this.socialSecurity,
    this.earningtList,
    this.deductionList,
    this.ytdList,
  });

  PaystubResult.fromJson(Map<String, dynamic> json) {
    companyName = json['companyName'] ?? '';
    companyAddress = json['companyAddress'] ?? '';
    employeeName = json['employeeName'] ?? '';
    employeeAddress = json['employeeAddress'] ?? '';
    payDate = json['payDate'] ?? '';
    payPeriod = json['payPeriod'] ?? '';
    grossPay = json['grossPay']?.toString() ?? '0';
    netPay = json['netPay']?.toString() ?? '0';
    deductions = json['deductions']?.toString() ?? '0';
    taxStatus = json['taxStatus'] ?? '';
    ssn = json['ssn'] ?? '';
    paymentMethod = json['paymentMethod'] ?? '';
    checkIssueDate = json['checkIssueDate'] ?? '';
    payments = json['payments'] != null
        ? PaystubPayments.fromJson(json['payments'])
        : null;
    deductionsData = json['deductionsData'] != null
        ? PaystubDeductions.fromJson(json['deductionsData'])
        : null;
    yearToDate = json['yearToDate'] != null
        ? PaystubYearToDate.fromJson(json['yearToDate'])
        : null;
    id = json['id'];
    address = json['address'];
    federalFillingStatus = json['federalFillingStatus'];
    socialSecurity = json['socialSecurity'];
    earningtList = json['earningtList'];
    deductionList = json['deductionList'];
    ytdList = json['ytdList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['companyName'] = companyName;
    data['companyAddress'] = companyAddress;
    data['employeeName'] = employeeName;
    data['employeeAddress'] = employeeAddress;
    data['payDate'] = payDate;
    data['payPeriod'] = payPeriod;
    data['grossPay'] = grossPay;
    data['netPay'] = netPay;
    data['deductions'] = deductions;
    data['taxStatus'] = taxStatus;
    data['ssn'] = ssn;
    data['paymentMethod'] = paymentMethod;
    data['checkIssueDate'] = checkIssueDate;
    if (payments != null) {
      data['payments'] = payments!.toJson();
    }
    if (deductionsData != null) {
      data['deductionsData'] = deductionsData!.toJson();
    }
    if (yearToDate != null) {
      data['yearToDate'] = yearToDate!.toJson();
    }
    data['id'] = id;
    data['address'] = address;
    data['federalFillingStatus'] = federalFillingStatus;
    data['socialSecurity'] = socialSecurity;
    data['earningtList'] = earningtList;
    data['deductionList'] = deductionList;
    data['ytdList'] = ytdList;
    return data;
  }
}

class PaystubPayments {
  String? tips;
  String? salary;
  String? otherBenefits;
  String? fringeBenefits;

  PaystubPayments({
    this.tips,
    this.salary,
    this.otherBenefits,
    this.fringeBenefits,
  });

  PaystubPayments.fromJson(Map<dynamic, dynamic> json) {
    tips = json['tips']?.toString() ?? '0';
    salary = json['salary']?.toString() ?? '0';
    otherBenefits = json['otherBenefits']?.toString() ?? '0';
    fringeBenefits = json['fringeBenefits']?.toString() ?? '0';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tips'] = tips;
    data['salary'] = salary;
    data['otherBenefits'] = otherBenefits;
    data['fringeBenefits'] = fringeBenefits;
    return data;
  }
}

class PaystubDeductions {
  String? federalWH;
  String? medicareTax;
  String? additionalMedicare;
  String? socialSecurityTax;
  String? nysWH1;
  String? nysWH2;

  PaystubDeductions({
    this.federalWH,
    this.medicareTax,
    this.additionalMedicare,
    this.socialSecurityTax,
    this.nysWH1,
    this.nysWH2,
  });

  PaystubDeductions.fromJson(Map<String, dynamic> json) {
    federalWH = json['federalWH']?.toString() ?? '0';
    medicareTax = json['medicareTax']?.toString() ?? '0';
    additionalMedicare = json['additionalMedicare']?.toString() ?? '0';
    socialSecurityTax = json['socialSecurityTax']?.toString() ?? '0';
    nysWH1 = json['nysWH1']?.toString() ?? '0';
    nysWH2 = json['nysWH2']?.toString() ?? '0';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['federalWH'] = federalWH;
    data['medicareTax'] = medicareTax;
    data['additionalMedicare'] = additionalMedicare;
    data['socialSecurityTax'] = socialSecurityTax;
    data['nysWH1'] = nysWH1;
    data['nysWH2'] = nysWH2;
    return data;
  }
}

class PaystubYearToDate {
  String? tips;
  String? salary;
  String? federalWH;
  String? medicareTax;
  String? socialSecurityTax;
  String? nysWH1;
  String? nysWH2;

  PaystubYearToDate({
    this.tips,
    this.salary,
    this.federalWH,
    this.medicareTax,
    this.socialSecurityTax,
    this.nysWH1,
    this.nysWH2,
  });

  PaystubYearToDate.fromJson(Map<dynamic, dynamic> json) {
    tips = json['tips']?.toString() ?? '0';
    salary = json['salary']?.toString() ?? '0';
    federalWH = json['federalWH']?.toString() ?? '0';
    medicareTax = json['medicareTax']?.toString() ?? '0';
    socialSecurityTax = json['socialSecurityTax']?.toString() ?? '0';
    nysWH1 = json['nysWH1']?.toString() ?? '0';
    nysWH2 = json['nysWH2']?.toString() ?? '0';
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['tips'] = tips;
    data['salary'] = salary;
    data['federalWH'] = federalWH;
    data['medicareTax'] = medicareTax;
    data['socialSecurityTax'] = socialSecurityTax;
    data['nysWH1'] = nysWH1;
    data['nysWH2'] = nysWH2;
    return data;
  }
}
