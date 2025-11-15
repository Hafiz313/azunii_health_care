import 'package:azunii_health_care/views/auth/Otp/otp_forget_view.dart';
import 'package:azunii_health_care/views/auth/Otp/otp_signup_view.dart';
import 'package:azunii_health_care/views/auth/forget/froget_view.dart';
import 'package:azunii_health_care/views/auth/forget/rest_password_view.dart';
import 'package:azunii_health_care/views/auth/login/login_view.dart';
import 'package:azunii_health_care/views/auth/Otp/otp_view.dart';
import 'package:azunii_health_care/views/auth/sing_up/signup_view.dart';
import 'package:azunii_health_care/views/auth/splash_view.dart';
import 'package:azunii_health_care/views/care_taker/home/home_view_caregiver.dart.dart';

import 'package:azunii_health_care/views/patient/home/home_view.dart';
import 'package:azunii_health_care/views/patient/dashboard/patient_dashboard.dart';
import 'package:azunii_health_care/views/patient/visits/visits_view.dart';
import 'package:azunii_health_care/views/patient/summary/feedback_view.dart';
import 'package:azunii_health_care/views/patient/advocacy/add_caregiver_view.dart';
import 'package:azunii_health_care/views/care_taker/dashboard/dashboard.dart';
import 'package:azunii_health_care/views/care_taker/home/home_view_caregiver.dart';
import 'package:azunii_health_care/views/care_taker/notes/notes_view.dart';
import 'package:azunii_health_care/views/care_taker/medication/medication_caretaker_view.dart';
import 'package:azunii_health_care/views/care_taker/faqs/faqs_view.dart';
import 'package:azunii_health_care/views/care_taker/settings/settings_view.dart';

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
  static const addVisit = AddVisitView.routeName;
  static const feedback = FeedbackView.routeName;
  static const addCaregiver = AddCaregiverView.routeName;
  static const careTakerDashboard = CareTakerDashboard.routeName;
  static const homeCaregiver = HomeView_caregiver.routeName;
  static const notesCaregiver = Notesview.routeName;
  static const medicationCaregiver = Medication_caretaker.routeName;
  static const faqsCaregiver = FAQsView.routeName;
  static const settingsCaregiver = Settingsview.routeName;

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
    GetPage(name: addVisit, page: () => AddVisitView()),
    GetPage(name: feedback, page: () => const FeedbackView()),
    GetPage(name: addCaregiver, page: () => const AddCaregiverView()),
    GetPage(name: careTakerDashboard, page: () => const CareTakerDashboard()),
    GetPage(name: homeCaregiver, page: () => const HomeView_caregiver()),
    GetPage(name: notesCaregiver, page: () => const Notesview()),
    GetPage(
        name: medicationCaregiver, page: () => const Medication_caretaker()),
    GetPage(name: faqsCaregiver, page: () => const FAQsView()),
    GetPage(name: settingsCaregiver, page: () => const Settingsview()),
  ];
}
