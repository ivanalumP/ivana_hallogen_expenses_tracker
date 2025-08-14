import 'package:json_annotation/json_annotation.dart';

part 'pagination_info.g.dart';

@JsonSerializable()
class PaginationInfo {
  @JsonKey(name: 'page', defaultValue: 1)
  final int page;

  @JsonKey(name: 'limit', defaultValue: 10)
  final int limit;

  @JsonKey(name: 'total', defaultValue: 0)
  final int total;

  @JsonKey(name: 'totalPages', defaultValue: 0)
  final int totalPages;

  @JsonKey(name: 'hasNext', defaultValue: false)
  final bool hasNext;

  @JsonKey(name: 'hasPrevious', defaultValue: false)
  final bool hasPrevious;

  const PaginationInfo({
    this.page = 1,
    this.limit = 10,
    this.total = 0,
    this.totalPages = 0,
    this.hasNext = false,
    this.hasPrevious = false,
  });

  /// Creates a PaginationInfo from a JSON map
  factory PaginationInfo.fromJson(Map<String, dynamic> json) =>
      _$PaginationInfoFromJson(json);

  /// Converts a PaginationInfo to a JSON map
  Map<String, dynamic> toJson() => _$PaginationInfoToJson(this);

  /// Creates a PaginationInfo with calculated values
  factory PaginationInfo.calculate({
    required int page,
    required int limit,
    required int total,
  }) {
    final totalPages = (total / limit).ceil();
    return PaginationInfo(
      page: page,
      limit: limit,
      total: total,
      totalPages: totalPages,
      hasNext: page < totalPages,
      hasPrevious: page > 1,
    );
  }

  /// Gets the offset for database queries
  int get offset => (page - 1) * limit;

  /// Checks if the current page is valid
  bool get isValidPage => page > 0 && page <= totalPages;

  /// Gets the next page number
  int? get nextPage => hasNext ? page + 1 : null;

  /// Gets the previous page number
  int? get previousPage => hasPrevious ? page - 1 : null;

  @override
  String toString() {
    return 'PaginationInfo(page: $page, limit: $limit, total: $total, totalPages: $totalPages, hasNext: $hasNext, hasPrevious: $hasPrevious)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaginationInfo &&
        other.page == page &&
        other.limit == limit &&
        other.total == total &&
        other.totalPages == totalPages &&
        other.hasNext == hasNext &&
        other.hasPrevious == hasPrevious;
  }

  @override
  int get hashCode {
    return page.hashCode ^
        limit.hashCode ^
        total.hashCode ^
        totalPages.hashCode ^
        hasNext.hashCode ^
        hasPrevious.hashCode;
  }
}
