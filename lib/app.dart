// lib/app.dart
import 'package:blog_bloc/features/auth/presentation/ui/login_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      home: const LoginPage(),
    );
  }
}
