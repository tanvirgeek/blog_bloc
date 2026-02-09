import 'package:blog_bloc/features/blogs/presentation/ui/blog_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/blog_bloc.dart';
import '../bloc/blog_event.dart';
import '../bloc/blog_state.dart';
import '../ui/widgets/create_blog_modal.dart';

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

      if (state is BlogLoadedAfterNormalPressed &&
          state.hasMore &&
          !_isFetching) {
        _page = 0;
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

  void _openCreateBlogModal() {
    final blogBloc = context.read<BlogBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => CreateBlogModal(blogBloc: blogBloc),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case "Hello":
                  context.read<BlogBloc>().add(BlogHelloPressed());
                case "T":
                  context.read<BlogBloc>().add(BlogTPressed());
                case "Normal":
                  context.read<BlogBloc>().add(BlogNormalPressed());
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: "Hello", child: Text("Hello")),
              PopupMenuItem(value: "T", child: Text("T")),
              PopupMenuItem(value: "Normal", child: Text("Normal")),
            ],
          ),

          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _openCreateBlogModal,
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogLoaded) _isFetching = false;

          if (state is BlogError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state is BlogSuccessFullyCreated) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            // Refresh blogs
            _page = 1;
            context.read<BlogBloc>().add(
              FetchBlogs(page: _page, limit: _limit),
            );
          }
        },
        builder: (context, state) {
          List blogs = [];
          bool isLoadingMore = false;

          if (state is BlogLoading) {
            blogs = state.oldBlogs;
            isLoadingMore = true;
          } else if (state is BlogLoaded) {
            blogs = state.blogs;
          }

          if (state is BlogLoadedAfterNormalPressed) {
            blogs = state.blogs;
          }

          // Full screen loader on first fetch
          if (state is BlogLoading && state.isFirstFetch) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: blogs.length + (isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < blogs.length) {
                final blog = blogs[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlogDetailsScreen(blogDetails: blog),
                      ),
                    );
                  },
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
