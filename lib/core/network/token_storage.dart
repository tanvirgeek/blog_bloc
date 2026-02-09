// core/network/token_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: 'refresh_token', value: token);

  Future<String?> getRefreshToken() =>
      _storage.read(key: 'refresh_token');

  Future<void> clear() => _storage.deleteAll();
}
