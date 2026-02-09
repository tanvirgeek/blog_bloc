import 'package:blog_bloc/features/auth/data/repository/auth_repository.dart';
import 'package:blog_bloc/features/auth/presentation/bloc/auth_event.dart';
import 'package:blog_bloc/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;

  AuthBloc(this.repo) : super(AuthInitial()) {
    on<RegisterRequested>(_register);
    on<LoginRequested>(_login);
    on<LogoutRequested>(_logout);
    on<RefreshRequested>(_refresh);
  }

  Future<void> _register(RegisterRequested e, emit) async {
    emit(AuthLoading());
    try {
      await repo.register(e.name, e.email, e.password);
      emit(AuthUnauthenticated());
    } catch (err) {
      emit(AuthError(err.toString()));
    }
  }

  Future<void> _login(LoginRequested e, emit) async {
    emit(AuthLoading());
    try {
      await repo.login(e.email, e.password);
      emit(AuthAuthenticated());
    } catch (err) {
      emit(AuthError(err.toString()));
    }
  }

  Future<void> _refresh(RefreshRequested e, emit) async {
    try {
      await repo.refreshToken();
      emit(AuthAuthenticated());
    } catch (_) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _logout(LogoutRequested e, emit) async {
    await repo.logout();
    emit(AuthUnauthenticated());
  }
}
