class Apis {
  ///base Url

  // static const String baseUrl = 'https://staging.app.eworkforcepayroll.com:618/api';
  static const String baseUrl = 'https://app.eworkforcepayroll.com:522/api';
  // static const String baseUrl = 'https://app.eworkforcepayroll.com:522/api';
  // static const String baseUrlStaging = 'https://staging.app.eworkforcepayroll.com:618/api/';
  static const loginApi = '/auth/login';
  static const isTenantAvailableApi = '/services/app/Account/IsTenantAvailable';
  static const forgetApi =
      '/services/app/SendOtp/SendOTPToEmailForForgetPassword';
  static const forgetOtpApi = '/services/app/SendOtp/VerifyOtpForMobile';
  static const otpVerifyApi = '/services/app/SendOtp/VerifyOtpForMobile';
  static const otpVerifyAuthApi = '/TokenAuth/VerifyAuthentication';
  static const otpVerifySignUpApi = '/TokenAuth/VerifyOtpForMobileSignUp';
  static const resetPasswordApi =
      '/services/app/Account/ResetPasswordForMobile';
  static const getJobEmp =
      '/services/app/EmpAttendence/GetEmpMultipleJobsDuringAttendence';
  static const signUpApi = '/TokenAuth/MobileSignup';
  static const authenticateApi = '/TokenAuth/Authenticate';
  static const saveLeaveRequestApi =
      '/services/app/EmpAttendence/SaveLeaveRequest';
  static const saveOverTimeRequestApi =
      '/services/app/EmpAttendence/SaveOvertimeRequest';
  static const saveSubstituteRequestApi =
      '/services/app/EmpAttendence/SaveSubstituteRequest';
  static const createOrEditEmployeePayment =
      '/services/app/Employee/CreateOrEditEmployeePayment';
  static const insertOrUpdateAttendenceApi =
      '/services/app/EmpAttendence/InsertOrUpdateAttendence';
  static const getLeaveCountApi =
      '/services/app/EmpAttendence/GetEmployeeLeavesCount';
  static const getCurrentLoginInformationsApi =
      '/services/app/Session/GetCurrentLoginInformations';
  static const getJobHoursApi =
      '/services/app/EmpAttendence/GetJobHoursOnDateBasis';
  static const getDashboardApi =
      '/services/app/EmpAttendence/GetMobileDashboardData';
  static const getPeriodsApi =
      '/services/app/CommonLookup/getPayperiods_ForEmployeePayStub';
  static const genratePayStub = '/File/GeneratePayStubsForMobile';
  static const getAttendanceListApi =
      '/services/app/EmpAttendence/GetWeeklyEmployeeAttendence';
  static const getAttendanceDetailsApi =
      '/services/app/EmpAttendence/GetAttendenceDetail';
  static const getSubstituteRequestsFromOther =
      '/services/app/EmpAttendence/GetSubstituteRequestsFromOther';
  static const getEmp = '/services/app/Employee/GetAllCompletedEmployees';
  static const getDesignation =
      '/services/app/EmpAttendence/GetAllDesignations';
  static const getLocation = '/services/app/CommonLookup/GetCompanyLocations';
  static const getLeaveBalanceListApi =
      '/services/app/EmpAttendence/GetLeavesRequestsListForMobile';
  static const getLeaveBalanceHistoryApi =
      '/services/app/EmpAttendence/GetEmployeeLeaves';
  static const getBankListApi = '/services/app/Employee/GetEmployeePaymentInfo';
  static const getSwitchCompanyList =
      '/TokenAuth/CompanyListForMobile/company-list-for-mobile';
  static const getSwitchCompanyById =
      '/TokenAuth/SwitchCompanyForMobile/switch-company-for-mobile';
  static const getSubstituteRequestsToOther =
      '/services/app/EmpAttendence/GetSubstituteRequestsFromOther';
  static const signupApi = '/users';
  static const forgetPasswordApi = '/auth/forgot-password';
  static const verifyOTPApi = '/auth/verify-otp';
  static const checkInApi = '/employee/check-in';
  static const checkOutApi = '/employee/checkout';
  static const startBreakApi = '/employee/start-break';
  static const endBreakApi = '/employee/end-break';
  static const currentHourApi = '/employee/current-hours';

  static const logoutApi = '/auth/logout';
  static const groupsApi = '/groups';
  // static const groupsApi = '/groups';
  static const playersApi = '/players/';
  static const deletePlayersApi = '/players/multiple_destroy';
  static const gameApi = '/games/';
}
