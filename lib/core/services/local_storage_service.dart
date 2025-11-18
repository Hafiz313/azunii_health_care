import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class LocalStorageService {
  static const String _userBoxName = 'userBox';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userIdKey = 'userId';
  static const String _userTypeKey = 'userType';

  /// Initialize Hive

  /// Save user locally

  /// Get user locally

  /// Delete user locally

  /// Set login status with user type
  static Future<void> setLoginStatus(bool isLoggedIn,
      {String? userType}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, isLoggedIn);

      if (userType != null) {
        await prefs.setString(_userTypeKey, userType);
      } else {
        await prefs.remove(_userTypeKey);
      }
    } catch (e) {
      throw Exception('Failed to set login status: $e');
    }
  }

  /// Get login status
  static Future<bool> getLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Get user type

  /// Clear all local data
  static Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      throw Exception('Failed to clear local data: $e');
    }
  }

  /// Complete logout - Clear all data and reset login status
  static Future<void> logout() async {
    try {
      // Clear Hive data

      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_isLoggedInKey);

      await prefs.remove(_userTypeKey);
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }
}
