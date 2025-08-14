import 'package:json_annotation/json_annotation.dart';
import 'pagination_info.dart';

part 'paginated_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PaginatedResponse<T> {
  @JsonKey(name: 'data', required: true)
  final List<T> data;

  @JsonKey(name: 'pagination', required: true)
  final PaginationInfo pagination;

  @JsonKey(name: 'success', defaultValue: true)
  final bool success;

  @JsonKey(name: 'message')
  final String? message;

  const PaginatedResponse({
    required this.data,
    required this.pagination,
    this.success = true,
    this.message,
  });

  /// Creates a PaginatedResponse from a JSON map
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginatedResponseFromJson(json, fromJsonT);

  /// Converts a PaginatedResponse to a JSON map
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PaginatedResponseToJson(this, toJsonT);

  /// Creates a PaginatedResponse with calculated pagination
  factory PaginatedResponse.withCalculatedPagination({
    required List<T> data,
    required int page,
    required int limit,
    required int total,
    bool success = true,
    String? message,
  }) {
    final pagination = PaginationInfo.calculate(
      page: page,
      limit: limit,
      total: total,
    );

    return PaginatedResponse<T>(
      data: data,
      pagination: pagination,
      success: success,
      message: message,
    );
  }

  /// Gets the current page number
  int get currentPage => pagination.page;

  /// Gets the total number of items
  int get totalItems => pagination.total;

  /// Gets the total number of pages
  int get totalPages => pagination.totalPages;

  /// Checks if there are more pages
  bool get hasMorePages => pagination.hasNext;

  /// Gets the number of items per page
  int get itemsPerPage => pagination.limit;

  /// Checks if the response is empty
  bool get isEmpty => data.isEmpty;

  /// Gets the number of items in the current page
  int get itemCount => data.length;

  @override
  String toString() {
    return 'PaginatedResponse(data: ${data.length} items, pagination: $pagination, success: $success, message: $message)';
  }
}
