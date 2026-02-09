// core/network/auth_http_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/auth/data/dto/api_exception.dart';

class AuthHttpClient {
  final http.Client _client = http.Client();
  final String baseUrl;

  AuthHttpClient(this.baseUrl);

  /// POST (already done)
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

  /// ✅ GET with access token + query params
  Future<Map<String, dynamic>> get(
    String path, {
    required String accessToken,
    Map<String, dynamic>? queryParams,
  }) async {
    final uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: queryParams?.map(
        (k, v) => MapEntry(k, v.toString()),
      ),
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

  /// 🔒 Centralized response handling
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
