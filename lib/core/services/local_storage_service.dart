import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class LocalStorageService {
  static const String _userBoxName = 'userBox';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userIdKey = 'userId';
  static const String _userTypeKey = 'userType';
  static const String _tokenKey = 'authToken';
  static const String _rememberMeKey = 'rememberMe';
  static const String _rememberedEmailKey = 'rememberedEmail';
  static const String _rememberedPasswordKey = 'rememberedPassword';
  
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

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
  /// NEVER throws — must always complete so navigation can proceed
  static Future<void> logout() async {
    try {
      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_isLoggedInKey);
      await prefs.remove(_userTypeKey);
    } catch (e) {
      // Ignore — we must not prevent navigation
    }
    try {
      // Clear secure storage separately — can fail on some devices
      await _secureStorage.delete(key: _tokenKey);
    } catch (e) {
      // Ignore — we must not prevent navigation
    }
  }
  
  /// Save doctor specialties to cache with timestamp
  static Future<void> saveDoctorSpecialties(String jsonString) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('doctor_specialties_cache', jsonString);
      await prefs.setString('doctor_specialties_date', DateTime.now().toIso8601String());
    } catch (e) {
      // Ignore
    }
  }

  /// Get cached doctor specialties if valid (less than 2 days old)
  static Future<String?> getCachedDoctorSpecialties() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateStr = prefs.getString('doctor_specialties_date');
      final dataStr = prefs.getString('doctor_specialties_cache');
      
      if (dateStr != null && dataStr != null) {
        final date = DateTime.parse(dateStr);
        final now = DateTime.now();
        // Check if cache is older than 2 days
        if (now.difference(date).inDays < 2) {
          return dataStr;
        }
      }
    } catch (e) {
      // Ignore
    }
    return null;
  }

  /// Save remember me credentials
  static Future<void> saveRememberMeCredentials(
      bool rememberMe, String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_rememberMeKey, rememberMe);

      if (rememberMe) {
        await _secureStorage.write(key: _rememberedEmailKey, value: email);
        await _secureStorage.write(key: _rememberedPasswordKey, value: password);
      } else {
        await _secureStorage.delete(key: _rememberedEmailKey);
        await _secureStorage.delete(key: _rememberedPasswordKey);
      }
    } catch (e) {
      // Ignore or log error
    }
  }

  /// Get remember me status
  static Future<bool> getRememberMeStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_rememberMeKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Get remembered credentials
  static Future<Map<String, String?>> getRememberedCredentials() async {
    try {
      final email = await _secureStorage.read(key: _rememberedEmailKey);
      final password = await _secureStorage.read(key: _rememberedPasswordKey);
      return {
        'email': email,
        'password': password,
      };
    } catch (e) {
      return {'email': null, 'password': null};
    }
  }

  /// Clear remembered credentials
  static Future<void> clearRememberedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_rememberMeKey);
      await _secureStorage.delete(key: _rememberedEmailKey);
      await _secureStorage.delete(key: _rememberedPasswordKey);
    } catch (e) {
      // Ignore
    }
  }
}
