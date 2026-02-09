// features/blogs/data/repository/blog_repository.dart
import 'package:blog_bloc/features/blogs/data/api/blog_api.dart';
import 'package:blog_bloc/features/auth/data/repository/auth_repository.dart';
import 'package:blog_bloc/features/auth/data/dto/api_exception.dart';
import 'package:blog_bloc/features/blogs/data/dto/blog_dto.dart';

class BlogRepository {
  final BlogApi api;
  final AuthRepository authRepository;

  BlogRepository(this.api, this.authRepository);

  Future<PaginatedBlogsDto> getBlogs({
    required int page,
    required int limit,
    bool retried = false,
  }) async {
    try {
      final token = authRepository.accessToken;
      if (token == null) throw ApiException('Not authenticated', 401);

      return await api.getBlogs(page: page, limit: limit, accessToken: token);
    } on ApiException catch (e) {
      if (e.statusCode == 401 && !retried) {
        await authRepository.refreshToken();

        return getBlogs(page: page, limit: limit, retried: true);
      }
      rethrow;
    }
  }
}
