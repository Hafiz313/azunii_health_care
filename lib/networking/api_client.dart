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
      throw ServerException('Something went wrong');
    }
  }

  // GET Request with Auth
  static Future<Map<String, dynamic>> getWithAuth(String endpoint) async {
    try {
      final url = Uri.parse('${Apis.baseUrl}$endpoint');
      final headers = await _getAuthHeaders();
      final response = await http.get(url, headers: headers).timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on HttpException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      throw ServerException('Something went wrong');
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

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on HttpException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      throw ServerException('Something went wrong');
    }
  }

  // POST Request with Auth
  static Future<Map<String, dynamic>> postWithAuth(String endpoint,
      {Map<String, dynamic>? body}) async {
    try {
      final url = Uri.parse('${Apis.baseUrl}$endpoint');
      final headers = await _getAuthHeaders();
      final response = await http
          .post(
            url,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on HttpException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      throw ServerException('Something went wrong');
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
      final headers = await _getAuthHeaders();

      request.headers.addAll(headers);

      fields.forEach((key, value) {
        request.fields[key] = value;
      });

      if (file != null && fileFieldName != null) {
        request.files.add(await http.MultipartFile.fromPath(
          fileFieldName,
          file.path,
        ));
      }

      final response = await http.Response.fromStream(
        await request.send().timeout(_timeout),
      );

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on HttpException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      throw ServerException('Something went wrong');
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
      throw ServerException('Something went wrong');
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
      throw ServerException('Something went wrong');
    }
  }

  // DELETE Request with Auth
  static Future<Map<String, dynamic>> deleteWithAuth(String endpoint) async {
    try {
      final url = Uri.parse('${Apis.baseUrl}$endpoint');
      final headers = await _getAuthHeaders();
      final response = await http.delete(url, headers: headers).timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on HttpException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      throw ServerException('Something went wrong');
    }
  }

  // Logout API
  static Future<Map<String, dynamic>> logout() async {
    try {
      final url = Uri.parse('${Apis.baseUrl}${Apis.logout}');
      final headers = await _getAuthHeaders();
      final response = await http.get(url, headers: headers).timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on HttpException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      throw ServerException('Something went wrong');
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
  static Map<String, dynamic> _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 400:
        final responseBody = jsonDecode(response.body);
        String errorMessage = 'Invalid request';

        // Handle nested error structure
        if (responseBody['message'] != null) {
          errorMessage = responseBody['message'];
        } else if (responseBody['errors'] != null) {
          final errors = responseBody['errors'];
          if (errors is Map && errors.isNotEmpty) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              errorMessage = firstError.first.toString();
            }
          }
        }

        throw ValidationException(errorMessage);
      case 401:
        throw UnauthorizedException();
      case 404:
        throw NotFoundException('Resource not found');
      case 405:
        throw ServerException('Method not allowed');
      case 500:
        throw ServerException('Internal server error');
      default:
        throw ServerException('An error occurred');
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
