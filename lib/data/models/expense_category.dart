import 'package:json_annotation/json_annotation.dart';

part 'expense_category.g.dart';

@JsonSerializable()
class ExpenseCategory {
  @JsonKey(name: 'name', required: true)
  final String name;

  @JsonKey(name: 'recommendedPercentage', defaultValue: 0.0)
  final double? recommendedPercentage;

  @JsonKey(name: 'isFixed', defaultValue: false)
  final bool isFixed;

  const ExpenseCategory({
    required this.name,
    this.recommendedPercentage,
    required this.isFixed,
  });

  /// Creates an ExpenseCategory from a JSON map
  factory ExpenseCategory.fromJson(Map<String, dynamic> json) =>
      _$ExpenseCategoryFromJson(json);

  /// Converts an ExpenseCategory to a JSON map
  Map<String, dynamic> toJson() => _$ExpenseCategoryToJson(this);

  /// Creates a copy of this ExpenseCategory with the given fields replaced
  ExpenseCategory copyWith({
    String? name,
    double? recommendedPercentage,
    bool? isFixed,
  }) {
    return ExpenseCategory(
      name: name ?? this.name,
      recommendedPercentage:
          recommendedPercentage ?? this.recommendedPercentage,
      isFixed: isFixed ?? this.isFixed,
    );
  }

  /// Get the recommended percentage with a fallback to 0.0
  double get safeRecommendedPercentage => recommendedPercentage ?? 0.0;

  /// Check if the category has a recommended percentage
  bool get hasRecommendedPercentage =>
      recommendedPercentage != null && recommendedPercentage! > 0;

  @override
  String toString() {
    return 'ExpenseCategory(name: $name, recommendedPercentage: $recommendedPercentage, isFixed: $isFixed)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExpenseCategory &&
        other.name == name &&
        other.recommendedPercentage == recommendedPercentage &&
        other.isFixed == isFixed;
  }

  @override
  int get hashCode {
    return name.hashCode ^ recommendedPercentage.hashCode ^ isFixed.hashCode;
  }
}
