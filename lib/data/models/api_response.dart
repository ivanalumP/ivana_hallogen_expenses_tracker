import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  @JsonKey(name: 'success', defaultValue: false)
  final bool success;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'data')
  final T? data;

  @JsonKey(name: 'error')
  final String? error;

  @JsonKey(name: 'statusCode', defaultValue: 200)
  final int statusCode;

  const ApiResponse({
    this.success = false,
    this.message,
    this.data,
    this.error,
    this.statusCode = 200,
  });

  /// Creates an ApiResponse from a JSON map
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  /// Converts an ApiResponse to a JSON map
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);

  /// Creates a success response
  factory ApiResponse.success({
    required T data,
    String? message,
    int statusCode = 200,
  }) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }

  /// Creates an error response
  factory ApiResponse.error({
    required String error,
    String? message,
    int statusCode = 400,
  }) {
    return ApiResponse<T>(
      success: false,
      error: error,
      message: message,
      statusCode: statusCode,
    );
  }

  /// Checks if the response is successful
  bool get isSuccess => success && error == null;

  /// Gets the error message or a default message
  String get errorMessage => error ?? message ?? 'An unknown error occurred';

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, data: $data, error: $error, statusCode: $statusCode)';
  }
}
