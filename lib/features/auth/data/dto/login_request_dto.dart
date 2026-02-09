class LoginRequestDto {
  final String email;
  final String password;

  LoginRequestDto(this.email, this.password);

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}
