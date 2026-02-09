// features/blogs/presentation/bloc/blog_state.dart
import 'package:equatable/equatable.dart';
import '../../data/dto/blog_dto.dart';

abstract class BlogState extends Equatable {
  const BlogState();

  @override
  List<Object?> get props => [];
}

class BlogInitial extends BlogState {}

class BlogLoading extends BlogState {
  final List<BlogDto> oldBlogs;
  final bool isFirstFetch;

  const BlogLoading(this.oldBlogs, {this.isFirstFetch = false});

  @override
  List<Object?> get props => [oldBlogs, isFirstFetch];
}

class BlogLoaded extends BlogState {
  final List<BlogDto> blogs;
  final int page;
  final int totalPages;

  const BlogLoaded({
    required this.blogs,
    required this.page,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;

  @override
  List<Object?> get props => [blogs, page, totalPages];
}

class BlogError extends BlogState {
  final String message;

  const BlogError(this.message);

  @override
  List<Object?> get props => [message];
}

// Creating Blog
class BLogCreating extends BlogState {}

class BlogSuccessFullyCreated extends BlogState {
  final String message = "Blog Created Successfully!";
}
