// features/blogs/data/api/blog_api.dart
import 'package:blog_bloc/core/network/app_http_client.dart';
import 'package:blog_bloc/features/auth/data/dto/api_exception.dart';
import '../dto/blog_dto.dart';

class BlogApi {
  final AppHttpClient client;

  BlogApi(this.client);

  /// Get paginated blogs
  Future<PaginatedBlogsDto> getBlogs({
    required int page,
    required int limit,
    required String accessToken,
  }) async {
    final res = await client.get(
      '/blogs',
      accessToken: accessToken,
      queryParams: {'page': page, 'limit': limit},
    );

    return PaginatedBlogsDto.fromJson(res);
  }

  /// Create blog with optional image
  Future<void> createBlog({
    required CreateBlogDto dto,
    required String accessToken,
  }) async {
    try {
      await client.multipartPost(
        '/blogs',
        accessToken: accessToken,
        fields: {'title': dto.title, 'content': dto.content},
        files: dto.image != null ? {'image': dto.image!} : null,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString(), 500);
    }
  }
}
