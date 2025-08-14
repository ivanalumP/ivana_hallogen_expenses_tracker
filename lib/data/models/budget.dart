import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'budget.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Budget {
  @HiveField(0)
  @JsonKey(name: 'monthlyBudget', required: true)
  final double monthlyBudget;

  @HiveField(1)
  @JsonKey(name: 'currentBalance', required: true)
  final double currentBalance;

  @HiveField(2)
  @JsonKey(name: 'totalSpent', required: true)
  final double totalSpent;

  @HiveField(3)
  @JsonKey(name: 'month', required: true)
  final String month;

  @HiveField(4)
  @JsonKey(name: 'year', required: true)
  final int year;

  const Budget({
    required this.monthlyBudget,
    required this.currentBalance,
    required this.totalSpent,
    required this.month,
    required this.year,
  });

  /// Creates a Budget from a JSON map
  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);

  /// Converts a Budget to a JSON map
  Map<String, dynamic> toJson() => _$BudgetToJson(this);

  /// Creates a copy of this Budget with the given fields replaced
  Budget copyWith({
    double? monthlyBudget,
    double? currentBalance,
    double? totalSpent,
    String? month,
    int? year,
  }) {
    return Budget(
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      currentBalance: currentBalance ?? this.currentBalance,
      totalSpent: totalSpent ?? this.totalSpent,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  /// Get the budget left (monthly budget - total spent)
  double get budgetLeft => monthlyBudget - totalSpent;

  /// Get the budget usage percentage
  double get budgetUsagePercentage {
    if (monthlyBudget <= 0) return 0.0;
    final percentage = (totalSpent / monthlyBudget) * 100;
    return percentage.isNaN || percentage.isInfinite ? 0.0 : percentage;
  }

  /// Check if budget is exceeded
  bool get isBudgetExceeded => totalSpent > monthlyBudget;

  /// Check if budget is close to being exceeded (80% or more)
  bool get isBudgetWarning {
    if (monthlyBudget <= 0) return false;
    final percentage = (totalSpent / monthlyBudget) * 100;
    if (percentage.isNaN || percentage.isInfinite) return false;
    return percentage >= 80 && !isBudgetExceeded;
  }

  /// Get the remaining balance (current balance - total spent)
  double get remainingBalance => currentBalance - totalSpent;

  /// Get formatted monthly budget amount
  String get formattedMonthlyBudget => '\$${monthlyBudget.toStringAsFixed(2)}';

  /// Get formatted total spent amount
  String get formattedTotalSpent => '\$${totalSpent.toStringAsFixed(2)}';

  /// Get formatted budget left amount
  String get formattedBudgetLeft => '\$${budgetLeft.toStringAsFixed(2)}';

  /// Get formatted current balance amount
  String get formattedCurrentBalance =>
      '\$${currentBalance.toStringAsFixed(2)}';

  @override
  String toString() {
    return 'Budget(monthlyBudget: $monthlyBudget, currentBalance: $currentBalance, totalSpent: $totalSpent, month: $month, year: $year)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Budget &&
        other.monthlyBudget == monthlyBudget &&
        other.currentBalance == currentBalance &&
        other.totalSpent == totalSpent &&
        other.month == month &&
        other.year == year;
  }

  @override
  int get hashCode {
    return monthlyBudget.hashCode ^
        currentBalance.hashCode ^
        totalSpent.hashCode ^
        month.hashCode ^
        year.hashCode;
  }
}
