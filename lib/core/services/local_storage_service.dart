import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class LocalStorageService {
  static const String _userBoxName = 'userBox';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userIdKey = 'userId';
  static const String _userTypeKey = 'userType';
  static const String _tokenKey = 'authToken';
  
  static const _secureStorage = FlutterSecureStorage();

  /// Initialize Hive

  /// Save user locally

  /// Get user locally

  /// Delete user locally

  /// Set login status with user type and token
  static Future<void> setLoginStatus(bool isLoggedIn,
      {String? userType, String? token}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, isLoggedIn);

      if (userType != null) {
        await prefs.setString(_userTypeKey, userType);
      } else {
        await prefs.remove(_userTypeKey);
      }

      if (token != null) {
        await _secureStorage.write(key: _tokenKey, value: token);
      } else {
        await _secureStorage.delete(key: _tokenKey);
      }
    } catch (e) {
      throw Exception('Failed to set login status');
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

  /// Get auth token from secure storage
  static Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: _tokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Get user type
  static Future<String?> getUserType() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userTypeKey);
    } catch (e) {
      return null;
    }
  }

  /// Clear all local data
  static Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await _secureStorage.deleteAll();
    } catch (e) {
      throw Exception('Failed to clear local data');
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
      
      // Clear secure storage
      await _secureStorage.delete(key: _tokenKey);
    } catch (e) {
      throw Exception('Failed to logout');
    }
  }
}
