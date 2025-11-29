import 'package:Azunii_Health/core/models/Auth_model.dart';

import '../../networking/api_client.dart';
import '../../networking/api_ref.dart';
import '../exceptions/app_exceptions.dart';

class AuthRepository {
  // Register User
  Future<AuthResponse> register(Map<String, dynamic> userData) async {
    try {
      print('\n📝 SIGNUP Request 📝');
      print('📧 Email: ${userData['email']}');
      print('👤 Name: ${userData['name']}');
      print('🔐 Password: [HIDDEN]\n');

      final response = await ApiClient.post(Apis.register, body: userData);
      return AuthResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Login User
  Future<AuthResponse> login(String email, String password) async {
    try {
      print('\n🔑 LOGIN Request 🔑');
      print('📧 Email: $email');
      print('🔐 Password: [HIDDEN]\n');

      final response = await ApiClient.post(Apis.login, body: {
        'email': email,
        'password': password,
      });
      return AuthResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Forgot Password
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await ApiClient.forgotPassword({
        'email': email,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Google Login
  Future<AuthResponse> googleAuth({
    required String googleId,
    required String email,
    required String name,
    required String deviceToken,
  }) async {
    try {
      print('\n🚀 Google Auth Request 🚀');
      print('📧 Email: $email');
      print('👤 Name: $name');
      print('🆔 Google ID: $googleId');
      print('📱 Device Token: $deviceToken\n');

      final response = await ApiClient.post(Apis.googleLogin, body: {
        'google_id': googleId,
        'email': email,
        'name': name,
        'device_token': deviceToken,
      });
      return AuthResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Apple Login
  Future<AuthResponse> appleLogin(String token) async {
    try {
      final response = await ApiClient.post(Apis.appleLogin, body: {
        'token': token,
      });
      return AuthResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await ApiClient.logout();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete Account
  Future<Map<String, dynamic>> deleteAccount() async {
    try {
      final response = await ApiClient.deleteAccount();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get Profile Info
  Future<ProfileResponse> getProfileInfo() async {
    try {
      print('\n👤 PROFILE INFO Request 👤');
      final response = await ApiClient.getWithAuth(Apis.profileInfo);
      print('📄 Profile Response: $response\n');
      return ProfileResponse.fromJson(response);
    } catch (e) {
      print('❌ Profile Info Error: $e');
      rethrow;
    }
  }
}
