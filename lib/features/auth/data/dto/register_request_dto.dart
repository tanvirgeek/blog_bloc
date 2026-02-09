class RegisterRequestDto {
  final String name;
  final String email;
  final String password;

  RegisterRequestDto(this.name, this.email, this.password);

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
  };
}
