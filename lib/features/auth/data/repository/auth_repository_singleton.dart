// features/auth/data/repository/auth_repository_singleton.dart
import 'auth_repository.dart';
import '../api/auth_api.dart';
import 'package:blog_bloc/core/network/app_http_client.dart';
import 'package:blog_bloc/core/network/token_storage.dart';

class AuthRepositorySingleton {
  static final AuthRepositorySingleton _instance =
      AuthRepositorySingleton._internal();

  late final AuthRepository repository;

  factory AuthRepositorySingleton() => _instance;

  AuthRepositorySingleton._internal() {
    final authHttpClient = AppHttpClient();
    final authApi = AuthApi(authHttpClient);
    final tokenStorage = TokenStorage();
    repository = AuthRepository(authApi, tokenStorage);
  }
}
