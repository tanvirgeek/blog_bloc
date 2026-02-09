// features/blogs/presentation/screens/blogs_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/blog_bloc.dart';
import '../bloc/blog_event.dart';
import '../bloc/blog_state.dart';
import '../../data/dto/blog_dto.dart';

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

  void _openCreateBlogModal() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    File? pickedImage;

    final blogBloc = context.read<BlogBloc>(); // 👈 parent context

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: StatefulBuilder(
          builder: (modalContext, setState) {

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: contentCtrl,
                    decoration: const InputDecoration(labelText: 'Content'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final image = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (image != null) {
                            setState(() {
                              pickedImage = File(image.path);
                            });
                          }
                        },
                        icon: const Icon(Icons.image),
                        label: const Text('Pick Image'),
                      ),
                      const SizedBox(width: 8),
                      if (pickedImage != null)
                        Expanded(
                          child: Text(
                            pickedImage!.path.split('/').last,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                            final dto = CreateBlogDto(
                              title: titleCtrl.text,
                              content: contentCtrl.text,
                              image: pickedImage,
                            );

                            // Add event
                            blogBloc.add(CreateBlog(dto: dto));

                            // Close modal
                            Navigator.pop(context);
                          },
                    child: const Text('Create Blog'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs'),
        actions: [
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Blog created successfully')),
            );
            // Optionally refresh blogs
            _page = 1;
            context.read<BlogBloc>().add(
              FetchBlogs(page: _page, limit: _limit),
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading && state.isFirstFetch) {
            return const Center(child: CircularProgressIndicator());
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
