class LoginResponse {
  Result? result;
  dynamic targetUrl;
  bool? success;
  dynamic error;
  bool? unAuthorizedRequest;
  bool? bAbp;

  LoginResponse(
      {this.result,
      this.targetUrl,
      this.success,
      this.error,
      this.unAuthorizedRequest,
      this.bAbp});

  LoginResponse.fromJson(Map<String, dynamic> json) {
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
  dynamic accessToken;
  dynamic encryptedAccessToken;
  int? expireInSeconds;
  int? userId;
  bool? isPhoneAuthentication;
  bool? isEmailAuthentication;
  String? phoneNumber;
  dynamic emailAddress;
  dynamic viewPath;
  bool? isTwoFactorRequired;
  bool? isNewDevice;
  bool? isSaveNewDevice;
  dynamic otpCode;
  String? deviceId;
  dynamic browerInfo;
  String? deviceType;

  Result(
      {this.accessToken,
      this.encryptedAccessToken,
      this.expireInSeconds,
      this.userId,
      this.isPhoneAuthentication,
      this.isEmailAuthentication,
      this.phoneNumber,
      this.emailAddress,
      this.viewPath,
      this.isTwoFactorRequired,
      this.isNewDevice,
      this.isSaveNewDevice,
      this.otpCode,
      this.deviceId,
      this.browerInfo,
      this.deviceType});

  Result.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    encryptedAccessToken = json['encryptedAccessToken'];
    expireInSeconds = json['expireInSeconds'];
    userId = json['userId'];
    isPhoneAuthentication = json['isPhoneAuthentication'];
    isEmailAuthentication = json['isEmailAuthentication'];
    phoneNumber = json['phoneNumber'];
    emailAddress = json['emailAddress'];
    viewPath = json['viewPath'];
    isTwoFactorRequired = json['isTwoFactorRequired'];
    isNewDevice = json['isNewDevice'];
    isSaveNewDevice = json['isSaveNewDevice'];
    otpCode = json['otpCode'];
    deviceId = json['deviceId'];
    browerInfo = json['browerInfo'];
    deviceType = json['deviceType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['encryptedAccessToken'] = this.encryptedAccessToken;
    data['expireInSeconds'] = this.expireInSeconds;
    data['userId'] = this.userId;
    data['isPhoneAuthentication'] = this.isPhoneAuthentication;
    data['isEmailAuthentication'] = this.isEmailAuthentication;
    data['phoneNumber'] = this.phoneNumber;
    data['emailAddress'] = this.emailAddress;
    data['viewPath'] = this.viewPath;
    data['isTwoFactorRequired'] = this.isTwoFactorRequired;
    data['isNewDevice'] = this.isNewDevice;
    data['isSaveNewDevice'] = this.isSaveNewDevice;
    data['otpCode'] = this.otpCode;
    data['deviceId'] = this.deviceId;
    data['browerInfo'] = this.browerInfo;
    data['deviceType'] = this.deviceType;
    return data;
  }
}
