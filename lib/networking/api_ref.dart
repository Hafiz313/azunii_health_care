import 'package:flutter_dotenv/flutter_dotenv.dart';

class Apis {
  static String get baseUrl => "https://azunii.devdioxide.com/api";
  // static String get baseUrl => dotenv.env['BASE_API_URL'] ?? 'https://fallback-url.com/api';

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
}
