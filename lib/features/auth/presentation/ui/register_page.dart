import 'package:blog_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_bloc/features/auth/presentation/bloc/auth_event.dart';
import 'package:blog_bloc/features/auth/presentation/bloc/auth_state.dart';
import 'package:blog_bloc/features/auth/presentation/ui/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pop(context); // back to login
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Register")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AuthTextField(controller: nameCtrl, hint: "Name"),
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
                    RegisterRequested(
                      name: nameCtrl.text,
                      email: emailCtrl.text,
                      password: passCtrl.text,
                    ),
                  );
                },
                child: const Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
