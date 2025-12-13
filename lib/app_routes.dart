import 'package:Azunii_Health/views/auth/forget/froget_view.dart';

import 'package:Azunii_Health/views/auth/login/login_view.dart';
import 'package:Azunii_Health/views/auth/sing_up/signup_view.dart';
import 'package:Azunii_Health/views/care_taker/FAQs/faqs_view.dart';
import 'package:Azunii_Health/views/care_taker/Medication/medication_caretaker_view.dart';
import 'package:Azunii_Health/views/care_taker/Notes/notes_view.dart';
import 'package:Azunii_Health/views/care_taker/dashboard/dashboard.dart';
import 'package:Azunii_Health/views/care_taker/feedback/feedback_view.dart';
import 'package:Azunii_Health/views/care_taker/home/home_view_caregiver.dart.dart';
import 'package:Azunii_Health/views/care_taker/settings/settings_view.dart';
import 'package:Azunii_Health/views/patient/advocacy/add_caregiver_view.dart';
import 'package:Azunii_Health/views/patient/dashboard/patient_dashboard.dart';
import 'package:Azunii_Health/views/patient/home/home_view.dart';
import 'package:Azunii_Health/views/patient/medicines/edit_medication.dart';
import 'package:Azunii_Health/views/patient/home/profile_view.dart';
import 'package:Azunii_Health/views/patient/privacy/privacy_policy_view.dart';
import 'package:Azunii_Health/views/patient/support/help_support_view.dart';
import 'package:Azunii_Health/views/patient/summary/view_summaries_view.dart';
import 'package:Azunii_Health/views/patient/visits/all_visits_view.dart';
import 'package:Azunii_Health/views/patient/visits/edit_visits_view.dart';
import 'package:Azunii_Health/views/patient/visits/visits_view.dart';
import 'package:Azunii_Health/views/splash/splash_view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRoutes {
  static const splash = SplashView.routeName;
  static const login = LoginView.routeName;
  static const signUp = SignUpView.routeName;

  static const home = HomeView.routeName;
  static const forget = ForgetView.routeName;

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
  static const editMedicineView = EditMedicineView.routeName;
  static const editVisitsView = EditVisitsView.routeName;
  static const profile = ProfileView.routeName;
  static const privacyPolicy = PrivacyPolicyView.routeName;
  static const helpSupport = HelpSupportView.routeName;
  static const allVisits = AllVisitsView.routeName;
  static const viewSummaries = ViewSummariesView.routeName;

  static final List<GetPage> pages = [
    GetPage(name: splash, page: () => SplashView()),
    GetPage(name: login, page: () => LoginView()),
    GetPage(name: signUp, page: () => SignUpView()),
    GetPage(name: home, page: () => HomeView()),
    GetPage(name: forget, page: () => ForgetView()),
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
    GetPage(name: editMedicineView, page: () => const EditMedicineView()),
    GetPage(name: editVisitsView, page: () => EditVisitsView()),
    GetPage(name: profile, page: () => const ProfileView()),
    GetPage(name: privacyPolicy, page: () => const PrivacyPolicyView()),
    GetPage(name: helpSupport, page: () => const HelpSupportView()),
    GetPage(name: allVisits, page: () => const AllVisitsView()),
    GetPage(name: viewSummaries, page: () => const ViewSummariesView()),
  ];
}
