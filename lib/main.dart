// lib/main.dart
import 'package:blog_bloc/app.dart';
import 'package:blog_bloc/features/auth/data/repository/auth_repository_singleton.dart';
import 'package:blog_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final authRepo = AuthRepositorySingleton().repository;
  runApp(BlocProvider(create: (_) => AuthBloc(authRepo), child: const MyApp()));
}
