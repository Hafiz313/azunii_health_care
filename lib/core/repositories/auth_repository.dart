import '../../networking/api_client.dart';
import '../../networking/api_ref.dart';
import '../exceptions/app_exceptions.dart';

class AuthRepository {
  // Register User
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await ApiClient.post(Apis.register, body: userData);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Login User
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await ApiClient.post('${Apis}Apis.login', body: {
        'email': email,
        'password': password,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Forgot Password
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await ApiClient.post(Apis.forgotPassword, body: {
        'email': email,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Google Login
  // Future<Map<String, dynamic>> googleLogin(String token) async {
  //   try {
  //     final response = await ApiClient.post(Apis.googleLogin, body: {
  //       'token': token,
  //     });
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  Future<Map<String, dynamic>> googleAuth({
    required String googleId,
    required String email,
    required String name,
    required String deviceToken,
  }) async {
    try {
      final response = await ApiClient.post(Apis.googleLogin, body: {
        'google_id': googleId,
        'email': email,
        'name': name,
        'device_token': deviceToken,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Apple Login
  Future<Map<String, dynamic>> appleLogin(String token) async {
    try {
      final response = await ApiClient.post(Apis.appleLogin, body: {
        'token': token,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await ApiClient.get(Apis.logout);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete Account
  Future<Map<String, dynamic>> deleteAccount() async {
    try {
      final response = await ApiClient.delete(Apis.deleteAccount);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get Profile Info
  Future<Map<String, dynamic>> getProfileInfo() async {
    try {
      final response = await ApiClient.get(Apis.profileInfo);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
