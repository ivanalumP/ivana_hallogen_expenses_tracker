// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedResponse<T> _$PaginatedResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) {
  $checkKeys(
    json,
    requiredKeys: const ['data', 'pagination'],
  );
  return PaginatedResponse<T>(
    data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
    pagination:
        PaginationInfo.fromJson(json['pagination'] as Map<String, dynamic>),
    success: json['success'] as bool? ?? true,
    message: json['message'] as String?,
  );
}

Map<String, dynamic> _$PaginatedResponseToJson<T>(
  PaginatedResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': instance.data.map(toJsonT).toList(),
      'pagination': instance.pagination,
      'success': instance.success,
      'message': instance.message,
    };
