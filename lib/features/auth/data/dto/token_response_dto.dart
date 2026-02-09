class TokenResponseDto {
  final String accessToken;
  final String refreshToken;

  TokenResponseDto(this.accessToken, this.refreshToken);

  factory TokenResponseDto.fromJson(Map<String, dynamic> json) {
    return TokenResponseDto(json['accessToken'], json['refreshToken']);
  }
}
