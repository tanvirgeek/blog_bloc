// features/auth/data/repository/auth_repository.dart
import '../api/auth_api.dart';
import '../dto/login_request_dto.dart';
import '../dto/register_request_dto.dart';
import 'package:blog_bloc/core/network/token_storage.dart';
import '../dto/api_exception.dart';

class AuthRepository {
  final AuthApi api;
  final TokenStorage storage;

  String? _accessToken;

  AuthRepository(this.api, this.storage);

  String? get accessToken => _accessToken;

  Future<void> register(String name, String email, String password) async {
    try {
      await api.register(RegisterRequestDto(name, email, password));
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Something went wrong', 500);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final tokens = await api.login(LoginRequestDto(email, password));
      _accessToken = tokens.accessToken;
      await storage.saveRefreshToken(tokens.refreshToken);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Something went wrong', 500);
    }
  }

  Future<void> refreshToken() async {
    final refresh = await storage.getRefreshToken();
    if (refresh == null) throw ApiException('No refresh token', 401);

    try {
      _accessToken = await api.refresh(refresh);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Something went wrong', 500);
    }
  }

  Future<void> logout() async {
    _accessToken = null;
    await storage.clear();
  }
}
