import 'package:hive_flutter/hive_flutter.dart';
import '../data/models/budget.dart';
import '../data/models/expense.dart';

/// Service for managing local storage using Hive
class HiveStorageService {
  static const String _budgetBoxName = 'budget_box';
  static const String _expensesBoxName = 'expenses_box';
  static const String _categoriesBoxName = 'categories_box';

  late Box<Budget> _budgetBox;
  late Box<Expense> _expensesBox;
  late Box<String> _categoriesBox;

  /// Initialize Hive storage
  Future<void> initialize() async {
    await Hive.initFlutter();

    // Open boxes
    _budgetBox = await Hive.openBox<Budget>(_budgetBoxName);
    _expensesBox = await Hive.openBox<Expense>(_expensesBoxName);
    _categoriesBox = await Hive.openBox<String>(_categoriesBoxName);
  }

  /// Budget operations
  Future<void> saveBudget(Budget budget) async {
    await _budgetBox.put('current_budget', budget);
  }

  Budget? getBudget() {
    return _budgetBox.get('current_budget');
  }

  Future<void> deleteBudget() async {
    await _budgetBox.delete('current_budget');
  }

  /// Expense operations
  Future<void> saveExpense(Expense expense) async {
    await _expensesBox.put(expense.id, expense);
  }

  List<Expense> getAllExpenses() {
    return _expensesBox.values.toList();
  }

  Expense? getExpense(String id) {
    return _expensesBox.get(id);
  }

  Future<void> updateExpense(Expense expense) async {
    await _expensesBox.put(expense.id, expense);
  }

  Future<void> deleteExpense(String id) async {
    await _expensesBox.delete(id);
  }

  Future<void> clearAllExpenses() async {
    await _expensesBox.clear();
  }

  /// Category operations (from API)
  Future<void> saveCategories(List<String> categories) async {
    await _categoriesBox.clear();
    for (int i = 0; i < categories.length; i++) {
      await _categoriesBox.put(i.toString(), categories[i]);
    }
  }

  List<String> getCategories() {
    return _categoriesBox.values.toList();
  }

  bool isValidCategory(String category) {
    final validCategories = getCategories();
    return validCategories.contains(category);
  }

  /// Calculate budget statistics
  BudgetStatistics calculateBudgetStatistics() {
    final budget = getBudget();
    final expenses = getAllExpenses();

    if (budget == null || budget.monthlyBudget <= 0) {
      return const BudgetStatistics(
        monthlyBudget: 0.0,
        totalSpent: 0.0,
        budgetLeft: 0.0,
        currentBalance: 0.0,
        isBudgetExceeded: false,
        isBudgetWarning: false,
        budgetUsagePercentage: 0.0,
      );
    }

    final totalSpent =
        expenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
    final budgetLeft = budget.monthlyBudget - totalSpent;
    final currentBalance = budget.currentBalance - totalSpent;

    // Calculate percentage with safety checks
    double budgetUsagePercentage = 0.0;
    if (budget.monthlyBudget > 0) {
      budgetUsagePercentage = (totalSpent / budget.monthlyBudget) * 100;
      // Ensure percentage is within valid range
      budgetUsagePercentage = budgetUsagePercentage.clamp(0.0, double.infinity);
      // Handle NaN
      if (budgetUsagePercentage.isNaN) {
        budgetUsagePercentage = 0.0;
      }
    }

    final isBudgetExceeded = totalSpent > budget.monthlyBudget;
    final isBudgetWarning = budgetUsagePercentage >= 80 && !isBudgetExceeded;

    return BudgetStatistics(
      monthlyBudget: budget.monthlyBudget,
      totalSpent: totalSpent,
      budgetLeft: budgetLeft,
      currentBalance: currentBalance,
      isBudgetExceeded: isBudgetExceeded,
      isBudgetWarning: isBudgetWarning,
      budgetUsagePercentage: budgetUsagePercentage,
    );
  }

  /// Close all boxes
  Future<void> close() async {
    await _budgetBox.close();
    await _expensesBox.close();
    await _categoriesBox.close();
  }
}

/// Statistics calculated from stored budget and expenses
class BudgetStatistics {
  final double monthlyBudget;
  final double totalSpent;
  final double budgetLeft;
  final double currentBalance;
  final bool isBudgetExceeded;
  final bool isBudgetWarning;
  final double budgetUsagePercentage;

  const BudgetStatistics({
    required this.monthlyBudget,
    required this.totalSpent,
    required this.budgetLeft,
    required this.currentBalance,
    required this.isBudgetExceeded,
    required this.isBudgetWarning,
    required this.budgetUsagePercentage,
  });
}
