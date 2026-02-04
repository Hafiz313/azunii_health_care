import 'package:Azunii_Health/core/models/Auth_model.dart';

import '../../networking/api_client.dart';
import '../../networking/api_ref.dart';
import '../exceptions/app_exceptions.dart';

class AuthRepository {
  // Register User
  Future<AuthResponse> register(Map<String, dynamic> userData) async {
    try {
      final fields =
          userData.map((key, value) => MapEntry(key, value.toString()));
      final response = await ApiClient.registerUserMultipart(
        Apis.register,
        body: fields,
      );
      return AuthResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Login User
  Future<AuthResponse> login(
      String email, String password, String fcmToken) async {
    try {
      final response = await ApiClient.post(Apis.login, body: {
        'email': email,
        'password': password,
        'fcm_token': fcmToken,
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
    required String fcmToken,
  }) async {
    try {
      final response = await ApiClient.post(Apis.googleLogin, body: {
        'google_id': googleId,
        'email': email,
        'name': name,
        'fcm_token': fcmToken,
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
      final response = await ApiClient.getWithAuth(Apis.deleteAccount);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get Profile Info
  Future<ProfileResponse> getProfileInfo() async {
    try {
      final response = await ApiClient.getWithAuth(Apis.profileInfo);
      return ProfileResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
