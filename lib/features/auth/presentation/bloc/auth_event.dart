sealed class AuthEvent {}

class RegisterRequested extends AuthEvent {
  final String name, email, password;
  RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
  });
}

class LoginRequested extends AuthEvent {
  final String email, password;
  LoginRequested({required this.email, required this.password});
}

class LogoutRequested extends AuthEvent {}

class RefreshRequested extends AuthEvent {}
