// features/blogs/presentation/screens/blogs_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/blog_bloc.dart';
import '../bloc/blog_event.dart';
import '../bloc/blog_state.dart';

class BlogsScreen extends StatefulWidget {
  const BlogsScreen({super.key});

  @override
  State<BlogsScreen> createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen> {
  final ScrollController _scrollController = ScrollController();

  int _page = 1;
  final int _limit = 10;
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();

    context.read<BlogBloc>().add(FetchBlogs(page: _page, limit: _limit));

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<BlogBloc>().state;

      if (state is BlogLoaded && state.hasMore && !_isFetching) {
        _isFetching = true;
        _page++;

        context.read<BlogBloc>().add(FetchBlogs(page: _page, limit: _limit));
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blogs')),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogLoaded) {
            _isFetching = false;
          }
        },
        builder: (context, state) {
          if (state is BlogLoading && state.isFirstFetch) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BlogError) {
            return Center(child: Text(state.message));
          }

          List blogs = [];
          bool isLoadingMore = false;

          if (state is BlogLoading) {
            blogs = state.oldBlogs;
            isLoadingMore = true;
          } else if (state is BlogLoaded) {
            blogs = state.blogs;
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: blogs.length + (isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < blogs.length) {
                final blog = blogs[index];
                return ListTile(
                  title: Text(blog.title),
                  subtitle: Text(
                    blog.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          );
        },
      ),
    );
  }
}
