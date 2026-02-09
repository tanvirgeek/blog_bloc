import 'package:blog_bloc/features/blogs/data/dto/blog_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/blog_repository.dart';
import '../../../auth/data/dto/api_exception.dart';
import 'blog_event.dart';
import 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final BlogRepository repository;

  BlogBloc(this.repository) : super(BlogInitial()) {
    on<FetchBlogs>(_onFetchBlogs);
    on<CreateBlog>(_onCreateBlog);
    on<BlogTPressed>(_onAddT);
    on<BlogHelloPressed>(_onAddHello);
    on<BlogNormalPressed>(_onNormalPressed);
  }

  Future<void> _onFetchBlogs(FetchBlogs event, Emitter<BlogState> emit) async {
    final currentState = state;
    List<BlogDto> oldBlogs = [];

    if (currentState is BlogLoaded) {
      oldBlogs = currentState.blogs;
    }

    emit(BlogLoading(oldBlogs, isFirstFetch: event.page == 1));

    try {
      final result = await repository.getBlogs(
        page: event.page,
        limit: event.limit,
      );

      final blogs = [...oldBlogs, ...result.blogs];

      emit(
        BlogLoaded(blogs: blogs, page: result.page, totalPages: result.pages),
      );
    } on ApiException catch (e) {
      emit(BlogError(e.message));
    } catch (_) {
      emit(const BlogError('Something went wrong'));
    }
  }

  Future<void> _onCreateBlog(CreateBlog event, Emitter<BlogState> emit) async {
    emit(BLogCreating()); // New state for creating

    try {
      await repository.createBlog(event.dto);

      emit(BlogSuccessFullyCreated()); // Success state
    } on ApiException catch (e) {
      emit(BlogError(e.message));
    } catch (_) {
      emit(const BlogError('Something went wrong'));
    }
  }

  Future<void> _onAddT(BlogTPressed event, Emitter<BlogState> emit) async {
    final currentState = state;

    if (currentState is BlogLoaded) {
      final updatedBlogs = currentState.blogs
          .map((b) => b.copyWith(title: '${b.title} T'))
          .toList();

      emit(
        BlogLoaded(
          blogs: updatedBlogs,
          page: currentState.page,
          totalPages: currentState.totalPages,
        ),
      );
    }
  }

  Future<void> _onAddHello(
    BlogHelloPressed event,
    Emitter<BlogState> emit,
  ) async {
    final currentState = state;

    if (currentState is BlogLoaded) {
      final updatedBlogs = currentState.blogs
          .map((b) => b.copyWith(title: '${b.title} Hello'))
          .toList();

      emit(
        BlogLoaded(
          blogs: updatedBlogs,
          page: currentState.page,
          totalPages: currentState.totalPages,
        ),
      );
    }
  }

  Future<void> _onNormalPressed(
    BlogNormalPressed event,
    Emitter<BlogState> emit,
  ) async {
    emit(BlogLoading([], isFirstFetch: true));

    try {
      final result = await repository.getBlogs(page: 1, limit: 10);

      final blogs = result.blogs;

      emit(
        BlogLoadedAfterNormalPressed(
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
