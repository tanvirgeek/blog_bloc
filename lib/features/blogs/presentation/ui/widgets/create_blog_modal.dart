import 'dart:io';
import 'package:blog_bloc/features/blogs/data/dto/blog_dto.dart';
import 'package:blog_bloc/features/blogs/presentation/bloc/blog_bloc.dart';
import 'package:blog_bloc/features/blogs/presentation/bloc/blog_event.dart';
import 'package:blog_bloc/features/blogs/presentation/bloc/blog_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreateBlogModal extends StatefulWidget {
  final BlogBloc blogBloc;
  const CreateBlogModal({super.key, required this.blogBloc});

  @override
  State<CreateBlogModal> createState() => _CreateBlogModalState();
}

class _CreateBlogModalState extends State<CreateBlogModal> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  File? _pickedImage;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlogBloc, BlogState>(
      bloc: widget.blogBloc, // explicit bloc
      listener: (context, state) {
        if (state is BlogSuccessFullyCreated) {
          Navigator.pop(context); // pop only on success
        }
        if (state is BlogError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _contentCtrl,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Pick Image'),
                  ),
                  const SizedBox(width: 8),
                  if (_pickedImage != null)
                    Expanded(
                      child: Text(
                        _pickedImage!.path.split('/').last,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final title = _titleCtrl.text.trim();
                  final content = _contentCtrl.text.trim();
                  if (title.isNotEmpty && content.isNotEmpty) {
                    final dto = CreateBlogDto(
                      title: title,
                      content: content,
                      image: _pickedImage,
                    );
                    widget.blogBloc.add(CreateBlog(dto: dto));
                  }
                },
                child: const Text('Create Blog'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
