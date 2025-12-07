import 'package:flutter_dotenv/flutter_dotenv.dart';

class Apis {
  static String get baseUrl =>
      dotenv.env['BASE_API_URL'] ?? 'https://fallback-url.com/api';

  // Auth endpoints
  static const String register = '/register';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String googleLogin = '/login-google';
  static const String appleLogin = '/login-apple';
  static const String logout = '/logout';
  static const String deleteAccount = '/delete-account';

  // Profile endpoints
  static const String profileInfo = '/profile/info';

  // Patient visits endpoints
  static const String storePatientVisit = '/patient/visits/store';
  static const String getPatientVisits = '/patient/visits/index';
  static const String getVisitDetails = '/patient/visits/show';
  static const String updatePatientVisit = '/patient/visits/update';

  // Patient summaries endpoints
  static const String getPatientSummary = '/patient/summary/index';
  static const String storePatientSummary = '/patient/summary/store';
  static const String updatePatientSummary = '/patient/summary/update';

  // Patient medicines endpoints
  static const String getPatientMedicines = '/patient/medicine/index';
  static const String storePatientMedicine = '/patient/medicine/store';
  static const String getMedicineDetails = '/patient/medicine/show';
  static const String updatePatientMedicine = '/patient/medicine/update';
  //feedback
  static const String storeFeedback = '/patient/feedback/store';
  //caregivers
  static const String caregiversNotes = '/caregiver/notes/store';
  static const String storeCaregivers = '/patient/caregiver/store';
  static const String getCaregivers = '/patient/caregiver/index';
  static const String caregiversDetail = '/patient/caregiver/show';
  static const String caregiversDestroy = '/patient/caregiver/destroy';
}
