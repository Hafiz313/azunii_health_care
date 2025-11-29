import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/exceptions/app_exceptions.dart';
import '../core/services/local_storage_service.dart';
import '../utils/snackbar_helper.dart';
import 'api_ref.dart';

class ApiClient {
  static const Duration _timeout = Duration(seconds: 30);

  // Helper method to get authorization headers
  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = await LocalStorageService.getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  // GET Request
  static Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('${Apis.baseUrl}$endpoint');
      final response = await http.get(url, headers: headers).timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on HttpException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      throw ServerException('Something went wrong: ${e.toString()}');
    }
  }

  // GET Request with Auth
  static Future<Map<String, dynamic>> getWithAuth(String endpoint) async {
    try {
      final url = Uri.parse('${Apis.baseUrl}$endpoint');
      final headers = await _getAuthHeaders();
      headers['Content-Type'] = 'multipart/form-data';
      final response = await http.get(url, headers: headers).timeout(_timeout);
      return _handleResponse(response, '👤 PROFILE INFO');
    } on SocketException {
      throw NetworkException('No internet connection');
    } on HttpException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      throw ServerException('Something went wrong: ${e.toString()}');
    }
  }

  // POST Request
  static Future<Map<String, dynamic>> post(String endpoint,
      {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('${Apis.baseUrl}$endpoint');
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json', ...?headers},
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);

      String apiName = '🔐 LOGIN/SIGNUP';
      if (endpoint.contains('login')) apiName = '🔑 LOGIN';
      if (endpoint.contains('register')) apiName = '📝 SIGNUP';
      if (endpoint.contains('google')) apiName = '🔍 GOOGLE SIGNIN';

      return _handleResponse(response, apiName);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on HttpException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      throw ServerException('Something went wrong: ${e.toString()}');
    }
  }

  // POST Request with Auth
  static Future<Map<String, dynamic>> postWithAuth(String endpoint,
      {Map<String, dynamic>? body}) async {
    try {
      final url = Uri.parse('${Apis.baseUrl}$endpoint');
      final response = await http
          .post(
            url,
            headers: await _getAuthHeaders(),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on HttpException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      throw ServerException('Something went wrong: ${e.toString()}');
    }
  }

  // Multipart POST Request with Auth (for file uploads)
  static Future<Map<String, dynamic>> postMultipartWithAuth(String endpoint,
      {required Map<String, String> fields,
      File? file,
      String? fileFieldName = 'attachment'}) async {
    try {
      final url = Uri.parse('${Apis.baseUrl}$endpoint');
      final request = http.MultipartRequest('POST', url);

      // Add authorization header
      final token = await LocalStorageService.getToken();
      request.headers['Authorization'] = 'Bearer $token';

      // Add text fields
      fields.forEach((key, value) {
        request.fields[key] = value;
      });

      // Add file if provided
      if (file != null && fileFieldName != null) {
        final fileStream = http.ByteStream(file.openRead());
        final fileLength = await file.length();
        final multipartFile = http.MultipartFile(
          fileFieldName,
          fileStream,
          fileLength,
          filename: file.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response, '📎 STORE VISIT');
    } on SocketException {
      throw NetworkException('No internet connection');
    } on HttpException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      throw ServerException('Something went wrong: ${e.toString()}');
    }
  }

  // PUT Request
  static Future<Map<String, dynamic>> put(String endpoint,
      {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('${Apis.baseUrl}$endpoint');
      final response = await http
          .put(
            url,
            headers: {'Content-Type': 'application/json', ...?headers},
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on HttpException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      throw ServerException('Something went wrong: ${e.toString()}');
    }
  }

  // DELETE Request
  static Future<Map<String, dynamic>> delete(String endpoint,
      {Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('${Apis.baseUrl}$endpoint');
      final response =
          await http.delete(url, headers: headers).timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on HttpException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      throw ServerException('Something went wrong: ${e.toString()}');
    }
  }

  // DELETE Request with Auth
  static Future<Map<String, dynamic>> deleteWithAuth(String endpoint) async {
    try {
      final url = Uri.parse('${Apis.baseUrl}$endpoint');
      final response = await http
          .delete(url, headers: await _getAuthHeaders())
          .timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on HttpException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      throw ServerException('Something went wrong: ${e.toString()}');
    }
  }

  // Logout API
  static Future<Map<String, dynamic>> logout() async {
    try {
      final url = Uri.parse('${Apis.baseUrl}${Apis.logout}');
      final response = await http
          .get(url, headers: await _getAuthHeaders())
          .timeout(_timeout);
      return _handleResponse(response, '🚪 LOGOUT');
    } on SocketException {
      throw NetworkException('No internet connection');
    } on HttpException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      throw ServerException('Something went wrong: ${e.toString()}');
    }
  }

  // Delete Account API
  static Future<Map<String, dynamic>> deleteAccount() async {
    return await deleteWithAuth(Apis.deleteAccount);
  }

  // Forgot Password API
  static Future<Map<String, dynamic>> forgotPassword(
      Map<String, dynamic> body) async {
    return await postWithAuth(Apis.forgotPassword, body: body);
  }

  // Handle Response
  static Map<String, dynamic> _handleResponse(http.Response response,
      [String? apiName]) {
    // Debug print with emoji and status code
    print('\n🔥 API Response Debug 🔥');
    print('📡 API: ${apiName ?? 'Unknown'}');
    print('📊 Status Code: ${response.statusCode}');
    print('📝 Response Body: ${response.body}');
    print('🔚 End Response\n');

    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 400:
        throw ValidationException(
            jsonDecode(response.body)['message'] ?? 'Invalid request');
      case 401:
        throw UnauthorizedException();
      case 404:
        throw NotFoundException('Resource not found');
      case 405:
        throw ServerException('Method not allowed - Check API endpoint method');
      case 500:
        throw ServerException('Internal server error');
      default:
        throw ServerException(
            'Error occurred with status: ${response.statusCode}');
    }
  }

  // Exception Handler
  static void handleException(Exception e) {
    if (e is NetworkException) {
      SnackbarHelper.showError(e.message);
    } else if (e is ValidationException) {
      SnackbarHelper.showWarning(e.message);
    } else if (e is UnauthorizedException) {
      SnackbarHelper.showError(e.message);
      // Add logout logic here
    } else if (e is NotFoundException) {
      SnackbarHelper.showError(e.message);
    } else if (e is ServerException) {
      SnackbarHelper.showError(e.message);
    } else {
      SnackbarHelper.showError('An unexpected error occurred');
    }
  }
}
