import '../../networking/api_client.dart';
import '../../networking/api_ref.dart';

class ProfileRepository {
  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? email,
    String? password,
    String? passwordConfirmation,
  }) async {
    try {
      final body = <String, dynamic>{};
      
      if (name != null) body['name'] = name;
      if (email != null) body['email'] = email;
      if (password != null) body['password'] = password;
      if (passwordConfirmation != null) body['password_confirmation'] = passwordConfirmation;
      
      final response = await ApiClient.postWithAuth(Apis.profileUpdate, body: body);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}