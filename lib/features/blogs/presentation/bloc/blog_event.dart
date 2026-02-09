// features/blogs/presentation/bloc/blog_event.dart
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
