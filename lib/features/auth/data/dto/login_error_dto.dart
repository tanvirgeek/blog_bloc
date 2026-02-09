// features/auth/data/dto/error_dto.dart
class ErrorDto {
  final String error;
  final int statusCode;

  ErrorDto({required this.error, required this.statusCode});

  factory ErrorDto.fromJson(Map<String, dynamic> json) {
    return ErrorDto(
      error: json['error'] ?? 'Unknown error',
      statusCode: json['statusCode'] ?? 500,
    );
  }
}
