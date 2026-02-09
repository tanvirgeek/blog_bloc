// features/auth/data/api/auth_api.dart
import 'package:blog_bloc/features/auth/data/dto/login_error_dto.dart';
import '../dto/login_request_dto.dart';
import '../dto/register_request_dto.dart';
import '../dto/token_response_dto.dart';
import '../dto/api_exception.dart';
import 'package:blog_bloc/core/network/auth_http_client.dart';

class AuthApi {
  final AuthHttpClient client;

  AuthApi(this.client);

  Future<void> register(RegisterRequestDto dto) async {
    try {
      final res = await client.post('/auth/register', dto.toJson());

      // Backend returned an error
      if (res['statusCode'] != null && res['statusCode'] != 200) {
        final error = ErrorDto.fromJson(res);
        throw ApiException(error.error, error.statusCode);
      }
    } catch (e) {
      // Network error or JSON parse error
      if (e is ApiException) rethrow;
      throw ApiException(e.toString(), 500);
    }
  }

  Future<TokenResponseDto> login(LoginRequestDto dto) async {
    try {
      final res = await client.post('/auth/login', dto.toJson());

      // Backend error
      if (res['statusCode'] != null && res['statusCode'] != 200) {
        final error = ErrorDto.fromJson(res);
        throw ApiException(error.error, error.statusCode);
      }

      return TokenResponseDto.fromJson(res);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString(), 500);
    }
  }

  Future<String> refresh(String refreshToken) async {
    try {
      final res = await client.post('/auth/refresh', {
        'refreshToken': refreshToken,
      });

      if (res['statusCode'] != null && res['statusCode'] != 200) {
        final error = ErrorDto.fromJson(res);
        throw ApiException(error.error, error.statusCode);
      }

      return res['accessToken'];
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString(), 500);
    }
  }
}
