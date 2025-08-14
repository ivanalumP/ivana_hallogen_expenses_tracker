import 'package:json_annotation/json_annotation.dart';
import 'expense_category.dart';

part 'expense_categories_response.g.dart';

@JsonSerializable()
class ExpenseCategoriesResponse {
  @JsonKey(name: 'expenseCategories', required: true)
  final List<ExpenseCategory> expenseCategories;

  const ExpenseCategoriesResponse({
    required this.expenseCategories,
  });

  /// Creates an ExpenseCategoriesResponse from a JSON map
  factory ExpenseCategoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$ExpenseCategoriesResponseFromJson(json);

  /// Converts an ExpenseCategoriesResponse to a JSON map
  Map<String, dynamic> toJson() => _$ExpenseCategoriesResponseToJson(this);

  /// Creates a copy of this ExpenseCategoriesResponse with the given fields replaced
  ExpenseCategoriesResponse copyWith({
    List<ExpenseCategory>? expenseCategories,
  }) {
    return ExpenseCategoriesResponse(
      expenseCategories: expenseCategories ?? this.expenseCategories,
    );
  }

  @override
  String toString() {
    return 'ExpenseCategoriesResponse(expenseCategories: $expenseCategories)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExpenseCategoriesResponse &&
        other.expenseCategories == expenseCategories;
  }

  @override
  int get hashCode => expenseCategories.hashCode;
}
