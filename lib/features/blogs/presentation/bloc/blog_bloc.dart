// features/blogs/presentation/bloc/blog_bloc.dart
import 'package:blog_bloc/features/blogs/data/dto/blog_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blog_event.dart';
import 'blog_state.dart';
import '../../data/repository/blog_repository.dart';
import '../../../auth/data/dto/api_exception.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final BlogRepository repository;

  BlogBloc(this.repository) : super(BlogInitial()) {
    on<FetchBlogs>(_onFetchBlogs);
  }

  Future<void> _onFetchBlogs(
    FetchBlogs event,
    Emitter<BlogState> emit,
  ) async {
    final currentState = state;
    List<BlogDto> oldBlogs = [];

    if (currentState is BlogLoaded) {
      oldBlogs = currentState.blogs;
    }

    emit(
      BlogLoading(
        oldBlogs,
        isFirstFetch: event.page == 1,
      ),
    );

    try {
      final result = await repository.getBlogs(
        page: event.page,
        limit: event.limit,
      );

      final blogs = [...oldBlogs, ...result.blogs];

      emit(
        BlogLoaded(
          blogs: blogs,
          page: result.page,
          totalPages: result.pages,
        ),
      );
    } on ApiException catch (e) {
      emit(BlogError(e.message));
    } catch (_) {
      emit(const BlogError('Something went wrong'));
    }
  }
}
