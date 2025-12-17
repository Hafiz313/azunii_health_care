import 'dart:convert';
import 'dart:io';
import 'package:Azunii_Health/utils/ApiExceptions.dart';
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
      throw ApiException(message: 'No internet connection');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Something went wrong');
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
      throw ApiException(message: 'No internet connection');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Something went wrong');
    }
  }

  // POST Request
  static Future<Map<String, dynamic>> post(String endpoint,
      {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('${Apis.baseUrl}$endpoint');
      print('\n🚀 API REQUEST 🚀');
      print('URL: $url');
      print('Body: ${jsonEncode(body)}');
      print('🔚 End Request\n');

      final response = await http
          .post(
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

  // POST Request with Auth
  static Future<Map<String, dynamic>> postWithAuth(String endpoint,
      {Map<String, dynamic>? body}) async {
    try {
      final url = Uri.parse('${Apis.baseUrl}$endpoint');
      final headers = await _getAuthHeaders();
      print('\n🚀 API REQUEST (AUTH) 🚀');
      print('URL: $url');
      print('Body: ${jsonEncode(body)}');
      print('🔚 End Request\n');

      final response = await http
          .post(
            url,
            headers: headers,
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
      throw ApiException(message: 'No internet connection');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Something went wrong');
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
      throw ApiException(message: 'No internet connection');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Something went wrong');
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
      throw ApiException(message: 'No internet connection');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Something went wrong');
    }
  }

  // DELETE Request with Auth
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

  // Logout API
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

  // Delete Account API
  static Future<Map<String, dynamic>> deleteAccount() async {
    return await deleteWithAuth(Apis.deleteAccount);
  }

  // Forgot Password API
  static Future<Map<String, dynamic>> forgotPassword(
      Map<String, dynamic> body) async {
    return await post(Apis.forgotPassword, body: body);
  }

  // Multipart Register User
  static Future<Map<String, dynamic>> registerUserMultipart(String endpoint,
      {required Map<String, String> body, File? file}) async {
    try {
      final url = Uri.parse('${Apis.baseUrl}$endpoint');
      print('\n🚀 MULTIPART REQUEST 🚀');
      print('URL: $url');
      print('Fields: $body');
      print('File: ${file?.path}');
      print('🔚 End Request\n');

      var request = http.MultipartRequest('POST', url);
      request.headers['Accept'] = 'application/json';
      request.fields.addAll(body);

      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
      }

      var streamedResponse = await request.send().timeout(_timeout);
      var responseString = await streamedResponse.stream.bytesToString();
      final responseJson = jsonDecode(responseString);

      print('\n🔥 API RESPONSE 🔥');
      print('Status Code: ${streamedResponse.statusCode}');
      print('Response Body: $responseString');
      print('🔚 End Response\n');

      if (streamedResponse.statusCode >= 200 &&
          streamedResponse.statusCode < 300) {
        return responseJson;
      } else {
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

  // Handle Response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    print('\n🔥 API RESPONSE 🔥');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('Headers: ${response.headers}');
    print('🔚 End Response\n');

    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);

      case 400:
      case 422:
        final responseBody = jsonDecode(response.body);
        String errorMessage = 'Invalid request';

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

        throw ApiException(message: errorMessage);

      case 401:
        throw ApiException(message: 'Unauthorized');

      case 404:
        throw ApiException(message: 'Resource not found');

      case 405:
        throw ApiException(message: 'Method not allowed');

      case 500:
        throw ApiException(message: 'Internal server error');

      default:
        throw ApiException(
            message:
                'Unexpected error occurred (status: ${response.statusCode})');
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
    } else if (e is NotFoundException) {
      SnackbarHelper.showError(e.message);
    } else if (e is ServerException) {
      SnackbarHelper.showError(e.message);
    } else {
      SnackbarHelper.showError('An unexpected error occurred');
    }
  }
}
