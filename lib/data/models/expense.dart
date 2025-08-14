import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'expense.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class Expense {
  @HiveField(0)
  @JsonKey(name: 'id', required: true)
  final String id;

  @HiveField(1)
  @JsonKey(name: 'title', required: true)
  final String title;

  @HiveField(2)
  @JsonKey(name: 'amount', required: true)
  final double amount;

  @HiveField(3)
  @JsonKey(name: 'category', required: true)
  final String category;

  @HiveField(4)
  @JsonKey(name: 'date', required: true)
  final DateTime date;

  @HiveField(5)
  @JsonKey(name: 'description')
  final String? description;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
  });

  /// Creates an Expense from a JSON map
  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);

  /// Converts an Expense to a JSON map
  Map<String, dynamic> toJson() => _$ExpenseToJson(this);

  /// Creates a copy of this Expense with the given fields replaced
  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    String? description,
    bool? isRecurring,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }

  /// Get formatted date string
  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expenseDate = DateTime(date.year, date.month, date.day);

    if (expenseDate == today) {
      return 'Today';
    } else if (expenseDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Get formatted amount string
  String get formattedAmount => '\$${amount.toStringAsFixed(2)}';

  /// Get short description (truncated if too long)
  String get shortDescription {
    if (description == null || description!.isEmpty) {
      return 'No description';
    }
    return description!.length > 50
        ? '${description!.substring(0, 50)}...'
        : description!;
  }

  @override
  String toString() {
    return 'Expense(id: $id, title: $title, amount: $amount, category: $category, date: $date, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Expense &&
        other.id == id &&
        other.title == title &&
        other.amount == amount &&
        other.category == category &&
        other.date == date &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        amount.hashCode ^
        category.hashCode ^
        date.hashCode ^
        description.hashCode;
  }
}
