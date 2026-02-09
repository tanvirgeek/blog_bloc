import 'dart:convert';
import 'dart:io';
import 'package:blog_bloc/core/constants.dart';
import 'package:http/http.dart' as http;
import '../../features/auth/data/dto/api_exception.dart';

class AuthHttpClient {
  final http.Client _client = http.Client();
  final String baseUrl = AppConstants.baseUrl;

  AuthHttpClient();

  /// POST (JSON)
  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final res = await _client.post(
      Uri.parse('$baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    return _handleResponse(res);
  }

  /// GET with query params + access token
  Future<Map<String, dynamic>> get(
    String path, {
    required String accessToken,
    Map<String, dynamic>? queryParams,
  }) async {
    final uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: queryParams?.map((k, v) => MapEntry(k, v.toString())),
    );

    final res = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    return _handleResponse(res);
  }

  /// 🔒 Multipart POST (for file upload)
  Future<Map<String, dynamic>> multipartPost(
    String path, {
    required String accessToken,
    Map<String, String>? fields,
    Map<String, File>? files,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $accessToken';
    request.fields.addAll(fields ?? {});

    if (files != null) {
      for (var entry in files.entries) {
        request.files.add(
          await http.MultipartFile.fromPath(entry.key, entry.value.path),
        );
      }
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response);
  }

  /// Centralized response handling
  Map<String, dynamic> _handleResponse(http.Response res) {
    Map<String, dynamic> data;
    try {
      data = jsonDecode(res.body);
    } catch (_) {
      data = {};
    }

    if (res.statusCode >= 400) {
      final message = data['error'] ?? 'Something went wrong';
      throw ApiException(message, res.statusCode);
    }

    return data;
  }
}
