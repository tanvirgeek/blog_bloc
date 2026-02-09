// features/blogs/presentation/bloc/blog_event.dart
import 'package:blog_bloc/features/blogs/data/dto/blog_dto.dart';
import 'package:equatable/equatable.dart';

abstract class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object?> get props => [];
}

class FetchBlogs extends BlogEvent {
  final int page;
  final int limit;

  const FetchBlogs({required this.page, required this.limit});

  @override
  List<Object?> get props => [page, limit];
}

class CreateBlog extends BlogEvent {
  final CreateBlogDto dto;

  const CreateBlog({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BlogTPressed extends BlogEvent {}

class BlogHelloPressed extends BlogEvent {}

class BlogNormalPressed extends BlogEvent {}
