import 'package:flutter/foundation.dart';

class SecurityConfig {
  // Disable debug logging in production
  static bool get enableDebugLogging => kDebugMode;

  // Token expiration time (15 minutes)
  static const Duration tokenExpirationDuration = Duration(minutes: 15);

  // Session timeout (30 minutes of inactivity)
  static const Duration sessionTimeout = Duration(minutes: 30);

  // Maximum login attempts before lockout
  static const int maxLoginAttempts = 5;

  // Lockout duration (15 minutes)
  static const Duration lockoutDuration = Duration(minutes: 15);

  // Minimum password length
  static const int minPasswordLength = 8;

  // Require HTTPS for all API calls
  static const bool enforceHttps = true;

  // Enable certificate pinning
  static const bool enableCertificatePinning = true;

  // List of allowed certificate hashes for pinning
  static const List<String> certificatePins = [
    // Add your certificate pins here
  ];

  // Disable screenshot capability in production
  static bool get preventScreenshots => !kDebugMode;

  // Disable clipboard access in production
  static bool get preventClipboardAccess => !kDebugMode;
}
