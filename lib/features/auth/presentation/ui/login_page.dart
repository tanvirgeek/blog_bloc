import 'package:blog_bloc/core/network/auth_http_client.dart';
import 'package:blog_bloc/features/auth/data/repository/auth_repository_singleton.dart';
import 'package:blog_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_bloc/features/auth/presentation/bloc/auth_event.dart';
import 'package:blog_bloc/features/auth/presentation/bloc/auth_state.dart';
import 'package:blog_bloc/features/auth/presentation/ui/register_page.dart';
import 'package:blog_bloc/features/auth/presentation/ui/widgets/auth_text_field.dart';
import 'package:blog_bloc/features/blogs/data/api/blog_api.dart';
import 'package:blog_bloc/features/blogs/data/repository/blog_repository.dart';
import 'package:blog_bloc/features/blogs/presentation/bloc/blog_bloc.dart';
import 'package:blog_bloc/features/blogs/presentation/ui/blogs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          final authHttpClient = AuthHttpClient('http://localhost:3000');
          final blogAPI = BlogApi(authHttpClient);
          final blogRepo = BlogRepository(
            blogAPI,
            AuthRepositorySingleton().repository,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => BlogBloc(blogRepo),
                child: const BlogsScreen(),
              ),
            ),
          );
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Login")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AuthTextField(controller: emailCtrl, hint: "Email"),
              AuthTextField(
                controller: passCtrl,
                hint: "Password",
                obscure: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                    LoginRequested(
                      email: emailCtrl.text,
                      password: passCtrl.text,
                    ),
                  );
                },
                child: const Text("Login"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  );
                },
                child: const Text("Create account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
