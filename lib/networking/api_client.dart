import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/exceptions/app_exceptions.dart';
import '../core/services/local_storage_service.dart';
import '../utils/ApiExceptions.dart';
import '../utils/snackbar_helper.dart';
import 'api_ref.dart';

/// ApiClient - Centralized HTTP client for all API requests
/// Handles authentication, error handling, and response parsing
class ApiClient {
  // ============================================================================
  // CONFIGURATION
  // ============================================================================

  static const Duration _timeout = Duration(seconds: 30);

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get authorization headers with Bearer token
  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = await LocalStorageService.getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  /// Handle API response and extract data or throw exceptions
  /// Checks for status field in response body and HTTP status codes
  static Map<String, dynamic> _handleResponse(http.Response response) {
    debugPrint('\n🔥 API RESPONSE 🔥');
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');
    debugPrint('🔚 End Response\n');

    switch (response.statusCode) {
      // Success responses
      case 200:
      case 201:
        final responseBody = jsonDecode(response.body);

        // Check if API returned status: false in response body
        if (responseBody['status'] != null && responseBody['status'] == false) {
          final message = responseBody['message'] ?? 'Something went wrong';
          throw ApiException(message: message);
        }

        return responseBody;

      // Redirect responses
      case 301:
      case 302:
        throw ApiException(
            message:
                'Server redirect detected. Please check API configuration.');

      // Error responses - Extract message from response body
      case 400:
      case 401:
      case 403:
      case 404:
      case 405:
      case 409:
      case 422:
      case 500:
        final responseBody = jsonDecode(response.body);
        String errorMessage = '';

        // Extract exact message from backend response
        if (responseBody['message'] != null) {
          errorMessage = responseBody['message'];
        } else if (responseBody['errors'] != null) {
          // Handle validation errors
          final errors = responseBody['errors'];
          if (errors is Map && errors.isNotEmpty) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              errorMessage = firstError.first.toString();
            }
          }
        }

        throw ApiException(message: errorMessage);

      // Unknown status codes - try to extract message from response
      default:
        try {
          final responseBody = jsonDecode(response.body);
          final message = responseBody['message'] ?? '';
          throw ApiException(message: message);
        } catch (e) {
          if (e is ApiException) rethrow;
          throw ApiException(message: '');
        }
    }
  }

  // ============================================================================
  // GET REQUESTS
  // ============================================================================

  /// GET request without authentication
  static Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('${Apis.baseUrl}$endpoint');
      final response = await http.get(url, headers: headers).timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw ApiException(message: 'No internet connection');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Something went wrong');
    }
  }

  /// GET request with authentication
  static Future<Map<String, dynamic>> getWithAuth(String endpoint) async {
    try {
      final url = Uri.parse('${Apis.baseUrl}$endpoint');
      final headers = await _getAuthHeaders();
      final response = await http.get(url, headers: headers).timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw ApiException(message: 'No internet connection');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Something went wrong');
    }
  }

  // ============================================================================
  // POST REQUESTS
  // ============================================================================

  /// POST request without authentication
  /// Uses http.Client to properly handle redirects
  static Future<Map<String, dynamic>> post(String endpoint,
      {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('${Apis.baseUrl}$endpoint');
      debugPrint('\n🚀 API REQUEST 🚀');
      debugPrint('URL: $url');
      debugPrint('Body: ${jsonEncode(body)}');
      debugPrint('🔚 End Request\n');

      final client = http.Client();
      final request = http.Request('POST', url);
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...?headers
      });
      if (body != null) {
        request.body = jsonEncode(body);
      }

      final streamedResponse = await client.send(request).timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);
      client.close();

      return _handleResponse(response);
    } on SocketException {
      throw ApiException(message: 'No internet connection');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Something went wrong');
    }
  }

  /// POST request with authentication
  static Future<Map<String, dynamic>> postWithAuth(String endpoint,
      {Map<String, dynamic>? body}) async {
    try {
      final url = Uri.parse('${Apis.baseUrl}$endpoint');
      final headers = await _getAuthHeaders();
      debugPrint('\n🚀 API REQUEST (AUTH) 🚀');
      debugPrint('URL: $url');
      debugPrint('Body: ${jsonEncode(body)}');
      debugPrint('🔚 End Request\n');

      final response = await http
          .post(
            url,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);

      final responseJson = jsonDecode(response.body);

      debugPrint('\n🔥 API RESPONSE 🔥');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('🔚 End Response\n');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Check if response has status field and it's false
        if (responseJson['status'] != null && responseJson['status'] == false) {
          final message = responseJson['message'] ?? 'Something went wrong';
          throw ApiException(message: message);
        }
        return responseJson;
      } else {
        // Extract error message from response
        String message = responseJson['message'] ?? 'Something went wrong';
        if (responseJson['errors'] != null) {
          final errors = responseJson['errors'];
          if (errors is Map && errors.isNotEmpty) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              message = firstError.first.toString();
            }
          }
        }
        throw ApiException(message: message);
      }
    } on SocketException {
      throw ApiException(message: 'No internet connection');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Something went wrong');
    }
  }

  // ============================================================================
  // MULTIPART REQUESTS (File Uploads)
  // ============================================================================

  /// Multipart POST request with authentication (for file uploads)
  static Future<Map<String, dynamic>> postMultipartWithAuth(String endpoint,
      {required Map<String, String> fields,
      File? file,
      String? fileFieldName = 'attachment'}) async {
    try {
      final url = Uri.parse('${Apis.baseUrl}$endpoint');
      final request = http.MultipartRequest('POST', url);
      final headers = await _getAuthHeaders();

      request.headers.addAll(headers);
      request.fields.addAll(fields);

      if (file != null && fileFieldName != null) {
        request.files.add(await http.MultipartFile.fromPath(
          fileFieldName,
          file.path,
        ));
      }

      var streamedResponse = await request.send().timeout(_timeout);
      var responseString = await streamedResponse.stream.bytesToString();
      final responseJson = jsonDecode(responseString);

      debugPrint('\n🔥 API RESPONSE 🔥');
      debugPrint('Status Code: ${streamedResponse.statusCode}');
      debugPrint('Response Body: $responseString');
      debugPrint('🔚 End Response\n');

      if (streamedResponse.statusCode >= 200 &&
          streamedResponse.statusCode < 300) {
        // Check if response has status field and it's false
        if (responseJson['status'] != null && responseJson['status'] == false) {
          final message = responseJson['message'] ?? 'Something went wrong';
          throw ApiException(message: message);
        }

        return responseJson;
      } else {
        // Extract error message from response
        String message = responseJson['message'] ?? 'Something went wrong';
        if (responseJson['errors'] != null) {
          final errors = responseJson['errors'];
          if (errors is Map && errors.isNotEmpty) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              message = firstError.first.toString();
            }
          }
        }
        throw ApiException(message: message);
      }
    } on SocketException {
      throw ApiException(message: 'No internet connection');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Something went wrong');
    }
  }

  /// Multipart POST request for user registration (without auth)
  static Future<Map<String, dynamic>> registerUserMultipart(String endpoint,
      {required Map<String, String> body, File? file}) async {
    try {
      final url = Uri.parse('${Apis.baseUrl}$endpoint');
      debugPrint('\n🚀 MULTIPART REQUEST 🚀');
      debugPrint('URL: $url');
      debugPrint('Fields: $body');
      debugPrint('File: ${file?.path}');
      debugPrint('🔚 End Request\n');

      var request = http.MultipartRequest('POST', url);
      request.headers['Accept'] = 'application/json';
      request.fields.addAll(body);

      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
      }

      var streamedResponse = await request.send().timeout(_timeout);
      var responseString = await streamedResponse.stream.bytesToString();
      final responseJson = jsonDecode(responseString);

      debugPrint('\n🔥 API RESPONSE 🔥');
      debugPrint('Status Code: ${streamedResponse.statusCode}');
      debugPrint('Response Body: $responseString');
      debugPrint('🔚 End Response\n');

      if (streamedResponse.statusCode >= 200 &&
          streamedResponse.statusCode < 300) {
        // Check if response has status field and it's false
        if (responseJson['status'] != null && responseJson['status'] == false) {
          final message = responseJson['message'] ?? 'Something went wrong';
          throw ApiException(message: message);
        }

        return responseJson;
      } else {
        // Extract error message from response
        String message = responseJson['message'] ?? 'Something went wrong';
        if (responseJson['errors'] != null) {
          final errors = responseJson['errors'];
          if (errors is Map && errors.isNotEmpty) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              message = firstError.first.toString();
            }
          }
        }
        throw ApiException(message: message);
      }
    } on SocketException {
      throw ApiException(message: 'No internet connection');
    } catch (e) {
      throw ApiException(message: '$e');
    }
  }

  // ============================================================================
  // PUT REQUESTS
  // ============================================================================

  /// PUT request without authentication
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
      throw ApiException(message: 'No internet connection');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Something went wrong');
    }
  }

  // ============================================================================
  // DELETE REQUESTS
  // ============================================================================

  /// DELETE request without authentication
  static Future<Map<String, dynamic>> delete(String endpoint,
      {Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('${Apis.baseUrl}$endpoint');
      final response =
          await http.delete(url, headers: headers).timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw ApiException(message: 'No internet connection');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Something went wrong');
    }
  }

  /// DELETE request with authentication
  static Future<Map<String, dynamic>> deleteWithAuth(String endpoint) async {
    try {
      final url = Uri.parse('${Apis.baseUrl}$endpoint');
      final headers = await _getAuthHeaders();
      final response =
          await http.delete(url, headers: headers).timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw ApiException(message: 'No internet connection');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Something went wrong');
    }
  }

  // ============================================================================
  // SPECIFIC API ENDPOINTS
  // ============================================================================

  /// Logout user
  static Future<Map<String, dynamic>> logout() async {
    try {
      final url = Uri.parse('${Apis.baseUrl}${Apis.logout}');
      final headers = await _getAuthHeaders();
      final response = await http.get(url, headers: headers).timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw ApiException(message: 'No internet connection');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Something went wrong');
    }
  }

  /// Delete user account
  static Future<Map<String, dynamic>> deleteAccount() async {
    return await getWithAuth(Apis.deleteAccount);
  }

  /// Send forgot password request
  static Future<Map<String, dynamic>> forgotPassword(
      Map<String, dynamic> body) async {
    return await post(Apis.forgotPassword, body: body);
  }

  // ============================================================================
  // EXCEPTION HANDLER
  // ============================================================================

  /// Handle exceptions and show appropriate snackbar messages
  static void handleException(Exception e) {
    if (e is NetworkException) {
      SnackbarHelper.showError(e.message);
    } else if (e is ValidationException) {
      SnackbarHelper.showWarning(e.message);
    } else if (e is UnauthorizedException) {
      SnackbarHelper.showError(e.message);
    } else if (e is NotFoundException) {
      SnackbarHelper.showError(e.message);
    } else if (e is ServerException) {
      SnackbarHelper.showError(e.message);
    } else {
      SnackbarHelper.showError('An unexpected error occurred');
    }
  }
}
