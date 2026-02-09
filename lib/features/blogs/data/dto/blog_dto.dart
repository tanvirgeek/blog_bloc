// features/blog/data/dto/blog_dto.dart
import 'dart:io';

class BlogDto {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String author;
  final DateTime createdAt;
  final DateTime updatedAt;

  BlogDto({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.author,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BlogDto.fromJson(Map<String, dynamic> json) {
    return BlogDto(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      author: json['author'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class PaginatedBlogsDto {
  final int total;
  final int page;
  final int pages;
  final List<BlogDto> blogs;

  PaginatedBlogsDto({
    required this.total,
    required this.page,
    required this.pages,
    required this.blogs,
  });

  factory PaginatedBlogsDto.fromJson(Map<String, dynamic> json) {
    return PaginatedBlogsDto(
      total: json['total'],
      page: json['page'],
      pages: json['pages'],
      blogs: (json['blogs'] as List).map((e) => BlogDto.fromJson(e)).toList(),
    );
  }
}


class CreateBlogDto {
  final String title;
  final String content;
  final File? image;

  CreateBlogDto({
    required this.title,
    required this.content,
    this.image,
  });

  // For API call, we'll handle multipart in the repository, so we don't convert image to JSON here
  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
      };
}
