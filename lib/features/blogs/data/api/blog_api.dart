import 'package:blog_bloc/core/network/auth_http_client.dart';
import 'package:blog_bloc/features/blogs/data/dto/blog_dto.dart';

class BlogApi {
  final AuthHttpClient client;

  BlogApi(this.client);

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
}
