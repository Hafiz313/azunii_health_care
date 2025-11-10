import 'package:azunii_health_care/views/auth/Otp/otp_forget_view.dart';
import 'package:azunii_health_care/views/auth/Otp/otp_signup_view.dart';
import 'package:azunii_health_care/views/auth/forget/froget_view.dart';
import 'package:azunii_health_care/views/auth/forget/rest_password_view.dart';
import 'package:azunii_health_care/views/auth/login/login_view.dart';
import 'package:azunii_health_care/views/auth/Otp/otp_view.dart';
import 'package:azunii_health_care/views/auth/sing_up/signup_view.dart';
import 'package:azunii_health_care/views/auth/splash_view.dart';

import 'package:azunii_health_care/views/care_taker/home/home_view.dart';
import 'package:azunii_health_care/views/patient/patient_dashboard.dart';

import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRoutes {
  static const splash = SplashView.routeName;
  static const login = LoginView.routeName;
  static const signUp = SignUpView.routeName;
  static const otp = OtpView.routeName;
  static const home = HomeView.routeName;
  static const forget = ForgetView.routeName;
  static const otpSign = OtpSignUpView.routeName;
  static const otpForget = OtpForgetView.routeName;
  static const restPas = RestPasswordView.routeName;
  static const patientDashboard = PatientDashboard.routeName;

  static final List<GetPage> pages = [
    GetPage(name: splash, page: () => SplashView()),
    GetPage(name: login, page: () => LoginView()),
    GetPage(name: signUp, page: () => SignUpView()),
    GetPage(name: otp, page: () => OtpView()),
    GetPage(name: home, page: () => HomeView()),
    GetPage(name: forget, page: () => ForgetView()),
    GetPage(name: otpSign, page: () => OtpSignUpView()),
    GetPage(name: otpForget, page: () => OtpForgetView()),
    GetPage(name: restPas, page: () => RestPasswordView()),
    GetPage(name: patientDashboard, page: () => PatientDashboard()),
  ];
}
